defmodule CAR.Decoder do
  @moduledoc """
  Module for decoding CARv1 files.
  Spec: https://ipld.io/specs/transport/car/carv1/
  """

  @type header_error() :: {:error, :header, atom()}
  @type block_error() :: {:error, :block, atom()}

  alias Varint.LEB128

  @spec decode(binary()) :: {:ok, CAR.Archive.t()} | header_error()
  def decode(binary) do
    with {:ok, roots, rest} <- header(binary),
         {:ok, blocks} <- data(rest) do
      {:ok, %CAR.Archive{version: 1, roots: roots, blocks: blocks}}
    end
  end

  @spec header(binary()) :: {:ok, map(), binary()} | header_error()
  defp header(binary) do
    with {length, rest} <- LEB128.decode(binary),
         <<header::binary-size(length), rest::binary>> <- rest,
         #  TODO: make sure header is always CBOR
         {:ok, %{"version" => 1, "roots" => roots}, <<>>} <- CAR.DagCbor.decode(header) do
      {:ok, roots, rest}
    else
      # Invalid header length
      <<_::binary>> -> {:error, :header, :too_short}
      # Incorrect header structure
      {:ok, _, _} -> {:error, :invalid_header}
      # CBOR error
      {:error, reason} -> {:error, :invalid_header, reason}
    end
  end

  @spec data(binary(), map()) :: {:ok, %{binary() => any()}} | block_error()
  defp data(binary, blocks \\ %{}) do
    with {length, rest} <- LEB128.decode(binary),
         <<cid_data::binary-size(length), rest::binary>> <- rest,
         {_version, cid, data} <- cid(cid_data),
         # TODO: support DAG-PB & RAW modes
         {:ok, block, <<>>} <- CAR.DagCbor.decode(data),
         blocks <- Map.put(blocks, cid, block) do
      case rest do
        <<>> -> {:ok, blocks}
        rest -> data(rest, blocks)
      end
    else
      <<_::binary>> -> {:error, :block, :too_short}
      # TODO: better name lol
      {:ok, _, _} -> {:error, :block, :not_one_cbor}
      {:error, reason} -> {:error, :block, reason}
    end
  end

  @doc """
  Extract a CIDv0 or CIDv1 from an arbitrary byte stream.
  """
  @spec cid(binary()) :: {integer(), binary(), binary()}
  def cid(<<0x12, 0x20, id::32, rest::binary>>) do
    {0, <<0x12, 0x20, id>>, rest}
  end

  def cid(<<0x01, binary::binary>>) do
    # CIDv1 = <<version::varint, codec::varint, multihash::binary>> where multihash = <<function_code, length, digest::binary-size(length)>>
    # {1 = version, rest} = LEB128.decode(binary)
    {codec, <<mh_1, mh_2::binary-size(1), rest::binary>>} = LEB128.decode(binary)
    {mh_length, _} = LEB128.decode(mh_2)
    <<mh_rest::binary-size(mh_length), rest::binary>> = rest
    multihash = <<mh_1, mh_2::binary, mh_rest::binary>>
    cid = <<0x01, LEB128.encode(codec)::binary, multihash::binary>>

    {1, cid, rest}
  end
end
