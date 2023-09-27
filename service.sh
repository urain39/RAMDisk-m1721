#!/system/bin/sh

#
## Added by urain39@cyfan.cf
#

TOPDIR="/data/media/0"
TMPDIRS="$TOPDIR/ramdisk"

[ -f /data/tmpdir.conf ] && TMPDIRS="$(
  sed -E "/^[\t ]*(#|\$)/d;s:\\\$TOPDIR\\\$?:$TOPDIR:g" /data/tmpdir.conf |
    grep -Eo '^((/([^/.\t]{1,2}|[^/.\t]\.|\.[^/.\t]|[^/\t]{3,}))+/?|/)([\t].+)?$'
)"

umask 000

IFS="
"
for LINE in $TMPDIRS; do
  IFS="	"
  read -r DIR OPTS <<DELIM
$LINE
DELIM
  (echo "$DIR" | grep -Eq "^$TOPDIR/.") || continue
  rm -rf "$DIR" && mkdir -p "$DIR"
  [ "$OPTS" = "" ] && OPTS="size=25%"
  mount -t tmpfs tmpfs -o "$OPTS" "$DIR" 2>/dev/null || mount -t tmpfs tmpfs "$DIR"
done
