#!/bin/bash

${HOME}/.dots/sync_git.sh && printf "\033[32msynced dots\033[0m\n" || printf "\033[31msyncing dots failed\033[0m\n"

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && sudo sh -c "rankmirrors -n 10 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist" && printf "\033[32mupdated mirrors\033[0m\n" || printf "\033[31mupdating mirrors failed\033[0m\n"

sudo pacman -Rns --noconfirm ttf-jetbrains-mono-nerd > /dev/null 2>&1 && sudo pacman -Syu --noconfirm && printf "\033[32mupdated system\033[0m\n" || printf "\033[31mpacman -Syu failed\033[0m\n"
