# ${bashbashrc_dir}/promptcommand.d/99printstat.sh
_pc_printstat() {
  local shlv="[${SHLVL:-1}]"
  [ ${SHLVL:-1} -gt 1 ] || shlv=""
  case "${TERM:-xterm}" in
  xterm*)
    printf "\033]0;%s@%s%s:%s\007" \
      "${USER:-}" "${HOSTNAME%%.*}" "${shlv}" "${PWD/#$HOME/~}"
    ;;
  screen*|tmux*)
    printf "\033]0;%s@%s%s:%s\033\\" \
      "${USER:-}" "${HOSTNAME%%.*}" "${shlv}" "${PWD/#$HOME/~}"
    ;;
  *)
    ;;
  esac
  return 0
} 2>/dev/null
