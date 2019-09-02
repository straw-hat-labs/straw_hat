use Mix.Config

config :logger, level: :warn

config :straw_hat, StrawHat.TestSupport.MockApp, json_library: "Jason"
