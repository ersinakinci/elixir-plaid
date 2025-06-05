defmodule Plaid.Transactions.RemovedSyncedTransaction do
  @moduledoc """
  [Plaid removed synced transaction schema.](https://plaid.com/docs/api/products/transactions/#transactionssync)
  """

  @behaviour Plaid.Castable

  alias Plaid.Castable

  @type t :: %__MODULE__{
          transaction_id: String.t(),
          account_id: String.t()
        }

  defstruct [
    :account_id,
    :transaction_id
  ]

  @impl true
  def cast(generic_map) do
    %__MODULE__{
      account_id: generic_map["account_id"],
      transaction_id: generic_map["transaction_id"]
    }
  end
end
