# ${bashbashrc_dir}/environment.d/mbox.sh

[ -n "${USER:-}" ] ||
  return 0

# Lookup Mbox config
for mboxconffile in \
"${bashrc_userdir:-$HOME}"/{,.}mbox.conf
do
  [ -f "${mboxconffile}" ] &&
  . "${mboxconffile}" &&
  break || :
done 2>/dev/null || :
unset mboxconffile

# Env: MBOX
if [ -z "${MBOX:-}" ]
then
  [ -z "${MBOX:-}" -a \
    -d "${XDG_DATA_HOME:-$HOME/.local/share}" ] &&
  MBOX="${XDG_DATA_HOME:-$HOME/.local/share}/mbox" ||
  [ -z "${MBOX:-}" -a \
    -d "${HOME}/.local" ] &&
  MBOX="${HOME}/.local/mbox" || :
  [ -z "${MBOX:-}" ] ||
  export MBOX
fi

# Env: DEAD
if [ -z "${DEAD:-}" ]
then
  [ -z "${DEAD:-}" -a \
    -d "${XDG_DATA_HOME:-$HOME/.local/share}" ] &&
  DEAD="${XDG_DATA_HOME:-$HOME/.local/share}/dead.letter" || :
  [ -z "${DEAD:-}" -a \
    -d "${HOME}/.local" ] &&
  DEAD="${HOME}/.local/dead.letter" || :
  [ -z "${DEAD:-}" ] ||
  export DEAD
fi

# Env: MAIL
if [ -z "${MAIL:-}" ]
then
  # Mail spool dir
  mailspooldir=""
  # Lookup Mail spool dir
  for mailspooldir in /var/spool/mail /var/mail
  do
    [ -d "${mailspooldir:-}" ] &&
    break || :
  done 2>/dev/null || :
  [ -d "${mailspooldir:-X}" ] &&
  MAIL="${mailspooldir}/${USER}"
  [ -z "${MAIL:-}" ] ||
  export MAIL
  # Cleanup
  unset mailspooldir
fi

# Env: MAILPATH
if [ -z "${MAILPATH:-}" ]
then
  MAILPATH=""
  if [ -n "${MAIL}" ]
  then
    MAILPATH="${MAILPATH:+$MAILPATH:}"
    MAILPATH="${MAILPATH}${MAIL}"
    MAILPATH="${MAILPATH}?Your have mail."
  fi
  if [ -n "${DEAD}" ]
  then
    MAILPATH="${MAILPATH:+$MAILPATH:}"
    MAILPATH="${MAILPATH}${DEAD}"
    MAILPATH="${MAILPATH}?Delivery errors detected,"
    MAILPATH="${MAILPATH} Check file '\$_'."
  fi
fi

# Env: Email check interval
if [ -z "${MAILCHECK:}" ]
then
  MAILCHECK=60
fi

# End
return 0
