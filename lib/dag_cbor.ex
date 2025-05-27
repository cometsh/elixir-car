defmodule CAR.DagCbor do
  @moduledoc """
  Module for helping with DAG-CBOR quirks.
  """

  @doc """
  Decode a given binary using CBOR, with extra handling to pull tagged CIDs out of their wrapping struct.
  """
  @spec decode(binary()) :: {:ok, any(), binary()} | {:error, atom()}
  def decode(binary) do
    case CBOR.decode(binary) do
      {:ok, value, rest} -> {:ok, remap_cid_tags(value), rest}
      e -> e
    end
  end

  # Recurse through a data structure and extract all CIDs from their tags.
  @spec remap_cid_tags(any()) :: any()
  defp remap_cid_tags(%{} = container) do
    container
    |> Enum.into([])
    |> Enum.map(fn {k, v} -> {k, do_remap(v)} end)
    |> Enum.into(%{})
  end

  defp remap_cid_tags([_ | _] = container) do
    Enum.map(container, &do_remap/1)
  end

  defp remap_cid_tags(term), do: term

  # CIDs are always tagged with `42` in DAG-CBOR.
  # TODO?: stringify them?
  defp do_remap(%CBOR.Tag{tag: 42, value: %CBOR.Tag{tag: :bytes, value: <<0, cid::binary>>}}),
    do: cid

  defp do_remap(%CBOR.Tag{} = tag), do: tag
  defp do_remap(%{} = container), do: remap_cid_tags(container)
  defp do_remap([_ | _] = container), do: remap_cid_tags(container)
  defp do_remap(scalar), do: scalar
end
