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

# Env: MBOX and DEAD
if [ -z "${MBOX:-}" -o -z "${DEAD:-}" ]
then
  if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}" ]
  then
    [ -n "${MBOX}" ] ||
    MBOX="${XDG_DATA_HOME:-$HOME/.local/share}/mbox"
    [ -n "${DEAD}" ] ||
    DEAD="${XDG_DATA_HOME:-$HOME/.local/share}/dead.letter"
  fi
  if [ -d "${HOME}/.local" ]
  then
    [ -n "${MBOX}" ] ||
    MBOX="${HOME}/.local/mbox"
    [ -n "${DEAD}" ] ||
    DEAD="${HOME}/.local/dead.letter"
  fi
fi
# Export MBOX and DEAD
[ -z "${MBOX:-}" ] ||
export MBOX
[ -z "${DEAD:-}" ] ||
export DEAD

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
  # Cleanup
  unset mailspooldir
fi
# Export MAIL
[ -z "${MAIL:-}" ] ||
export MAIL
  
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
# Export MAILPATH
[ -z "${MAILPATH:-}" ] ||
export MAILPATH

# Env: Email check interval
if [ -z "${MAILCHECK:}" ]
then
  MAILCHECK=60
fi

# End
return 0
