<div align="center">

# asdf-httpx [![Build](https://github.com/l-lin/asdf-httpx/actions/workflows/build.yml/badge.svg)](https://github.com/l-lin/asdf-httpx/actions/workflows/build.yml) [![Lint](https://github.com/l-lin/asdf-httpx/actions/workflows/lint.yml/badge.svg)](https://github.com/l-lin/asdf-httpx/actions/workflows/lint.yml)


[httpx](https://github.com/l-lin/asdf-httpx) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add httpx
# or
asdf plugin add httpx https://github.com/l-lin/asdf-httpx.git
```

httpx:

```shell
# Show all installable versions
asdf list-all httpx

# Install specific version
asdf install httpx latest

# Set a version globally (on your ~/.tool-versions file)
asdf global httpx latest

# Now httpx commands are available
httpx --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/l-lin/asdf-httpx/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Louis Lin](https://github.com/l-lin/)
