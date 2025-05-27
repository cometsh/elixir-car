defmodule CAR do
  @moduledoc """
  Tools for working with CAR files.
  """

  @doc """
  Decode a CAR into an Elixir struct.
  """
  @spec decode(binary()) ::
          {:ok, CAR.Archive.t()} | CAR.Decoder.header_error() | CAR.Decoder.block_error()
  def decode(binary), do: CAR.Decoder.decode(binary)
end
