#!/bin/bash

# ensures that we have a recent version of ruby installed
# and kicks things over to initialize.rb

set -o pipefail

pushd $HOME

if [ -f /etc/debian_version ]; then
    RBENV_PREREQS="git curl zlib1g-dev build-essential libssl-dev libreadline-dev"
    echo "debian based system"
    echo "going to install prereqs: $RBENV_PREREQS"
    sudo apt-get install $RBENV_PREREQS
fi

# rbenv
if [ ! -d ~/.rbenv ]; then
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    export PATH="$HOME/.rbenv/bin:$PATH"
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    if [ -f  ~/.bash_profile ]; then
        mv -f ~/.bash_profile ~/dot-bash_profile.orig
    fi
    eval "$(rbenv init -)"
fi

# ruby-build
if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# what is the latest stable ruby build?
latest_ruby=`rbenv install --list | grep 'p[0-9]\+' | tail -1`

# install it if we don't have it
our_ruby=`rbenv versions | grep -o '[0-9\.]\+-p[0-9]\+' | tail -1`

if [ "$our_ruby" == "$latest_ruby" ]; then
    rbenv install "$latest_ruby"
    rbenv rehash
fi

gem install dotmation

cat <<-MESSAGE
    ___       ___       ___   
   /\  \     /\  \     /\  \  
  /::\  \   /::\  \    \:\  \ 
 /:/\:\__\ /:/\:\__\   /::\__\
 \:\/:/  / \:\/:/  /  /:/\/__/
  \::/  /   \::/  /   \/__/   
   \/__/     \/__/            
                     ___       ___       ___       ___       ___       ___   
                    /\__\     /\  \     /\  \     /\  \     /\  \     /\__\  
                   /::L_L_   /::\  \    \:\  \   _\:\  \   /::\  \   /:| _|_ 
                  /:/L:\__\ /::\:\__\   /::\__\ /\/::\__\ /:/\:\__\ /::|/\__\
                  \/_/:/  / \/\::/  /  /:/\/__/ \::/\/__/ \:\/:/  / \/|::/  /
                    /:/  /    /:/  /   \/__/     \:\__\    \::/  /    |:/  / 
                    \/__/     \/__/               \/__/     \/__/     \/__/  

If you already have a dotmation config file in the expected location
(~/.config/dotmation/config) then just:

    dotmation update

If you don't have thinks linked up yet, you need to initialize:

    dotmation init <path/to/dotmation/config>

    # or, if you have the file on github: (dotfiles/config/dotmation/config)
    dotmation init <github-user-name> 

[Many thanks to the excellent programmers of 'fresh' for inspiration]
MESSAGE

popd

