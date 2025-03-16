# ${bashbashrc_dir}/01_bash_profile.sh
[ -n "$BASH" ] ||  return 0

# Run login shell only.
shopt -q login_shell || return 0

# Load scripts under '*/profile.d' dir.
for profiledir in \
  "${bashrclocaldir:-X}"/profile.d \
  "${bashrc_userdir:-X}"/{,.}profile.d
do
  [ -d "${profiledir}" ] ||
    continue
  for profile_sh in \
  "${profiledir}"/*.sh{,".${ostype:-OS}",".${vendor:-OV}"}
  do
    [ -f "${profile_sh}" -a -x "${profile_sh}" ] && {
    set +u; . "${profile_sh}"; set -u; } || :
  done &>/dev/null
  unset profile_sh
done
unset profiledir

# end
return 0
