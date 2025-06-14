# CAR

An Elixir package for dealing with
[CARv1](https://ipld.io/specs/transport/car/carv1/) (content archive) files.

Currently only just a basic decoder for use in
[Comet](https://github.com/cometsh), but hopefully to become a fully fledged CAR
library for all sorts of uses (eventually).

## TODO

- Encoding CAR files
- Support for more codecs specified in a block's CID (e.g. DAG-PB, RAW).
  Currently only DAG-CBOR is supported and automatically.
- Tests

## Installation

Add `car` to your `mix.exs`

```elixir
def deps do
  [
    {:car, "~> 0.1.0"}
  ]
end
```

## Basic Usage

```elixir
car_binary = receive_car()
{:ok, decoded_car} = CAR.decode(car_binary)
```

## License

This project is licensed under the [MIT License](./LICENSE)
