(define-module (packages gopass)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gnupg)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

(define-public gopass
  (package
    (name "gopass")
    (version "1.15.5")
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
         "1r04pr6v64rh1q25dlvhp9nall318kakkvjnipx80wh3qjwi00af"))))
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