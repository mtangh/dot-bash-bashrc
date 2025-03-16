# ${bashbashrc_dir}/99_user_bashrc.sh
[ -n "$BASH" ] ||  return 0

: "user_bashrc" && {

  # When '~/.bash_profile' does not exist during '/etc/profile'
  # processing of the login shell.
  if shopt -q login_shell &&
     [[ "${BASH_SOURCE[*]}" =~ \ /etc/profile$ ]] &&
     [ ! -f "${HOME}/.bash_profile" ]
  then
    if [ -f "${HOME}/.bashrc" ]
    then
      # If it is not a recursive call, it will process '~/.bashrc'.
      [[ "${BASH_SOURCE[*]}" \
         =~ .*\ ${HOME}/.bashrc(\ .*|\ *)$ ]] ||
      . ${HOME}/.bashrc
    fi
  fi

  # Source the scripts in the '${bashrc_userdir}' directory.
  if [ -d "${bashrc_userdir:-X}" ]
  then
    for dot_rc_scr in \
    "${bashrc_userdir}"/*.sh{,.${ostype:-OS},.${vendor:-OV}}
    do
      [ -f "${dot_rc_scr}" -a -x "${dot_rc_scr}" ] && {
      set +u; . "${dot_rc_scr}"; set -u; } || :
    done
    unset dot_rc_scr
  fi

} 2>/dev/null || :

# End
return 0
