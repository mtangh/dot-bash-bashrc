# ${bashbashrc_dir}/06_stty.sh
[ -n "$BASH" ] ||  return 0

# Skip all for non-interactive shells.
[[ "$-" = *i* ]] && [ -t 0 ] && {

  # Disable flow control.
  stty -ixon

  # dismiss Ctrl-o:
  # Toggle discarding of output.
  stty discard undef

  # dismiss Ctrl-s:
  # Stop the output.
  stty stop undef

  # dismiss Ctrl-q:
  # Restart the output after stopping it.
  stty start undef

} &>/dev/null || :

# end
return 0