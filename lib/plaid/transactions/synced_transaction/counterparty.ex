defmodule Plaid.Transactions.SyncedTransaction.Counterparty do
  @moduledoc """
  [Plaid counterparty schema.](https://plaid.com/docs/api/products/transactions/#transactionssync)
  """

  @behaviour Plaid.Castable

  alias Plaid.Castable

  @type t :: %__MODULE__{
          name: String.t(),
          entity_id: String.t() | nil,
          type: String.t(),
          website: String.t() | nil,
          logo_url: String.t() | nil,
          confidence_level: String.t() | nil
        }

  defstruct [
    :name,
    :entity_id,
    :type,
    :website,
    :logo_url,
    :confidence_level
  ]

  @impl true
  def cast(generic_map) do
    %__MODULE__{
      name: generic_map["primary"],
      entity_id: generic_map["entity_id"],
      type: generic_map["type"],
      website: generic_map["website"],
      logo_url: generic_map["logo_url"],
      confidence_level: generic_map["confidence_level"]
    }
  end
end
