# ${bashbashrc_dir}/environment.d/less.sh

# less installed ?
[ -x "$(type -P less)" ] ||
  return 0

# Default options for less
LESS="-LMRgi -z-2 -x4"

# Exporting LESS variables to the environment
export LESS

# Charset for LESS
LESSCHARSET=utf-8
export LESSCHARSET

# Color settings when there is no interactive shell
if [ -t 0 ]
then
  case "${PAGER:-}" in
  */less|*/jless)
    LESS_TERMCAP_mb="$(tput bold; tput setaf 1)"
    LESS_TERMCAP_md="$(tput bold; tput setaf 4)"
    LESS_TERMCAP_me="$(tput sgr0)"
    LESS_TERMCAP_so="$(tput bold; tput setaf 3; tput setab 7)"
    LESS_TERMCAP_se="$(tput rmso; tput sgr0)"
    LESS_TERMCAP_us="$(tput smul; tput bold; tput setaf 6)"
    LESS_TERMCAP_ue="$(tput rmul; tput sgr0)"
    LESS_TERMCAP_mr="$(tput rev)"
    LESS_TERMCAP_mh="$(tput dim)"
    LESS_TERMCAP_ZN="$(tput ssubm)"
    LESS_TERMCAP_ZV="$(tput rsubm)"
    LESS_TERMCAP_ZO="$(tput ssupm)"
    LESS_TERMCAP_ZW="$(tput rsupm)"
    # Export
    export LESS_TERMCAP_mb
    export LESS_TERMCAP_md
    export LESS_TERMCAP_me
    export LESS_TERMCAP_so
    export LESS_TERMCAP_se
    export LESS_TERMCAP_us
    export LESS_TERMCAP_ue
    export LESS_TERMCAP_mr
    export LESS_TERMCAP_mh
    export LESS_TERMCAP_ZN
    export LESS_TERMCAP_ZV
    export LESS_TERMCAP_ZO
    export LESS_TERMCAP_ZW
    ;;
  *)
    ;;
  esac
fi

# less preprocessor
if [ -x "$(type -P lesspipe)" ]
then
  eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x "$(type -P lesspipe.sh)" ]
then
  LESSOPEN="$(type -P lesspipe.sh)"
  LESSOPEN="|${LESSOPEN} %s"
  export LESSOPEN
fi

# End
return 0
