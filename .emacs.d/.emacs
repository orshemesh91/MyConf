;; .Emacs

                                        ; TODO Kopzon:
                                        ;     begPutty
                                        ;     YASnippet - for code templates

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(company-cmake-executable "/usr/local/bin/cmake")
 '(custom-enabled-themes (quote (AAA_PuTTY)))
 '(custom-safe-themes
   (quote
    ("08f3c9e1ac1ba58e11783144edbc4a90963307dc074f4bb01aa0e7a5ce7e4e8f" default)))
 '(custom-theme-directory "~/.emacs.d/themes")
 '(desktop-save-mode nil)
 '(display-line-numbers t)
 '(electric-pair-mode t)
 '(global-undo-tree-mode t)
 '(helm-completion-style (quote emacs))
 '(helm-mode t)
 '(hscroll-margin 5)
 '(hscroll-step 0)
 '(inhibit-startup-screen t)
 '(irony-cmake-executable "/usr/local/bin/cmake")
 '(isearch-allow-scroll t)
 '(magit-repository-directories
   (quote
    (("~/ScaleIO" . 0)
     ("~/ScaleIO_1" . 0)
     ("~/ScaleIO_2" . 0)
     ("~/EnvKopzon" . 0))))
 '(maximum-scroll-margin 0.25)
 '(package-selected-packages
   (quote
    (evil undo-tree helm-posframe magit expand-region helm-descbinds elpy ace-jump-mode general which-key company-irony-c-headers irony-eldoc flycheck-irony company-irony irony use-package ggtags multiple-cursors call-graph helm-gtags helm)))
 '(scroll-preserve-screen-position 1)
 '(which-function-mode t)
 '(which-key-mode t))


;;Undo tree


