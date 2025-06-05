defmodule Plaid.Transactions.SyncedTransaction.PersonalFinanceCategory do
  @moduledoc """
  [Plaid counterparty schema.](https://plaid.com/docs/api/products/transactions/#transactionssync)
  """

  @behaviour Plaid.Castable

  alias Plaid.Castable

  @type t :: %__MODULE__{
          primary: String.t(),
          detailed: String.t(),
          confidence_level: String.t() | nil
        }

  defstruct [
    :primary,
    :detailed,
    :confidence_level
  ]

  @impl true
  def cast(generic_map) do
    %__MODULE__{
      primary: generic_map["primary"],
      detailed: generic_map["detailed"],
      confidence_level: generic_map["confidence_level"]
    }
  end
end
