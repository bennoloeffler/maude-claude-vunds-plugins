#!/usr/bin/env bash
set -euo pipefail

EVENT="${1:-UnknownEvent}"
TRACE_DIR="${HOME}/.maude/trace-logs-of-everything"
TRACE_SETTINGS="${HOME}/.maude/trace-settings.json"

payload="$(cat)"

trace_enabled="${MAUDE_TRACE_ON:-}"

if [ -z "${trace_enabled}" ] && [ -f "${TRACE_SETTINGS}" ]; then
  if command -v jq >/dev/null 2>&1; then
    trace_enabled="$(jq -r '.enabled // empty' "${TRACE_SETTINGS}" 2>/dev/null || true)"
  else
    trace_enabled="$(sed -n 's/.*"enabled"[[:space:]]*:[[:space:]]*\(true\|false\).*/\1/p' "${TRACE_SETTINGS}" 2>/dev/null || true)"
  fi
fi

if [ "${trace_enabled:-false}" != "true" ]; then
  exit 0
fi

mkdir -p "${TRACE_DIR}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

has_jq=0
if command -v jq >/dev/null 2>&1; then
  has_jq=1
fi

get_json() {
  local key="$1"
  if [ "${has_jq}" -eq 1 ]; then
    printf '%s' "${payload}" | jq -r "${key} // empty" 2>/dev/null || true
  else
    printf ''
  fi
}

session_id="$(get_json '.session_id')"
session_name="$(get_json '.session_name')"
project_dir="$(get_json '.project_dir')"
project_name="$(basename "${project_dir:-unknown}")"

session_key="${session_id:-${session_name:-${project_name}}}"
session_key="${session_key//[^A-Za-z0-9._-]/_}"

session_file="${TRACE_DIR}/.session-${session_key}"
if [ -f "${session_file}" ]; then
  log_file="$(cat "${session_file}")"
else
  log_file="${TRACE_DIR}/$(date -u +"%Y-%m-%d--%H-%M-%S")--${USER}-${session_key}-TRACE.log"
  printf '%s' "${log_file}" > "${session_file}"
  printf '[%s] MAUDE TRACE_START session=%s project=%s\n' "${timestamp}" "${session_key}" "${project_name}" >> "${log_file}"
fi

tool_name="$(get_json '.tool_name')"
tool_input="$(get_json '.tool_input')"
tool_response="$(get_json '.tool_response')"
user_prompt="$(get_json '.user_prompt')"
assistant_response="$(get_json '.assistant_response')"

category="MAUDE"
message="EVENT ${EVENT}"

case "${EVENT}" in
  UserPromptSubmit)
    category="USER"
    message="PROMPT ${user_prompt}"
    ;;
  PreToolUse)
    category="TOOL ${tool_name} INPUT"
    message="${tool_input}"
    ;;
  PostToolUse)
    if printf '%s' "${tool_name}" | grep -qi 'mcp'; then
      category="MCP"
      message="${tool_response}"
    elif printf '%s' "${tool_name}" | grep -qi 'skill'; then
      category="SKILL"
      message="${tool_response}"
    else
      category="TOOL ${tool_name} RESULT"
      message="${tool_response}"
    fi
    ;;
  Stop)
    category="ASSISTANT"
    message="${assistant_response}"
    ;;
  SessionStart|SessionEnd)
    category="MAUDE"
    message="${EVENT}"
    ;;
  *)
    category="MAUDE"
    message="EVENT ${EVENT}"
    ;;
esac

printf '[%s] %s %s\n' "${timestamp}" "${category}" "${message}" >> "${log_file}"

if [ "${has_jq}" -eq 1 ]; then
  compact="$(printf '%s' "${payload}" | jq -c '.' 2>/dev/null || printf '%s' "${payload}")"
  printf '[%s] RAW_JSON %s\n' "${timestamp}" "${compact}" >> "${log_file}"
else
  printf '[%s] RAW_JSON %s\n' "${timestamp}" "${payload}" >> "${log_file}"
fi
