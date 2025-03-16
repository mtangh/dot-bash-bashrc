# ${bashbashrc_dir}/environment.d/${ostype}/DS_Store.sh
[[ "${ostype:-OS}" = macos* ]] || return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/environment.d/*}" ] &&
  cd "${BASH_SOURCE%/environment.d/*}"; pwd); } || :

# A colon-separated list of suffixes to ignore when performingfilename.
# completion. A file name whose suffix matches one of the entries in
# FIGNORE is excluded from the list of matched file names.
if [ -x "${bashbashrc_dir}/bin/pathconfig" ]
then
  FIGNORE="$(${bashbashrc_dir}/bin/pathconfig FIGNORE -a .DS_Store)"
else
  FIGNORE="${FIGNORE:-}${FIGNORE:+:}.DS_Store"
fi

# Export to the environment
export FIGNORE

# End
return 0
