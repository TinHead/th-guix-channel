(define-module (th packages promtail)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

(define-public promtail-bin
  (package
    (name "promtail-bin")
    (version "2.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/grafana/loki/releases/download/v" version "/promtail-linux-amd64.zip"))
       (sha256
        (base32
         "0xahkdbcc169bivyw8kqzmrl1sdjww72z6zlsfzqq2dg9jx0bnq4"))))
    (build-system binary-build-system)
    (inputs    
     `(("gcc:lib" ,gcc "lib")
       ("glibc" ,glibc)
       ("unzip",unzip)))
    (arguments
     `(#:install-plan
      `(("promtail-linux-amd64" "/bin/promtail"))
      #:patchelf-plan
       `(("promtail-linux-amd64" ("gcc:lib" "glibc")))
		 ))
    (synopsis "Grafana log collector")
    (description "Grafana log collector")
    (home-page "https://grafana.io/")
    (license (nonfree "https://grafana.io"))
))
promtail-bin
