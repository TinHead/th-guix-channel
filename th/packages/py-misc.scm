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
(define-public python-awesomeversion 
 (package
   (name "python-awesomeversion")
   (version "23.8.0")
   (source (origin
             (method url-fetch)
             (uri (pypi-uri "awesomeversion" version))
             (sha256
              (base32
               "1hr15q6a73fw0l0hizpwb1wc7m7d3a1iphx15f8xnskiga8v526p"))))
   (build-system pyproject-build-system)
   (home-page "https://github.com/ludeeus/awesomeversion")
   (synopsis
    "One version package to rule them all, One version package to find them, One version package to bring them all, and in the darkness bind them.")
   (description
    "One version package to rule them all, One version package to find them, One
 version package to bring them all, and in the darkness bind them.")
  (license expat))
)
(define-public python-home-assistant-bluetooth
(package
  (name "python-home-assistant-bluetooth")
  (version "1.10.3")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "home_assistant_bluetooth" version))
            (sha256
             (base32
              "13f9ixc26gqxn3dk3rs0s5vzdg5sfshggjqv0znjw6lib4wl1x26"))))
  (build-system pyproject-build-system)
  (home-page "https://github.com/home-assistant-libs/home-assistant-bluetooth")
  (synopsis "Home Assistant Bluetooth Models and Helpers")
  (description "Home Assistant Bluetooth Models and Helpers")
  (license #f))
)