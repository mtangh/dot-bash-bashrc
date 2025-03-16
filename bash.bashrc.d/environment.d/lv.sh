# ${bashbashrc_dir}/environment.d/lv.sh

# lv installed ?
[ -x "$(type -P lv)" ] ||
  return 0

# LV Environment Variables
LV="-lac -Ou8 -c"

# Color settings when there is no interactive shell
if [ -t 0 ]
then
  LV="${LV:-}${LV:+ }-Sb5:31"
  LV="${LV:-}${LV:+ }-Sh1;34"
  LV="${LV:-}${LV:+ }-Su4;36"
  LV="${LV:-}${LV:+ }-Sr7;33;41"
  LV="${LV:-}${LV:+ }-Ss7;33;47"
fi || :

# Exporting LV variables to the environment
export LV

# End
return 0
