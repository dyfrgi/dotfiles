#!/bin/sh
# Taken from thoughtbot/dotfiles

for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: $target exists but is not a symlink."
    fi
  else
    if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ]; then
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim -u ~/.vimrc.bundles +BundleInstall +qa

# install rbenv
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv

# install rbenv plugins
mkdir ~/.rbenv-plugins
git clone https://github.com/carsomyr/rbenv-bundler.git ~/.rbenv-plugins/rbenv-bundler
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv-plugins/ruby-build.git
git clone https://github.com/tpope/gem-ctags.git ~/.rbenv-plugins/gem-ctags

git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv-plugins/rbenv-default-gems
echo "bundler\ngem-ctags" > ~/.rbenv/default-gems

ln -s ~/.rbenv-plugins ~/.rbenv/plugins
