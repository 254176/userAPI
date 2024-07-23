#!/bin/sh
set -e
export LC_ALL=C

install_from_default() {
  if [ ! -f $2 ]; then
    cp -p $1 $2
  fi
}

update_to_current_default() {
  if [ -f $2 ]; then
    md5=`md5sum $2 | cut -f 1 -d " "`
    case "$md5" in
      # modified file
      *)
        return
        ;;
    esac
    if ! cmp -s $1 $2; then
      echo "Updating $2 to current default."
      cp -p $1 $2
    fi
  fi
}

if [ "$1" = "configure" ] && [ "$2" = "" ] ; then
  install_from_default /usr/share/libc-bin/nsswitch.conf /etc/nsswitch.conf
fi

if [ "$1" = "configure" ] && [ "$2" != "" ]; then
  update_to_current_default /usr/share/libc-bin/nsswitch.conf /etc/nsswitch.conf
fi

if [ "$1" = "triggered" ] || [ "$1" = "configure" ]; then
  ldconfig || ldconfig --verbose
  exit 0
fi



exit 0

