gpg-key-creation-assistant
===
> Currently WIP

Plain shell assistant helping you setting up a new GPG key.

## Requirements
- [gpg already installed](#How-to-install-GPG)
- bash 4+

## Features
- create new key
- export private and public key
- set up git
   - local config
   - provide instructions for
        - GitHub
        - GitLab

## Usage
```bash
bash <(wget -qO- https://raw.githubusercontent.com/timo-reymann/gpg-key-creation-assistant/main/assistant)
```

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

