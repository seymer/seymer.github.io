;; Snippets E.G. <E
;;a       ‘#+BEGIN_EXPORT ascii’ … ‘#+END_EXPORT’
;;c       ‘#+BEGIN_CENTER’ … ‘#+END_CENTER’
;;C       ‘#+BEGIN_COMMENT’ … ‘#+END_COMMENT’
;;e       ‘#+BEGIN_EXAMPLE’ … ‘#+END_EXAMPLE’
;;E       ‘#+BEGIN_EXPORT’ … ‘#+END_EXPORT’
;;h       ‘#+BEGIN_EXPORT html’ … ‘#+END_EXPORT’
;;l       ‘#+BEGIN_EXPORT latex’ … ‘#+END_EXPORT’
;;q       ‘#+BEGIN_QUOTE’ … ‘#+END_QUOTE’
;;s       ‘#+BEGIN_SRC’ … ‘#+END_SRC’
;;v       ‘#+BEGIN_VERSE’ … ‘#+END_VERSE’
(require 'org-tempo)

;; timestamp format
(setf org-html-metadata-timestamp-format "%Y %b %d")
(setf org-export-date-timestamp-format "%Y-%m-%d")

;; Truncate line e.g. M-x toggle-truncate-lines
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

;; Enable HTML5
(setq org-html-html5-fancy t
      org-html-doctype     "html5")

;; Disable ox-html's default CSS and JavaScript
(setq org-html-head-include-default-style nil
      org-html-head-include-scripts       nil)

;; Don't show section numbers or table of contents by default
(setq org-export-with-section-numbers nil
      org-export-with-toc             nil)

;; TODO: tweak headline id format. I dislike the randomly generated ones.
;; Look into customizing: :html-format-headline-function and
;; org-html-format-headline-function
;; (setq org-html-self-link-headlines 'nil)

(require 'ox-html)
;; Render ~verbatim~ as kbd tag in HTML
(add-to-list 'org-html-text-markup-alist '(verbatim . "<kbd>%s</kbd>"))

;; Enable code syntax highlighting if available
                                        ;(require 'package)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;(setq package-load-list '((htmlize t)))
;;(package-initialize)

(unless (package-installed-p 'htmlize)
  (package-refresh-contents)
  (package-install 'htmlize))

(if (package-installed-p 'htmlize)
    (setq org-html-htmlize-output-type 'css)
  (setq org-html-htmlize-output-type 'nil))
(put 'set-goal-column 'disabled nil)


(require 'ox-publish)

(setq org-export-global-macros
      '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@")
        ("cc-by-nd" . "@@html:<div class=\"license-notice-container\">
  <div class=\"license-notice\">
    <div class\"notice\">
      <span><b>Note:</b></span>
      <span>
        <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nd/4.0/\">
          <img alt=\"Creative Commons License\"
               src=\"https://i.creativecommons.org/l/by-nd/4.0/88x31.png\" />
        </a>
      </span>
    </div>
    This post is licensed under the
    <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nd/4.0/\">
      CC-BY-ND 4.0
    </a>.
  </div>
</div>@@")
        ("right-justify" . "@@html:<span class=\"right-justify\">$1</span>@@")))

(defun org-sitemap-custom-entry-format (entry style project)
  "Sitemap PROJECT ENTRY STYLE format that includes date."
  (let ((filename (org-publish-find-title entry project)))
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
                                  (org-publish-find-date entry project))
              entry
              filename))))

(defvar blog-css "<link rel=\"shortcut icon\" href=\"https://www.khow.me/blog/images/favicon.ico\" /><link rel=\"stylesheet\" type=\"text/css\" href=\"./css/site.css\" />")
(defvar blog-css-extra "<link rel=\"stylesheet\" media=\"(prefers-color-scheme: light)\" href=\"./css/modus-operandi.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" media=\"(prefers-color-scheme: dark)\" href=\"./css/modus-vivendi.css\" type=\"text/css\"/>")
(defvar blog-footer "<div id=\"disqus_thread\"></div>
            <script type=\"text/javascript\">
            var disqus_shortname = 'seymer';
            (function() {
                    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
                    dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
                    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
                    })();
            </script>
            <script>
              (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

              ga('create', 'UA-110114842-1', 'auto');
              ga('send', 'pageview');
            </script>")


(setq org-publish-project-alist
      `(
        ("blog"
         :base-directory "~/Github/seymer.github.io/src/org/"
         :publishing-directory "~/Github/seymer.github.io/blog/"
         :recursive nil
         :html-head-include-default-style nil
         :html-head ,blog-css
         :html-head-extra ,blog-css-extra
         :publishing-function org-html-publish-to-html
         :section-numbers 't
         :auto-sitemap 't
         :sitemap-filename "index.org"
         :sitemap-title "Siqing's Blog"
         :sitemap-sort-files anti-chronologically
         :sitemap-format-entry org-sitemap-custom-entry-format
         :with-toc 't
         :html-postamble ,blog-footer
         )

        ("site" :components ("blog"))))

(provide 'init-local)
