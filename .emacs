;; Package management via dimitry/el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

; If I write custom recipes, they go here
; (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(setq my-packages
  '(
    ace-jump-mode
    el-get
    evil
  )
)

;; create a backup file directory
(defun make-backup-file-name (file)
  (concat "~/.emacs.backups/" (file-name-nondirectory file) "~"))

;; Tramp configuration
(setq tramp-default-method "ssh")

;; Keyboard configuration
(define-key special-event-map [muhenkan] 'ignore)
(define-key special-event-map [S-muhenkan] 'ignore)
(define-key special-event-map [C-muhenkan] 'ignore)
(define-key special-event-map [M-muhenkan] 'ignore)

; Not sure what this is for
; (global-font-lock-mode 1)

; Add column number in the status bar
(setq column-number-mode t)

;; Org configuration
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/.org/emacs.org"
			     "~/.org/japanese.org"
			     "~/.org/scala.org")
)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; Evil configuration
(require 'evil)
(eval-after-load "evil"
  '(progn
     (evil-mode 1)
     (global-linum-mode 1)
     (menu-bar-mode -1)

     (define-key evil-normal-state-map (kbd "C-w h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-w j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-w k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-w l") 'evil-window-right)
     (define-key evil-normal-state-map (kbd "C-w n") 'evil-window-new)
     (define-key evil-normal-state-map (kbd "C-w v") 'evil-window-vnew)
;    (define-key evil-normal-state-map (kbd "") 'ace-jump-mode)
     ))

(setq linum-format "%d ")

(setq vc-follow-symlinks t)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
    t)
