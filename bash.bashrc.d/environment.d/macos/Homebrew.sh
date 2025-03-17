# ${bashbashrc_dir}/environment.d/${ostype}/Homebrew.sh

# Homebrew prefix
[ -x "$(type -P brew)" ] &&
homebrewprefix=$(brew --prefix) || :

# Exists Homebrew prefix
[ -d "${homebrewprefix:-X}" ] ||
return 0

# Load scripts under '*/profile.d' dir.
if [ -d "${homebrewprefix:-X}/etc/profile.d" ]
then
  set +u
  for profile_sh in "${homebrewprefix}/etc/profile.d"/*.sh
  do
    [ -f "${profile_sh}" -a \
      -x "${profile_sh}" ] &&
    . "${profile_sh}" || :
  done
  unset profile_sh
  set -u
fi

# Load scripts for bash-completion
if [ -d "${homebrewprefix:-X}/etc/bash_completion.d" ]
then
  set +u
  for completesh in "${homebrewprefix}/etc/bash_completion.d"/*.sh
  do
    [ -f "${completesh}" ] &&
    . "${completesh}" || :
  done
  unset completesh
  set -u
fi

# Cleanup
unset homebrewprefix

# End
return 0
