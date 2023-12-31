#!/bin/sh

README="""\
#sync dots script
  \033[34msync\033[0m to upload local dots
  \033[34mload\033[0m to load global dots

  -m to add a commit message"""


target_dir="/home/v/.dots"
dot_directories="
	/home/v/.zshrc
	/home/v/.zprofile
	/home/v/.config/zsh
	/usr/bin/start_sway.sh
	/home/v/s/help_scripts
	/home/v/.config/sway
	/home/v/.config/eww
	/home/v/.config/nvim
	/home/v/.config/keyd
	/etc/keyd
	/home/v/.config/helix
	/home/v/.config/git
	/home/v/.config/greenclip.toml
	/home/v/.config/foot
	/home/v/.config/alacritty
	/home/v/.config/cargo
	/home/v/.config/zathura
	/home/v/.config/mimeapps.list
	/home/v/.local/share/applications/nnn.desktop
	/home/v/.local/share/applications/nvim.desktop
	/home/v/.config/dconf/user
	/home/v/.config/nnn/termfilechooser.sh
	/home/v/.config/nnn/setup.sh
	/home/v/.config/xdg-desktop-portal-termfilechooser/config
	/home/v/.file_snippets
	/home/v/.config/openvpn
	/etc/systemd/system/getty@tty1.service.d/override.conf
	/home/v/.config/zellij
	/home/v/Wallpapers
	/home/v/.config/jfind
	/home/v/.lesskey
	/usr/share/X11/xkb/symbols/semimak
	/usr/share/X11/xkb/symbols/ru
	/usr/share/X11/xkb/symbols/us
"

commit() {
	# local message=$(date +"%Y-%m-%d %H:%M:%S")
	local message="." # At this moment it makes more sense to me to auto-commit with '.', so other comments are easily searchable
	if [ -n "$1" ]; then
		message="$@"
	fi
	git -C "$target_dir" add -A && git -C "$target_dir" commit -m "$message" && git -C "$target_dir" push
}

exclude_gitignore() {
	local dir="$1"
	local command="$2"
	while IFS= read -r line; do
		command="$command --exclude=$line"
	done < "${dir}/.gitignore"
	echo "$command"
}

sync() {
	#rm -rf the old sync first (to distinguish, we remove all dirs that are not '.git')
	find "${HOME}/.dots/" -mindepth 1 -maxdepth 1 -type d ! -name '.git' -exec rm -rf {} +

	for dir in $dot_directories; do
		printf "\033[34m%s\033[0m\n" "$dir"
		command="rsync -au"
		command=$(exclude_gitignore "$dir" "$command" 2>/dev/null || :)

		case "$command" in
			*"--exclude"*) echo ${command} | sed 's/^rsync -au //' ;;
		esac

		to="$target_dir$dir"
		mkdir -p "$(dirname "$to")"
		$command "$dir" $(dirname "$to") || printf "\033[31merror\033[0m\n"
	done
}

#TODO: `reverse()`, that would sync it back in place after I made changes on the side of the git repo, which I want to sync locally

load() {
	touch "${HOME}/.local.sh"
	for dir in $dot_directories; do
		from="$(pwd)$dir"
		stripped=$(echo "$dir" | sed 's/^\/home\/v//')
		if [ "$stripped" != "$dir" ]; then
			to="${HOME}${stripped}"
		else
			# normally, all the things outside ${HOME} are working on the daemon level, and should not be exported
			continue
		fi
		mkdir -p "$(dirname "$to")"
		rsync -ru $from $(dirname "$to")
	done

	# # load gits
	mkdir -p ${HOME}/.config/zsh/plugins
	git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.config/zsh/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${HOME}/.config/zsh/plugins/zsh-syntax-highlighting
	mkdir -p ${HOME}/clone
	git clone https://github.com/jake-stewart/massren ${HOME}/clone/massren
	#
}

if [ -z "$1" ] || [ "$1" = "sync" ]; then
	shift
	sync
	if [ "$1" = "-m" ]; then
		shift
		commit "$@"
	else
		commit
	fi
elif [ "$1" = "load" ]; then
	load
elif [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]; then
	printf "${README}\n"
else
	printf "${README}\n"
	return 1
fi

