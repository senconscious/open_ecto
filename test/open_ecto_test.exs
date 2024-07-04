defmodule OpenEctoTest do
  use ExUnit.Case, async: true

  defmodule Book do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:name, :string)
      field(:year, :integer)

      embeds_one :author, Author, primary_key: false do
        field(:name, :string)
      end

      embeds_many :receipts, Receipt, primary_key: false do
        field(:bearer, :string)
        field(:rate, :integer)
      end
    end
  end

  test "prototype" do
    Book
    |> OpenEcto.parse_to_open_api_map()
    |> IO.inspect()
  end
end
