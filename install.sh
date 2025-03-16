#!/bin/bash
# shellcheck disable=SC2015,SC2034,SC2120,SC2124,SC2128,SC2166
[ -n "$BASH" ] 1>/dev/null 2>&1 || {
echo "Run it in bash." 1>&2; exit 1; }
THIS="${BASH_SOURCE:-./install.sh}"
NAME="${THIS##*/}"
BASE="${NAME%.*}"
CDIR=$([ -n "${THIS%/*}" ] && cd "${THIS%/*}" &>/dev/null || :; pwd)
# Prohibits overwriting by redirect and use of undefined variables.
set -Cu
# The return value of a pipeline is the value of the last command to
# exit with a non-zero status.
set -o pipefail
# Case insensitive regular expressions.
shopt -s nocasematch
# Path
PATH=/usr/bin:/usr/sbin:/bin:/sbin; export PATH
# Git Project URL
GIT_PROJ_URL="${GIT_PROJ_URL:-https://github.com/mtangh/dot-bash-bashrc.git}"
# Git Project name
GIT_PROJNAME="${GIT_PROJ_URL##*/}"
GIT_PROJNAME="${GIT_PROJNAME%.git}"
# Install Prefix
INSTALL_PREFIX="${INSTALL_PREFIX:-}"
# Install Source
INSTALL_SOURCE="${INSTALL_SOURCE:-}"
# Install Workdir
[ -n "${INSTALLWORKDIR:-}" ] ||
INSTALLWORKDIR="$(cd ${TMPDIR:-/tmp} || :;pwd)/${GIT_PROJNAME}.$$"
# Timestamp
INSTALL_TIMEST="$(date +'%Y%m%dT%H%M%S')"
# Flag: Xtrace
X_TRACE_ON=0
# Flag: dry-run
DRY_RUN_ON=0
# Function: Stdout
_stdout() {
  local ltag="${1:-$GIT_PROJNAME/$NAME}"
  local line=""
  cat - | while IFS= read -r line
  do
    [[ "${line}" = ${ltag}:* ]] ||
    printf "%s: " "${ltag}"; echo "${line}"
  done
  return 0
}
# Function: Echo
_echo() {
  echo "$@" |_stdout
}
# Function: Abort
_abort() {
  local exitcode=1 &>/dev/null
  local messages="$@"
  [[ ${1:-} =~ ^[0-9]+$ ]] && {
    exitcode="${1}"; shift;
  } &>/dev/null
  echo "ERROR: ${messages} (${exitcode:-1})" |_stdout 1>&2
  [ ${exitcode:-1} -le 0 ] || exit ${exitcode:-1}
  return 0
}
# Function: Cleanup
_cleanup() {
  if [ ${DRY_RUN_ON:-0} -eq 0 ]
  then
    [ -n "${INSTALLWORKDIR:-X}" ] ||
    rm -rf "${INSTALLWORKDIR}" &>/dev/null || :
  else
    echo rm -rf "${INSTALLWORKDIR:-}"
  fi
  return 0
}
# Function: usage
_usage() {
cat - <<_USAGE_
Usage: ${GIT_PROJNAME}/${NAME} [OPTIONS]

OPTIONS:

-G, --global
  Install in the global scope.
-U, --user
  Install in the user environment.
-D, --debug
  Enable debug output.
-n, --dry-run
  Dry run mode

_USAGE_
  return 0
}
# Commands
git_cmnd="$(type -P git)"
[ -z "${git_cmnd}" ] && {
  _abort 1 "Command (git) not found."; } || :
diff_cmd="$(type -P diff)"
[ -z "${diff_cmd}" ] && {
  _abort 1 "Command (diff) not found."; } || :
patchcmd="$(type -P patch)"
[ -z "${patchcmd}" ] && {
  _abort 1 "Command (patch) not found."; } || :
# Debug
[[ "${DEBUG:-NO}" =~ ^([1-9][0-9]*|YES|ON|TRUE)$ ]] && {
  X_TRACE_ON=1; DRY_RUN_ON=1; } || :
# Parsing command line options
while [ $# -gt 0 ]
do
  case "${1:-}" in
  -G*|--global*|--system*)
    INSTALL_PREFIX="/etc"
    ;;
  -U*|--user*)
    INSTALL_PREFIX="${XRG_CONFIG_HOME:-$HOME/.config}"
    ;;
  -D*|-debug*|--debug*)
    X_TRACE_ON=1
    ;;
  -n*|-dry-run*|--dry-run*)
    DRY_RUN_ON=1
    ;;
  -h|-help*|--help*)
    _usage; exit 0
    ;;
  *)
    _abort 22 "Invalid argument, argv='${1:-}'."
    ;;
  esac
  shift
