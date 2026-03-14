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
| [git](https://git-scm.com/) | `gitlog`, `gitdiff` |
| [docker](https://www.docker.com/) | `dexec` |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | `kctx`, `kpod`, `ktop` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fzf default command |
| [bat](https://github.com/sharkdp/bat) | `notes` (optional, falls back to `cat`) |

## Commands

### Git

| Command | Description |
|---|---|
| `gitlog` | Browse git log with fzf preview |
| `gitdiff` | Browse changed files with inline diff preview |

### Kubernetes

| Command | Description |
|---|---|
| `kctx` | Switch Kubernetes context |
| `kpod` | Interactive pod manager (enter: exec, ctrl-l: logs, ctrl-p: prev logs) |
| `ktop` | Live pod CPU/memory dashboard (`-s cpu\|mem`, `-i` interval) |

### Docker

| Command | Description |
|---|---|
| `dcon` | Interactive container manager (enter: exec, ctrl-l: logs) |

### Notes

| Command | Description |
|---|---|
| `note` | Create a note in `~/Documents/notes` by category (daily, projects, people, learning, ideas) |
| `notes` | Open notes vault in Helix |
