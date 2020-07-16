#!/bin/bash
red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }


install_zsh() {
	# zsh
	chsh -s /bin/zsh root
	echo $SHELL
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
	sed -i -e 's/(git)/(git z zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
	source ~/.zshrc
	# plugin
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}


install_tmux() {
	# tmux
	cd
	git clone https://github.com/gpakosz/.tmux.git
	ln -s -f .tmux/.tmux.conf
	cp .tmux/.tmux.conf.local .
	# append new setting
	cat >> ~/.tmux.conf.local <<EOL
tmux_conf_theme_status_left='  #S | '
tmux_conf_theme_status_right='#{prefix}#{pairing}#{synchronized}, %R , %d %b |'
tmux_conf_theme_status_left_bg='#00afff,#00afff,#00afff'
set-option -g repeat-time 1
set-option -g status-position top
set-window-option -g mode-keys vi
EOL

}

install_vim() {
	# vim
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	cat > ~/.vimrc <<EOL
set nocompatible              " be iMproved, required
set nu

set backspace=2
syntax on

filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'itchyny/lightline.vim'
" Plugin 'scrooloose/syntastic'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin '907th/vim-auto-save'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

autocmd FileType cpp nmap <buffer> <F9> :w<bar>! g++ -W -std=c++0x -o %:t:r %:t && ./%:t:r <Cr>
autocmd FileType python nmap <buffer> <F9> :w<bar>! python %:t <Cr>
autocmd FileType cpp nmap <buffer> <F10> :w<bar>! g++ -W -std=c++0x -o %:t:r %:t && ./%:t:r < in<Cr>
let g:auto_save = 1  " enable AutoSave on Vim startup
EOL
	vim -c 'PluginInstall' -c 'qa!'
}

install() {
	cmd="apt-get"
	if [[ $(command -v yum) ]]; then

		cmd="yum"

	fi
	
	echo "........... zsh/tmux/vim 一键安装配置脚本 by szfck .........."
	echo
	echo "帮助说明: https://github.com/szfck/dev-config"
	echo

	echo "环境配置"
	echo
	echo " 1. skip"
	echo
	echo " 2. docker"
	echo
	echo " 3. remote server"
	echo
	
	
	read -p "$(echo -e "请选择 [${magenta}1-3$none]:")" choose
	case $choose in
	1)
		# skip
		;;
	2)
		# use aliyun mirror
		sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
		apt-get update

		$cmd install -y git zip unzip curl wget vim tmux

		# install docker zsh
		sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -t robbyrussell
		;;
	3)
		$cmd install -y git zip unzip curl wget vim tmux zsh
		;;
	*)
		error
		;;
	esac

	clear
	echo "zsh配置"
	echo
	echo " 1. skip"
	echo
	echo " 2. 安装"
	echo
	echo " 3. 删除"
	echo
	
	read -p "$(echo -e "请选择 [${magenta}1-3$none]:")" choose
	case $choose in
	1)
		# skip
		;;
	2)
		install_zsh
		zsh
		;;
	3)
		rm -rf ~/.oh-my-zsh
		;;
	*)
		error
		;;
	esac

	clear
	echo "tmux配置"
	echo
	echo " 1. skip"
	echo
	echo " 2. 安装"
	echo
	echo " 3. 删除"
	echo
	
	read -p "$(echo -e "请选择 [${magenta}1-3$none]:")" choose
	case $choose in
	1)
		# skip
		;;
	2)
		install_tmux
		;;
	3)
		rm -rf ~/.tmux*
		;;
	*)
		error
		;;
	esac

	clear
	echo "vim配置"
	echo
	echo " 1. skip"
	echo
	echo " 2. 安装"
	echo
	echo " 3. 删除"
	echo
	
	read -p "$(echo -e "请选择 [${magenta}1-3$none]:")" choose
	case $choose in
	1)
		# skip
		;;
	2)
		install_vim
		;;
	3)
		rm -rf ~/.vim
		;;
	*)
		error
		;;
	esac
	# install_zsh
	# install_tmux
	# install_vim
	
	# rm -rf ~/dev-config
	# git clone https://github.com/szfck/dev-config.git
}


# while :; do
# 	echo
# 	echo "........... zsh/tmux/vim 一键安装配置脚本 by szfck .........."
# 	echo
# 	echo "帮助说明: https://github.com/szfck/dev-config"
# 	echo
# 	echo " 1. 安装"
# 	echo
# 	echo " 2. 卸载"
# 	echo
	
# 	read -p "$(echo -e "请选择 [${magenta}1-2$none]:")" choose
# 	case $choose in
# 	1)
# 		install
# 		break
# 		;;
# 	2)
# 		uninstall
# 		break
# 		;;
# 	*)
# 		error
# 		;;
# 	esac
# done

clear

install
