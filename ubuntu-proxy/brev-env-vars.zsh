_brev_hook() {
  trap -- '' SIGINT;
  eval "$(/home/linuxbrew/.linuxbrew/bin/brev configure-env-vars zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_brev_hook]+1}" ]]; then
  precmd_functions=( _brev_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_brev_hook]+1}" ]]; then
  chpwd_functions=( _brev_hook ${chpwd_functions[@]} )
fi
