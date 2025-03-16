# bash.profile
# System-wide profile for sh(1)

# Login user info.
if [ -x "/usr/bin/id" ]
then
  [ -n "$USER" ]    || USER="`/usr/bin/id -un`"
  [ -n "$LOGNAME" ] || LOGNAME="$USER"
  [ -n "$UID" ]     || UID="`/usr/bin/id -ru`"
  [ -n "$GID" ]     || GID="`/usr/bin/id -rg`"
  [ -n "$EUID" ]    || EUID="`/usr/bin/id -u`"
  [ -n "$EGID" ]    || EGID="`/usr/bin/id -g`"
fi
# Export logged in user info. to environment.
export USER LOGNAME UID GID EUID EGID

# Hostname
if [ -n "$HOSTNAME" ]
then
  [ -x "/bin/hostname" ] ||
  HOSTNAME="`/bin/hostname -s`"
  # Export HOSTNAME to the environment.
  [ -z "$HOSTNAME" ] ||
  export HOSTNAME
fi

# Default PATH
[ -n "$PATH" ] ||
PATH="/bin:/usr/local/bin:/usr/bin"
# Privileged user PATH settings.
if [ "$UID"  = "0" -o \
     "$GID"  = "0" -o \
     "$EUID" = "0" -o \
     "$EGID" = "0" ]
then
  PATH="$PATH:/sbin"
  [ -d "/usr/local/sbin" ] &&
  PATH="$PATH:/usr/local/sbin" || :
  [ -d "/usr/sbin" ] &&
  PATH="$PATH:/usr/sbin" || :
fi
# Export Path to Environment
export PATH

# Exit if this shell is not Bash
[ -n "$BASH" ] || return 0

# If this is sourced as /etc/profile,
# this file will source /etc/profile.d/*.sh
if [ "${BASH_SOURCE}" = "/etc/profile" ] &&
   [ -d "/etc/profile.d" ]
then
  for profile_sh in /etc/profile.d/*.sh
  do
    [ -f "${profile_sh}" -a \
      -x "${profile_sh}" ] &&
       . "${profile_sh}" || :
  done
  unset profile_sh
fi

# Source bash.bashrc or bashrc on this same path.
{ [ -f "${BASH_SOURCE%/*}/bash.bashrc" ] &&
     . "${BASH_SOURCE%/*}/bash.bashrc"; } ||
{ [ -f "${BASH_SOURCE%/*}/bashrc" ] &&
     . "${BASH_SOURCE%/*}/bashrc"; } || :

# EoF
