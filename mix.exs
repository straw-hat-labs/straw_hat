defmodule StrawHat.Mixfile do
  use Mix.Project

  @version "0.0.11"

  @elixir_version "~> 1.5"
  @name :straw_hat
  @description """
    StrawHat Utilities
  """
  @source_url "https://github.com/straw-hat-llc/straw_hat"

  def project do
    production? = Mix.env == :prod

    [
      app: @name,
      description: @description,
      version: @version,
      elixir: @elixir_version,
      build_embedded: production?,
      start_permanent: production?,
      deps: deps(),
      package: package(),

      # docs
      name: "StrawHat",
      source_url: @source_url,
      homepage_url: @source_url,
      docs: [
        main: "StrawHat",
        extras: ["README.md"]
      ],

      # coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:ecto, "~> 2.2"},
      {:absinthe, "~> 1.3"},
      {:poison, "~> 3.1"},

      # Tools
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: :test, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: @name,
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: ["Yordis Prieto"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
