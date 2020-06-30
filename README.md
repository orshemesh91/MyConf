# description
    configures ~/.aliases, ~/.bashrc and ~/.emacs
    adds some libreries to .emacs.d/lisp/

# Basic How To
 to use Emacs with Putty over ssh you should follow the next steps (* means the step is mandatory, otherwhise this step is nice to have):

1. *Install Putty on your windows machine

2. Configure colors in Putty (The default is very poor)

3. *Clone Emacs repository from github to your Linux machine (https://github.com/emacs-mirror/emacs.git) (don't use sudo yum install emacs, it installs version 24 which is too old for some important features)

4. *Follow the README to install Emacs from source (this is to have the latest version. I use 26.3, you can checkout to 26.3 tag and 

5. install this version, but I think everything should work fine with the most updated version)

6. *Clone EnvKopzon from github (https://github.com/sakopzon/EnvKopzon.git)

7. *run ./replace_emacs_conf_only.sh (this will save your old emacs configuration and set sim-links of .emacs and .emacs.d to the ones in EnvKopzon)

8. *Install global for gtags "sudo yum install global"

9. To customize gtags for ScaleIO project edit the "common" section in ~/.globalrc with
common:\
:skip=env/,os/,test/,gtest/,mgmt/,cedrs/,external/,*.cpp,HTML/,HTML.pub/,tags,TAGS,ID,y.tab.c,y.tab.h,gtags.files,cscope.files,cscope.out,cscope.po.out,cscope.in.out,SCCS/,RCS/,CVS/,CVSROOT/,{arch}\
/,autom4te.cache/,*.orig,*.rej,*.bak,*~,#*#,*.swp,*.tmp,*_flymake.*,*_flymake,*.o,*.a,*.so,*.lo,*.zip,*.gz,*.bz2,*.xz,*.lzh,*.Z,*.tgz,*.min.js,*min.css:

)
This will skip tests, java code, directory links when parsing the code. If you want them to ba parsed you can create alternative .globalrc file and use it with "gtags --gtagsconf <path_to_alternative_globalrc_file>"

10. *Run "gtags" from src/ in the project.

11. run "find . -name "*.py" -print | etags -" from sds_test folder for python tags. (when in python file press <alt>-x python-mode <enter>)

Now Emacs is up and running.


Few key moments to be familiar with:

1. M=<alt>; C=<ctrl>; RET=<enter>; .el file is emacs-lisp file usually contains a package code

2. "M-x" opens a command line called minibuffer (at the bottom of the screen) which will wait for a function name and <enter> will execute it

3. .emacs is the configuration file which is read by Emacs on startup. There you can find all my packages customization and few usable functions (don't be afraid from lisp, typing "M-r i will show all functions and you can start typing to interactively search for what you need").

4. .emacs.d is the emacs configuration directory, this is where packages are installed and where you should put all downloaded by hand .el files (when you will want to get some new behavior and you will not find it is the package installation manager)

5. Emacs consists of frames (standalone session - I am not using it), windows (how the screen is separated) and buffers (each window holds a buffer, you can change buffers in the same window, buffers usually contain files).

6. melpa is the package installation manager (use by M-x package-install RET)

7. helm is the base infrastructure package. It allows lots of nice navigation (and not only) features as interactive search (e.g. typing "server as start" when searching for a function will find netPath_StartAsServer). You can explore helm function by typing M-x helm, wait for second and the buffer will show you all helm functions

8. most usefull key bindings for coding (all key bindings are defined in .emacs, you can customize it however you want)(﻿Oshri Adler﻿ the currect key bindings version is defined such that you never need to use CTRL key):

* M-r and M-1: prefix for control and navigation commands (when you type it a mini-buffer will jump on the screen which will describe all functions you can call from that prefix)
* "M-r 000": exit emacs
* "M-r <right>": switch to next buffer
* "M-1 <right>": switch to next window
* "M-\": quit ongoing command (if you start typing a command and want to make it stop to start searching the code again or to start another command)
* "M-r M-g": grep commands prefix ("M-x grep RET" will let you write the grep command in the minibuffer, but will run from the parent directory of the file in the current buffer)
* "M-r 3": gtags find definition
* "M-r 1": gtags find references
* "M-r 2": gtags find symbols (good for variables and MIT callbacks)
* "M-r `": back to previous gtags search place
* "M-r <up>": open last gtags search window
* "M-r f": gtags find file
* "M-r M-b": show all buffers (you can )
* "M-r ;": call hierarchy (inside the call-graph buffer you can type "d" to remove entry, "r" to reset removed child entries and "+"/"-" to expand children or close them)
* "M-r \": open file in new buffer (this will start searching from the parent directory of the current file)
* "M-x compile RET": will ask for compilation command (e.g. less -j8) and run make from the parent directory of the file in the current buffer (use M-n and M-p to jump over the compilation errors)
* "M-r k": will open a buffer with a list of all opened buffers. <enter> will kill the selected buffer.
* "M-r / 3": split windows horizontally.
* "M-r / 1" open current buffer on fuul screen
* "M-x gdb RET": open gdb in emacs (use "file", "core", "args" and "set substitute-path <a> <b>" commands to start debugging with live code tracking) "M-r 9" will reset gdb buffer as left window and associated code buffer on the right.
* "M-f M-f": start search forward
* "M-s h .": highlight current symbol. "M-s-h-u" opens buffer with all highlights and <enter> will remove the selected highlight. "M-s h U" will remove all highlights at once.
* "M-r j": prefix for cool jump mode for faster navigation
* "M-r / .": open .emacs file
* "M-r / l": execute whole file in current buffer (to run the elisp code in the current buffer like after you make changes in .emacs) * * "M-r x" will execute the last elisp command (everything inside "()" is a command)
* "M-r / <up>": rotate windows clockwise
