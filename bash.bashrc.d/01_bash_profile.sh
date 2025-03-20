# ${bashbashrc_dir}/01_bash_profile.sh
[ -n "$BASH" ] ||  return 0

# Run login shell only.
shopt -q login_shell || return 0

# Load scripts under '*/profile.d' dir.
for profiledir in \
  "${bashrclocaldir:-X}"/profile.d \
  "${bashrc_userdir:-X}"/{,.}profile.d{,"/${HOSTNAME:-HN}"}
do
  if [ -d "${profiledir}" ]
  then
    set +u
    for profile_sh in \
    "${profiledir}"/*.sh{,".${ostype:-OS}",".${vendor:-OV}"}
    do
      [ -f "${profile_sh}" -a \
        -x "${profile_sh}" ] &&
      . "${profile_sh}" || :
    done
    unset profile_sh
    set -u
  fi
done
unset profiledir

# end
return 0
