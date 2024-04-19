(define-module (th packages bemenu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages popt)
  #:use-module (guix download)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-crypto)
  #:use-module (guix build-system cargo))

(define-public rust-tracing-appender-0.2
  (package
    (name "rust-tracing-appender")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tracing-appender" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kq69qyjvb4dxch5c9zgii6cqhy9nkk81z0r4pj3y2nc537fhrim"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-tracing-subscriber" ,rust-tracing-subscriber-0.3))))
    (home-page "https://tokio.rs")
    (synopsis
     "Provides utilities for file appenders and making non-blocking writers.
")
    (description
     "This package provides utilities for file appenders and making non-blocking
writers.")
    (license license:expat)))

(define-public rust-platforms-3
  (package
    (name "rust-platforms")
    (version "3.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "platforms" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rzyw9y1v1qnh69smjmbslynw19x01jzji269n7mi1ljcw4d88yv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://rustsec.org")
    (synopsis
     "Rust platform registry with information about valid Rust platforms (target
triple, target_arch, target_os) sourced from the Rust compiler.
")
    (description
     "Rust platform registry with information about valid Rust platforms (target
triple, target_arch, target_os) sourced from the Rust compiler.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fiat-crypto-0.1
  (package
    (name "rust-fiat-crypto")
    (version "0.1.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fiat-crypto" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xvbcg6wh42q3n7294mzq5xxw8fpqsgc0d69dvm5srh1f6cgc9g8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/mit-plv/fiat-crypto")
    (synopsis "Fiat-crypto generated Rust")
    (description "Fiat-crypto generated Rust")
    (license (list license:expat))))

(define-public rust-curve25519-dalek-derive-0.1
  (package
    (name "rust-curve25519-dalek-derive")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "curve25519-dalek-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cry71xxrr0mcy5my3fb502cwfxy6822k4pm19cwrilrg7hq4s7l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis "curve25519-dalek Derives")
    (description "curve25519-dalek Derives")
    (license (list license:expat license:asl2.0))))

(define-public rust-curve25519-dalek-4
  (package
    (name "rust-curve25519-dalek")
    (version "4.0.0-rc.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "curve25519-dalek" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19s7w3k9l97p2m171ammxxkac3ig9vf289lxd1znzq06ziqcwsj3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-curve25519-dalek-derive" ,rust-curve25519-dalek-derive-0.1)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-fiat-crypto" ,rust-fiat-crypto-0.1)
                       ("rust-platforms" ,rust-platforms-3)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-subtle" ,rust-subtle-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis
     "A pure-Rust implementation of group operations on ristretto255 and Curve25519")
    (description
     "This package provides a pure-Rust implementation of group operations on
ristretto255 and Curve25519")
    (license license:bsd-3)))

(define-public rust-x25519-dalek-2
  (package
    (name "rust-x25519-dalek")
    (version "2.0.0-rc.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "x25519-dalek" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fp6yil0kqqqzaff1wpg2l7m5c1vjcn731jqkl2ig3k8v83swzzc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-curve25519-dalek" ,rust-curve25519-dalek-4)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/dalek-cryptography/curve25519-dalek")
    (synopsis
     "X25519 elliptic curve Diffie-Hellman key exchange in pure-Rust, using curve25519-dalek.")
    (description
     "X25519 elliptic curve Diffie-Hellman key exchange in pure-Rust, using
curve25519-dalek.")
    (license license:bsd-3)))

(define-public rust-ip-network-table-deps-treebitmap-0.5
  (package
    (name "rust-ip-network-table-deps-treebitmap")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ip_network_table-deps-treebitmap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pcyl0q3kdhlamzds5immbm00ql3d9mk9w2jnys0x75rvqr72lwf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/JakubOnderka/treebitmap")
    (synopsis "Forked version of fast IPv4/IPv6 lookup trie.")
    (description "Forked version of fast IPv4/IPv6 lookup trie.")
    (license license:expat)))

(define-public rust-ip-network-table-0.2
  (package
    (name "rust-ip-network-table")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ip_network_table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1h5jghwk1nm5lmilylwpqsf4qwbsvxx6ygyzbs6gxqn5qp7vg6a0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ip-network" ,rust-ip-network-0.4)
                       ("rust-ip-network-table-deps-treebitmap" ,rust-ip-network-table-deps-treebitmap-0.5))))
    (home-page "https://github.com/JakubOnderka/ip_network_table")
    (synopsis "IPv4 and IPv6 network fast lookup table.
")
    (description "IPv4 and IPv6 network fast lookup table.")
    (license license:bsd-2)))

(define-public rust-ip-network-0.4
  (package
    (name "rust-ip-network")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ip_network" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c8fkq601gj8bqqf36jf96pglw1m8j470vaxmacz5clq19y08bxa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-diesel" ,rust-diesel-1)
                       ("rust-postgres" ,rust-postgres-0.19)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/JakubOnderka/ip_network")
    (synopsis "IPv4 and IPv6 network structs.
")
    (description "IPv4 and IPv6 network structs.")
    (license license:bsd-2)))

(define-public rust-chacha20poly1305-0.10
  (package
    (name "rust-chacha20poly1305")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chacha20poly1305" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dfwq9ag7x7lnd0znafpcn8h7k4nfr9gkzm0w7sc1lcj451pkk8h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.5)
                       ("rust-chacha20" ,rust-chacha20-0.9)
                       ("rust-cipher" ,rust-cipher-0.4)
                       ("rust-poly1305" ,rust-poly1305-0.8)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page
     "https://github.com/RustCrypto/AEADs/tree/master/chacha20poly1305")
    (synopsis
     "Pure Rust implementation of the ChaCha20Poly1305 Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration. Also contains implementations of the XChaCha20Poly1305
extended nonce variant of ChaCha20Poly1305, and the reduced-round
ChaCha8Poly1305 and ChaCha12Poly1305 lightweight variants.
")
    (description
     "Pure Rust implementation of the @code{ChaCha20Poly1305} Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration.  Also contains implementations of the
X@code{ChaCha20Poly1305} extended nonce variant of @code{ChaCha20Poly1305}, and
the reduced-round @code{ChaCha8Poly1305} and @code{ChaCha12Poly1305} lightweight
variants.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-boringtun-0.6
  (package
    (name "rust-boringtun")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "boringtun" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0abzf8xwiwlv366cs8dlmldw44b7bqlalkiz6nnbjx6636q8f5vm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.5)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-blake2" ,rust-blake2-0.10)
                       ("rust-chacha20poly1305" ,rust-chacha20poly1305-0.10)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-hmac" ,rust-hmac-0.12)
                       ("rust-ip-network" ,rust-ip-network-0.4)
                       ("rust-ip-network-table" ,rust-ip-network-table-0.2)
                       ("rust-jni" ,rust-jni-0.19)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mock-instant" ,rust-mock-instant-0.2)
                       ("rust-nix" ,rust-nix-0.25)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracing-subscriber" ,rust-tracing-subscriber-0.3)
                       ("rust-untrusted" ,rust-untrusted-0.9)
                       ("rust-x25519-dalek" ,rust-x25519-dalek-2))))
    (home-page "https://github.com/cloudflare/boringtun")
    (synopsis
     "an implementation of the WireGuardÂ® protocol designed for portability and speed")
    (description
     "an implementation of the @code{WireGuardÂ®} protocol designed for portability
and speed")
    (license license:bsd-3)))

(define-public rust-boringtun-cli-0.6
  (package
    (name "rust-boringtun-cli")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "boringtun-cli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rb796nwr9l0qvwycm60l2wn62hfb3rfbzbxg5az6nzsb0lmwnb8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-boringtun" ,rust-boringtun-0.6)
                       ("rust-clap" ,rust-clap-3)
                       ("rust-daemonize" ,rust-daemonize-0.4)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracing-appender" ,rust-tracing-appender-0.2)
                       ("rust-tracing-subscriber" ,rust-tracing-subscriber-0.3))))
    (home-page "https://github.com/cloudflare/boringtun")
    (synopsis
     "an implementation of the WireGuardÂ® protocol designed for portability and speed")
    (description
     "an implementation of the @code{WireGuardÂ®} protocol designed for portability
and speed")
    (license license:bsd-3)))
rust-boringtun-cli-0.6
