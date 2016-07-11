(require 'pdf-tools)
(require 'pdf-annot)
(require 'pdf-history)
(require 'pdf-info)
(require 'pdf-isearch)
(require 'pdf-links)
(require 'pdf-misc)
(require 'pdf-occur)
(require 'pdf-outline)
(require 'pdf-sync)
(require 'tablist-filter)
(require 'tablist)
(add-to-list 'auto-mode-alist (cons "\\.pdf$" 'pdf-view-mode))

(add-hook 'pdf-view-mode-hook
  (lambda ()
    (pdf-misc-size-indication-minor-mode)
    (pdf-links-minor-mode)
    (pdf-isearch-minor-mode)
    (pdf-view-midnight-minor-mode)
  )
)

(setq pdf-view-midnight-colors '("#7f9f7f" . "#3f3f3f"))

(provide '60-pdf-tools)
