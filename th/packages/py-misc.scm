(define-module (th packages py-misc)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (guix download)
#:use-module (guix build-system python)
#:use-module (guix build-system pyproject)
#:use-module (gnu packages python-build)
#:use-module (gnu packages check)
#:use-module (gnu packages python)
#:use-module (gnu packages python-xyz)
#:use-module (gnu packages python-web)
#:use-module (gnu packages python-check)
#:use-module (gnu packages django)
#:use-module (gnu packages python-crypto)
#:use-module (gnu packages openstack)
#:use-module (gnu packages glib)
#:use-module (gnu packages admin)
#:use-module (gnu packages rust-apps)
#:use-module (gnu packages rust)
#:use-module (gnu packages crates-io)
#:use-module (gnu packages ghostscript)
#:use-module (gnu packages fontutils)
#:use-module (gnu packages compression)

#:use-module (gnu packages image)
#:use-module (guix git-download)
#:use-module ((guix licenses) #:prefix license:))

(define-public python-pillow-11
  (package
    (name "python-pillow")
    (version "11.0.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "Pillow" version))
              (sha256
               (base32
                "011wgm1mssjchpva9wsi2a07im9czyjvik137xlp5f0g7vykdrkm"))
              (modules '((guix build utils)))
              (snippet '(begin
                          (delete-file-recursively "src/thirdparty")))
              (patches
               (search-patches "python-pillow-CVE-2022-45199.patch"
                               ;; Included in 10.1.0.
                               "python-pillow-use-zlib-1.3.patch"))))
    (build-system python-build-system)
    (native-inputs (list python-pytest))
    (inputs (list freetype
                  lcms
                  libjpeg-turbo
                  libtiff
                  libwebp
                  openjpeg
                  zlib))
    (propagated-inputs (list python-olefile))
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-after 'unpack 'patch-ldconfig
                    (lambda _
                      (substitute* "setup.py"
                        (("\\['/sbin/ldconfig', '-p'\\]") "['true']"))))
                  (replace 'check
                    (lambda* (#:key outputs inputs tests? #:allow-other-keys)
                      (when tests?
                        (setenv "HOME"
                                (getcwd))
                        (add-installed-pythonpath inputs outputs)
                        (invoke "python" "selftest.py" "--installed")
                        (invoke "python" "-m" "pytest" "-vv")))))))
    (home-page "https://python-pillow.org")
    (synopsis "Fork of the Python Imaging Library")
    (description
     "The Python Imaging Library adds image processing capabilities to your
Python interpreter.  This library provides extensive file format support, an
efficient internal representation, and fairly powerful image processing
capabilities.  The core image library is designed for fast access to data
stored in a few basic pixel formats.  It should provide a solid foundation for
a general image processing tool.")
    (properties `((cpe-name . "pillow")))
    (license #f)
    ; (license (x11-style
    ;           "http://www.pythonware.com/products/pil/license.htm"
    ;           "The PIL Software License"))
    ))
(define-public python-ruff
  (package
    (name "python-ruff")
    (version "0.6.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ruff" version))
       (sha256
        (base32 "1ywndddd1kgpbczmpmm1sxgy0fz6vba3ss63hpr0qg23mdzxhcjd"))))
    (build-system pyproject-build-system)
    (native-inputs (list maturin rust-cargo rust rust-lsp-types-0.95))
    (home-page "https://docs.astral.sh/ruff")
    (synopsis
     "An extremely fast Python linter and code formatter, written in Rust.")
    (description
     "An extremely fast Python linter and code formatter, written in Rust.")
    (license license:expat)))

(define-public python-solaar
  (package
    (name "python-solaar")
    (version "1.1.13")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "solaar" version))
       (sha256
        (base32 "1pc9hdmgjlmh307xvajh2mkksx2m2jylykxkjry3bdqn2xmk8wnk"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-psutil python-pygobject python-xlib
                             python-pyudev python-pyyaml))
    (native-inputs (list python-pytest python-pytest-cov python-pytest-mock
                         python-ruff))
    (home-page "http://pwr-solaar.github.io/Solaar/")
    (synopsis
     "Linux device manager for Logitech receivers, keyboards, mice, and tablets.")
    (description
     "Linux device manager for Logitech receivers, keyboards, mice, and tablets.")
    (license #f)))

(define-public python-sanic2
  (package
    (inherit python-sanic)
   (arguments
     '(#:tests? #f))
       ; #:phases (modify-phases %standard-phases
          ; (delete 'patch-fish-config))))                          ;funky version number
))

(define-public python-ajsonrpc
  (package
    (name "python-ajsonrpc")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ajsonrpc" version))
       (sha256
        (base32 "17x1a4r4l428mhwn53abki9gzdzq3halyr4lj48fw3dzy0caq6vr"))))
    (build-system python-build-system)
    (propagated-inputs
     (list python-quart
           python-sanic2
           python-tornado))
    (home-page "https://github.com/pavlov99/ajsonrpc")
    (synopsis "Async JSON-RPC 2.0 protocol and server")
    (description
     "This package provides a Python JSON-RPC 2.0 protocol and server powered
by asyncio.")
    (license license:expat)))
; (define-public python-sanic
;   (package
;     (name "python-sanic")
;     (version "23.12.1")
;     (source
;      (origin
;        (method url-fetch)
;        (uri (pypi-uri "sanic" version))
;        (sha256
;         (base32 "115vnir4qijv89139g5h0i4l0n4w3bgh1ickgnk8xidxsa0wla15"))))
;     (build-system pyproject-build-system)
;     (propagated-inputs (list python-aiofiles
;                              python-html5tagger
;                              python-httptools
;                              python-multidict
;                              python-sanic-routing
;                              python-tracerite
;                              python-typing-extensions
;                              python-websockets))
;     (native-inputs (list python-bandit
;                          python-beautifulsoup4
;                          python-chardet
;                          python-coverage
;                          python-cryptography
;                          python-docutils
;                          python-mypy
;                          python-pygments
;                          python-pytest
;                          python-pytest-benchmark
;                          python-pytest-sanic
;                          python-ruff
;                          python-sanic-testing
;                          python-slotscheck
;                          python-towncrier
;                          python-tox
;                          python-types-ujson
;                          python-uvicorn))
;     (home-page "http://github.com/sanic-org/sanic/")
;     (synopsis
;      "A web server and web framework that's written to go fast. Build fast. Run fast.")
;     (description
;      "This package provides a web server and web framework that's written to go fast.
; Build fast.  Run fast.")
;     (license expat)))

    
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
    (license license:asl2.0)))
    
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
    (license license:gpl3)))

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
    (license license:bsd-3)))

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
                             ; python-sanic
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
  (license license:expat))
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
  (license license:expat))
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
  (license license:expat))
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
  (license license:expat)))
  
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
  (license license:expat))
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
(define-public python-niimprint
  (package
    (name "python-niimprint")
    (version "")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/TinHead/niimprint")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1djkc50pgy60l86hy6frnzzxsav4cccglwq7z395i9z07b31jiva"))))
    (build-system pyproject-build-system)
        (arguments
     `(#:tests? #f
       #:phases
        (modify-phases %standard-phases
         (delete 'sanity-check))))

    ; (arguments
     ; (list #:tests? #f))
    ;  `(#:phases
    ;    (modify-phases %standard-phases
    ;      (add-before 'build 'configure
    ;        (lambda _
    ;          (setenv "SKLEARN_BUILD_PARALLEL"
    ;                  (number->string (parallel-job-count)))))
    ;      (add-after 'build 'build-ext
    ;        (lambda _ (invoke "python" "setup.py" "build_ext" "--inplace"
    ;                          "-j" (number->string (parallel-job-count)))))
    ;      (replace 'check
    ;        (lambda* (#:key tests? #:allow-other-keys)
    ;          (when tests?
    ;            ;; Restrict OpenBLAS threads to prevent segfaults while testing!
    ;            (setenv "OPENBLAS_NUM_THREADS" "1")

    ;            ;; Some tests require write access to $HOME.
    ;            (setenv "HOME" "/tmp")

    ;            ;; Step out of the source directory to avoid interference;
    ;            ;; we want to run the installed code with extensions etc.
    ;            (with-directory-excursion "/tmp"
    ;              (invoke "pytest" "-vv" "--pyargs" "sklearn"
    ;                      "-m" "not network"
    ;                      "-n" (number->string (parallel-job-count))
    ;                      ;; This test tries to access the internet.
    ;                      "-k" "not test_load_boston_alternative"))))))))
    ; (inputs (list openblas))
    (native-inputs
     (list python-click
           python-pillow-11
           python-pyserial
           poetry))
    (propagated-inputs
     (list python-pyserial python-pillow python-click))
    (home-page "https://scikit-learn.org/")
    (synopsis "Machine Learning in Python")
    (description
     "Scikit-learn provides simple and efficient tools for data mining and
data analysis.")
    (license #f)))

python-niimprint
; #:use-module (gnu packages crates-io)
; python-pillow-11
