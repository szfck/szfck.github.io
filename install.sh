#!/bin/bash
# cmd="apt-get"; if [[ $(command -v yum) ]]; then cmd="yum"; fi; sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; apt-get update; $cmd install -y git zip unzip curl wget vim tmux; bash <(curl https://szfck.github.io/install.sh)

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


install_tmux() {
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
		;;
	3)
		rm -rf ~/.tmux*
		;;
	*)
		error
		;;
	esac
}

install_vim() {

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
		# vim
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
		cat > ~/.vimrc <<EOL
set nocompatible              " be iMproved, required
set nu

set backspace=2
syntax on

filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tomtom/tcomment_vim'
Plugin '907th/vim-auto-save'

call vundle#end()            " required
filetype plugin indent on    " required

autocmd FileType cpp nmap <buffer> <F9> :w<bar>! g++ -W -std=c++0x -o %:t:r %:t && ./%:t:r <Cr>
autocmd FileType python nmap <buffer> <F9> :w<bar>! python %:t <Cr>
autocmd FileType cpp nmap <buffer> <F10> :w<bar>! g++ -W -std=c++0x -o %:t:r %:t && ./%:t:r < in<Cr>
let g:auto_save = 1  " enable AutoSave on Vim startup

nmap <Enter> za

" Folding
set foldenable
set foldmethod=indent
set foldcolumn=1
set foldlevel=4
EOL
	vim -c 'PluginInstall' -c 'qa!'
		;;
	3)
		rm -rf ~/.vim
		;;
	*)
		error
		;;
	esac

}

install_zsh() {
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
		# zsh
		chsh -s /bin/zsh root
		echo $SHELL
		wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
		sed -i -e 's/(git)/(git z zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
		source ~/.zshrc
		# plugin
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		zsh
		;;
	3)
		rm -rf ~/.oh-my-zsh
		;;
	*)
		error
		;;
	esac
	
}

cmd="apt-get"
if [[ $(command -v yum) ]]; then

	cmd="yum"

fi

update() {
	# use aliyun mirror
	sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
	sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
	apt-get update

	$cmd install -y git zip unzip curl wget vim tmux gcc ltrace net-tools openjdk-8-jdk
}

install() {
	
	
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
		# docker
		
		update
		install_tmux
		install_vim

		# install docker zsh
		sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
	    -t robbyrussell

		install_zsh
		;;
	3)
		# remote server

		update
		install_tmux
		install_vim

		$cmd install zsh

	    install_zsh
		;;
	*)
		error
		;;
	esac

}


clear

install
