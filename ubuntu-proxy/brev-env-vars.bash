_brev_hook() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$(/home/linuxbrew/.linuxbrew/bin/brev configure-env-vars bash)";
  trap - SIGINT;
  return $previous_exit_status;
};
if ! [[ "${PROMPT_COMMAND:-}" =~ _brev_hook ]]; then
  PROMPT_COMMAND="_brev_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
