workflow "Tests & Formatting" {
    on = "push"
    resolves = ["Check Formatting", "Check Linter", "Run Tests"]
}

action "Get Deps" {
    uses = "jclem/action-mix/deps.get@v1.3.2"
}

action "Run Tests" {
    uses = "jclem/action-mix/test@v1.3.2"
    needs = "Get Deps"
}

action "Check Formatting" {
    uses = "jclem/action-mix@v1.3.2"
    needs = "Get Deps"
    args = "format --check-formatted"
}

action "Check Linter" {
    uses = "jclem/action-mix@v1.3.2"
    needs = "Get Deps"
    args = "credo"
}
