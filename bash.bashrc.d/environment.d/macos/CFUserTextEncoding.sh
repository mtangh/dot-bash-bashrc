# ${bashbashrc_dir}/environment.d/macos/CFUserTextEncoding.sh
[[ "${ostype:-OS}" = macos* ]] || return 0

# Set bash.bashrc dir if undefined.
[ ! -d "${bashbashrc_dir:-X}" ] && {
  bashbashrc_dir=$([ -n "${BASH_SOURCE%/environment.d/*}" ] &&
  cd "${BASH_SOURCE%/environment.d/*}"; pwd); } || :

# Hex UID
_hex_uid="0x$(printf "%X" "${UID:-0}")"

# ".CFUserTextEncoding"
_cf_file="${HOME}/.CFUserTextEncoding"

# CF user text encoding (For MacOSX)
[ -e "${_cf_file}" ] ||
touch "${_cf_file}" 2>/dev/null
if [ -s "${_cf_file}" ]
then
  __CF_USER_TEXT_ENCODING="${_hex_uid}:$(cat ${_cf_file} 2>/dev/null)"
else

  cf_charset=""
  cf_country=""

  case "${LANG//utf/UTF}" in
  *.UTF*8) cf_charset="0x8000100" ;;
  ja*)     cf_charset="1"  ;;
  zh_CN*)  cf_charset="25" ;;
  zh_*)    cf_charset="2"  ;;
  ko*)     cf_charset="3"  ;;
  ru*|uk*) cf_charset="7"  ;;
  th*)     cf_charset="21" ;;
  cs*|sk*) cf_charset="29" ;;
  hr*)     cf_charset="36" ;;
  ro*)     cf_charset="38" ;;
  *)       cf_charset="0"  ;;
  esac

  case "${LANG}" in
  en_GB*) cf_country="2"  ;;
  de*)    cf_country="3"  ;;
  it*)    cf_country="4"  ;;
  nl*)    cf_country="5"  ;;
  sv*)    cf_country="7"  ;;
  da*)    cf_country="9"  ;;
  pt_PT*) cf_country="10" ;;
  fr_CA*) cf_country="11" ;;
  no*)    cf_country="12" ;;
  ja*)    cf_country="14" ;;
  en_AU*) cf_country="15" ;;
  fi*)    cf_country="17" ;;
  ru*)    cf_country="32" ;;
  ro*)    cf_country="39" ;;
  pl*)    cf_country="42" ;;
  ko*)    cf_country="51" ;;
  zh_CN*) cf_country="52" ;;
  zh_*)   cf_country="53" ;;
  th*)    cf_country="54" ;;
  cs*)    cf_country="56" ;;
  sk*)    cf_country="57" ;;
  uk*)    cf_country="62" ;;
  hr*)    cf_country="68" ;;
  pt*)    cf_country="71" ;;
  ca*)    cf_country="73" ;;
  es*)    cf_country="86" ;;
  fr*)    cf_country="91" ;;
  vi*)    cf_country="97" ;;
  *)      cf_country="0"  ;;
  esac

  # Set '__CF_USER_TEXT_ENCODING'
  __CF_USER_TEXT_ENCODING="${_hex_uid}:${cf_charset}:${cf_country}"

  # Release variables after use
  unset cf_charset cf_country

fi

# Export to the environment
export __CF_USER_TEXT_ENCODING

# Create a .CFUserTextEncoding, if not exists.
[ -s "${_cf_file}" ] ||
printf "%s" "${__CF_USER_TEXT_ENCODING%%*:}" \
1>"${_cf_file}" 2>/dev/null || :

# Unset all variables
unset _hex_uid _cf_file

# End
return 0