done
# Install Prefix
[ -n "${INSTALL_PREFIX:-}" ] ||
INSTALL_PREFIX="${XDG_CONFIG_HOME:-$HOME/.config}"
# Need SUDO
[ "${INSTALL_PREFIX}" != "/etc" ] ||
[ "$(id -u)" == "0" ] || _abort 1 "Need SUDO."
# Enable trace, verbose
[ ${X_TRACE_ON:-0} -eq 0 ] || {
  PS4='>(${LINENO:--})${FUNCNAME+:$FUNCNAME()}: '
  export PS4; set -xv; shopt -s extdebug; }
# Set trap
: "Trap" && {
  # Set trap
  trap "_cleanup" SIGTERM SIGHUP SIGINT SIGQUIT
  trap "_cleanup" EXIT
} || :
# Print message
cat - <<_MSG_ |_stdout
Date=${INSTALL_TIMEST}
_MSG_
# Install Source
if [ -z "${INSTALL_SOURCE:-}" ] &&
   [ -n "${CDIR}" -a -e "${CDIR}/.git" ]
then
  # Set script dir to install source
  ( cd "${CDIR}" &&
    ${git_cmnd} config --get remote.origin.url |
    grep -E "/${GIT_PROJNAME}[.]git\$" &&
    "${git_cmnd}" pull; ) &>/dev/null &&
  INSTALL_SOURCE="${CDIR}" && {
cat - <<_MSG_ |_stdout
Git repo detected,
Set script dir to install source dir.
_MSG_
  }
fi
# Clone repo if not repo
if [ -z "${INSTALL_SOURCE:-}" ]
then
  # clone
cat - <<_MSG_
No Git repo detected,
Clone git repo '${GIT_PROJ_URL}'
and proceed with installation.''."
_MSG_
  # Set install source from git proj.
  ( [ ! -d "${INSTALLWORKDIR:-}" ] ||
    mkdir -p "${INSTALLWORKDIR}" &&
    cd "${INSTALLWORKDIR}" &&
    "${git_cmnd}" clone "${GIT_PROJ_URL}" &&
    cd "./${GIT_PROJNAME}" || exit $?; ) 2>&1 |
  _stdout
  # Install source
  INSTALL_SOURCE=$(
    cd "${INSTALLWORKDIR}/${GIT_PROJNAME}.git" &>/dev/null &&
    pwd; )
  [ -e "${INSTALL_SOURCE:-X}" ] ||
  _abort 2 "No such file or directory, 'INSTALL_SOURCE'."
cat - <<_MSG_ |_stdout
Git repo clone successful." ||
_MSG_
fi
# Print variables
cat - <<_MSG_ |_stdout
INSTALLWORKDIR="${INSTALLWORKDIR}"
INSTALL_SOURCE="${INSTALL_SOURCE}"
INSTALL_PREFIX="${INSTALL_PREFIX}"
_MSG_
# Insatll
: "Install" && {
  installfiles=$(
    find "${INSTALL_SOURCE}" -mindepth 1 -maxdepth 1 -name "bash*" |
    sort; )
  # Each files and directories
  while read -r filepath
  do
    basename="${filepath##*/}"
    destpath="${INSTALL_PREFIX}/${basename}"
    patchout="${INSTALL_PREFIX}/.${basename}-${INSTALL_TIMEST}.patch"
cat - <<_MSG_ |_stdout
${basename}: Patch to '${destpath}'. (${patchout##*/})
_MSG_
    _echo "Source=${basename} to=${destpath}."
    [ -d "${filepath}" -a ! -d "${destpath}" ] && {
      mkdir -p "${destpath}"; } &>/dev/null || :
    ( cd "${INSTALL_PREFIX}" &&
      "${diff_cmd}" -Nur "./${basename}" "${filepath}" |
      tee "${patchout}" |
      if [ ${DRY_RUN_ON:-0} -eq 0 ]
      then "${patchcmd}" -p0
      else cat -; fi || exit $?
      if [ -d "./${basename}" ]
      then
        [ ${DRY_RUN_ON:-0} -eq 0 ] &&
        drun="" || drun="echo"
        ${drun} cd "./${basename}" && {
        ${drun} find ./bin -type f -exec chmod a+x {} \;
        ${drun} find . -type f -a -name "*.sh" -exec chmod a+x {} \; ; }
      fi || :; ) 2>&1 |_stdout
    [ $? -eq 0 ] ||
    _abort 1 "Failed update '${basename}'."
  done < <(echo "${installfiles}")
} # : "Install"
# Complete
_echo "Done."
# End
exit 0
