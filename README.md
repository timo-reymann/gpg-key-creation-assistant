GPG Key Creation Assistant
===
[![LICENSE](https://img.shields.io/github/license/timo-reymann/gpg-key-creation-assistant)](https://github.com/timo-reymann/gpg-key-creation-assistant/blob/main/LICENSE)


<p align="center">
	<img width="300" src="./.github/images/logo.png">
    <br />
    Plain shell assistant helping you setting up a new GPG key.
</p>

## Features

- create new key
- export private and public key
- set up git
    - local config
    - in case gh cli is installed, try to publish gpg key
    - provide instructions to add key to
        - GitHub
        - GitLab

## Requirements

- [gpg already installed](#How-to-install-GPG)
- [bash 3+](https://www.gnu.org/software/bash/)

## Usage

### ... with curl

```bash
bash <(curl -sS https://raw.githubusercontent.com/timo-reymann/gpg-key-creation-assistant/main/assistant)
```

### ... with wget

```bash
bash <(wget -qO- https://raw.githubusercontent.com/timo-reymann/gpg-key-creation-assistant/main/assistant)
```

## Motivation

Setting up GPG is a task often seen as very complicated by developers.

So most people just dont do it, having a portable installer is a proposed solution from me.

The idea is simple: Provide a step by step guide making it almost a no brainer creating a key and setting it up
properly.

## Documentation

### How to install GPG

#### MacOS

- Install [GPG Suite](https://gpgtools.org/)
- GPG is added to path by default

#### Linux

- Install [Gnu GPG 2](https://gnupg.org/download/)
- GPG is in PATH if installed with package manager by default

#### Windows

- Install Git for Windows, the git bash includes gpg by default
- Alternative: Install [GPG4Win](https://www.gpg4win.org/download.html)
- Make sure the gpg.exe is in your PATH

## Contributing

I love your input! I want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the configuration
- Submitting a fix
- Proposing new features
- Becoming a maintainer

To get started please read the [Contribution Guidelines](./CONTRIBUTING.md).

## Development

### Requirements

- [GNU make](https://www.gnu.org/software/make/)
- [Docker](https://docs.docker.com/get-docker/)

### Build

````sh
make build
````

### Credits

- Logo
  - Girl used as assistant in README
    from [seekpng](https://www.seekpng.com/ipng/u2w7w7a9e6a9y3o0_child-teacher-clipart-teacher-assistant-clip-art/)
  - GNU PG Logo from [Wikimedia Commons](https://de.wikipedia.org/wiki/Datei:GnuPG-Logo.svg)
