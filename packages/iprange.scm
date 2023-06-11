(define-module (th-guix-channel packages iprange)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download))

(define-public iprange
(package
  (name "iprange")
  (version "1.0.4")
  (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/firehol/iprange/releases/download/v1.0.4/iprange-" version
                                ".tar.gz"))
            (sha256
             (base32
              "0a3l9n8yxq7r19mlvr3c590yi74gf8f1ndkk668g5vw0c7p990iw"))))
  (build-system gnu-build-system)
  (synopsis "Firhol - iprange tool")
  (description
   "Iprange")
  (home-page "https://firehol.org/")
  (license gpl2)))