;;Evil
(require 'evil)
(evil-mode 1)
(setq evil-default-state 'emacs)
(add-to-list 'evil-buffer-regexps '("\\*magit:"))
;(setq evil-want-C-w-in-emacs-state t)
;(setq evil-disable-insert-state-bindings t)


;; Includes.
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/lisp/eshel")
(add-to-list 'load-path "~/.emacs.d/lisp/irony")
;; best not to include the ending “.el” or “.elc”


; MELPA
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archeves (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )


(require 'expand-region)

;Smart scrolling
;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)
;;scroll window up/down by one line
(global-set-key (kbd "M-<down>") 'scroll-up-line)
;(global-set-key (kbd "<escape>-<dowN>") 'scroll-up-line)
(global-set-key (kbd "M-<up>") 'scroll-down-line)
;(global-set-key (kbd "ESC-<up>") 'scroll-down-line)
(global-set-key (kbd "M-C-u") (lambda () (interactive) (backward-up-list) (recenter-top-bottom)))


;Shortcuts to important files
(defun dot-emacs ()
  "Quickly open .emacs"
  (interactive)
  (find-file "~/.emacs"))
(global-set-key (kbd "C-x .") 'dot-emacs)


;Git
(autoload 'mo-git-blame-current "mo-git-blame" nil t)
(global-set-key '[f8]   'mo-git-blame-current)
(global-set-key '[C-f8]   'mo-git-blame-quit)
(global-set-key '[f7]   'mo-git-blame-quit)


;Rotate frame
(load "rotate-frame")
(global-set-key (kbd "C-x / <up>") 'rotate-frame-clockwise)
(global-set-key (kbd "C-x / <down>") 'rotate-frame-anticlockwise)
(global-set-key (kbd "C-x / <right>") 'rotate-frame)


(setq kill-ring-max 60)
(setq vc-follow-symlinks nil)
;;(setq tool-bar-style 'text)


; Multiple search in buffer
(defun modi/unhighlight-all-in-buffer ()
 "Remove all highlights made by `hi-lock' from the current buffer.
    The same result can also be be achieved by \\[universal-argument] \\[unhighlight-regexp]."
 (interactive)
 ;; `unhighlight-regexp' is aliased to `hi-lock-unface-buffer'
 (hi-lock-unface-buffer t))
(bind-key "h U" #'modi/unhighlight-all-in-buffer search-map)


;; Spell checking
;(add-hook 'text-mode-hook 'flyspell-mode)
;(add-hook 'prog-mode-hook 'flyspell-prog-mode)


;; Auto complete
(require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay 1)
  (setq company-minimum-prefix-length 1)
(require 'company-irony)
  (add-to-list 'company-backends 'company-irony)
(require 'irony)
(push 'c-mode irony-supported-major-modes)
;(add-hook 'c++-mode-hook 'irony-mode)
  ;(add-hook 'c-mode-hook 'irony-mode)
  ;(add-hook 'irony-mode-hook 'irony-cdb-autosetuop-compile-options)
(with-eval-after-load 'company
  ;(add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode))
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;irony-cdb-autosetup-compile-options

;(use-package irony
;  :ensure t
;  :config
;  (unless (irony--locate-server-executable)
;    (irony-install-server))
;  )
;(irony-install-server t)


;TODO Kopzon - handle elisp bad comment indentation
;(defun foo () (setq comment-indent-function (lambda () 0)))
;(add-hook 'emacs-lisp-mode-hook 'foo 'APPEND)
;(setq ess-fancy-comments nil)


; HELM
(define-key helm-map "\t" 'helm-execute-persistent-action)
(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(setq helm-display-header-line nil)
(set-face-attribute 'helm-selection nil 
                    :background "purple"
                    :foreground "black")
(global-set-key (kbd "C-h b") 'helm-descbinds)
;(setq helm-gtags-highlight-candidate nil)
(setq helm-gtags-pulse-at-cursor nil)
;(setq helm-gtags-direct-helm-completing t)
(setq helm-gtags-direct-helm-completing t)
(setq helm-gtags-display-style 'detail)
;If this variable is non-nil, TAG file is updated after saving buffer
(setq helm-gtags-auto-update t)

;Positioning
(setq helm-split-window-in-side-p t)
(helm-autoresize-mode t)
(setq helm-autoresize-max-height 50)
(setq helm-default-display-buffer-functions '(display-buffer-in-side-window))
(defun set-helm-auto-resize-max-height (hight)
  "Set helm buffer max hight"
  (interactive (list (read-from-minibuffer "helm-max-hight: " nil nil t))
  (setq helm-autoresize-max-height hight)));TODO Kopzon - doesn't work :(
(define-prefix-co\mmand 'Kopzon-h-map)
(global-set-key (kbd "M-h") 'Kopzon-h-map)
(general-define-key
 :prefix "M-h"
 "f" (lambda () (interactive) (setq helm-default-display-buffer-functions '(display-buffer-in-side-window)))
 "b" (lambda () (interactive) (setq helm-default-display-buffer-functions '(display-buffer-in-atom-window)))
 "min" (lambda () (interactive) (setq helm-autoresize-max-height 30))
 "med" (lambda () (interactive) (setq helm-autoresize-max-height 50))
 "max" (lambda () (interactive) (setq helm-autoresize-max-height 100)))

;(helm-posframe-enable)
;(setq helm-posframe-parameters
;      '((left-fringe . 10)
;        (right-fringe . 10)))
;(setq helm-posframe-width 50)


;Call hirarchy
(global-set-key (kbd "M-;") 'call-graph)
(setq cg-initial-max-depth 1)
(setq imenu-max-item-length "Unlimited")
(defun set-max-depth (depth)
  "Set call-graph max depth"
  (interactive "nmax-depth: ")
  (setq cg-initial-max-depth depth))
(global-set-key (kbd "C-x C-d") 'set-max-depth)


; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-x <down>") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x a") 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)


;TODO Kopzon - understand how macros can be saved by emacs itself and remove this function
(defun save-macro (name key)
    "save a macro. Take a name and key as argument
     and save the last defined macro under
     this name and keyboard shortcut under this key
     at the end of your .emacs"
     (interactive "SName of the macro: \nsKey: ")  ; ask for the name and key of the macro
     (kmacro-name-last-macro name)                 ; use this name for the macro
     (find-file user-init-file)                    ; open ~/.emacs or other user init file
     (goto-char (point-max))                       ; go to the end of the .emacs
     (newline)                                     ; insert a newline
     (insert-kbd-macro name)                       ; copy the macro
     (call-interactively 'eval-last-sexp)
     (insert "(global-set-key (kbd \"C-x ")
     (insert key)
     (insert "\") ")
     (insert "\'" (symbol-name name))
     (insert ")")
     (call-interactively 'eval-last-sexp)
     (newline)                                     ; insert a newline
     (switch-to-buffer nil))                       ; return to the initial buffer


;This one is kept here only as a reference for similar functionallity
(defun new-func (name ret)
    "create new func"
     (interactive "sFunction name: \nsReturn type: ")          ; ask for the name of the function
     (find-file "~/LinuxConfigurations/new_func.template")     ; open template file
     (narrow-to-region (point-min) (point-max))
     (goto-char (point-min))
     (while (re-search-forward "funcName" nil t)               ; set function name
         (replace-match name))
     (goto-char (point-min))
     (while (re-search-forward "retValType" nil t)             ; set function return type
         (replace-match ret))
     (clipboard-kill-ring-save (point-min) (point-max))        ; copy all text from tmp
     (primitive-undo 4 buffer-undo-list)                       ; undo changes in template buffer
     (widen)                                                   ; widen
     (switch-to-buffer nil)                                    ; return to the prev buffer
     (yank)                                                    ; paste
     (kill-buffer new_func.template))                          ; kill template buffer
(global-set-key (kbd "C-x / f") 'new-func)


(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")
  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))
  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion
      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))
      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )
      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))
(global-set-key (kbd "C-x / d") 'duplicate-line)


;Buffers manipulation
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(defun close-other-buffers () 
  (interactive)                                                                   
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))
(global-set-key (kbd "C-x c a") 'close-all-buffers)
(global-set-key (kbd "C-x c c") 'close-other-buffers)


;Quit Emacs and save session in .emacs.d
;(global-set-key (kbd "C-x C-v") 'save-buffers-kill-emacs);TODO Kopzon - save session without question if to save!


;Refresh all buffers
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer) 
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))
(global-set-key '[C-f5] 'revert-buffer)
(global-set-key '[f5] 'revert-all-buffers)


; Initial display
(defun switch-full-screen ()
   (interactive)
   (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))
(global-set-key '[f11] 'switch-full-screen)

(if (display-graphic-p)
    (progn
    ;; if graphic
      (switch-full-screen)))


(global-set-key (kbd "C-x / l") 'eval-buffer)
(global-set-key (kbd "C-x / \\") 'toggle-truncate-lines)


; Winner - window layout stack
(winner-mode t)


;;Ediff
(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set)
                'set-default)
                        ',variable ,value))
(csetq ediff-window-setup-function 'ediff-setup-windows-plain)
(csetq ediff-split-window-function 'split-window-horizontally)
;(csetq ediff-diff-options "-w")
;(add-hook 'ediff-after-quit-hook-internal 'winner-undo)
(defun ora-ediff-hook ()
  (ediff-setup-keymap)
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))
(add-hook 'ediff-mode-hook 'ora-ediff-hook)


; Shift line up/down
(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))
(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))
(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))
(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)


; TODO Kopzon - enhance C style
(c-add-style "Kopzon Style"
             '("*c-guess*:/home/kopzoa/ScaleIO/src/mos/usr/mos_timed_action.c"
               (c-basic-offset . 4)     ; Guessed value
               (c-offsets-alist
                (arglist-cont . 0)      ; Guessed value
                (arglist-intro . +)     ; Guessed value
                (block-close . 0)       ; Guessed value
                (class-close . 0)       ; Guessed value
                (cpp-define-intro . +)  ; Guessed value
                (defun-block-intro . +) ; Guessed value
                (defun-close . 0)       ; Guessed value
                (defun-open . 0)        ; Guessed value
                (inclass . +)           ; Guessed value
                (label . 0)             ; Guessed value
                (statement . 0)         ; Guessed value
                (statement-block-intro . +) ; Guessed value
                (statement-cont . +)    ; Guessed value
                (substatement-open . 0) ; Guessed value
                (topmost-intro . 0)     ; Guessed value
                (access-label . -)
                (annotation-top-cont . 0)
                (annotation-var-cont . +)
                (arglist-close . c-lineup-close-paren)
                (arglist-cont-nonempty . c-lineup-arglist)
                (block-open . 0)
                (brace-entry-open . 0)
                (brace-list-close . 0)
                (brace-list-entry . 0)
                (brace-list-intro . +)
                (brace-list-open . 0)
                (c . c-lineup-C-comments)
                (case-label . 0)
                (catch-clause . 0)
                (class-open . 0)
                (comment-intro . c-lineup-comment)
                (composition-close . 0)
                (composition-open . 0)
                (cpp-macro . -1000)
                (cpp-macro-cont . +)
                (do-while-closure . 0)
                (else-clause . 0)
                (extern-lang-close . 0)
                (extern-lang-open . 0)
                (friend . 0)
                (func-decl-cont . +)
                (incomposition . +)
                (inexpr-class . +)
                (inexpr-statement . +)
                (inextern-lang . +)
                (inher-cont . c-lineup-multi-inher)
                (inher-intro . +)
                (inlambda . c-lineup-inexpr-block)
                (inline-close . 0)
                (inline-open . +)
                (inmodule . +)
                (innamespace . +)
                (knr-argdecl . 0)
                (knr-argdecl-intro . +)
                (lambda-intro-cont . +)
                (member-init-cont . c-lineup-multi-inher)
                (member-init-intro . +)
                (module-close . 0)
                (module-open . 0)
                (namespace-close . 0)
                (namespace-open . 0)
                (objc-method-args-cont . c-lineup-ObjC-method-args)
                (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
                (objc-method-intro .
                                   [0])
                (statement-case-intro . +)
                (statement-case-open . 0)
                (stream-op . c-lineup-streamop)
                (string . -1000)
                (substatement . +)
                (substatement-label . 2)
                (template-args-cont c-lineup-template-args +)
                (topmost-intro-cont . c-lineup-topmost-intro-cont))))

;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  ;; set my personal style for the current buffer
  (c-set-style "Kopzon Style")
  ;; other customizations
  (setq tab-width 4
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;GDB
(defun one-gud-window ()
  "Switch to the gud buffer and maximize"
  (interactive)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (gud-refresh))
(global-set-key (kbd "C-x 9") 'one-gud-window)

;; Open core wrappers
(defun open-core-old (platform-name binary-name core-name)
  "Open a core file dumped by a specific distro"
  (interactive
    (list (read-from-minibuffer "Platform: ")
          (read-file-name "Binary: ")
          (read-file-name "Core: ")))
  (let* ((libs-dir (concat "~/libs/libs_" platform-name))
         (cmd-line (concat "gdb -i=mi "
                           "-ex \"set libthread-db-search-path " libs-dir "\" "
                           "-ex \"set sysroot " libs-dir "\" " 
                           "-ex \"set auto-load libthread-db on\" "
                           "-c " core-name " -e " binary-name)))
    (message cmd-line)
    (gdb cmd-line)))
(defun gdb-core (repo-name libs-dir core-name bin-name)
  "Run gdb with alternative libs dir"
  (interactive 
    (list 
      (read-from-minibuffer "Please specify git repository: " nil nil t)
      (read-directory-name "Please specify libs dir: " nil nil t)
      (read-file-name "Please specify core file: " nil nil t)
      (read-file-name "Please specify binary file: " nil nil t)))
  (gdb (format (concat "gdb "
                       "-ex \"print 0\" "
                       "-ex \"set sysroot %s\" "
                       "-ex \"set auto-load libthread-db on\" "
                       "-ex \"set auto-load safe-path %s\" "
                       "-ex \"set libthread-db-search-path %s\" "
                       "-ex \"set solib-search-path %s\" "
                       "-ex \"file %s\" "
                       "-ex \"core-file %s\" "
                       "-ex \"set substitute-path /home/sio/projects/src/ /home/sio/%s/src/\" "
                       "-ex \"set substitute-path /data/builds/workspace/ScaleIO-Common-Job/src/ /home/sio/%s/src/\" "
                       "-i=mi ")

               libs-dir
               libs-dir
               libs-dir
               libs-dir
               bin-name
               core-name
               repo-name
               repo-name)))
;; the * is not working well :(
(defun gdb-core-new (bug-dir)
  "Run gdb with alternative libs dir"
  (interactive 
    (list 
      (read-directory-name "Please specify bug directory: " nil nil t)))
  (gdb (format (concat "gdb "
                       "-ex \"print 0\" "
                       "-ex \"set sysroot %s/Kopzon/libs\" "
                       "-ex \"set auto-load libthread-db on\" "
                       "-ex \"set auto-load safe-path %s/Kopzon/libs\" "
                       "-ex \"set libthread-db-search-path %s/Kopzon/libs\" "
                       "-ex \"set solib-search-path %s/Kopzon/libs\" "
                       "-ex \"file %s/Kopzon/sds-*\" "
                       "-ex \"core-file %s/Kopzon/core*\" "
                       "-i=mi ")

               bug-dir
               bug-dir
               bug-dir
               bug-dir
               bug-dir
               bug-dir)))


;; grep
(defun grep-Kopzon-rn (pattern-to-search search-folder)
  "Run grep  --color -rn <pattern-to-search> <search-folder>"
  (interactive 
    (list 
      (read-from-minibuffer "Pattern to search: " nil nil t)
      (read-directory-name "Directory to search in: " nil nil t)))
  (grep (format (concat "grep "
                       "--color "
                       "-rn "
                       "'%s' "
                       "%s")

               pattern-to-search
               search-folder)))
(defun grep-Kopzon-rni (pattern-to-search search-folder)
  "Run grep  --color -rni <pattern-to-search> <search-folder>"
  (interactive 
    (list 
      (read-from-minibuffer "Pattern to search: " nil nil t)
      (read-directory-name "Directory to search in: " nil nil t)))
  (grep (format (concat "grep "
                       "--color "
                       "-rni "
                       "'%s' "
                       "%s")

               pattern-to-search
               search-folder)))
(global-set-key (kbd "C-x g") 'grep-Kopzon-rni)
(defun grep-Kopzon-rni-include (pattern-to-search search-folder file-name-pattern)
  "Run grep  --color -rni --include=<file-name-pattern> -e <pattern-to-search> <search-folder>"
  (interactive 
    (list 
      (read-from-minibuffer "Pattern to search: " nil nil t)
      (read-directory-name "Directory to search in: " nil nil t)
      (read-from-minibuffer "File name pattern to search in: " nil nil t)))
  (grep (format (concat "grep "
                       "--color "
                       "-rni "
                       "--include=\*%s\* "
                       "-e '%s' "
                       "%s")

               file-name-pattern
               pattern-to-search
               search-folder)))


; Set GNU/Global stuff
; ====================

(setq c-mode-hook (lambda () (gtags-mode 1)))

; MISC GLOBALS
(column-number-mode)
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq-default indent-tabs-mode nil) ;We hate tabs


(defun elisp-info ()
  "Run info in elisp node."
  (interactive)
  (info "elisp"))


;Bash stuff
;(modify-syntax-entry ?'if' "('fi'" bash-mode-syntax-table)
;(modify-syntax-entry ?$ ")^" bash-mode-syntax-table)

;; if fi jump
;(global-set-key "%" 'match-paren)
;(defun match-paren (arg)
;  "Go to the matching paren if on a paren; otherwise insert %."
;  (interactive "p")
;  (cond ((looking-at "\\s\'if'") (forward-list 1) (backward-char 1))
;        ((looking-at "\\s\'fi'") (forward-char 1) (backward-list 1))
;        (t (self-insert-command (or arg 1)))))

(defun bash ()
  "Run terminal with bash"
  (interactive)
  (term "/bin/bash"))

(defun bash-sep ()
  "Insert a line of hashtags"
  (interactive)
  (beginning-of-line)
  (dotimes 
    (idx 79) (insert "#"))
  (insert "\n"))

(defun see-sep ()
  "Insert a commented line of '='"
  (interactive)
  (beginning-of-line)
  (insert "/* ")
  (dotimes (idx 73)
    (insert "="))
  (insert " */\n"))


(defun xah-pop-local-mark-ring ()
  "Move cursor to last mark position of current buffer.
Call this repeatedly will cycle all positions in `mark-ring'.
URL `http://ergoemacs.org/emacs/emacs_jump_to_previous_position.html'
Version 2016-04-04"
  (interactive)
  (set-mark-command t))


; GTAGS
;;(load-file "/usr/local/share/gtags/gtags.el")
(load-file "/usr/share/emacs/site-lisp/gtags.el")


(defun kopzon-update-all-tags ()
  "update gtags and tags"
  (interactive)
  (call-interactively 'ggtags-update-tags)
  (call-interactively 'helm-gtags-update-tags))


; Kopzon's Prefixes
(ggtags-mode t)
(define-prefix-command 'Kopzon-g-map)
(global-set-key (kbd "M-g") 'Kopzon-g-map)
(general-define-key
 :prefix "M-g"
 "tt" 'ggtags-find-tag-dwim ;finds tags, references and symbols
 "td" 'ggtags-find-definition
 "tr" 'ggtags-find-tag-regexp
 "r" 'ggtags-find-reference
 "s" 'ggtags-find-other-symbol
 "u" 'ggtags-update-tags
 "ht" 'ggtags-view-tag-history
 "hs" 'ggtags-view-search-history
 "q" 'ggtags-query-replace
 "b" 'ggtags-prev-mark
 "p" 'ggtags-prev-mark
 "n" 'ggtags-next-mark
 "M-g" 'gtags-find-with-grep
 "M-f" 'gtags-find-file
 "M-b" 'gtags-pop-stack
 "M-t" 'helm-gtags-find-tag
 "M-r" 'helm-gtags-find-rtag
 "<up>" 'comint-previous-input
 "<down>" 'comint-next-input
 "g" 'goto-line
 "<up>" 'move-text-up
 "<down>" 'move-text-down
 "<right>" (kbd "C-u 4 C-x <tab>")
 "<left>" (kbd "C-u -4 C-x <tab>"))
;g-map end

(defun scroll-up-3-lines ()
  "scroll up 3 lines"
  (interactive)
  (setq counter 3)
  (while (> counter 0)
   (scroll-up-line)
   (setq counter (1- counter))))

(defun scroll-down-3-lines ()
  "scroll up 3 lines"
  (interactive)
  (setq counter 3)
  (while (> counter 0)
   (scroll-down-line)
   (setq counter (1- counter))))

(define-prefix-command 'Kopzon-3-map)
(global-set-key (kbd "M-3") 'Kopzon-3-map)
(general-define-key
 :prefix "M-3"
 "<left>" 'switch-to-next-buffer
 "<right>" 'switch-to-prev-buffer
 "<up>" 'comint-previous-input
 "<down>" 'comint-next-input
 "[" 'switch-to-prev-buffer
 "]" 'switch-to-next-buffer

 "<next>" 'scroll-up-3-lines
 "<prior>" 'scroll-down-3-lines
 "<insertchar>" 'mc/edit-lines
 "<deletechar>" 'next-multiframe-window
 "<home>" 'save-buffers-kill-emacs
 "<end>" 'save-buffer
 "<select>" 'save-buffer

 "9"  'one-gud-window
 "M-b" 'helm-buffers-list
 "k" 'kill-buffer
 "/." 'dot-emacs
 "o" (kbd "C-x o")
 "j"  'ace-jump-mode
 "pl" 'xah-pop-local-mark-ring
 "po" 'pop-global-mark
 "M-b" 'helm-buffers-list
 "3" 'er/expand-region
 "1" 'er/contract-region
)
;;end 3-map

(define-prefix-command 'Kopzon-1-map)
(global-set-key (kbd "M-1") 'Kopzon-1-map)
(general-define-key
 :prefix "M-1"
 "<next>" 'scroll-up-3-lines
 "<prior>" 'scroll-down-3-lines
 "<insertchar>" 'mc/edit-lines
 "<deletechar>" 'next-multiframe-window
 "<home>" 'save-buffers-kill-emacs
 "<end>" 'save-buffer
 "<select>" 'save-buffer

 "9"  'one-gud-window
 "M-b" 'helm-buffers-list
 "/." 'dot-emacs
 "o" (kbd "C-x o")
 "j"  'ace-jump-mode
 "pl" 'xah-pop-local-mark-ring
 "po" 'pop-global-mark
 "M-b" 'helm-buffers-list

 "e" (kbd "C-SPC C-e")
 "a" (kbd "C-SPC C-a")
 "ml" (kbd "C-a C-SPC C-e <down> C-a")
 "<right>" (kbd "C-SPC C-<right>") ;one word forward
 "<left>" (kbd "C-SPC C-<left>") ;one word backward
 "<down>" (kbd "C-a C-SPC <down>") ;one line forward
 "<up>" (kbd "C-a <down> C-SPC <up>") ;one line backward
 "1" (kbd "C-<left> C-SPC C-<right>")
 "2" (kbd "C-<left> C-SPC C-u 2 C-<right>")
 "3" (kbd "C-<left> C-SPC C-u 3 C-<right>")
 "4" (kbd "C-<left> C-SPC C-u 4 C-<right>")
 "5" (kbd "C-<left> C-SPC C-u 5 C-<right>")
 "6" (kbd "C-<left> C-SPC C-u 6 C-<right>")
 "\`" (kbd "C-<right> C-SPC C-<left>")
 "-2" (kbd "C-<right> C-SPC C-u 2 C-<left>")
 "-3" (kbd "C-<right> C-SPC C-u 3 C-<left>")
 "-4" (kbd "C-<right> C-SPC C-u 4 C-<left>")
 "-5" (kbd "C-<right> C-SPC C-u 5 C-<left>")
 "-6" (kbd "C-<right> C-SPC C-u 6 C-<left>")
 )
; end 1-map

(define-prefix-command 'Kopzon-k-map)
(global-set-key (kbd "M-k") 'Kopzon-k-map)
(general-define-key
 :prefix "M-k"
 "e" (kbd "C-SPC C-e <DEL>")
 "a" (kbd "C-SPC C-a <DEL>")
 "l" (kbd "C-a C-k C-k"))

(define-prefix-co\mmand 'Kopzon-r-map)
(global-set-key (kbd "M-r") 'Kopzon-r-map)
(global-set-key (kbd "M-t") 'Kopzon-r-map) ; alias for typos
(general-define-key
 :prefix "M-r"
 "<left>" 'switch-to-prev-buffer
 "<right>" 'switch-to-next-buffer
 "[" 'switch-to-prev-buffer
 "]" 'switch-to-next-buffer
 "<down>" (kbd "C-x C-x C-g") ; return to previous point position

 "<next>" 'scroll-up-3-lines
 "<prior>" 'scroll-down-3-lines
 "<insertchar>" (kbd "C-e C-x C-e")
 "<deletechar>" 'next-multiframe-window
 "<home>" 'save-buffers-kill-emacs
 "<end>" 'save-buffer
 "<select>" 'save-buffer

 ;"src0" (kbd) TODO Kopzon - define macro for jumping between sio repositories
 "u" 'undo-tree-visualize
 "n" 'evil-exit-emacs-state
 "e" 'ediff-buffers
 "pl" 'xah-pop-local-mark-ring
 "po" 'pop-global-mark
 "M-b" 'helm-buffers-list
 "bb" 'helm-bookmarks
 "bs" 'bookmark-set
;TODO Kopzon - remove all bookmarks, hint: close all buffers removes from list
 "bd" 'bookmark-delete
 "h" 'helm-cycle-resume
 "o" 'other-window
 "i" 'helm-imenu ;outline
 "d" 'helm-show-kill-ring
 "qr" 'query-replace
 "M-d" 'duplicate-line
 "/1" 'delete-other-windows
 "/2" 'split-window-below
 "/3" 'split-window-right
 "/0" 'delete-window
 "/ <up>" 'rotate-frame-clockwise
 "/ <down>" 'rotate-frame-anticlockwise
 "/ <right>" 'rotate-frame
 "\\" 'helm-find-files
 "M-f" 'helm-find-files
 "//" (kbd "C-x 1 C-x 3")
 "j" 'ace-jump-word-mode
 "." 'save-buffer
 "M-." 'save-buffer
 "k" 'kill-buffer
 "x" (kbd "C-e C-x C-e <down> C-a")
 "'" (kbd "C-e C-x C-e <down> C-a")
 "SPC" (kbd "C-SPC")
 "M-g g" 'grep-Kopzon-rni
 "M-g s" 'grep-Kopzon-rn
 "M-g i" 'grep-Kopzon-rni-include
 "M-r 9" 'gdb-core
 "9" 'one-gud-window
 "r" 'read-only-mode
 "/." 'dot-emacs
 "/l" 'eval-buffer
 "c" (kbd "C-c C-c")
 "/c" (kbd "C-x / c")

 "mmm" 'magit
 "mco" 'magit-checkout
 "mbc" 'magit-branch-create
 "mbd" 'magit-branch-delete
 "mcl" 'magit-clean
 "msf" 'magit-stage-file
 "msm" 'magit-stage-modified
 "msa" 'magit-stage-modified
 "mcm" 'magit-commit
 "mf" 'magit-fetch-all-prune
 "mdw" 'magit-ediff-show-working-tree ; ediff all files in the working tree
 "mdc" 'magit-ediff-compare           ; ediff two or more serialized hashes
 "mds" 'magit-ediff-show-commit       ; select commit hash to be shown
 "mdr" 'magit-diff-range              ; select commit hash to show diff with current working tree
 "mmg" 'magit-merge
 "ml" 'magit-log-current
 "mrh" 'magit-reset-hard
 "mpl" 'magit-pull
 "mps" 'magit-push
 "mri" 'magit-rebase-interactive
 "mss" 'magit-stash
 "msl" 'magit-stash-list
 "msp" 'magit-stash-pop 
 "msc" 'magit-stash-clear 
 "mt" 'magit-tag 
 
 "3" 'helm-gtags-find-tag
 "M-3" 'helm-gtags-find-tag
 "gt" 'helm-gtags-find-tag
 "1" 'helm-gtags-find-rtag
 "M-1" 'helm-gtags-find-rtag
 "gr" 'helm-gtags-find-rtag
 "2" 'helm-gtags-find-symbol
 "M-2" 'helm-gtags-find-symbol
 "gs" 'helm-gtags-find-symbol
 "4" 'helm-gtags-find-pattern
 "M-4" 'helm-gtags-find-pattern
 "gp" 'helm-gtags-find-pattern
 "f" 'gtags-find-file
 "gf" 'gtags-find-file
 "\`" 'helm-gtags-previous-history
 "M-\`" 'helm-gtags-previous-history
 "gb" 'helm-gtags-previous-history
 "gn" 'helm-gtags-next-history
 "gu" 'kopzon-update-all-tags
; "gu" 'ggtags-update-tags
; "gu" 'helm-gtags-update-tags
 "gc" 'helm-gtags-create-tags
 "M-e" 'helm-gtags-resume
 "<up>" 'helm-gtags-resume
 "gh" 'helm-gtags-show-stack
 )
;;r-map


;TODO Kopzon - How to define minor mode
;; Main use is to have my key bindings have the highest priority
;; https://github.com/kaushalmodi/.emacs.d/blob/master/elisp/modi-mode.el

;(defvar my-mode-map (Kopzon-r-map)
;  "Keymap for `my-mode'.")

;;;###autoload
;(define-minor-mode my-mode
;  "A minor mode so that my key settings override annoying major modes."
;  ;; If init-value is not set to t, this mode does not get enabled in
;  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
;  ;; More info: http://emacs.stackexchange.com/q/16693/115
;  :init-value t
;  :lighter " my-mode"
;  :keymap Kopzon-r-map)
;
;;;;###autoload
;(define-globalized-minor-mode global-my-mode my-mode my-mode)
;
;;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;;; The keymaps in `emulation-mode-map-alists' take precedence over
;;; `minor-mode-map-alist'
;(add-to-list 'emulation-mode-map-alists `((my-mode . ,Kopzon-r-map)))
;
;;; Turn off the minor mode in the minibuffer
;(defun turn-off-my-mode ()
;  "Turn off my-mode."
;  (my-mode -1))
;(add-hook 'minibuffer-setup-hook #'turn-off-my-mode)
;
;(provide 'my-mode)



;Point navigation
(global-set-key (kbd "M-\\") 'keyboard-quit)
(global-set-key (kbd "M-c") 'keyboard-quit )
(global-set-key (kbd "M-e") 'move-end-of-line)
(global-set-key (kbd "M-a") 'move-beginning-of-line)
(global-set-key (kbd "M-d") 'yank)
(global-set-key (kbd "M-q") 'kill-region)
(global-set-key (kbd "M-i") 'evil-exit-emacs-state)
(global-set-key (kbd "C-i") 'evil-exit-emacs-state)
(global-set-key (kbd "M-\'") 'undo)
(global-set-key (kbd "M-l") 'recenter-top-bottom)
(global-set-key (kbd "<select>") 'move-end-of-line)
(global-set-key (kbd "M-n") (kbd "C-M-n"))
(global-set-key (kbd "M-p") (kbd "C-M-p"))
(global-set-key (kbd "M-u") (kbd "C-M-u"))


(defun repeatK (n f arg)
  "Calls the function F N times with ARG. Returns
the arithmetic mean of the results."
  (/ (loop repeat n sum (funcall f arg))
     n))


(global-set-key (kbd "M-f") 'isearch-forward-regexp)
(define-key isearch-mode-map "\M-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\M-r" 'isearch-repeat-backward)
(define-key isearch-mode-map "\M-1" 'isearch-yank-word-or-char)
(define-key isearch-mode-map "\M-w" 'isearch-yank-word-or-char)
;TODO Kopzon - implement 2,3,4,5
;(define-key isearch-mode-map "\M-2" 'repeatK(2 isearch-yank-word-or-char nil))
;(define-key isearch-mode-map "\M-3" 'isearch-yank-word-or-char)
;(define-key isearch-mode-map "\M-4" 'isearch-yank-word-or-char)
;(define-key isearch-mode-map "\M-5" 'isearch-yank-word-or-char)


;Evil key maps

(define-prefix-co\mmand 'Kopzon-Evil-map)
(global-set-key (kbd "M-m") 'Kopzon-Evil-map)
(general-define-key
  :prefix "M-m"
  :keymaps 'override
  "<left>" 'switch-to-prev-buffer
  "<right>" 'switch-to-next-buffer
  "[" 'switch-to-prev-buffer
  "]" 'switch-to-next-buffer
  "'" 'switch-to-prev-buffer
  ";" 'switch-to-next-buffer
  "o" 'other-window

  "<up>" 'helm-gtags-resume

  "<next>" 'scroll-up-3-lines
  "<prior>" 'scroll-down-3-lines
  "<insertchar>" (kbd "C-e C-x C-e")
  "<deletechar>" 'next-multiframe-window
  "<home>" 'save-buffers-kill-emacs
  "<end>" 'save-buffer
  "<select>" 'save-buffer 

  ;;Marking
 "ve" (kbd "C-SPC C-e")
 "va" (kbd "C-SPC C-a")
 "vl" (kbd "C-SPC C-<right>") ;one word forward
 "vh" (kbd "C-SPC C-<left>") ;one word backward
 "vj" (kbd "C-a C-SPC <down>") ;one line forward
 "vk" (kbd "C-a <down> C-SPC <up>") ;one line backward

  "h" 'highlight-symbol-at-point
  "l" 'recenter-top-bottom
  "pl" 'xah-pop-local-mark-ring
  "po" 'pop-global-mark
  "b" 'helm-buffers-list
  "o" 'other-window
  "i" 'helm-imenu ;outline
  "ring" 'helm-show-kill-ring
  "q" 'query-replace
  "d" 'duplicate-line
  "1" 'delete-other-windows
  "2" 'split-window-below
  "3" 'split-window-right
  "0" 'delete-window
  "/<up>" 'rotate-frame-clockwise
  "\\" 'helm-find-files
  "//" (kbd "C-x 1 C-x 3")
  "j" 'ace-jump-word-mode
  "s" 'save-buffer
  "k" 'kill-buffer
  "wq" 'save-buffers-kill-emacs
  "gg" 'grep-Kopzon-rni
  "8" 'gdb-core
  "9" 'one-gud-window
  "read" 'read-only-mode
  "/." 'dot-emacs
  "/l" 'eval-buffer
  "c" (kbd "C-c C-c")
  "u" 'undo-tree-visualize
  "f" 'isearch-forward-regexp

  "mmm" 'magit
  "mco" 'magit-checkout
  "mbc" 'magit-branch-create
  "mbd" 'magit-branch-delete
  "mcl" 'magit-clean
  "msf" 'magit-stage-file
  "msm" 'magit-stage-modified
  "msa" 'magit-stage-modified
  "mcm" 'magit-commit
  "mf" 'magit-fetch-all-prune
  "mda" 'magit-ediff-show-working-tree ; ediff all files in the working tree
  "mdh" 'magit-ediff-compare           ; ediff two or more serialized hashes
  "mdc" 'magit-ediff-show-commit       ; select commit hash to be shown
  "mmg" 'magit-merge
  "ml" 'magit-log-current
  "mrh" 'magit-reset-hard
  "mpl" 'magit-pull
  "mps" 'magit-push
  "mri" 'magit-rebase-interactive
  "mss" 'magit-stash
  "msl" 'magit-stash-list
  "msp" 'magit-stash-pop 
  "msc" 'magit-stash-clear 
  "mt" 'magit-tag 
  
  "gt" 'helm-gtags-find-tag
  "3" 'helm-gtags-find-tag
  "gr" 'helm-gtags-find-rtag
  "1" 'helm-gtags-find-rtag
  "gs" 'helm-gtags-find-symbol
  "2" 'helm-gtags-find-symbol
  "gp" 'helm-gtags-find-pattern
  "4" 'helm-gtags-find-pattern
  "gb" 'helm-gtags-previous-history
  "`" 'helm-gtags-previous-history
  "gn" 'helm-gtags-next-history
  "gf" 'gtags-find-file
  "f" 'gtags-find-file
  "gu" 'kopzon-update-all-tags
  "t" 'kopzon-update-all-tags
  "gh" 'helm-gtags-resume
  "<up>" 'helm-gtags-resume
  "ga" 'helm-gtags-show-stack
)
;;end of evil-map
(general-def '(normal visual) "SPC" (general-simulate-key "M-m"))

(define-key evil-normal-state-map (kbd "i") 'evil-emacs-state) 
(define-key evil-normal-state-map (kbd "<insertchar>") 'evil-emacs-state)
(define-key evil-normal-state-map (kbd "e") 'move-end-of-line) 
(define-key evil-normal-state-map (kbd "a") 'move-beginning-of-line) 
(define-key evil-normal-state-map (kbd "q") 'keyboard-quit) 
(define-key evil-normal-state-map (kbd ",") 'backward-word)
(define-key evil-normal-state-map (kbd ".") 'forward-word)
(define-key evil-normal-state-map (kbd "c") 'recenter-top-bottom)
(define-key evil-normal-state-map (kbd "M-j") 'scroll-up-line)
(define-key evil-normal-state-map (kbd "M-k") 'scroll-down-line)

(define-key evil-insert-state-map (kbd "g") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "q") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "v") 'evil-visual-state)
(define-key evil-insert-state-map (kbd "<insertchar>") 'evil-normal-state)

(define-key evil-visual-state-map (kbd "i") 'evil-emacs-state)
(define-key evil-visual-state-map (kbd "g") 'ejvil-normal-state)
(define-key evil-visual-state-map (kbd "q") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "v") 'evil-normal-state)
(define-key evil-visual-state-map (kbd ",") 'backward-word)
(define-key evil-visual-state-map (kbd ".") 'forward-word)
(define-key evil-visual-state-map (kbd "<insertchar>") 'evil-emacs-state)

(define-key evil-emacs-state-map (kbd "<insertchar>") 'evil-normal-state)

;;##############################################################################

;; Auto saved macros

(fset 'docExistingFunc
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 19 40 left 67108896 18 32 right 134217847 1 return up 47 42 42 return 32 42 32 70 117 110 99 116 105 111 110 32 78 97 109 101 58 32 25 return 32 42 return 32 42 32 68 101 115 99 114 105 112 116 105 111 110 58 return 42 32 32 32 46 46 46 return 42 up up 1 S-down S-down S-down 134217847 S-insert S-insert 42 42 47 return up up up up up up up C-right C-S-left backspace 80 97 114 97 109 101 116 101 114 115 down down down right C-S-left backspace 82 101 116 117 114 110 1 S-down S-down S-down 134217847 S-insert up up up C-right C-S-left backspace 78 111 116 101 115 down down down down 1] 0 "%d")) arg)))
(global-set-key (kbd "C-x / b") 'docExistingFunc)

(fset 'endOfFuncDoc
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217729 19 40 left 67108896 18 32 right 134217847 134217733 18 125 right 47 42 42 47 left left 32 69 110 100 32 111 102 32 25 32] 0 "%d")) arg)))
(global-set-key (kbd "C-x ;") 'endOfFuncDoc)

(fset 'argsIdentFix
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 44 right left backspace 44 delete 10] 0 "%d")) arg)))
(global-set-key (kbd "C-x ,") 'argsIdentFix)

(fset 'todoKopzonComment
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 return up 105 110 116 32 120 59 C-S-left C-S-left backspace 47 42 42 47 left left 84 79 68 79 32 75 111 112 122 111 110 32 45 32] 0 "%d")) arg)))
(global-set-key (kbd "C-x / c") 'todoKopzonComment)

(fset 'headerComment
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 return up 47 42 42 47 left left 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 1 S-down 134217847 return up 25 up return up 25 backspace left left left left left left left left left left left left left left left left left left left left left left left left left left left left left left left left delete backspace delete backspace delete backspace delete backspace delete backspace 32 32 left 88 88 88 88 88 88 88 88 down up] 0 "%d")) arg)))
(global-set-key (kbd "C-x / =") 'headerComment)


(fset 'commentFix
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([18 47 42 right 42 19 42 47 left 42 18 110 97 109 101 24 19] 0 "%d")) arg)))
(global-set-key (kbd "C-x f") 'commentFix)

(fset 'kopzonTrace
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 return up 77 79 83 95 84 82 65 67 69 40 41 59 left left 77 79 83 95 67 79 77 80 95 83 68 67 95 73 79 67 84 76 44 32 77 79 83 95 70 82 69 81 95 76 79 87 44 10 32 34 34 left 75 111 112 122 111 110 58 32 24 19] 0 "%d")) arg)))
(global-set-key (kbd "C-x / t") 'kopzonTrace)

(fset 'KopzonPrint
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 return up 120 59 backspace backspace 112 114 105 110 116 102 40 34 75 111 112 122 111 110 32 45 32 92 110 34 41 59 left left left left left] 0 "%d")) arg)))
(global-set-key (kbd "C-x / p") 'KopzonPrint)

(fset 'close-next-buffer
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 111 24 107 return 24 111] 0 "%d")) arg)))
(global-set-key (kbd "C-x x") 'close-next-buffer)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hi-black-b ((t (:background "saddle brown" :weight bold))))
 '(hi-blue-b ((t (:background "dark orange" :foreground "blue1" :weight bold))))
 '(hi-red-b ((t (:background "green" :foreground "red1" :weight bold)))))
(put 'magit-clean 'disabled nil)
