(el-get 'sync '(ruby-mode))
(el-get 'sync '(robe-mode))
(el-get 'sync '(rhtml-mode))
(el-get 'sync '(rspec-mode))
(el-get 'sync '(ruby-hash-syntax))

(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.thor\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Thorfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.xml.builder$" . ruby-mode))

(require 'rspec-mode)

;; never edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

;; do not deep indent after parenthesis in newline
(setq ruby-deep-indent-paren nil)

;; unindent closing paren
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

;; adjust evil shift width per language
(add-hook 'ruby-mode-hook
  (function (lambda ()
              (local-set-key "\t" 'insert-two-spaces)
              (setq evil-shift-width ruby-indent-level)
              (define-key evil-normal-state-local-map "%" 'evil-ruby-jump-item)
              (define-key evil-motion-state-local-map "%" 'evil-ruby-jump-item))))
