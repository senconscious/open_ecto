defmodule OpenEcto do
  @moduledoc """
  Documentation for `OpenEcto`.
  """

  @simple_types [:string, :integer]

  def parse_to_open_api_map(struct) do
    %{
      parse_name(struct) => %{
        type: :object,
        properties: parse_properties(struct)
      }
    }
  end

  defp parse_name(struct) do
    struct
    |> Module.split()
    |> List.last()
  end

  defp parse_properties(struct) do
    struct.__changeset__()
    |> Stream.map(&parse_type/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_type({field, type}) when type in @simple_types do
    %{
      field => get_type_details(type)
    }
  end

  defp parse_type({field, {:embed, %Ecto.Embedded{cardinality: cardinatily, related: related}}}) do
    %{field => get_embed_type_details(cardinatily, related)}
  end

  defp parse_type(_), do: nil

  defp get_type_details(:string), do: %{type: :string}
  defp get_type_details(:integer), do: %{type: :integer, format: "int64"}

  defp get_embed_type_details(:one, related) do
    %{
      type: :object,
      properties: parse_properties(related)
    }
  end

  defp get_embed_type_details(:many, related) do
    %{
      type: :array,
      items: %{
        type: :object,
        properties: parse_properties(related)
      }
    }
  end
end
