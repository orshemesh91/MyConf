mv ~/.emacs ~/.old_emacs
mv ~/.emacs.d ~/.old_emacs.d

ln -s $PWD/.emacs.d ~/.emacs.d
ln -s $PWD/.emacs.d/.emacs ~/.emacs
