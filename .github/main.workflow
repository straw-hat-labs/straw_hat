workflow "Health Checking" {
  on = "push"
  resolves = [
    "Run Tests",
    "Check Formatting",
    "Check Linter"
  ]
}

action "Get Deps" {
  uses = "jclem/action-mix/deps.get@v1.3.3"
}

action "Run Tests" {
  uses = "jclem/action-mix@v1.3.3"
  needs = "Get Deps"
  args = "coveralls.json"
  env = {MIX_ENV = "test"}
}

action "Check Formatting" {
  uses = "jclem/action-mix@v1.3.3"
  needs = "Get Deps"
  args = "format --check-formatted"
}

action "Check Linter" {
  uses = "jclem/action-mix@v1.3.3"
  needs = "Get Deps"
  args = "credo"
}

