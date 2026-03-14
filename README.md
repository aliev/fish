# fish

A collection of fzf-powered utilities for fish shell: git, Kubernetes, Docker, and notes.

## Installation

Using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install aliev/fish
```

## Dependencies

| Dependency | Required by |
|---|---|
| [fzf](https://github.com/junegunn/fzf) | all commands |
| [git](https://git-scm.com/) | `gitlog`, `gitdiff`, `gitblame`, `ghpr` |
| [gh](https://cli.github.com/) | `ghpr` |
| [docker](https://www.docker.com/) | `dexec` |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | `kctx`, `kexec`, `klogs`, `ktop` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fzf default command |
| [bat](https://github.com/sharkdp/bat) | `notes` (optional, falls back to `cat`) |

## Commands

### Git

| Command | Description |
|---|---|
| `gitlog` | Browse git log with fzf preview |
| `gitdiff` | Browse changed files with inline diff preview |
| `gitblame` | Browse files and their git blame interactively |
| `ghpr` | Browse and open pull requests via GitHub CLI |

### Kubernetes

| Command | Description |
|---|---|
| `kctx` | Switch Kubernetes context |
| `kexec` | Exec into a pod (bash/sh) |
| `klogs` | Stream pod logs (`-p` for previous) |
| `ktop` | Live pod CPU/memory dashboard (`-s cpu\|mem`, `-i` interval) |

### Docker

| Command | Description |
|---|---|
| `dexec` | Exec into a running container (bash/sh) |

### Notes

| Command | Description |
|---|---|
| `note` | Create a note in `~/notes` by category (daily, projects, people, learning, ideas) |
| `notes` | Fuzzy-search and open notes from `~/notes` |
