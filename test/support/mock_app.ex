defmodule StrawHat.TestSupport.MockApp do
  use StrawHat.Configurable,
    otp_app: :straw_hat,
    config: [
      site: "https://github.com/straw-hat-team/straw_hat"
    ]
end
