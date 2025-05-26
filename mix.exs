defmodule CAR.MixProject do
  use Mix.Project

  def project do
    [
      app: :car,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cbor, "~> 1.0.0"},
      {:typedstruct, "~> 0.5"},
      {:varint, "~> 1.4"}
    ]
  end
end
