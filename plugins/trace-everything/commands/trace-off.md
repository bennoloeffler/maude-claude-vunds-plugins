Trace Everything: OFF

Disable tracing for this session:

export MAUDE_TRACE_ON=false

Optional: persist across sessions by updating settings:

cat << 'JSON' > ~/.maude/trace-settings.json
{
  "enabled": false
}
JSON
