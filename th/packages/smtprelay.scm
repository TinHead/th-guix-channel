(define-module (th packages smtprelay)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gnupg)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

(define-public smtprelay-bin
  (package
    (name "smtprelay-bin")
    (version "1.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append ;https://github.com/decke/smtprelay/releases/download/v1.10.0/smtprelay-v1.10.0-linux-amd64.tar.gz
             "https://github.com/decke/smtprelay/releases/download/v" version  "/smtprelay-v" version "-linux-amd64.tar.gz"))
       (sha256
        (base32
         "1qlhb21msc6sgi17nr5kzm88cfndrcsx6zr75x49s08fjhlsjmfj"))))
    (build-system binary-build-system)
    (inputs (list gnupg))
    (arguments
     `(#:install-plan
       `(("smtprelay" "/bin/"))
       #:patchelf-plan
       `(("smtprelay" ("gcc:lib" "glibc")))

		 ))
    (synopsis "Simple Golang SMTP relay/proxy server")
    (description "Simple Golang SMTP relay/proxy server")
    (home-page "https://github.com/decke/smtprelay")
    (license (nonfree "https://github.com/decke/smtprelay"))
))
smtprelay-bin
