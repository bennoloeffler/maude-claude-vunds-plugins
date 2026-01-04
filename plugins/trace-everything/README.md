# Trace Everything

Hooks-based tracing plugin for Claude Code. Logs user prompts, tool calls, tool results, and assistant responses to a per-session trace file.

## Warning

Trace logs can contain sensitive data (prompts, tool inputs, secrets). Use only when needed and store logs securely.

## Log Path

`~/.maude/trace-logs-of-everything/ISO-DATE--hh-mm-ss--user-sessionName-TRACE.log`

## Enable / Disable

Tracing is only active when `MAUDE_TRACE_ON=true`.

- Enable (session): `export MAUDE_TRACE_ON=true`
- Disable (session): `export MAUDE_TRACE_ON=false`

Optional persistence:

```sh
cat << 'JSON' > ~/.maude/trace-settings.json
{
  "enabled": true
}
JSON
```

## Commands

- `/trace on`
- `/trace off`
- `/trace folder`
- `/traces analyze`

## Install

```text
/plugin marketplace add bennoloeffler/maude-claude-vunds-plugins
/plugin install trace-everything@maude-claude-vunds-plugins
```
