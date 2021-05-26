mv ~/.bashrc ~/.old_bashrc
mv ~/.aliases ~/.old_aliases
mv ~/.gdbinit ~/.old_gdbinit
# mv ~/.screenrc ~/.old_screenrc

ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.aliases ~/.aliases
ln -s $PWD/.gdbinit ~/.gdbinit
# ln -s $PWD/.screenrc ~/.screenrc

source $PWD/.bashrc ~/.bashrc
source $PWD/.aliases ~/.aliases
# source $PWD/.screenrc ~/.screenrc

