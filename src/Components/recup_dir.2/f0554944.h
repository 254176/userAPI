_lsblk_module()
{
	local cur prev OPTS LSBLK_COLS_ALL
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	LSBLK_COLS_ALL="
		NAME KNAME MAJ:MIN FSTYPE MOUNTPOINT LABEL UUID PARTTYPE
		PARTLABEL PARTUUID PARTFLAGS RA RO RM HOTPLUG MODEL SERIAL SIZE
		STATE OWNER GROUP MODE ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC
		ROTA SCHED RQ-SIZE TYPE DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
		WSAME WWN RAND PKNAME HCTL TRAN SUBSYSTEMS REV VENDOR
	"

	case $prev in
		'-e'|'--exclude'|'-I'|'--include')
			local realcur prefix MAJOR_ALL MAJOR I J
			realcur="${cur##*,}"
			prefix="${cur%$realcur}"
			for I in /sys/dev/block/*; do
				J=${I##*/}
				MAJOR_ALL="${MAJOR_ALL:-""} ${J%%:*}"
			done
			for WORD in ${MAJOR_ALL:-""}; do
				if ! [[ $prefix == *"$WORD"* ]]; then
					MAJOR="$WORD ${MAJOR:-""}"
				fi
			done
			compopt -o nospace
			COMPREPLY=( $(compgen -P "$prefix" -W "${MAJOR:-""}" -S ',' -- $realcur) )
			return 0
			;;
		'-o'|'--output'|'-M'|'--dedup')
			local prefix realcur LSBLK_COLS
			realcur="${cur##*,}"
			prefix="${cur%$realcur}"
			for WORD in $LSBLK_COLS_ALL; do
				if ! [[ $prefix == *"$WORD"* ]]; then
					LSBLK_COLS="$WORD ${LSBLK_COLS:-""}"
				fi
			done
			compopt -o nospace
			COMPREPLY=( $(compgen -P "$prefix" -W "$LSBLK_COLS" -S ',' -- $realcur) )
			return 0
			;;
		'-x'|'--sort')
			compopt -o nospace
			COMPREPLY=( $(compgen -W "$LSBLK_COLS_ALL"  -- $cur) )
			return 0
			;;
		'-h'|'--help'|'-V'|'--version')
			return 0
			;;
	esac
	case $cur in
		-*)
			OPTS="--all
				--bytes
				--nodeps
				--discard
				--exclude
				--fs
				--help
				--include
				--json
				--ascii
				--list
				--dedup
				--merge
				--perms
				--noheadings
				--output
				--output-all
				--paths
				--pairs
				--raw
				--inverse
				--topology
				--scsi
				--sort
				--help
				--version"
			COMPREPLY=( $(compgen -W "${OPTS[*]}" -- $cur) )
			return 0
			;;
	esac
	compopt -o bashdefault -o default
	COMPREPLY=( $(compgen -W "$($1 -pnro name)" -- $cur) )
	return 0
}
complete -F _lsblk_module lsblk
