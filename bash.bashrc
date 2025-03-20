# bash.bashrc
# Global bashrc file for interactive bash(1) shells.

# Bash ?
[ -z "$BASH" ] && return 0 || :

# Skip all for noninteractive shells.
[ ! -t 0 ] 1>/dev/null 2>&1 && return 0 || :

# When a recursive call is detected,
# the program will exit without doing anything.
[[ "${BASH_SOURCE[*]}" \
   =~ .*\ (${BASH_SOURCE})(\ .*|\ *)$ ]] && {
  [[ "${re:-}" =~ ^Set$ ]] || :
  return 0; } || :
# If sourced from the user's bashrc in a login shell,
# bash.bashrc will exit without doing anything.
shopt -q login_shell &&
[[ "${BASH_SOURCE[*]}" \
   =~ /[.]bashrc(\ .*|\ *)$ ]] && {
  [[ "${re:-}" =~ ^Set$ ]] || :
  return 0; } || :

# Prompt setting (default)
PS1='\u@\h \W\$ '

# bash resource configs default
bashbashrcname="${BASH_SOURCE##*/}"
bashbashrcname="${bashbashrcname:-bash.bashrc}"
[ -d "${BASH_SOURCE}.d" ] &&
bashbashrc_dir=$(cd "${BASH_SOURCE}.d" && pwd) ||
bashbashrc_dir="/etc/${bashbashrcname}.d"

# bash resource configs (system local)
[ -d "/usr/local/etc/bash" ] &&
bashrclocaldir="/usr/local/etc/bash" ||
bashrclocaldir="/usr/local/bash"

# bash resource configs (user)
{ [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/bash" ] &&
  bashrc_userdir="${XDG_CONFIG_HOME:-$HOME/.config}/bash"; } ||
{ [ -d "${XDG_CONFIG_HOME:-$HOME/.config}" ] &&
  bashrc_userdir="${XDG_CONFIG_HOME:-$HOME/.config}"; } ||
{ [ -d "${HOME}/.bash" ] &&
  bashrc_userdir="${HOME}/.bash"; } ||
bashrc_userdir="${HOME}"

# Source the system-wide bashrc.
if [ -e "/etc/bashrc" ]
then . "/etc/bashrc"
fi || :

# 'bash.bashrc.d' Initialization
[ -d "${bashbashrc_dir:-X}" ] && {

  # path config
  [ -x "${bashbashrc_dir}/bin/pathconfig" ] &&
  pathconf="${bashbashrc_dir}/bin/pathconfig" ||
  pathconf=":"

  # tests version
  [ -x "${bashbashrc_dir}/bin/tests-version.sh" ] &&
  testsver="${bashbashrc_dir}/bin/tests-version.sh" ||
  testsver=":"

  # Treat unset variables as an error when performing parameterr expansion.
  set -Cu

  # Load to the 'bash.bashrc.d' scripts
  for bashrcsh in \
  "${bashbashrc_dir}"/[0-9][0-9]_*.sh{,.${ostype:-OS},.${vendor:-ARCH}} \
  "${bashrclocaldir:-X}"/[0-9][0-9]_*.sh
  do
    [ -f "${bashrcsh}" -a -x "${bashrcsh}" ] &&
    . "${bashrcsh}" || :
  done
  unset bashrcsh
  # Reset BASH_REMATCH
  [[ "${re:-}" =~ ^Set$ ]] || :

  # Unset 'Cu'
  set +Cu

  # Unset all variables
  unset pathconf testsver

} || :
# [ -d "${bashbashrc_dir:-X}" ]

# Unset all variables
unset bashbashrcname
unset bashbashrc_dir
unset bashrclocaldir bashrc_userdir

# EoF
