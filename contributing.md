# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test httpx https://github.com/l-lin/asdf-httpx.git "httpx --completion zsh"
```

Tests are automatically run in GitHub Actions on push and PR.
