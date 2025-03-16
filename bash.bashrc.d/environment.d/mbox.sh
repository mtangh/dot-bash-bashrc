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

# End
return 0
