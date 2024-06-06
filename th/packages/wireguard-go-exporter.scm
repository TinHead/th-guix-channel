
(define-module (th packages wireguard-go-exporter))
(use-modules 
  (gnu packages base)
  (guix packages)
  (guix download)
  (guix build-system go)
  ((guix licenses) #:prefix license:)
  (gnu packages golang)
  ; (gnu packages crates-web)
  ; (gnu packages crates-graphics)
  (guix git-download)
  )
(define-public wireguard-go-exporter
  (package
    (name "wireguard-go-exporter")
    (version "0.0.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/1kurops/wireguard-go-exporter")
                    (commit "0d224ca238d5bb735a2b3b08dd5f32bc8957b022")))
              ; (file-name-separator-stringe-name (git-file-name name version))
              (sha256
               (base32
                "15x9xx4fd1n7ma7qqcpz94mym5gmg7rlff3f5kg7jqribda30hrm"))))
    (build-system go-build-system)
    (arguments
     '(#:tests? #f
       #:install-source? #f
       #:import-path "github.com/1kurops/wireguard-go-exporter"))
       ; #:phases
       ; (modify-phases %standard-phases
         ;; Source-only package
         ; (delete 'build))))
    (propagated-inputs
     (list ; go-github-com-beorn7-perks-quantile
           ; go-github-com-golang-protobuf-proto
           ; go-github-com-prometheus-client-model
           ; go-github-com-prometheus-common
           ; go-github-com-prometheus-procfs
          go-github-com-prometheus-client-golang))
           ; go-github-com-cespare-xxhash))
    (synopsis "Golang Wireguard exporter format Prometheus")
    (description "This package @code{promhttp} provides wireguard Prometheus metrics.")
    (home-page "https://github.com/1kurops/wireguard-go-exporter")
    (license #f)))

; wireguard-go-exporter
