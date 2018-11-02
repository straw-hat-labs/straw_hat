deps:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get

linter:
	mix format --check-formatted
	mix credo

testing: deps
	mix coveralls.json

docs:
	mix inch.report

ci: deps linter testing docs
