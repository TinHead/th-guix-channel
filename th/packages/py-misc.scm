(define-module (th packages py-misc)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (guix download)
#:use-module (guix build-system python)
#:use-module (guix build-system pyproject)
#:use-module (gnu packages python-build)
#:use-module (gnu packages check)
#:use-module (gnu packages python-xyz)
#:use-module (gnu packages python-web)
#:use-module (gnu packages python-check)
#:use-module (gnu packages django)
#:use-module (gnu packages rust-apps)
#:use-module (gnu packages rust)
#:use-module (guix licenses))

(define-public python-sanic
  (package
    (name "python-sanic")
    (version "23.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "sanic" version))
       (sha256
        (base32 "115vnir4qijv89139g5h0i4l0n4w3bgh1ickgnk8xidxsa0wla15"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-aiofiles
                             python-html5tagger
                             python-httptools
                             python-multidict
                             python-sanic-routing
                             python-tracerite
                             python-typing-extensions
                             python-websockets))
    (native-inputs (list python-bandit
                         python-beautifulsoup4
                         python-chardet
                         python-coverage
                         python-cryptography
                         python-docutils
                         python-mypy
                         python-pygments
                         python-pytest
                         python-pytest-benchmark
                         python-pytest-sanic
                         python-ruff
                         python-sanic-testing
                         python-slotscheck
                         python-towncrier
                         python-tox
                         python-types-ujson
                         python-uvicorn))
    (home-page "http://github.com/sanic-org/sanic/")
    (synopsis
     "A web server and web framework that's written to go fast. Build fast. Run fast.")
    (description
     "This package provides a web server and web framework that's written to go fast.
Build fast.  Run fast.")
    (license expat)))
    
(define-public python-readme-renderer
  (package
    (name "python-readme-renderer")
    (version "43.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "readme_renderer" version))
       (sha256
        (base32 "04g3zpa0kp6505h5inylj2npnkydyy3jdmnqxsg504q82hlds60q"))))
    (build-system pyproject-build-system)
    (arguments
     `(#:tests? #f
       #:phases
        (modify-phases %standard-phases
         (delete 'sanity-check))))
    (propagated-inputs (list python-docutils python-pygments))
    (home-page "")
    (synopsis
     "readme_renderer is a library for rendering readme descriptions for Warehouse")
    (description
     "readme_renderer is a library for rendering readme descriptions for Warehouse")
    (license asl2.0)))
    
(define-public python-build
  (package
    (name "python-build")
    (version "1.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "build" version))
       (sha256
        (base32 "17g1wcx8f7h0db3ymwdni1sjnyrpfna5fi9m8dng49hchzs66qjj"))))
    (build-system pyproject-build-system)
    (arguments
     `(#:tests? #f))
    (native-inputs (list python-flit-core-bootstrap python-tomli python-pyproject-hooks))
    (home-page "")
    (synopsis "A simple, correct Python build frontend")
    (description
     "This package provides a simple, correct Python build frontend")
    (license #f)))

(define-public python-zest.releaser
  (package
    (name "python-zest.releaser")
    (version "9.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "zest.releaser" version))
       (sha256
        (base32 "00b0mp0m6cq6126d54g43fm9sk31j9q4v7vr7l83wsvzk8jzpwby"))))
    (build-system pyproject-build-system)
    (arguments
     `(#:tests? #f
       #:phases
        (modify-phases %standard-phases
         (delete 'sanity-check))))
    (propagated-inputs (list python-build
                             python-colorama
                             python-readme-renderer
                             python-requests
                             python-setuptools
                             python-twine))
    (native-inputs (list python-wheel python-tomli python-zope-testing
                         python-zope-testrunner python-readme-renderer))
    (home-page #f)
    (synopsis "Software releasing made easy and repeatable")
    (description "Software releasing made easy and repeatable")
    (license gpl3)))

(define-public python-semantic-version
  (package
    (name "python-semantic-version")
    (version "2.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "semantic_version" version))
       (sha256
        (base32 "0704smz9k6hdd6i5xh0xf0sk47kannjb77abilvvp34r6v9vdaxx"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-check-manifest
                         python-colorama
                         python-coverage
                         python-django
                         python-flake8
                         python-nose2
                         python-readme-renderer
                         python-tox
                         python-wheel
                         python-zest.releaser))
    (home-page "https://github.com/rbarrois/python-semanticversion")
    (synopsis "A library implementing the 'SemVer' scheme.")
    (description
     "This package provides a library implementing the @code{SemVer} scheme.")
    (license bsd-3)))

(define-public python-platformio
  (package
    (name "python-platformio")
    (version "6.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "platformio" version))
       (sha256
        (base32 "1r6lsyf3jwpi0qvgs2dzxssc9hv18ync7x7q1ky3ii9hiw4wx23s"))))
    (build-system pyproject-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list python-ajsonrpc
                             python-bottle
                             python-click
                             python-colorama
                             python-marshmallow
                             python-pyelftools
                             python-pyserial
                             python-requests
                             python-semantic-version
                             python-starlette
                             python-tabulate
                             python-uvicorn
                             python-wsproto))
    (home-page "https://platformio.org")
    (synopsis
     "Your Gateway to Embedded Software Development Excellence. Unlock the true potential of embedded software development with PlatformIO's collaborative ecosystem, embracing declarative principles, test-driven methodologies, and modern toolchains for unrivaled success.")
    (description
     "Your Gateway to Embedded Software Development Excellence.  Unlock the true
potential of embedded software development with @code{PlatformIO's}
collaborative ecosystem, embracing declarative principles, test-driven
methodologies, and modern toolchains for unrivaled success.")
    (license #f))
)

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
  (build-system python-build-system)
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

python-platformio
