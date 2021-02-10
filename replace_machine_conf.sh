mv ~/.bashrc ~/.old_bashrc
mv ~/.aliases ~/.old_aliases
mv ~/.screenrc ~/.old_screenrc

ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.aliases ~/.aliases
ln -s $PWD/.screenrc ~/.screenrc
