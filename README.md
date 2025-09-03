# LLM Agent Configuration

This repository contains configuration files for LLM agents, currently
[Claude Code](https://github.com/anthropics/claude-code)
and [Codex CLI](https://github.com/openai/codex).

## Claude

Includes statusline customization and specialized agents. PRs are welcome for
interesting and/or useful agents. MCP servers (of which we currently have none) are also
welcome.

Status line currently reads:

```text
cwd | git-branch | v1.x.y (+123|-456)
```

with colors:

```text
blue | cyan/magenta | yellow (green|red)
```

The git branch is cyan when clean, magenta when dirty.

## Codex

Configures permissions to be a bit more lax than the default, and allow network access.
