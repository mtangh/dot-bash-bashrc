# ${bashbashrc_dir}/00_bash_platform.sh
[ -n "$BASH" ] ||  return 0

# Skip if already set.
[ -z "${ostype:-}" -a \
  -z "${osarch:-}" -a \
  -z "${vendor:-}" ] ||
  return 0

# Init
ostype=""
osarch=""
vendor=""

# Platform
: "platform" && {

  # OS, Vendor
  if [ -n "${MACHTYPE:-}" ] &&
     [[ "${MACHTYPE}" =~ ^([^-]+)-([^-]+)-([^-]+)(-.*$|$) ]]
  then
    ostype="${BASH_REMATCH[3]}"
    vendor="${BASH_REMATCH[2]}"
    # Populate OS
    case "${ostype:-}" in
    darwin*)
      if [ -x "/usr/bin/sw_vers" ]
      then ostype=$(/usr/bin/sw_vers -productName |tr '[:upper:]' '[:lower:]')
      else ostype="darwin"
      fi
      ;;
    *)
      ;;
    esac
    # OS and Vendor
    if [ -n "${ostype:-}" -a -n "${vendor:-}" ]
    then
      vendor="${ostype}_${vendor}"
    fi
  fi
  # Unset BASH_REMATCH.
  unset BASH_REMATCH

  # Architecture
  case "${osarch:=$(/usr/bin/arch)}" in
  arm64|aarch64)
    osarch="arm64"
    ;;
  arm*|aarch*)
    osarch="arm"
    ;;
  *)
    ;;
  esac

} || :

# Set readonly
if [ -n "${ostype:-}" -a \
     -n "${osarch:-}" -a \
     -n "${vendor:-}" ]
then
  declare -r ostype osarch vendor
fi &>/dev/null || :

# End
return $?
