git branch -D tmp
git checkout -b tmp
cp ~/.bashrc $PWD/.bashrc
cp ~/.aliases $PWD/.aliases
cp ~/.screenrc $PWD/.screenrc
git commit -am "update repo conf files"
git status
