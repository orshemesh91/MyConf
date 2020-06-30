mv ~/.bashrc ~/.old_bashrc
mv ~/.aliases ~/.old_aliases
mv ~/.screenrc ~/.old_screenrc
mv ~/.tmux.conf ~/.old_tmux.conf
mv ~/.inputrc ~/.old_.inputrc
mv ~/.globalrc ~/.old_.globalrc

ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.aliases ~/.aliases
ln -s $PWD/.screenrc ~/.screenrc
ln -s $PWD/.tmux.conf ~/.tmux.conf
ln -s $PWD/.inputrc ~/.inputrc
ln -s $PWD/.globalrc ~/.globalrc

./replace_emacs_conf_only.sh
