(define-module (th packages py-misc)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (guix download)
#:use-module (guix build-system python)
#:use-module (guix build-system pyproject)
#:use-module (guix licenses))

(define-public python-atomicwrites-homeassistant 
(package
  (name "python-atomicwrites-homeassistant")
  (version "1.4.1")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "atomicwrites-homeassistant" version))
            (sha256
             (base32
              "0bsc3xfslmqsj02h7llnl135zdbp1cj6dn98a924arzi0qhnfsi5"))))
  (build-system pyproject-build-system)
  (home-page "https://github.com/untitaker/python-atomicwrites")
  (synopsis "Atomic file writes.")
  (description "Atomic file-name-separator-stringe writes.")
  (license expat))
)