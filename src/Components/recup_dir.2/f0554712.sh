#!/bin/sh
set -e

case "$1" in
	remove)
		;;

	purge)
		rm -f /etc/adjtime
		;;

	*)
		;;
esac

# Automatically added by dh_installinit/13.3.4
if [ "$1" = "purge" ] ; then
	update-rc.d hwclock.sh remove >/dev/null
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.3.4
if [ -d /run/systemd/system ] && [ "$1" = remove ]; then
	systemctl --system daemon-reload >/dev/null || true
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.3.4
if [ -d /run/systemd/system ] && [ "$1" = remove ]; then
	systemctl --system daemon-reload >/dev/null || true
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.3.4
if [ "$1" = "remove" ]; then
	if [ -x "/usr/bin/deb-systemd-helper" ]; then
		deb-systemd-helper mask 'fstrim.timer' >/dev/null || true
	fi
fi

if [ "$1" = "purge" ]; then
	if [ -x "/usr/bin/deb-systemd-helper" ]; then
		deb-systemd-helper purge 'fstrim.timer' >/dev/null || true
		deb-systemd-helper unmask 'fstrim.timer' >/dev/null || true
	fi
fi
# End automatically added section

