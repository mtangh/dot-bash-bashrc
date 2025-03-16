if [[ "${ostype:-OS}" = macos* ]]
then
cat - <<'_EOF_'
-a /Library/Apple/usr/bin
-a /Library/Apple/bin
_EOF_
  if [ "$(id -u)" = "0" ] ||
     [[ "$(id -Gn)" =~ (^|\ +)(wheel|admin)(\ +|$) ]]
  then
cat - <<'_EOF_'
-a /Library/Apple/usr/sbin
-a /Library/Apple/sbin
_EOF_
  fi
fi
