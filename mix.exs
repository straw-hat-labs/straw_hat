defmodule StrawHat.MixProject do
  use Mix.Project

  @name :straw_hat
  @version "0.4.3"
  @elixir_version "~> 1.7"

  @description """
  StrawHat Utilities.
  """
  @source_url "https://github.com/straw-hat-team/straw_hat"

  def project do
    [
      name: "StrawHat",
      description: @description,
      app: @name,
      version: @version,
      elixir: @elixir_version,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],

      # Extras
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:ecto, ">= 0.0.0", optional: true},

      # Tools
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      # {:inch_ex, ">= 0.0.0", only: [:dev], runtime: false},
      {:inch_ex, github: "rrrene/inch_ex"}
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

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
