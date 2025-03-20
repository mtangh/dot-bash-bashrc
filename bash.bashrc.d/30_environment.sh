# ${bashbashrc_dir}/30_environment.sh

# Environments

## EDITOR
[ -z "${EDITOR:-}" ] && EDITOR="$(type -P vi)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -P vim)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -P emacs)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -P pico)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -P nano)"
[ -z "${EDITOR:-}" ] || export EDITOR
[ -z "${EDITOR:-}" ] && unset  EDITOR || :

## PAGER
[ -z "${PAGER:-}" ] && PAGER="$(type -P lv)"
[ -z "${PAGER:-}" ] && PAGER="$(type -P jless)"
[ -z "${PAGER:-}" ] && PAGER="$(type -P less)"
[ -z "${PAGER:-}" ] && PAGER="$(type -P more)"
[ -z "${PAGER:-}" ] || export PAGER
[ -z "${PAGER:-}" ] && unset  PAGER || :

## RSYNC
[ -x "`type -P rsync`" -a -x "`type -P ssh`" ] && {
  RSYNC_RSH="`type -P ssh`"; export RSYNC_RSH; } || :

## CVS
[ -x "`type -P cvs`" -a -x "`type -P ssh`" ] && {
  CVS_RSH="`type -P ssh`"; export CVS_RSH; } || :

# Exit if this shell is not Bash
[ -n "$BASH" ] || return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

# load environments
for env_path in \
"${bashbashrc_dir}/environment" \
"${bashrclocaldir:-X}/environment" \
"${bashrc_userdir:-X}/{,.}bash_environment" \
"${bashrc_userdir:-X}/{,.}environment"
do
  [ -e "${env_path}" -o \
    -d "${env_path}.d" ] &&
  for env_file in \
  "${env_path}" \
  "${env_path}.d"{"/${ostype:-OS}","/${vendor:-OV}"}/* \
  "${env_path}.d/hosts/${HOSTNAME%%.*}"/*
  do
    [ -f "${env_file}" -a -x "${env_file}" ] && {
    set +u; . "${env_file}"; set -u; }
  done || :
  unset env_file
done
unset env_path

# End
return 0
