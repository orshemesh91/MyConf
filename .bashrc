# .bashrc

### Source global definitions
#if [ -f /etc/bashrc ]; then
#    . /etc/bashrc
#fi
export TERM=xterm-256color
export TERM=screen-256color
export TERMCAP=

### Aliases and functions

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# echo Current path $PATH
PATH=$PATH:/usr/local/bin/:/home/linuxbrew/.linuxbrew/bin/:/usr/local/bin/

### Prompt
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[1;36m\]\h\[\e[m\]\[\e[1;33m\]\\$\[\e[m\]\[\e[1;36m\]\u\[\e[m\]\[\e[1;33m\]\\$\[\e[1;36m\]\`parse_git_branch\`\[\e[m\]\[\e[m\]\[\e[1;33m\]\W\[\e[m\]: "

# directories
alias ls='ls --color'
LS_COLORS='di=0;34:fi=0:ln=31:pi=0;5:so=0;5:bd=0;5:cd=5:or=0;31;45:mi=0:ex=0;33:*.rpm=37:*.sh=32:*.gz=0;31:*.zip=0;31'
export LS_COLORS


### Shell Functions

# parameters:
    # $1 - blob (file) hash
    # $2 - grep pattern for remote branch names to search in
    # $3 - number of commits back you want to check

function find_commit_by_blob(){
found=0;
for brch in $(git branch -r | grep -i $2); do
    echo "CHECKING BRANCH ${brch}";
    for cur in $(git log ${brch} -$3 --format='%H-%T'); do
        echo "Checking ${cur}";
        git ls-tree -r $(echo ${cur}| awk -F- '{print $2}') | grep $1 && echo 'FOUND IT!' && found=1 && break;
    done;
    if [ $found -eq 1 ]; then
        break;
    fi;
done
}
source scl_source enable devtoolset-8 llvm-toolset-7.0
