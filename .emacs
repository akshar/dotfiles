
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-sources '(:name queue :url "https://elpa.gnu.org/packages/queue.html"))
(add-to-list 'el-get-sources '(:name inflections :url "https://raw.githubusercontent.com/remvee/emacs-rails/master/inflections.el"))
(add-to-list 'el-get-sources '(:name jsx-mode :url "https://raw.githubusercontent.com/jsx/jsx-mode.el/master/src/jsx-mode.el"))

(add-to-list 'el-get-recipe-path "/Users/akshar/code/configs/dotemacs/recipes")

(setq nel:my-packages '())
(defvar nel-initialized-hook nil)

(defun nel:require-packages (&rest packages)
  (setq nel:my-packages
	(append nel:my-packages packages)))

(defun nel:customize-package (name &rest details)
  (setq el-get-sources
        (cons (append (list :name name) details) el-get-sources)))

(defmacro nel:run-after-initializing (&rest body)
  `(add-hook 'nel-initialized-hook
	     (lambda ()
	       ,@body)))

(add-to-list 'exec-path "~/bin")

;; end of preface
;; base.el
(nel:require-packages 'anzu 'browse-kill-ring 'company-mode 'projectile 'undo-tree 'smex 'multiple-cursors 'yasnippets 'rainbow-delimiters 'expand-region 'neotree  'go-mode 'go-autocomplete 'exec-path-from-shell)

(defun back-to-indentation-or-beginning () (interactive)
       (if (= (point) (progn (back-to-indentation) (point)))
	   (beginning-of-line)))

(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn (indent-region (region-beginning) (region-end)))
      (progn (indent-buffer)))))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;;Beacon
(beacon-mode 1)
(setq beacon-color "red")
(setq beacon-blink-delay 0.4)
(setq beacon-blink-duration 0.4)
(setq beacon-blink-when-point-moves 7)
(setq beacon-push-mark 5)
(setq beacon-size 25)

(nel:run-after-initializing
 (projectile-global-mode t)
 (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
 (global-linum-mode t)
 (global-company-mode t)
 (global-undo-tree-mode t)
 (tool-bar-mode -1)
 (ido-mode 1)
 (delete-selection-mode t)
 (fset 'yes-or-no-p 'y-or-n-p)
 (scroll-bar-mode -1)
 (yas-global-mode t)
 (add-hook 'before-save-hook 'delete-trailing-whitespace))

(nel:run-after-initializing
 (windmove-default-keybindings)
 (global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)
 (global-set-key (kbd "C-=") 'er/expand-region)
 (global-set-key (kbd "s-t") 'projectile-find-file)
 (global-set-key (kbd "s-g") 'projectile-grep)
 (global-set-key (kbd "M-x") 'smex)
 (global-set-key (kbd "RET") 'newline-and-indent)
 (global-set-key (kbd "s-p") 'projectile-switch-project)
 (global-set-key (kbd "M-S-<up>") 'move-line-up)
 (global-set-key (kbd "M-S-<down>") 'move-line-down)
 (global-set-key (kbd "C-c n") 'indent-region-or-buffer))

;; Show full file path in the title bar
(setq
 frame-title-format
 '((:eval (if (buffer-file-name)
	      (abbreviate-file-name (buffer-file-name))
	    "%b"))))

;; Scroll one line at a time
(setq scroll-conservatively 10)

(global-hl-line-mode)

;; Disables audio bell
(setq ring-bell-function
      (lambda () (message "*beep*")))
;; clojure.el
(nel:require-packages 'cider 'clj-refactor 'align-cljlet 'smartparens 'fill-column-indicator)

(nel:customize-package 'cider :checkout "v0.12.0")
(setq cider-repl-history-file "~/.emacs.d/nrepl-history")
(setq cider-auto-select-error-buffer t)
(setq cider-repl-popup-stacktraces t)

(defcustom clojure-column-line nil
  "When non nil, puts a line at some character on clojure mode"
  :type 'integer
  :group 'clojure)

(defun custom-cider-shortcuts ()
  (local-set-key (kbd "C-c ,") 'cider-test-run-tests)
  (local-set-key (kbd "C-c ,") 'cider-test-run-tests)
  (local-set-key (kbd "C-c M-o") 'cider-repl-clear-buffer))

(defun custom-turn-on-fci-mode ()
  (when clojure-column-line
    (setq fci-rule-column clojure-column-line)
    (turn-on-fci-mode)))

(defmacro clojure:save-before-running (function)
  `(defadvice ,function (before save-first activate)
     (save-buffer)))

(defmacro clojure:load-before-running (function)
  `(defadvice ,function (before save-first activate)
     (cider-load-buffer)))

(nel:run-after-initializing
 (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
 (add-hook 'clojure-mode-hook 'clj-refactor-mode)
 (add-hook 'clojure-mode-hook 'show-paren-mode)
 (add-hook 'clojure-mode-hook 'sp-use-paredit-bindings)
 (add-hook 'clojure-mode-hook (lambda () (cljr-add-keybindings-with-prefix "C-c C-m")))
 (add-hook 'clojure-mode-hook 'custom-cider-shortcuts)
 (add-hook 'clojure-mode-hook 'custom-turn-on-fci-mode)

 (add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
 (add-hook 'cider-repl-mode-hook 'show-paren-mode)
 (add-hook 'cider-repl-mode-hook 'sp-use-paredit-bindings)

 (clojure:save-before-running cider-load-current-buffer)
 (clojure:load-before-running cider-test-run-tests)
 (clojure:load-before-running cider-test-rerun-tests)
 (clojure:load-before-running cider-test-run-test))
;; git.el
(nel:require-packages 'magit)

(nel:run-after-initializing
 (global-set-key (kbd "C-c g") 'magit-status))
;; grizzl.el
(nel:require-packages 'grizzl)

(setq projectile-completion-system 'grizzl)
;; markdown.el
(nel:require-packages 'markdown-mode)
;; monokai.el
(nel:require-packages 'monokai-theme)

(nel:run-after-initializing
 (load-theme 'material t)
 (set-face-attribute 'mode-line nil
		     :foreground "Black"
		     :background "DarkOrange"
		     :box nil)
(set-face-attribute 'isearch nil
                    :foreground "#000000"
                    :background "#ffff00"))   ;;'monokai t

(nel:require-packages 'emacs-powerline)
;; (setq powerline-arrow-shape 'arrow)   ;; the default
(setq powerline-arrow-shape 'curve)   ;; give your mode-line curves
(setq powerline-arrow-shape 'arrow14) ;; best for small fonts

;; recentf.el
(defun grizzl-recentf ()
  (interactive)
  (let ((file (grizzl-completing-read "Recent: " (grizzl-make-index (reverse recentf-list)))))
    (when file
      (find-file file))))

(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 15)
(setq recentf-auto-cleanup 'never)

(nel:run-after-initializing
 (recentf-mode +1)
 (run-with-timer 0 60 'recentf-save-list)
 (global-set-key (kbd "C-c f") 'grizzl-recentf))
;; ruby.el
(nel:require-packages 'rspec-mode 'ruby-tools 'yaml-mode 'ruby-electric)
;; save-autosave-in-temp-folder.el
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
;; sublime.el
(nel:require-packages 'expand-region)

(defmacro move-back-horizontal-after (&rest code)
  `(let ((horizontal-position (current-column)))
     (progn
       ,@code
       (move-to-column horizontal-position))))

(defun comment-or-uncomment-line-or-region ()
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (move-back-horizontal-after
     (comment-or-uncomment-region (line-beginning-position) (line-end-position))
     (forward-line 1))))

(defun duplicate-line ()
  (interactive)
  (move-back-horizontal-after
   (move-beginning-of-line 1)
   (kill-line)
   (yank)
   (open-line 1)
   (forward-line 1)
   (yank)))

(defun expand-to-word-and-multiple-cursors (args)
  (interactive "p")
  (if (region-active-p) (mc/mark-next-like-this args) (er/mark-word)))

(nel:run-after-initializing
 (require 'expand-region)
 (global-set-key (kbd "M-s-<right>") 'switch-to-next-buffer)
 (global-set-key (kbd "M-s-<left>") 'switch-to-prev-buffer)
 (global-set-key (kbd "s-D") 'duplicate-line)
 (global-set-key (kbd "s-Z") 'undo-tree-redo)
 (global-set-key (kbd "M-;") 'comment-or-uncomment-line-or-region)
 (global-set-key (kbd "C-<down-mouse-1>") 'mc/add-cursor-on-click)
 (global-set-key (kbd "C-S-<down>") 'mc/edit-lines)
 (global-set-key (kbd "s-d") 'expand-to-word-and-multiple-cursors))
;; web.el
(nel:require-packages 'web-mode 'scss-mode 'coffee-mode 'jshint-mode)

(setq coffee-tab-width 2)
(setq scss-compile-at-save nil)
(setq js-indent-level 2)

(add-hook 'js-mode-hook 'smartparens-strict-mode)
(add-hook 'js-mode-hook 'show-paren-mode)
(add-hook 'js-mode-hook 'sp-use-paredit-bindings)

;;robe
(add-hook 'ruby-mode-hook 'robe-mode)


;;GO
;; (setenv "GOPATH" "/Users/akshar/go")

;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize)
;;   (exec-path-from-shell-copy-env "GOPATH"))

(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
  (setq gofmt-command "goimports")                ; gofmt uses invokes goimports
  (if (not (string-match "go" compile-command))   ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; guru settings
  (go-guru-hl-identifier-mode)                    ; highlight identifiers

  ;; Key bindings specific to go-mode
  (local-set-key (kbd "M-.") 'godef-jump)         ; Go to definition
  (local-set-key (kbd "M-*") 'pop-tag-mark)       ; Return from whence you came
  (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
  (local-set-key (kbd "M-P") 'recompile)          ; Redo most recent compile cmd
  (local-set-key (kbd "M-]") 'next-error)         ; Go to next error (or msg)
  (local-set-key (kbd "M-[") 'previous-error)     ; Go to previous error or msg

  ;; Misc go stuff
  (auto-complete-mode 1))                         ; Enable auto-complete mode

(add-hook 'go-mode-hook 'my-go-mode-hook)


;; modules/personal/empty.el.el
;; start of epilogue

(el-get 'sync nel:my-packages)
(run-hooks 'nel-initialized-hook)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
