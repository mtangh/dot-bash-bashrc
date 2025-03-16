# ${bashbashrc_dir}/environment.d/macos/python.sh

# Python version
PYTHON_VER=2.7

# Homebrew prefix
[ -x "$(type -P brew)" ] &&
homebrewprefix=$(brew --prefix) || :

# Exists Homebrew prefix
[ -d "${homebrewprefix:-X}" ] ||
return 0

# PYTHON PATH
#for path_ent in \
#${homebrewprefix}/Frameworks/Python.framework/Versions/Current/lib/python${PYTHON_VER} \
#${homebrewprefix}/Frameworks/Python.framework/Versions/Current/lib ;
#do
#  [ -d "${path_ent}" ] ||
#    continue
#  [[ "${PYTHONPATH}" \
#    =~ ^(.*:)*${path_ent}(:.*)*$ ]] ||
#  PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}${path_ent}"
#  unset BASH_REMATCH
#done
#unset path_end

# Export
[ -z "${PYTHONPATH:-}" ] ||
export PYTHONPATH

# Site Dir. for Homebrew
PY_HOMEBREW_SITE_DIR="${homebrewprefix}/lib/python${PYTHON_VER}/site-packages"

# Exists PY_HOMEBREW_SITE_DIR ?
[ -d "${PY_HOMEBREW_SITE_DIR}" ] && {

  # Site Dir. for User
  PY_USER_SITE_DIR="${HOME}/Library/Python/${PYTHON_VER}/lib/python/site-packages"

  [ -d "${PY_USER_SITE_DIR}" ] ||
  mkdir -p "${PY_USER_SITE_DIR}" &>/dev/null || :

  grep "${PY_HOMEBREW_SITE_DIR}" ${PY_USER_SITE_DIR}/homebrew.pth || {
#cat - <<_EOF_ >>"${PY_USER_SITE_DIR}/homebrew.pth"
#import site;
#site.addsitedir("${PY_HOMEBREW_SITE_DIR}")
#_EOF_
cat - <<_EOF_ >>"${PY_USER_SITE_DIR}/homebrew.pth"
${PY_HOMEBREW_SITE_DIR}
_EOF_
  }

} &>/dev/null || :

# Cleanup
unset homebrewprefix
unset PY_HOMEBREW_SITE_DIR PY_USER_SITE_DIR

# End
return 0
