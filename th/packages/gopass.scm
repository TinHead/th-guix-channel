(define-module (th packages gopass)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gnupg)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

(define-public gopass-bin
  (package
    (name "gopass-bin")
    (version "1.15.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/gopasspw/gopass/releases/download/v"
             version
             "/gopass-"
	     version
	     "-linux-amd64.tar.gz"))
       (sha256
        (base32
         "0r0hf4qp0iqndn4i58g57mzsg9priiy5hfjhl9gq6z8mk1h6q204"))))
    (build-system binary-build-system)
    (inputs (list gnupg))
    (arguments
     `(#:install-plan
      `(("gopass" "/bin/"))
		 ))
    (synopsis "The slightly more awesome standard unix password manager for teams.")
    (description "The slightly more awesome standard unix password manager for teams.")
    (home-page "https://www.gopass.pw/")
    (license (nonfree "https://www.gopass.pw"))
))