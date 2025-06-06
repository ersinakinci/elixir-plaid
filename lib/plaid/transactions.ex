defmodule Plaid.Transactions do
  @moduledoc """
  [Plaid Transactions API](https://plaid.com/docs/api/transactions) calls and schema.
  """

  defmodule SyncResponse do
    @moduledoc """
    [Plaid API /transactions/sync response schema.](https://plaid.com/docs/api/products/transactions/#transactionssync)
    """

    @behaviour Castable

    alias Plaid.{Castable, Account, Transactions}

    @type t :: %__MODULE__{
            transactions_update_status: binary(),
            accounts: [Account.t()],
            added: [Transactions.Transaction.t()],
            modified: [Transactions.Transaction.t()],
            removed: [Transactions.Transaction.t()],
            next_cursor: binary(),
            has_more: boolean(),
            request_id: String.t(),
            access_token: String.t() | nil
          }

    defstruct [
      :transactions_update_status,
      :accounts,
      :added,
      :modified,
      :removed,
      :next_cursor,
      :has_more,
      :request_id,
      :access_token
    ]

    @impl true
    def cast(generic_map) do
      %__MODULE__{
        transactions_update_status: generic_map["transactions_update_status"],
        accounts: Castable.cast_list(Account, generic_map["accounts"]),
        added: Castable.cast_list(Transactions.SyncedTransaction, generic_map["added"]),
        modified: Castable.cast_list(Transactions.SyncedTransaction, generic_map["modified"]),
        removed:
          Castable.cast_list(Transactions.RemovedSyncedTransaction, generic_map["removed"]),
        next_cursor: generic_map["next_cursor"],
        has_more: generic_map["has_more"],
        request_id: generic_map["request_id"],
        access_token: generic_map["access_token"]
      }
    end
  end

  defmodule GetResponse do
    @moduledoc """
    [Plaid API /transactions/get response schema.](https://plaid.com/docs/api/transactions)
    """

    @behaviour Plaid.Castable

    alias Plaid.Account
    alias Plaid.Castable
    alias Plaid.Item
    alias Plaid.Transactions.Transaction

    @type t :: %__MODULE__{
            accounts: [Account.t()],
            transactions: [Transaction.t()],
            item: Item.t(),
            total_transactions: integer(),
            request_id: String.t()
          }

    defstruct [
      :accounts,
      :transactions,
      :item,
      :total_transactions,
      :request_id
    ]

    @impl true
    def cast(generic_map) do
      %__MODULE__{
        accounts: Castable.cast_list(Account, generic_map["accounts"]),
        transactions: Castable.cast_list(Transaction, generic_map["transactions"]),
        item: Castable.cast(Item, generic_map["item"]),
        total_transactions: generic_map["total_transactions"],
        request_id: generic_map["request_id"]
      }
    end
  end

  @doc """
  Sync the latest transactions.

  Does a `POST /transactions/sync` call, which gives you details on transactions
  that have been added, modified, and removed relative to the update indicated
  by `cursor`.

  Params:
  * `access_token` - Token to fetch transactions for.

  Options:
  * `:cursor`                       - Opaque token pointing to an update, after which all newly
                                      added, modified, and removed transactions will be returned.
  * `:count`                        - Number of transactions to pull (min 1, max 500, default 100).
  * `:include_original_description` - Include the raw unparsed transaction description from the
                                      financial institution.
  * `:days_requested`               - Maximum number of days of transaction history (only applies
                                      to calls for Items where the Transactions product has not
                                      already been initialized).
  * `:account_id`                   - Specific account id for which to fetch balances.
  """
  @spec sync(String.t(), options, Plaid.config()) :: {:ok, SyncResponse.t()} | {:error, Plaid.Error.t()}
  when options: %{
               optional(:cursor) => String.t(),
               optional(:count) => integer(),
               optional(:include_original_description) => boolean(),
               optional(:days_requested) => integer(),
               optional(:account_id) => String.t(),
             }
  def sync(access_token, options \\ %{}, config) do
    params_payload = Map.take(options, [:cursor, :count])
    options_payload = Map.take(options, [:include_original_description, :days_requested, :account_id])
    payload = params_payload
      |> Map.put(:options, options_payload)
      |> Map.put(:access_token, access_token)

    Plaid.Client.call(
             "/transactions/sync",
             payload,
             Plaid.Transactions.SyncResponse,
             config
           )
  end

  @doc """
  Get information about transactions.

  Does a `POST /transactions/get` call which gives you high level account
  data along with transactions from all accounts contained in the
  `access_token`'s item.

  Params:
  * `access_token` - Token to fetch transactions for.
  * `start_date`   - Start of query for transactions.
  * `end_date`     - End of query for transactions.

  Options:
  * `:account_ids` - Specific account ids to fetch balances for.
  * `:count`       - Amount of transactions to pull.
  * `:offset`      - Offset to start pulling transactions.

  ## Example

      Transactions.get("access-sandbox-123xxx", "2019-10-10", "2019-10-20", client_id: "123", secret: "abc")
      {:ok, %Transactions.GetResponse{}}

  """
  @spec get(String.t(), String.t(), String.t(), options, Plaid.config()) ::
          {:ok, GetResponse.t()} | {:error, Plaid.Error.t()}
        when options: %{
               optional(:account_ids) => [String.t()],
               optional(:count) => integer(),
               optional(:offset) => integer()
             }
  def get(access_token, start_date, end_date, options \\ %{}, config) do
    options_payload = Map.take(options, [:account_ids, :count, :offset])

    payload =
      %{}
      |> Map.put(:access_token, access_token)
      |> Map.put(:start_date, start_date)
      |> Map.put(:end_date, end_date)
      |> Map.put(:options, options_payload)

    Plaid.Client.call(
      "/transactions/get",
      payload,
      Plaid.Transactions.GetResponse,
      config
    )
  end

  @doc """
  Manually refresh transactions.

  Does a `POST /transactions/refresh` call which kicks off a manual
  transactions extraction for all accounts contained in the `access_token`'s
  item.

  * `access_token` - Token to fetch transactions for.

  ## Examples

    Transactions.refresh("access-sandbox-123xxx", client_id: "123", secret: "abc")
    {:ok, %Plaid.SimpleResponse{}}

  """
  @spec refresh(String.t(), Plaid.config()) ::
          {:ok, Plaid.SimpleResponse.t()} | {:error, Plaid.Error.t()}
  def refresh(access_token, config) do
    Plaid.Client.call(
      "/transactions/refresh",
      %{access_token: access_token},
      Plaid.SimpleResponse,
      config
    )
  end
end
