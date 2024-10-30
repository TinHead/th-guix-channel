(define-module (th packages niimprintx))

(use-modules (nonguix build-system binary)
             (guix download)
             (gnu packages gcc)
             (gnu packages compression)
             (gnu packages base)
             (gnu packages python-xyz)
             (guix packages)
             ((guix licenses) #:prefix license:)
             )
(define-public niimprintx
  (package
    (name "niimprintx")
    (version "0.0.47")
    (source
     (origin
       (method url-fetch)
       (uri 
         (string-append 
           "https://github.com/labbots/NiimPrintX/releases/download/v" version "/NiimPrintX-CLI-v" version "-Linux-x86_64.tar.gz"))
       (sha256
        (base32
         "1v1ya889bhmy2wzwpq2jgj2f0glzra4ccwc3hpfvb6x0kp8k5c5c"))))
    (build-system binary-build-system)
(arguments
      `(#:install-plan
        `(("niimprintx" "bin/"))
        #:patchelf-plan
        `(
          ("niimprintx" ("gcc" "glibc" "zlib")) 
        )))

    (inputs
     (list `(,gcc "lib") glibc zlib ))
    (propagated-inputs (list python-dbus))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

niimprintx
