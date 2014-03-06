;; create a backup file directory
(defun make-backup-file-name (file)
(concat "~/.emacs.backups/" (file-name-nondirectory file) "~"))
(setq tramp-default-method "ssh")

(define-key special-event-map [muhenkan] 'ignore)
(define-key special-event-map [S-muhenkan] 'ignore)
(define-key special-event-map [C-muhenkan] 'ignore)
(define-key special-event-map [M-muhenkan] 'ignore)

(global-font-lock-mode 1)
(setq column-number-mode t)
