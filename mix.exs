defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.2.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bot.Core.Main, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.8"},
      {:nosedrum,
       git: "https://github.com/kshannoninnes/nosedrum.git",
       branch: "feature/bulk-register-commands"},
      # {:nosedrum, path: "../nosedrum"},
      # {:nosedrum, "~> 0.6"},
      {:req, "~> 0.4"},
      {:xfile, "~> 0.4"},
      {:dotenvy, "~> 0.8.0"}
    ]
  end
end
