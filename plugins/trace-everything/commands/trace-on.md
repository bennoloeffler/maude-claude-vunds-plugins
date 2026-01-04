Trace Everything: ON

Do this in the Claude Code terminal to enable tracing for this session:

export MAUDE_TRACE_ON=true

Optional: persist across sessions by writing a small settings file:

cat << 'JSON' > ~/.maude/trace-settings.json
{
  "enabled": true
}
JSON
