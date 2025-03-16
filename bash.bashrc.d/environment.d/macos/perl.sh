# ${bashbashrc_dir}/environment.d/macos/perl.sh

PERL_BADLANG=0
export PERL_BADLANG

# Homebrew prefix
[ -x "$(type -P brew)" ] &&
homebrewprefix=$(brew --prefix) || :

# Exists Homebrew prefix
[ -d "${homebrewprefix:-X}" ] ||
return 0

# Homebrew's Perl
[ -x "${homebrewprefix}/bin/perl" ] ||
return  0

# Perl5 Lib
PERL5LIB=""

# Setup Perl5 Lib
for perl5lib in $(
perl -e '
foreach(@INC){
$_=~s#^/usr/local/#'"${homebrewprefix}"'#g &&
print $_."\n"; }')
do
  [ -z "${perl5lib}" ] ||
  PERL5LIB="${PERL5LIB:+$PERL5LIB:}${perl5lib}"
done
unset perl5lib

# Export
[ -z "$PERL5LIB" ] ||
export PERL5LIB

# End
return 0
