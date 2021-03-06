;;; Basic ruby setup
(require 'ruby-mode)
(require 'ruby-hash-syntax)

(add-auto-mode 'ruby-mode
               "Rakefile\\'" "\\.rake\\'" "\\.rxml\\'" "\\.rbs\\'"
               "\\.rjs\\'" "\\.irbrc\\'" "\\.pryrc\\'" "\\.builder\\'" "\\.ru\\'"
               "\\.gemspec\\'" "Gemfile\\'" "Kirkfile\\'")

(setq ruby-use-encoding-map nil)

(after-load 'ruby-mode
  (define-key ruby-mode-map (kbd "TAB") 'indent-for-tab-command)

  ;; Stupidly the non-bundled ruby-mode isn't a derived mode of
  ;; prog-mode: we run the latter's hooks anyway in that case.
  (add-hook 'ruby-mode-hook
            (lambda ()
              (unless (derived-mode-p 'prog-mode)
                (run-hooks 'prog-mode-hook)))))

(add-hook 'ruby-mode-hook 'subword-mode)

;; TODO: hippie-expand ignoring : for names in ruby-mode
;; TODO: hippie-expand adaptor for auto-complete sources

(after-load 'page-break-lines
  (push 'ruby-mode page-break-lines-modes))

;;; Inferior ruby
(require 'inf-ruby)
(require 'ac-inf-ruby)
(after-load 'auto-complete
  (add-to-list 'ac-modes 'inf-ruby-mode))
(add-hook 'inf-ruby-mode-hook 'ac-inf-ruby-enable)
(after-load 'inf-ruby
  (define-key inf-ruby-mode-map (kbd "TAB") 'auto-complete))

(require 'inf-ruby)
(setq inf-ruby-default-implementation "pry")
(setq inf-ruby-eval-binding "Pry.toplevel_binding")
(add-hook 'inf-ruby-mode-hook 'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c C-p") 'inf-ruby)


;;; Ruby compilation
(require 'ruby-compilation)

(after-load 'ruby-mode
  (let ((m ruby-mode-map))
    (define-key m [S-f7] 'ruby-compilation-this-buffer)
    (define-key m [f7] 'ruby-compilation-this-test)))

(after-load 'ruby-compilation
  (defalias 'rake 'ruby-compilation-rake))


;;; Robe
(require 'robe)
(after-load 'ruby-mode
  (add-hook 'ruby-mode-hook 'robe-mode))
(add-hook 'robe-mode-hook 'ac-robe-setup)

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(defun sanityinc/maybe-enable-robe-ac ()
  "Enable/disable robe auto-complete source as necessary."
  (if robe-mode
      (progn
        (add-hook 'ac-sources 'ac-source-robe nil t)
        (set-auto-complete-as-completion-at-point-function))
    (remove-hook 'ac-sources 'ac-source-robe)))

(after-load 'robe
  (add-hook 'robe-mode-hook 'sanityinc/maybe-enable-robe-ac)
  (add-hook 'robe-mode-hook (lambda() (local-set-key (kbd "M-*") 'pop-tag-mark))))


;; Customise highlight-symbol to not highlight do/end/class/def etc.
(defun sanityinc/suppress-ruby-mode-keyword-highlights ()
  "Suppress highlight-symbol for do/end etc."
  (set (make-local-variable 'highlight-symbol-ignore-list)
       (list (concat "\\_<" (regexp-opt '("do" "end")) "\\_>"))))
(add-hook 'ruby-mode-hook 'sanityinc/suppress-ruby-mode-keyword-highlights)

(require 'rubocop)
(require 'rubocopfmt)
(add-hook 'ruby-mode-hook #'rubocopfmt-mode)
(setq rubocopfmt-use-bundler-when-possible nil)

;;; ri support
(require 'yari)
(defalias 'ri 'yari)


;;; YAML
(require 'yaml-mode)


;;; ERB
(require 'mmm-mode)
(defun sanityinc/ensure-mmm-erb-loaded ()
  (require 'mmm-erb))

(require 'derived)

(defun sanityinc/set-up-mode-for-erb (mode)
  (add-hook (derived-mode-hook-name mode) 'sanityinc/ensure-mmm-erb-loaded)
  (mmm-add-mode-ext-class mode "\\.erb\\'" 'erb))

(let ((html-erb-modes '(html-mode html-erb-mode nxml-mode)))
  (dolist (mode html-erb-modes)
    (sanityinc/set-up-mode-for-erb mode)
    (mmm-add-mode-ext-class mode "\\.r?html\\(\\.erb\\)?\\'" 'html-js)
    (mmm-add-mode-ext-class mode "\\.r?html\\(\\.erb\\)?\\'" 'html-css)))

(mapc 'sanityinc/set-up-mode-for-erb
      '(coffee-mode js-mode js2-mode js3-mode markdown-mode textile-mode))

(mmm-add-mode-ext-class 'html-erb-mode "\\.jst\\.ejs\\'" 'ejs)

(add-auto-mode 'html-erb-mode "\\.rhtml\\'" "\\.html\\.erb\\'")
(add-to-list 'auto-mode-alist '("\\.jst\\.ejs\\'"  . html-erb-mode))
(mmm-add-mode-ext-class 'yaml-mode "\\.yaml\\'" 'erb)

(dolist (mode (list 'js-mode 'js2-mode 'js3-mode))
  (mmm-add-mode-ext-class mode "\\.js\\.erb\\'" 'erb))


;;----------------------------------------------------------------------------
;; Ruby - my convention for heredocs containing SQL
;;----------------------------------------------------------------------------

;; Needs to run after rinari to avoid clobbering font-lock-keywords?

;; (require 'mmm-mode)
;; (eval-after-load 'mmm-mode
;;   '(progn
;;      (mmm-add-classes
;;       '((ruby-heredoc-sql
;;          :submode sql-mode
;;          :front "<<-?[\'\"]?\\(end_sql\\)[\'\"]?"
;;          :save-matches 1
;;          :front-offset (end-of-line 1)
;;          :back "^[ \t]*~1$"
;;          :delimiter-mode nil)))
;;      (mmm-add-mode-ext-class 'ruby-mode "\\.rb\\'" 'ruby-heredoc-sql)))

;(add-to-list 'mmm-set-file-name-for-modes 'ruby-mode)



(provide '16-ruby)
