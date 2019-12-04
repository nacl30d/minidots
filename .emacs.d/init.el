;;; init.el --- my miniinit el
;;; commentary:

;;; Code:

;;----------------------------------------------------------------------------------
;; Encoding and Language
;;----------------------------------------------------------------------------------
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-locale-environment nil)
(set-language-environment 'utf-8)

;;----------------------------------------------------------------------------------
;; basics
;;----------------------------------------------------------------------------------
(setq-default tab-width 4 indent-tabs-mode nil)
(setq completion-ignore-case t)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq backup-directory-alist            ;backup file dir
      (cons (cons ".*" (expand-file-name "~/.emacs.d/.backup/"))
            backup-directory-alist))
(setq auto-save-file-name-transforms    ;auto-save file dir
      `((".*", (expand-file-name "~/.emacs.d/.backup/") t)))
(setq auto-save-list-file-prefix "~/.emacs.d/.backup/auto-save-list/.saves-")


;;----------------------------------------------------------------------------------
;; mode line
;;----------------------------------------------------------------------------------
(defface egoge-display-time
  '((((type tty))
       (:foreground "blue")))
  "Face used to display the time in the mode line.")
(defvar display-time-string-forms
      '((propertize (concat " " monthname " " day " " 24-hours ":" minutes " ")
                    'face 'egoge-display-time)))
(display-time-mode t)
(global-linum-mode t)
(defvar linum-format "%d ")
(column-number-mode t)


;;----------------------------------------------------------------------------------
;; use package
;;----------------------------------------------------------------------------------
(require 'package)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;;;; add melpa and orgmode for packages
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
    ("melpa" . "http://melpa.org/packages/")
    ("org" . "http://orgmode.org/elpa/")))

(unless package-archive-contents
  (package-refresh-contents))
;;;;; ensure to use use-package
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

(require 'use-package-ensure)
(setq use-package-always-ensure t)


;;----------------------------------------------------------------------------------
;; views
;;----------------------------------------------------------------------------------
(show-paren-mode t)                     ;highlight paren pairs
(menu-bar-mode -1)                      ;hidden menu bar
(setq inhibit-startup-message t)        ;hidden startup msg
(global-set-key (kbd "C-x p") '(lambda () (interactive)(other-window -1))) ;reverse windo

(use-package srcery-theme               ;theme
  :ensure t
  :init
  (load-theme 'srcery t))

(use-package hiwin                      ;change background color if active window or not
  :ensure t
  :init
  (hiwin-activate)
  (set-face-background 'hiwin-face "gray50"))

;; (use-package hl-line+                   ;flash cursor line
;;   :bind ("C-x C-h" . flash-line-highlight)
;;   :config
;;   (set-face-background 'hl-line "yellow"))

(use-package whitespace                ;white spaces
  :bind ("C-x w" . global-whitespace-mode)
  :init
  (global-whitespace-mode 1)
  :config
  (setq whitespace-style '(face tabs tab-mark spaces space-mark))
  (setq whitespace-display-mappings
        '((space-mark ?\u3000 [?\u25a1])
          (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-foreground 'whitespace-tab "#adff2f")
  (set-face-background 'whitespace-tab 'nil)
  (set-face-underline  'whitespace-tab t)
  (set-face-foreground 'whitespace-space "#7cfc00")
  (set-face-background 'whitespace-space 'nil)
  (set-face-bold-p     'whitespace-space t))


;;----------------------------------------------------------------------------------
;; edit
;;----------------------------------------------------------------------------------
(global-set-key (kbd "C-h") 'delete-backward-char)
(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "C-c g") 'goto-line) ;goto line
(defun one-line-comment ()
  "Toggle comment out."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end))))
(global-set-key (kbd "M-/") 'one-line-comment)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

;; (use-package web-mode
;;   :mode (("\\.html?\\'" . web-mode))
;;   :config
;;   (setq web-mode-enable-auto-closing t)
;;   (setq web-mode-enable-auto-pairing t)
;;   (setq web-mode-markup-indent-offset 2)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-code-indent-offset 2)
;;   (setq web-mode-style-padding 2)
;;   (setq web-mode-script-padding 2)
;;   (setq web-mode-block-padding 0)
;;   (setq web-mode-enable-css-colorization t))

;; (use-package js2-mode
;;   :mode (("\\.js\\'" . js2-mode))
;;   :config
;;   (setq js2-strict-missing-semi-warning nil)
;;   (setq js2-missing-semi-one-line-override nil)
;;   (setq js2-basic-offset 2))

;; (use-package php-mode
;;   :mode (("\\.php\\'" . php-mode)))

;; (use-package markdown-mode
;;   :commands (markdown-mode gfm-mode)
;;   :mode (("README\\.md\\'" . gfm-mode)
;;          ("\\.md\\'" . markdown-mode))
;;   :init
;;   (setq markdown-command "multimarkdown"))

;; (use-package yaml-mode
;;   :mode (("\\.ya?ml$" . yaml-mode))
;;   :config
;;   (define-key yaml-mode-map (kbd "C-m") 'newline-and-indent))

;; (use-package json-mode
;;   :mode (("\\.json$" . json-mode)))

;;----------------------------------------------------------------------------------
;; shell
;;----------------------------------------------------------------------------------
(use-package multi-term
  :bind ("C-c t" . multi-term)
  :config
  (setq multi-term-program "/usr/local/bin/zsh")
  (delete "C-c" term-unbind-key-list)
  (defun term-send-previous-line ()
    (interactive)
    (term-send-raw-string (kbd "C-p")))
  (defun term-send-next-line ()
    (interactive)
    (term-send-raw-string (kbd "C-n")))
  (add-hook 'term-mode-hook
            '(lambda ()
               (define-key term-raw-map (kbd "C-p") 'term-send-previous-line)
               (define-key term-raw-map (kbd "C-n") 'term-send-next-line))))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (undo-tree use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
