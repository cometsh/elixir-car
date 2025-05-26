defmodule CAR do
  @doc """
  Decode a CAR (content archive) into an Elixir struct.
  """
  def decode(binary), do: CAR.Decoder.decode(binary)
end
