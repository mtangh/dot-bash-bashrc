# ${bashbashrc_dir}/environment.d/glib2.sh

## This caused GLib2 applications to convert filenames from 
## locale encoding to UTF-8. If the locale encoding is already
## UTF-8 then it makes no difference.

G_BROKEN_FILENAMES=1
export G_BROKEN_FILENAMES

# End
return 0
