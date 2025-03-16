if [ "$(id -u)" = "0" ] ||
   [[ "$(id -Gn)" =~ (^|\ +)(wheel|admin)(\ +|$) ]]
then
cat - <<'_EOF_'
-a /sbin
-a /usr/local/sbin
-a /usr/sbin
-a /opt/local/sbin
-a /opt/sbin
_EOF_
fi
