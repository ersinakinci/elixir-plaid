defmodule Plaid.Transactions.SyncedTransaction do
  @moduledoc """
  [Plaid Synced Transaction schema.](https://plaid.com/docs/api/products/transactions/#transactionssync)
  """

  @behaviour Plaid.Castable

  alias Plaid.Transactions.Transaction.PersonalFinanceCategory
  alias Plaid.Castable
  alias Plaid.Transactions.Transaction.{Location, PaymentMeta}
  alias Plaid.Transactions.SyncedTransaction.{Counterparty, PersonalFinanceCategory}

  @type t :: %__MODULE__{
          account_id: String.t(),
          amount: number(),
          iso_currency_code: String.t() | nil,
          unofficial_currency_code: String.t() | nil,
          check_number: String.t() | nil,
          date: String.t(),
          authorized_date: String.t() | nil,
          authorized_datetime: String.t() | nil,
          location: Location.t(),
          name: String.t(),
          merchant_name: String.t() | nil,
          payment_meta: PaymentMeta.t(),
          payment_channel: String.t(),
          pending: boolean(),
          pending_transaction_id: String.t() | nil,
          account_owner: String.t() | nil,
          transaction_id: String.t(),
          transaction_code: String.t() | nil,
          transaction_type: String.t(),
          logo_url: String.t() | nil,
          website: String.t() | nil,
          datetime: String.t() | nil,
          personal_finance_category: PersonalFinanceCategory.t() | nil,
          personal_finance_category_icon_url: String.t(),
          counterparties: [CounterParty.t()],
          merchant_id: String.t() | nil,
          date_transacted: String.t() | nil,
          original_description: String.t() | nil
        }

  defstruct [
    :account_id,
    :amount,
    :iso_currency_code,
    :unofficial_currency_code,
    :check_number,
    :date,
    :authorized_date,
    :authorized_datetime,
    :location,
    :name,
    :merchant_name,
    :payment_meta,
    :payment_channel,
    :pending,
    :pending_transaction_id,
    :account_owner,
    :transaction_id,
    :transaction_code,
    :transaction_type,
    :logo_url,
    :website,
    :datetime,
    :personal_finance_category,
    :personal_finance_category_icon_url,
    :counterparties,
    :merchant_id,
    :date_transacted,
    :original_description
  ]

  @impl true
  def cast(generic_map) do
    %__MODULE__{
      account_id: generic_map["account_id"],
      amount: generic_map["amount"],
      iso_currency_code: generic_map["iso_currency_code"],
      unofficial_currency_code: generic_map["unofficial_currency_code"],
      check_number: generic_map["check_number"],
      date: generic_map["date"],
      authorized_date: generic_map["authorized_date"],
      authorized_datetime: generic_map["authorized_datetime"],
      location: Castable.cast(Location, generic_map["location"]),
      name: generic_map["name"],
      merchant_name: generic_map["merchant_name"],
      payment_meta: Castable.cast(PaymentMeta, generic_map["payment_meta"]),
      payment_channel: generic_map["payment_channel"],
      pending: generic_map["pending"],
      pending_transaction_id: generic_map["pending_transaction_id"],
      account_owner: generic_map["account_owner"],
      transaction_id: generic_map["transaction_id"],
      transaction_code: generic_map["transaction_code"],
      transaction_type: generic_map["transaction_type"],
      logo_url: generic_map["logo_url"],
      website: generic_map["website"],
      datetime: generic_map["datetime"],
      personal_finance_category:
        Castable.cast(PersonalFinanceCategory, generic_map["personal_finance_category"]),
      personal_finance_category_icon_url: generic_map["personal_finance_category_icon_url"],
      counterparties: Castable.cast_list(Counterparty, generic_map["counterparties"]),
      merchant_id: generic_map["merchant_id"],
      date_transacted: generic_map["date_transacted"],
      original_description: generic_map["original_description"]
    }
  end
end
