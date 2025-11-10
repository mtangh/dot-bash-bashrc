if [ "$(id -u)" = "0" ] ||
   [[ "$(id -Gn)" =~ (^|\ +)(wheel|adm|admin)(\ +|$) ]]
then
cat - <<'_EOF_'
-a /opt/local/sbin
-a /opt/sbin
-a /usr/local/sbin
-a /usr/sbin
-a /sbin
_EOF_
fi
