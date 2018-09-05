;; add load-path
(add-to-list 'load-path "/usr/local/Cellar/mu/1.0/share/emacs/site-lisp/mu/mu4e")

(require 'mu4e)
(require 'smtpmail)
(require 'mu4e-alert)

(setq mu4e-mu-binary "/usr/local/bin/mu")
(setq sendmail-program "msmtp")
(setq mu4e-get-mail-command "mbsync -a")

(setq mu4e-maildir "~/.mail"
      mu4e-update-interval 300
      mu4e-view-show-addresses t)

;; smtp
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)

;; (defun my-make-mu4e-context (name address signature)
;;     "Return a mu4e context named NAME with :match-func matching
;;   its ADDRESS in From or CC fields of the parent message. The
;;   context's `user-mail-address' is set to ADDRESS and its
;;   `mu4e-compose-signature' to SIGNATURE."
;;     (lexical-let ((addr-lex address))
;;       (make-mu4e-context :name name
;;                          :vars `((user-mail-address . ,address)
;;                                  (mu4e-compose-signature . ,signature))
;;                          :match-func
;;                          (lambda (msg)
;;                            (when msg
;;                              (or (mu4e-message-contact-field-matches msg :to addr-lex)
;;                                  (mu4e-message-contact-field-matches msg :cc addr-lex)))))))

;; (setq mu4e-contexts
;;         `( ,(my-make-mu4e-context "angeldsphinx" "angeldsphinx@gmail.com"
;;                                   (concat
;;                                    "Best Regards\n"
;;                                    "Sphinx Angelds\n"))))

(setq mu4e-contexts
      `(
        ,(make-mu4e-context
          :name "angeldsphinx@gmail.com"
          :enter-func (lambda () (mu4e-message "Entering context angeldsphinx@gmail.com"))
          :leave-func (lambda () (mu4e-message "Leaving context angeldsphinx@gmail.com"))
          :match-func (lambda (msg)
                        (or (null msg)
                            (mu4e-message-contact-field-matches
                             msg '(:from :to :cc :bcc) "angeldsphinx@gmail.com")))
          :vars '((user-mail-address . "angeldsphinx@gmail.com")
                  (user-full-name . "Sphinx Angelds" )
                  (mu4e-drafts-folder . "/angeldsphinx/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/angeldsphinx/[Gmail]/Sent Mail")
                  (mu4e-trash-folder . "/angeldsphinx/[Gmail]/Trash")))))

(setq mu4e-user-mail-address-list
      (delq nil (mapcar (lambda (context)
                          (cdr (assq 'user-mail-address
                                     (mu4e-context-vars context))))
                        mu4e-contexts)))


(setq mu4e-attachment-dir  "~/Downloads")
(setq mu4e-view-fields '(:from :to :cc :subject :date :mailing-list :attachments :signature))

;; mu4e-alert
(with-eval-after-load 'mu4e
  (mu4e-alert-enable-mode-line-display)
  (mu4e-alert-enable-notifications)
  (mu4e-alert-set-default-style 'notifier))



(provide '69-mail)
