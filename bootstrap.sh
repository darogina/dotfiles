#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;

    # Setup Vundle for VIM
    if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ] ; then
        echo "CLONING"
        git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    else
        git -C "$HOME/.vim/bundle/Vundle.vim" pull
    fi
    vim +PluginInstall +qall

    # Setup NVM
    mkdir -p "$HOME/.nvm"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
