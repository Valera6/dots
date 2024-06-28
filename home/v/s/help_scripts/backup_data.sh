#!/bin/sh
# From the target directories we copy _all_ files, and then all directories _iff_ they _do not_ have .git in them.
# Directories that _do_ have .git in them are not copied, but their .git is.

README="""\
	#sync files script
	\033[34msync \$sync_dir\033[0m to upload local files
	\033[34mload \$sync_dir\033[0m to load global files"""

target_directories="
	/home/v/.data/
	/home/v/s/
	/home/v/Documents/
	/home/v/.documents/
	/home/v/.ssh/
	/home/v/.vim/
	/home/v/Images/
	/home/v/Sounds/
	/home/v/g/
	/home/v/math/
	/home/v/uni/
	/home/v/.cargo/bin/
	/home/v/.cargo/git/
	/home/v/.cargo/.crates.toml
	/home/v/.cargo/credentials.toml
	/home/v/.config/gh/hosts.yml
	/etc/resolv.conf
	/etc/locale.gen
	/etc/locale.conf
	/etc/hostname
	/etc/hosts
	/etc/default/grub
	/etc/NetworkManager/system-connections/
"

sync_files_and_directories() {
	local copied_file_or_dir="$1"
	local dest_dir="$2"
	local directories_with_git=""

	to_dir=$(dirname "$dest_dir$copied_file_or_dir")
	mkdir -p "${to_dir}"

	if [ -f "$copied_file_or_dir" ]; then
		filename=$(basename "$copied_file_or_dir")
		cp "${copied_file_or_dir}" "${to_dir}/${filename}" || printf "\033[31merror\033[0m on ${copied_file_or_dir} -> ${to_dir}/${filename}\n"
		return
	fi

	# target is definitely a directory here
	copied_dir="$copied_file_or_dir"
	filename=$(basename "$copied_dir")
	to_dir="$to_dir/$filename"
	mkdir -p "${to_dir}"
	for file_or_dir in $(fd --maxdepth=1 --search-path "${copied_dir}") ; do
		if [ -f "$file_or_dir" ]; then
			cp "$file_or_dir" "${to_dir}" || printf "\033[31merror\033[0m on ${file_or_dir} -> ${to_dir}\n"
		else
			dir=${file_or_dir}
			rsync -au "${dir}" --exclude "target/" ${to_dir} || printf "\033[31merror\033[0m on ${dir} -> ${to_dir}\n"
		fi
	done
}

sync() {
	local sync_directory="$1"
	rm -rf "${sync_directory}/*"
	local directories_with_git=""

	for target_dir in $target_directories; do
		printf "\033[34m%s\033[0m\n" "$target_dir"
		sync_files_and_directories "$target_dir" "$sync_directory"
	done
}

load() {
	local sync_directory="$1"
	for target_dir in $target_directories; do
		from="${sync_directory}${target_dir}"
		to_dir="${target_dir}"
		mkdir -p "$(dirname "${to_dir}")"
		rsync -ru "${from}" "$(dirname "${to_dir}")" || printf "\033[31merror\033[0m on ${from} -> ${to_dir}\n"
	done
}

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0 <sync|load> <sync_directory>"
	exit 1
fi

sync_directory="${2%/}"
if [ "$1" = "sync" ]; then
	sync "$sync_directory"
elif [ "$1" = "load" ]; then
	load "$sync_directory"
elif [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]; then
	printf "${README}\n"
else
	printf "${README}\n"
	exit 1
fi
