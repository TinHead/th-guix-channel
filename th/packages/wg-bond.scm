
(define-module (th packages wg-bond))
(use-modules 
  (gnu packages base)
  (guix packages)
  (guix download)
  (guix build-system cargo)
  ((guix licenses) #:prefix license:)
  (gnu packages crates-io)
  (gnu packages crates-web)
  (gnu packages crates-graphics)
  )


(define-public rust-checked-int-cast-1
  (package
    (name "rust-checked-int-cast")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "checked_int_cast" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06brva5agm6g12q15f8fidz17akb85q211496p1k2qxhb9mmxk0p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/PeterReid/checked_int_cast")
    (synopsis
     "Conversions between primitive integers with overflow and underflow checking")
    (description
     "This package provides Conversions between primitive integers with overflow and underflow checking.")
    (license license:expat)))

(define-public rust-qrcode-0.12
  (package
    (name "rust-qrcode")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "qrcode" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zzmrwb44r17zn0hkpin0yldwxjdwya2nkvv23jwcc1nbx2z3lhn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-checked-int-cast" ,rust-checked-int-cast-1)
                       ("rust-image" ,rust-image-0.23))))
    (home-page "https://github.com/kennytm/qrcode-rust")
    (synopsis "QR code encoder in Rust")
    (description "This package provides QR code encoder in Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ipnetwork-0.16
  (package
    (name "rust-ipnetwork")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ipnetwork" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07nkh9djfmkkwd0phkgrv977kfmvw4hmrn1xxw4cjyx23psskv5q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clippy" ,rust-clippy-0.0)
                       ("rust-serde" ,rust-serde-0.8))))
    (home-page "https://github.com/achanda/ipnetwork")
    (synopsis "library to work with IP CIDRs in Rust")
    (description
     "This package provides a library to work with IP CIDRs in Rust.")
    (license license:asl2.0)))

(define-public rust-wg-bond-0.2
  (package
    (name "rust-wg-bond")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wg-bond" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09200fs3x1rqam3r2nlv197bbw907gwidsq4f1k5df3g0kdnb247"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-base64" ,rust-base64-0.11)
                       ("rust-clap" ,rust-clap-2)
                       ("rust-ipnetwork" ,rust-ipnetwork-0.16)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pretty-env-logger" ,rust-pretty-env-logger-0.4)
                       ("rust-qrcode" ,rust-qrcode-0.12)
                       ("rust-rand" ,rust-rand-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-strum" ,rust-strum-0.18)
                       ("rust-strum-macros" ,rust-strum-macros-0.18)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://gitlab.com/cab404/wg-bond")
    (synopsis "Wireguard configuration manager")
    (description "This package provides Wireguard configuration manager.")
    (license license:gpl3+)))

