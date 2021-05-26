git branch -D tmp
git checkout -b tmp

cp ~/.bashrc $PWD/.bashrc
cp ~/.aliases $PWD/.aliases
cp ~/.gdbinit $PWD/.gdbinit
# cp ~/.screenrc $PWD/.screenrc

git status
git commit -am "update repo conf files"
echo switched to branch tmp with the changes
