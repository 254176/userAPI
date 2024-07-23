=ahci1  68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		else
		  search --no-floppy --fs-uuid --set=root 68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		fi
		echo	'Loading Linux 5.10.0-30-amd64 ...'
		linux	/boot/vmlinuz-5.10.0-30-amd64 root=UUID=68c99ec4-25c6-0b7f-99b9-4daecfe1065e ro single console=ttyS0,19200n8 net.ifnames=0
		echo	'Loading initial ramdisk ...'
		initrd	/boot/initrd.img-5.10.0-30-amd64
	}
	menuentry 'Debian GNU/Linux, with Linux 5.10.0-28-amd64' --class debian --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.10.0-28-amd64-advanced-68c99ec4-25c6-0b7f-99b9-4daecfe1065e' {
		gfxmode $linux_gfx_mode
		insmod gzio
		if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
		insmod ext2
		set root='hd1'
		if [ x$feature_platform_search_hint = xy ]; then
		  search --no-floppy --fs-uuid --set=root --hint-bios=hd1 --hint-efi=hd1 --hint-baremetal=ahci1  68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		else
		  search --no-floppy --fs-uuid --set=root 68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		fi
		echo	'Loading Linux 5.10.0-28-amd64 ...'
		linux	/boot/vmlinuz-5.10.0-28-amd64 root=UUID=68c99ec4-25c6-0b7f-99b9-4daecfe1065e ro console=ttyS0,19200n8 net.ifnames=0 
		echo	'Loading initial ramdisk ...'
		initrd	/boot/initrd.img-5.10.0-28-amd64
	}
	menuentry 'Debian GNU/Linux, with Linux 5.10.0-28-amd64 (recovery mode)' --class debian --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.10.0-28-amd64-recovery-68c99ec4-25c6-0b7f-99b9-4daecfe1065e' {
		gfxmode $linux_gfx_mode
		insmod gzio
		if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
		insmod ext2
		set root='hd1'
		if [ x$feature_platform_search_hint = xy ]; then
		  search --no-floppy --fs-uuid --set=root --hint-bios=hd1 --hint-efi=hd1 --hint-baremetal=ahci1  68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		else
		  search --no-floppy --fs-uuid --set=root 68c99ec4-25c6-0b7f-99b9-4daecfe1065e
		fi
		echo	'Loading Linux 5.10.0-28-amd64 ...'
		linux	/boot/vmlinuz-5.10.0-28-amd64 root=UUID=68c99ec4-25c6-0b7f-99b9-4daecfe1065e ro single console=ttyS0,19200n8 net.ifnames=0
		echo	'Loading initial ramdisk ...'
		initrd	/boot/initrd.img-5.10.0-28-amd64
	}
}

### END /etc/grub.d/10_linux ###

### BEGIN /etc/grub.d/20_linux_xen ###
