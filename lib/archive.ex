defmodule CAR.Archive do
  @moduledoc """
  Struct representing a decoded CAR file.
  """

  use TypedStruct

  typedstruct enforce: true do
    field :version, integer()
    field :roots, list(binary())
    field :blocks, %{binary() => any()}
  end

  @doc """
  Get all content blocks that are referenced to in `roots`.
  """
  @spec root_blocks(t()) :: %{binary() => any()}
  def root_blocks(%__MODULE__{} = car) do
    car.roots |> Enum.map(fn cid -> {cid, car.blocks[cid]} end) |> Enum.into(%{})
  end

  @doc """
  Get a content block by its CID.
  """
  @spec get_block(t(), binary()) :: any()
  def get_block(%__MODULE__{} = car, cid) do
    car.blocks[cid]
  end
end
