#! /bin/sh
set -e

if [ "$1" = remove ]; then
    # When both the multiarch and the corresponding biarch packages are
    # installed, removing the multiarch package will remove the dynamic
    # linker. Recreate it in the postinst.
    ARCH=${DPKG_MAINTSCRIPT_ARCH}
    case "${ARCH}" in
        kfreebsd-i386 | s390 | powerpc)
            target="/lib32/ld.so.1"
            ;;
        i386 | sparc)
            target="/lib32/ld-linux.so.2"
            ;;
        *)
            target="$(dpkg-query -L libc6-${ARCH} 2>/dev/null | grep -E '/lib.*/ld-[0-9.]+\.so$' || true)"
            ;;
    esac
    if [ -f "$target" ] && ! [ -f /lib64/ld-linux-x86-64.so.2 ] ; then
        ln -sf ${target#$(dirname /lib64/ld-linux-x86-64.so.2)/} /lib64/ld-linux-x86-64.so.2
    fi
fi

if [ "$1" = deconfigure ]; then
    :; # blah, do something useful with ldso
fi

# Automatically added by dh_installdebconf/13.3.4
if [ "$1" = purge ] && [ -e /usr/share/debconf/confmodule ]; then
	. /usr/share/debconf/confmodule
	db_purge
fi
# End automatically added section


exit 0
