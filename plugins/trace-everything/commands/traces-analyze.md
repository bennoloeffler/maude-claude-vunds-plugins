Traces: Analyze

Best-effort quick scan of the latest trace log:

LATEST=$(ls -t ~/.maude/trace-logs-of-everything/*-TRACE.log 2>/dev/null | head -1)
if [ -z "$LATEST" ]; then
  echo "No trace logs found."
  exit 0
fi

echo "Latest trace: $LATEST"

echo "\nTop tools (counts):"
grep -E -o "TOOL [^ ]+" "$LATEST" | sort | uniq -c | sort -nr | head -20

echo "\nTop MCP events (counts):"
grep -o "MCP" "$LATEST" | sort | uniq -c | sort -nr | head -20

echo "\nTop SKILL events (counts):"
grep -o "SKILL" "$LATEST" | sort | uniq -c | sort -nr | head -20
