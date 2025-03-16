# java_home.sh
# shellcheck disable=SC2010,SC2139

[ -z "${JAVA_HOME_SELECTED:-}" ] ||
return 0 &>/dev/null

# Functions

## Java Home Versions
java-home-versions() {
  local jhomedir=""
  case "${MACHTYPE:-}" in
  *-apple-darwin*)
    jhomedir="/Library/Java/JavaVirtualMachines"
    if [ -d "${jhomedir}" ]
    then ls -1 "${jhomedir}"/*/Contents/Home/bin/java
    else :
    fi |awk -F/ -f <(
cat - <<'_EOF_'
$5~/[.]jdk$/{
  gsub(/^[^-]+-/,"",$5);
  gsub(/([.]0[.]|[.])jdk$/,"",$5);
  gsub(/^1[.]/,"",$5);
  print($5);
};
_EOF_
    )
    ;;
  *-*-linux-*)
    jhomedir="/usr/lib/jvm"
    if [ -d "${jhomedir}" ]
    then ls -1 "${jhomedir}"/*/bin/java
    else :
    fi |awk -F/ -f <(
cat - <<'_EOF_'
$5~/^java-(1[.][6-9][.][0-9]$|[1-9][0-9]*$|[1-9][0-9]*-openjdk(-[a-z]+$|$))/{
  gsub(/^java(-1[.]|-)/,"",$5);
  gsub(/([.]0$|[.]0-openjdk.*$|-openjdk.*$)/,"",$5);
  print($5);
}
_EOF_
    )
    ;;
  *)
    ;;
  esac 2>/dev/null |
  sort -un || :
  return 0;
}

## Java SDK select
java-home-select() {
  local java_ver="${1:-}"
  local jhomedir=""
  local jhomecmd=""
  local java_cmd=""
  [ -n "${java_ver:-}" ] ||
  java_ver="${JAVA_VERSION:-}"
  [ -n "${java_ver:-}" ] ||
  java_ver=$(java-home-versions |tail -n1 2>/dev/null)
  case "${MACHTYPE:-}" in
  *-apple-darwin*)
    jhomedir="/Library/Java/JavaVirtualMachines"
    jhomecmd=$(type -p java_home)
    jhomecmd="${jhomecmd:-/usr/libexec/java_home}"
    if [ -x "${jhomecmd:-X}" ]
    then
      case "${java_ver:-}" in
      [6-9]|[6-9].*)
        java_ver="1.${java_ver}"
        ;;
      esac
      java_cmd=$(echo "$(${jhomecmd} -v ${java_ver})/bin/java")
    fi
    if [ ! -x "${java_cmd:-X}" ]
    then
      java_cmd=$(
        ls -1 "${jhomedir}"/*/Contents/Home/bin/java |grep -E \
        "/Java[^/]+/([^.0-9]*)(${java_ver}|${java_ver#1.})[^0-9]*.*[.]jdk/" |
        sort -r |head -n1; )
    fi
    ;;
  *-*-linux-*)
    jhomedir="/usr/lib/jvm"
    java_cmd=$(
      ls -1 "${jhomedir}"/*/bin/java |grep -E \
      "/jvm/([^.0-9]*)(${java_ver}|${java_ver#1.})[^0-9]" |
      sort -r |head -n1; )
    ;;
  esac &>/dev/null
  if [ ! -x "${java_cmd:-X}" ]
  then
    java_cmd=$(type -P java)
    java_cmd=$(readlink -f "${java_cmd}")
  fi 2>/dev/null
  [ -x "${java_cmd:-X}" ] && {
    java_cmd="${java_cmd%/bin/java}"
    java_cmd="${java_cmd%/jre}"
    echo "${java_cmd}"
  } 2>/dev/null
  return $?
}

## bashrc for Java Home
java-home-bashrc() {
  local java_ver="${1:-}"
  local javahome=""
  java_home=$("java-home-select" ${java_ver})
cat - <<_EOF_
# ${FUNCNAME} ${java_ver}
# JAVA_HOME_SELECTED
JAVA_HOME_SWITCH="${java_ver}"
declare -r JAVA_HOME_SELECTED
export JAVA_HOME_SELECTED
# Java Home
JAVA_HOME="${javahome}"
export JAVA_HOME
# Java Home
JAVA_VERSION="${java_ver}"
export JAVA_VERSION
# bashrc
if   [ -r "\${HOME}/.bash.bashrc" ]
then . "\${HOME}/.bash.bashrc"
elif [ -r "\${HOME}/.bashrc" ]
then . "\${HOME}/.bashrc"
elif [ -r "/etc/bashrc" ]
then . "/etc/bashrc"
fi || :
# Path
PATH="\${JAVA_HOME}/bin:\${PATH}"
export PATH
# Path
MANPATH="\${JAVA_HOME}/man:\${MANPATH}"
export MANPATH
# Print
echo
echo "JAVA_VERSION=\${JAVA_VERSION}"
echo "JAVA_HOME=\${JAVA_HOME}"
echo "PATH="
echo "\${PATH}" |tr ':' ' ' |xargs -n1 |cat -n
echo
java -version
echo
# end
return 0
_EOF_
  return $?
}

## Switch Java Home
java-home-switch() {
  if [ -n "${JAVA_HOME_SELECTED:-}" ]
  then
    echo "${FUNCNAME}: Shells in the java_home environment cannot be started multiple times." 1>&2
    echo "${FUNCNAME}: Please try closing the current shell." 1>&2
    return 1
  fi;
  bash --rcfile <("java-home-bashrc" "$@")
  return $?
}

# Export functions
export -f "java-home-versions" \
          "java-home-select" \
          "java-home-bashrc" \
          "java-home-switch"

# Load 'java.env'
[ -z "${JAVA_HOME:-}" ] && {

  for java_env in \
  "${XDG_CONFIG_HOME:-$HOME/.config}/java/java.env" \
  "${HOME}/.java/java.env"
  do
    [ -r "${java_env}" ] &&
    . "${java_env}" && break
  done &>/dev/null || :

  [ -n "${JAVA_HOME:-}" ] &&
  export JAVA_HOME || :
  [ -n "${JAVA_VERSION:-}" ] &&
  export JAVA_VERSION || :
  [ -n "${JAVA_ARCH:-}" ] &&
  export JAVA_ARCH || :

} || :

# Set JAVA_HOME
[ -z "${JAVA_HOME:-}" ] && {

  JAVA_HOME=$("java-home-select")

  [ -d "${JAVA_HOME:-X}" ] && {

    export JAVA_HOME

    [ -d "${JAVA_HOME}/bin" ] && {
      [[ "${PATH}" =~ (^|:)${JAVA_HOME}/bin(\$|:) ]] ||
      PATH="${JAVA_HOME}/bin:${PATH}"; }
    [ -d "${JAVA_HOME}/man" ] && {
      [[ "${MANPATH}" =~ (^|:)${JAVA_HOME}/man(\$|:) ]] ||
      MANPATH="${JAVA_HOME}/man:${MANPATH}"; }

    export PATH MANPATH

    # Unset BASH_REMATCH.
    unset BASH_REMATCH

  } # [ -d "${JAVA_HOME:-X}" ] &&

  for java_ver in $("java-home-versions")
  do
    alias java_home_jdk${java_ver}="java-home-switch ${java_ver}"
  done &>/dev/null

} || :

# End
return 0
