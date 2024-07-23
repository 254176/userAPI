#!/bin/sh
set -e
export LC_ALL=C

type=$1
preversion=$2

kernel_compare_versions () {
    verA=$(($(echo "$1" | sed 's/\([0-9]*\)\.\([0-9]*\).*/\1 \* 100 + \2/')))
    verB=$(($(echo "$3" | sed 's/\([0-9]*\)\.\([0-9]*\).*/\1 \* 100 + \2/')))

    test $verA -$2 $verB
}

if [ "$type" != abort-upgrade -a -z "$DPKG_ROOT" ]
then
    # Check if the debconf module is available and usable
    USE_DEBCONF=
    if [ "$DEBIAN_HAS_FRONTEND" ]; then
        # Debconf is already loaded, so we already checked if the frontend
        # is usable or not
        USE_DEBCONF=1
    elif [ -f /usr/share/debconf/confmodule ]; then
        # cdebconf has a working fallback mechanism in case dialog
        # is not usable, so do not try to do anything smart here
        if [ "$DEBCONF_USE_CDEBCONF" ] ; then
            USE_DEBCONF=1
        # debconf requires perl
        elif perl -e "" 2>/dev/null ; then
            # Check that the selected frontend will work
            if [ -n "$DEBIAN_FRONTEND" ] ; then
                frontend="$DEBIAN_FRONTEND"
            else
                # Query the frontend without first sourcing the confmodule to avoid
                # losing control of the tty. This snippet must not be copied blindly.
                frontend="$(echo 'GET debconf/frontend' | debconf-communicate | sed '/^0 /!d;s/^0 //')"
                frontend="${frontend:-Dialog}"
            fi
            frontend=`echo $frontend | tr '[:upper:]' '[:lower:]'`
            case "$frontend" in
            dialog)
                # debconf uses whiptail by default unless dialog is available and
                # $DEBCONF_FORCE_DIALOG is set
                if [ -x "$(which whiptail)" ] && ! ( [ -n "$DEBCONF_FORCE_DIALOG" ] && [ -x "$(which dialog)" ] ); then
                    frontend=whiptail
                fi
                # Only enable debconf if the whiptail/dialog are not available
                # (in which case debconf has a fallback mechanism) or usable
                if ! [ -x "$(which $frontend)" ] || $frontend --version > /dev/null 2>&1 ; then
                    USE_DEBCONF=1
                fi
                ;;
            *)
                 # For now assume that all other frontends are fine
                 USE_DEBCONF=1
                ;;
            esac
        fi
    fi

    # Load debconf module if available and usable
    if [ "$USE_DEBCONF" ]; then
        . /usr/share/debconf/confmodule
    fi

    # See if LD_LIBRARY_PATH contains the traditional /lib, but not the
    # multiarch path
    dirs=$(echo $LD_LIBRARY_PATH | sed 's/:/ /g')
    for dir in $dirs ; do
        dir=$(readlink -e $dir || true)
        case "$dir" in
        /lib)
            seen_traditional=1
            ;;
        /lib/x86_64-linux-gnu)
            seen_multiarch=1
            ;;
        esac
    done
    if test -n "$seen_traditional" && test -z "$seen_multiarch" ; then
        echo
        echo "LD_LIBRARY_PATH contains the traditional /lib directory,"
        echo "but not the multiarch directory /lib/x86_64-linux-gnu."
        echo "It is not safe to upgrade the C library in this situation;"
        echo "please remove the /lib/directory from LD_LIBRARY_PATH and" 
        echo "try again."
        echo
        exit 1
    fi

    # glibc kernel version check
    system=`uname -s`
    if [ "$system" = "Linux" ]
    then
        # sanity checking for the appropriate kernel on each architecture.
        kernel_ver=`uname -r`
        case ${DPKG_MAINTSCRIPT_ARCH} in
            *)
                # The GNU libc requires a >= 3.2 kernel, found in wheezy
                kernel_ver_min=3.2
                kernel_ver_rec=3.2
                ;;
        esac

        if kernel_compare_versions "$kernel_ver" lt $kernel_ver_min
        then
            if [ "$USE_DEBCONF" ]
            then
                db_version 2.0
                db_fset glibc/kernel-too-old seen false
                db_reset glibc/kernel-too-old
                db_subst glibc/kernel-too-old kernel_ver $kernel_ver_rec
                db_input critical glibc/kernel-too-old || true
                db_go
                db_stop
            else
                echo "ERROR: This version of the GNU libc requires kernel version"
                echo "$kernel_ver_rec or later.  Please upgrade your kernel before installing"
                echo "glibc."
                echo
            fi
            exit 1
        fi

        if kernel_compare_versions "$kernel_ver" lt $kernel_ver_rec
        then
            if [ "$USE_DEBCONF" ]
            then
                db_version 2.0
                db_fset glibc/kernel-not-supported seen false
                db_reset glibc/kernel-not-supported
                db_subst glibc/kernel-not-supported kernel_ver $kernel_ver_rec
                db_input critical glibc/kernel-not-supported || true
                db_go
                db_stop
            else
                echo "WARNING: This version of the GNU libc requires kernel version"
                echo "$kernel_ver_rec or later.  Older versions might work but are not officially"
                echo "supported.  Please consider upgrading your kernel."
                echo
            fi
        fi

    elif [ $system = "GNU/kFreeBSD" ]
    then
        kernel_ver=`uname -r`
        kernel_ver_min=8.3
        if kernel_compare_versions "$kernel_ver" lt $kernel_ver_min
        then
            if [ "$USE_DEBCONF" ]
            then
                db_version 2.0
                db_version 2.0
                db_fset glibc/kernel-too-old seen false
                db_reset glibc/kernel-too-old
                db_subst glibc/kernel-too-old kernel_ver $kernel_ver_min
                db_input critical glibc/kernel-too-old || true
                db_go
                db_stop
            else
                echo "ERROR: This version of the GNU libc requires kernel version"
                echo "$kernel_ver_min or later.  Please upgrade your kernel before installing"
                echo "glibc."
                echo
            fi
            exit 1
        fi
    fi
