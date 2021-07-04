mv ~/.bashrc ~/.old_bashrc
mv ~/.bash_profile ~/.old_bash_profile
mv ~/.aliases ~/.old_aliases
mv ~/.gdbinit ~/.old_gdbinit
# mv ~/.screenrc ~/.old_screenrc

ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.bash_profile ~/.bash_profile
ln -s $PWD/.aliases ~/.aliases
ln -s $PWD/.gdbinit ~/.gdbinit
# ln -s $PWD/.screenrc ~/.screenrc

source $PWD/.bashrc ~/.bashrc
source $PWD/.bash_profile ~/.bash_profile
source $PWD/.aliases ~/.aliases
# source $PWD/.screenrc ~/.screenrc

