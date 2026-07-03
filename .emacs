(setq mac-option-modifier  'super)
(setq mac-command-modifier 'meta)

(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-h h"))
(define-key global-map (kbd "<mouse-2>") 'ignore)

;(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-auto-revert-mode 1)
;(global-display-line-numbers-mode 1)
(blink-cursor-mode 0)


(setq inhibit-startup-screen t
      inhibit-default-init t
      create-lockfiles nil
      initial-major-mode 'fundamental-mode
      initial-scratch-message "Any color you like.\n"
      scroll-conservatively 101
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(1)
      auto-window-vscroll nil
      vc-follow-symlinks t
      confirm-kill-processes nil
      echo-keystrokes 0.5
      dired-dwim-target t
      tab-always-indent t
      read-process-output-max (* 1024 1024)
      ring-bell-function 'ignore
      require-final-newline t
      imenu-max-items 1000
      imenu-max-item-length 1000
      make-backup-files nil
      warning-minimum-level :error
      custom-file (expand-file-name "custom.el" user-emacs-directory))


(setq-default indent-tabs-mode nil
              tab-width 4
              select-active-regions nil
              display-line-numbers-type 'relative)

(set-face-attribute 'default nil :height 180 :family "Menlo")

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq c-basic-offset 4)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.l\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.y\\'" . c++-mode))

(defun mutagen-start (session hostname remote local)
  (interactive "sSession: \nsHostname: \nsRemote: \nDLocal: ")
  (let* ((expanded-local (expand-file-name local))
         (mutagen-cmd (format "mutagen sync create --name=%s --sync-mode=two-way-resolved %s %s:%s"
                              session
                              (shell-quote-argument expanded-local)
                              hostname
                              remote)))
    (compile mutagen-cmd)))


(defun mutagen-check ()
  (interactive)
  (compile "mutagen sync list"))

(defun mutagen-reset (session)
  (interactive "sSession: ")
  (compile (format "mutagen sync reset %s && mutagen sync list" session)))

(defun mutagen-terminate (session)
  (interactive "sSession: ")
  (compile (format "mutagen sync terminate %s" session)))


(defun increment-number-at-point ()
  (interactive)
  (let ((old-point (point)))
    (unwind-protect
        (progn
          (skip-chars-backward "0-9")
          (or (looking-at "[0-9]+")
              (error "No number at point"))
          (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
      (goto-char old-point))))

(defun my-comment ()
  (interactive)
  (if (evil-visual-state-p)
      (comment-dwim 2)
    (comment-line 1)))

(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

;; evil-mode
(use-package evil
  :ensure t
  :init
  (setq evil-default-state 'emacs
        evil-want-C-u-scroll t
        evil-want-Y-yank-to-eol t
        evil-undo-system 'undo-redo
        evil-symbol-word-search t
        evil-want-keybinding nil
        evil-search-module 'evil-search)
  :config
  (evil-mode 1)
  (setq evil-motion-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-emacs-state-modes nil)
  (evil-set-initial-state 'prog-mode 'normal)
  (evil-set-initial-state 'text-mode 'normal)
  (evil-set-initial-state 'fundamental-mode 'normal)
  (evil-set-initial-state 'conf-mode 'normal)
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (define-key evil-inner-text-objects-map "w" #'evil-inner-symbol)
  (define-key evil-outer-text-objects-map "w" #'evil-a-symbol)

  (setq evil-vi-states '(normal
                         insert
                         visual
                         replace
                         operator
                         motion))

  (evil-define-key '(normal emacs)  'global (kbd "<f2>")    'goto-line)
  (evil-define-key '(normal emacs)  'global (kbd "<f8>")    'compile)
  (evil-define-key '(normal emacs)  'global (kbd "C-\\")    'split-window-horizontally)
  (evil-define-key '(normal emacs)  'global (kbd "C-x C-b") 'ibuffer)
  (evil-define-key '(normal visual) 'global (kbd "C-/")  'my-comment)
  (evil-define-key 'normal    'global (kbd "g r")  'replace-string)
  (evil-define-key 'normal    'global (kbd "g R")  'query-replace)
  (evil-define-key 'normal    'global (kbd "'")    'evil-goto-mark)
  (evil-define-key 'normal    'global (kbd "C-n")  'evil-ex-nohighlight)
  (evil-define-key 'normal    'global (kbd "C-a")  'increment-number-at-point)
  (evil-define-key 'normal    'global (kbd "C-j")  'evil-next-line)
  (evil-define-key 'normal    'global (kbd "C-p")  'ignore)

  (evil-define-key evil-vi-states 'global (kbd "C-k") 'ignore)
  (evil-define-key (cons 'emacs evil-vi-states) 'global (kbd "C-z") 'ignore)
  (evil-define-key evil-vi-states 'global (kbd "K")   'ignore)
  (evil-define-key evil-vi-states 'global (kbd "C-g") 'evil-keyboard-quit)
  (evil-define-key evil-vi-states 'global (kbd "<mouse-2>") 'ignore)

  (setq evil-default-cursor        'box
        evil-normal-state-cursor   'box
        evil-insert-state-cursor   'box
        evil-visual-state-cursor   'box
        evil-motion-state-cursor   'box
        evil-replace-state-cursor  'box
        evil-operator-state-cursor 'box
        evil-emacs-state-cursor    'box))


(let ((background      "#292929")
      (gutters         "#292929")
      (gutter-fg       "#292929")
      (gutters-active  "#292929")
      (builtin         "#FFFFFF")
      (selection       "#0000FF")
      (text            "#D3B58D")
      (comments        "#FFFF00")
      (punctuation     "#D3B58D")
      (type            "#98FB98")
      (keywords        "#FFFFFF")
      (variables       "#BFC9DB")
      (functions       "#ffffff")
      (methods         "#BFC9DB")
      (strings         "#2EC09C")
      (constants       "#BFC9DB")
      (macros          "#98FB98")
      (numbers         "#D699B5")
      (white           "#FFFFFF")
      (error           "#ff0000")
      (warning         "#FFFF00")
      (highlight-line  "#D89B75")
      (line-fg         "#126367"))

  (set-face-attribute 'default nil :foreground text :background background)
  (set-face-attribute 'region nil :background selection)
  (set-face-attribute 'cursor nil :background white)
  (set-face-attribute 'fringe nil :foreground white :background background)
  (set-face-attribute 'highlight nil :background selection)

  (set-face-attribute 'font-lock-keyword-face nil :foreground keywords)
  (set-face-attribute 'font-lock-type-face nil :foreground type)
  (set-face-attribute 'font-lock-constant-face nil :foreground constants)
  (set-face-attribute 'font-lock-property-use-face nil :foreground text)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground variables)
  (set-face-attribute 'font-lock-variable-use-face nil :foreground text)
  (set-face-attribute 'font-lock-builtin-face nil :foreground builtin)
  (set-face-attribute 'font-lock-string-face nil :foreground strings)
  (set-face-attribute 'font-lock-comment-face nil :foreground comments)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground comments)
  (set-face-attribute 'font-lock-doc-face nil :foreground comments)
  (set-face-attribute 'font-lock-function-name-face nil :foreground functions)
  (set-face-attribute 'font-lock-function-call-face nil :foreground text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground macros)
  (set-face-attribute 'font-lock-warning-face nil :foreground warning)


  (set-face-attribute 'mode-line nil :foreground background :background text :box nil)
  (set-face-attribute 'mode-line-inactive nil :foreground text :background background :box nil)

  (set-face-attribute 'line-number nil :foreground line-fg :background background)
  (set-face-attribute 'line-number-current-line nil :foreground white :background background))
