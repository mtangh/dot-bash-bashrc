# ${bashbashrc_dir}/03_path.sh
[ -n "$BASH" ] ||  return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/*}" ] &&
  cd "${BASH_SOURCE%/*}"; pwd); } || :

# path config command not found
[ -x "${pathconf:-}" ] || return 1

# Function: build_path_string
build_path_string() {
  local basename="${1:-paths}"
  local pathbase=""
  local pathfile=""
  local pathdirs=""
  for pathbase in \
  "/etc/${basename}" \
  "${bashbashrc_dir}/pathconfig.d/${basename}" \
  "${bashrclocaldir:-X}/pathconfig.d/${basename}" \
  "${bashrc_userdir:-X}/pathconfig.d/${basename}" \
  "${bashrc_userdir:-X}/${basename}" \
  "${XDG_CONFIG_HOME:-$HOME/.config}/pathconfig.d/${basename}" \
  "${XDG_CONFIG_HOME:-$HOME/.config}/${basename}" \
  "${HOME}/.pathconfig.d/${basename}" \
  "${HOME}/.${basename}"
  do
    [ -e "${pathbase}" -o \
      -d "${pathbase}.d" ] &&
    for pathfile in \
    "${pathbase}" \
    "${pathbase}.d"/* \
    "${pathbase}.d"/{"${ostype:-OS}","${vendor:-OV}"}/* \
    "${pathbase}.d/hosts/${HOSTNAME%%.*}"/*
    do
      if [ -f "${pathfile}" -a -s "${pathfile}" ]
      then
        pathdirs="${pathdirs:-}${pathdirs:+ }"
        [ -x "${pathfile}" ] &&
        pathdirs="${pathdirs}"$(echo "$(/bin/bash ${pathfile})")
        [ -x "${pathfile}" ] ||
        pathdirs="${pathdirs}"$(echo "$(/bin/cat ${pathfile})")
      fi
    done
  done || :
  [ -n "${pathdirs}" ] &&
  echo "${pathdirs}" || :
  return $?
}

# PATH
: "PATH" && {

  paths_dirs=""

  ## Set default
  for paths_file in $( : && {
    [ "${UID:-0}" = "0" ] &&
    echo {,/usr/,/usr/local}/sbin || :
    echo {,/usr/,/usr/local}/bin
    } 2>/dev/null; )
  do
    [ -d "${paths_file}" ] || continue
    paths_dirs="${paths_dirs:+ }${paths_dirs:-}"
    paths_dirs="-i${paths_file}${paths_dirs:-}"
  done || :
  unset paths_file

  ## Build pathconfig options
  paths_dirs="${paths_dirs} -a $(build_path_string paths)"

  ## for ${HOME}/bin, etc
  for userbindir in \
  "${HOME}"/.local/{,s}bin \
  "${HOME}"/{Library/Apple/usr,Library/Apple,.macOS}/{s,}bin
  do
    [ -d "${userbindir}" ] || continue
    paths_dirs="${paths_dirs:+${paths_dirs} }"
    paths_dirs="${paths_dirs}-a${userbindir}"
  done || :
  unset userbindir

  ## Rebuild and Export new PATH
  PATH="$(${pathconf} TEMP -f ${paths_dirs})"
  export PATH; unset paths_dirs

} # : "PATH" && {

# MANPATH
: "MANPATH" && {

  ## Build pathconfig options
  paths_dirs="-a $(build_path_string manpaths)"
  ## Rebuild and Export new MANPATH
  MANPATH="$(${pathconf} TEMP -f ${paths_dirs})"
  export MANPATH; unset paths_dirs

} # : "MANPATH" && {

# INFOPATH
: "INFOPATH" && {

  ## Build pathconfig options
  paths_dirs="-a $(build_path_string infopaths)"
  ## Rebuild and Export new INFOPATH
  INFOPATH="$(${pathconf} TEMP -f -a ${paths_dirs})"
  export INFOPATH; unset paths_dirs

} # : "INFOPATH" && {

# Cleanup
unset pathconf
unset build_path_string

# End
return 0
