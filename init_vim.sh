#!/usr/bin/env bash
wrapper() {
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;36m"
  NORMAL="\033[0m"

  REPO_HTTPS="https://github.com/alvarogonjim/init_vim"
  PLUG_HTTPS="https://github.com/junegunn/vim-plug"

echo "${BLUE}"
cat << "HELLO_TEXT"
                               ___           ___           ___
      ___        ___          /__/\         /  /\         /  /\
     /__/\      /  /\        |  |::\       /  /::\       /  /:/
     \  \:\    /  /:/        |  |:|:\     /  /:/\:\     /  /:/
      \  \:\  /__/::\      __|__|:|\:\   /  /:/~/:/    /  /:/  ___
  ___  \__\:\ \__\/\:\__  /__/::::| \:\ /__/:/ /:/___ /__/:/  /  /\
 /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/ \  \:\/:::::/ \  \:\ /  /:/
 \  \:\|  |:|     \__\::/  \  \:\        \  \::/~~~~   \  \:\  /:/
  \  \:\__|:|     /__/:/    \  \:\        \  \:\        \  \:\/:/
   \__\::::/      \__\/      \  \:\        \  \:\        \  \::/
       ~~~~                   \__\/         \__\/         \__\/
      ___           ___           ___           ___           ___
     /__/\         /  /\         /  /\         /  /\         /__/\
     \  \:\       /  /::\       /  /::\       /  /::\        \  \:\
      \  \:\     /  /:/\:\     /  /:/\:\     /  /:/\:\        \__\:\
  _____\__\:\   /  /:/~/::\   /  /:/~/:/    /  /:/  \:\   ___ /  /::\
 /__/::::::::\ /__/:/ /:/\:\ /__/:/ /:/___ /__/:/ \__\:\ /__/\  /:/\:\
 \  \:\~~\~~\/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\ /  /:/ \  \:\/:/__\/
  \  \:\  ~~~   \  \::/       \  \::/~~~~   \  \:\  /:/   \  \::/
   \  \:\        \  \:\        \  \:\        \  \:\/:/     \  \:\
    \  \:\        \  \:\        \  \:\        \  \::/       \  \:\
     \__\/         \__\/         \__\/         \__\/         \__\/
HELLO_TEXT
echo "${NORMAL}"
  print "${YELLOW}\n" "Installing node and npm first"
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install nodejs
  sudo add-apt-repository ppa:jonathonf/vim
  sudo apt update
  print "${YELLOW}\n" "Installing last version of vim 
  sudo apt install vim
  if [ ! -n "$VIM" ]; then
    VIM=~/.vim
  fi

  if [ -d "$VIM" ]; then
    printf "${YELLOW}%s${NORMAL}\n" "You already have $VIM directory."
    printf "${YELLOW}%s${NORMAL}\n" "You have to remove $VIM if you want to re-install."
    exit 0
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}%s${NORMAL}\n" "Cloning vimrc from ${REPO_HTTPS}"

  hash git >/dev/null 2>&1 || {
    printf "${RED}%s${NORMAL}\n" "Error: git is not installed."
    exit 1
  }

  env git clone --depth=1 $REPO_HTTPS $VIM || {
    printf "${RED}%s${NORMAL}\n" "Error: git clone of vimrc repo failed."
    exit 1
  }

  printf "${BLUE}%s${NORMAL}\n" "Looking for an existing vim config..."
  if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
    printf "${YELLOW}%s${NORMAL}\n" "Found ~/.vimrc."
    printf "${BLUE}%s${NORMAL}\n" "You will see your old ~/.vimrc as $VIM/vimrc.bak"
    mv ~/.vimrc $VIM/vimrc.bak
  fi

  printf "${BLUE}%s${NORMAL}\n" "Symlinking $VIM/vimrc with ~/.vimrc..."
  ln -fs $VIM/vimrc ~/.vimrc

  if [ ! -d "$VIM/autoload/plug.vim" ]; then
      printf "${BLUE}%s${NORMAL}\n" "Installing Plug..."
      curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  printf "${GREEN}%s${NORMAL}\n" "Vimrc has been configured ;)"
  printf "${YELLOW}%s${NORMAL}\n" "Do not worry about error messages. When it occurs just press enter and wait till all plugins are installed."
  printf "${BLUE}%s${NORMAL}\n" "Keep calm and use VIM!"
}

wrapper
vim +PlugInstall
