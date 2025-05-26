defmodule CAR.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/cometsh/elixir-car"

  def project do
    [
      app: :car,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cbor, "~> 1.0.0"},
      {:typedstruct, "~> 0.5"},
      {:varint, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  def package do
    [
      licenses: "MIT",
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
