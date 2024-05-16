(define-module (th packages promexp))
(use-modules 
  (gnu packages base)
  (guix packages)
  (guix download)
  (guix build-system cargo)
  ((guix licenses) #:prefix license:)
  (gnu packages crates-io)
  (gnu packages crates-web)
  )

(define-public rust-prometheus-exporter-base-1
  (package
    (name "rust-prometheus-exporter-base")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prometheus_exporter_base" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "097nz74lcsic1wag0x49nmpz5nwpql7zz0k07z4p2f07ignsybg4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-env-logger" ,rust-env-logger-0.9)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-hyper-rustls" ,rust-hyper-rustls-0.23)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-num" ,rust-num-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/MindFlavor/prometheus_exporter_base")
    (synopsis "Prometheus Rust exporters base crate with optional boilerplate")
    (description
     "Prometheus Rust exporters base crate with optional boilerplate")
    (license license:expat)))

(define-public rust-prometheus-wireguard-exporter-3
  (package
    (name "rust-prometheus-wireguard-exporter")
    (version "3.6.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prometheus_wireguard_exporter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fq9qv90bdx5jprx8r7znc4g0b94p78yzz5b9k3ckbq170jhmvzg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-env-logger" ,rust-env-logger-0.9)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-prometheus-exporter-base" ,rust-prometheus-exporter-base-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1))
       #:cargo-development-inputs (("rust-clippy" ,rust-clippy-0.0))))
    (home-page "https://github.com/MindFlavor/prometheus_wireguard_exporter")
    (synopsis "Prometheus WireGuard Exporter")
    (description "Prometheus @code{WireGuard} Exporter")
    (license license:expat)))
