(define-module (th packages py-misc)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (guix download)
#:use-module (guix build-system python)
#:use-module (guix build-system pyproject)
#:use-module (gnu packages python-build)
#:use-module (gnu packages check)
#:use-module (gnu packages python-xyz)
#:use-module (guix licenses))

(define-public python-micropython-rp2-pico-w-stubs
(package
  (name "python-micropython-rp2-pico-w-stubs")
  (version "1.20.0.post3")
  (source
   (origin
     (method url-fetch)
     (uri (pypi-uri "micropython_rp2_pico_w_stubs" version))
     (sha256
      (base32 "092gpvwgkcjrgly5q70zqnwli22a8ip9zx4lwam1g93s1mh5dlri"))))
  (build-system pyproject-build-system)
  (home-page "https://github.com/josverl/micropython-stubs#micropython-stubs")
  (synopsis "MicroPython stubs")
  (description "@code{MicroPython} stubs")
  (license expat))
)
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
   (propagated-inputs (list python-pytest python-poetry-core))
   (arguments
    (list #:tests? #f))
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
  (inputs (list python-pytest python-poetry-core))
  
   (arguments
    (list #:tests? #f))
  (home-page "https://github.com/home-assistant-libs/home-assistant-bluetooth")
  (synopsis "Home Assistant Bluetooth Models and Helpers")
  (description "Home Assistant Bluetooth Models and Helpers")
  (license #f))
)
(define-public python-lru-dict
(package
  (name "python-lru-dict")
  (version "1.2.0")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "lru-dict" version))
            (sha256
             (base32
              "1mqvl5rfrwhddl96nw2ca4b9d1cj242700fvv3sdss4xy616gi8k"))))
  (build-system pyproject-build-system)
  (native-inputs (list python-pytest))
  (home-page "https://github.com/amitdev/lru-dict")
  (synopsis "An Dict like LRU container.")
  (description "An Dict like LRU container.")
  (license expat)))
  
(define-public python-ulid-transform
  (package
  (name "python-ulid-transform")
  (version "0.8.1")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "ulid_transform" version))
            (sha256
             (base32
              "07si139dhjac8r2q8l4frfizmxlfrf2impbfbzw92iqppn44hr57"))))
  (build-system pyproject-build-system)

  (inputs (list python-poetry-core))
  (home-page "https://github.com/bdraco/ulid-transform")
  (synopsis "Create and transform ULIDs")
  (description "Create and-map transform ULIDs")
  (license expat))
)
(define-public python-voluptuous-serialize
 (package
  (name "python-voluptuous-serialize")
  (version "2.6.0")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "voluptuous-serialize" version))
            (sha256
             (base32
              "1i57pkwzchljdmhdq31mypq6vzcfz8kxh0j42j9s70lm4dcdrb3r"))))
  (build-system pyproject-build-system)
  (propagated-inputs (list python-voluptuous))
  (home-page "http://github.com/balloob/voluptuous-serialize")
  (synopsis "Convert voluptuous schemas to dictionaries")
  (description "Convert voluptuous schemas to dictionaries")
  (license #f))
)