fi

if [ "$type" = upgrade -a -z "$DPKG_ROOT" ]
then
    if [ -n "$preversion" ] && [ -x "$(which ischroot)" ] && ! ischroot; then
	# NSS authentication trouble guard
	if dpkg --compare-versions "$preversion" lt 2.31; then
	    if pidof xscreensaver xlockmore >/dev/null; then
		if [ "$USE_DEBCONF" ] ; then
		    db_version 2.0
		    db_reset glibc/disable-screensaver
		    db_input critical glibc/disable-screensaver || true
		    db_go || true
		else
		    echo "xscreensaver and xlockmore must be restarted before upgrading"
		    echo
		    echo "One or more running instances of xscreensaver or xlockmore have been"
		    echo "detected on this system. Because of incompatible library changes, the"
		    echo "upgrade of the GNU C library will leave you unable to authenticate to"
		    echo "these programs. You should arrange for these programs to be restarted"
		    echo "or stopped before continuing this upgrade, to avoid locking your users"
		    echo "out of their current sessions."
		    echo
		    frontend=`echo "$DEBIAN_FRONTEND" | tr '[:upper:]' '[:lower:]'`
		    if [ "$frontend" = noninteractive ]; then
			echo "Non-interactive mode, upgrade glibc forcibly"
		    else
		        echo -n "Press a key to continue"
		        read answer
		    fi
		    echo
		fi
	    fi

	    check="kdm postgresql xdm"
	    # NSS services check:
	    	    echo -n "Checking for services that may need to be restarted..."
	    # Only get the ones that are installed, of the same architecture
	    # as libc (or arch all) and configured. Restart openssh-server even
	    # if only half-configured to continue accepting new connections
	    # during the upgrade.
	    check=$(dpkg-query -W -f='${binary:Package} ${Status} ${Architecture}\n' $check 2> /dev/null | \
			grep -E "(^openssh-server .* unpacked|installed) (all|${DPKG_MAINTSCRIPT_ARCH})$" | sed 's/[: ].*//')
	    # some init scripts don't match the package names
	    check=$(echo $check | \
		    sed -e's/\bapache2.2-common\b/apache2/g' \
			-e's/\bat\b/atd/g' \
			-e's/\bdovecot-common\b/dovecot/g' \
			-e's/\bexim4-base\b/exim4/g' \
			-e's/\blpr\b/lpd/g' \
			-e's/\blpr-ppd\b/lpd-ppd/g' \
			-e's/\bmysql-server\b/mysql/g' \
			-e's/\bopenssh-server\b/ssh/g' \
			-e's/\bsasl2-bin\b/saslauthd/g' \
			-e's/\bsamba\b/smbd/g' \
			-e's/\bpostgresql-common\b/postgresql/g' \
		    )
	    echo
	    echo "Checking init scripts..."
	    for service in $check; do
		invoke-rc.d ${service} status >/dev/null 2>/dev/null && status=0 || status=$?
		if [ "$status" = "0" ] || [ "$status" = "2" ] ; then
		    services="$service $services"
		elif [ "$status" = "100" ] ; then
		    echo "WARNING: init script for $service not found."
		fi
	    done

	    if [ -n "$services" ]; then 
		if [ "$USE_DEBCONF" ] ; then
	            db_version 2.0
		    db_reset glibc/upgrade
		    db_subst glibc/upgrade services $services
		    db_input critical glibc/upgrade || true
		    db_go || true
		    db_get glibc/upgrade
		    answer=$RET
		else
		    echo "Do you want to upgrade glibc now?"
		    echo
		    echo "Running services and programs that are using NSS need to be restarted,"
		    echo "otherwise they might not be able to do lookup or authentication any more."
		    echo "The installation process is able to restart some services (such as ssh or"
		    echo "telnetd), but other programs cannot be restarted automatically.  One such"
		    echo "program that needs manual stopping and restart after the glibc upgrade by"
		    echo "yourself is xdm - because automatic restart might disconnect your active"
		    echo "X11 sessions."
		    echo
		    echo "This script detected the following installed services which must be"
		    echo "stopped before the upgrade: $services"
		    echo
		    echo "If you want to interrupt the upgrade now and continue later, please"
		    echo "answer No to the question below."
		    echo 
		    frontend=`echo "$DEBIAN_FRONTEND" | tr '[:upper:]' '[:lower:]'`
		    if [ "$frontend" = noninteractive ]; then
			echo "Non-interactive mode, upgrade glibc forcibly"
			answer=true
		    else
		        echo -n "Do you want to upgrade glibc now? [Y/n] "
		        read answer
		        case $answer in
			    Y*|y*) answer=true ;;
			    N*|n*) answer=false ;;
			    *) answer=true ;;
			esac
		    fi
		    echo
		fi

		if [ "x$answer" != "xtrue" ]; then
	            echo "Stopped glibc upgrade.  Please retry the upgrade after you have"
	            echo "checked or stopped services by hand."
	            exit 1
		fi
	    fi
	fi # end upgrading and $preversion lt 2.31
    fi # Upgrading

    # This will keep us from using hwcap libs (optimized) during an
    # upgrade.
    touch /etc/ld.so.nohwcap
fi



if [ -n "$preversion" ]; then
    if dpkg --compare-versions "$preversion" lt 2.31; then
       # unconditionally wipe ld.so.cache on major version upgrades; this
       # makes those upgrades a bit slower, but is less error-prone than
       # hoping we notice every time the cache format is changed upstream
       rm -f "$DPKG_ROOT/etc/ld.so.cache"
       rm -f "$DPKG_ROOT/var/cache/ldconfig/aux-cache"
    fi
fi

exit 0
