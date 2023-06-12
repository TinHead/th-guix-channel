(define-public rust-boolean-expression-0.3
  (package
    (name "rust-boolean-expression")
    (version "0.3.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "boolean_expression" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10zspcm7h2dsywi4d26h8crj10qf0mn2clnk5wjx58l18iifycvw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-itertools" ,rust-itertools-0.9)
                       ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "https://github.com/cfallin/boolean_expression")
    (synopsis
     "A library for manipulating and evaluating Boolean expressions and BDDs")
    (description
     "This package provides a library for manipulating and evaluating Boolean
expressions and BDDs")
    (license license:expat)))

(define-public rust-bitmatch-0.1
  (package
    (name "rust-bitmatch")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bitmatch" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1bd3h49s3y4s0h5qhr1nr0yfc6p8z1y3p3jbb6scjrhrsh2y2lva"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-boolean-expression" ,rust-boolean-expression-0.3)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/porglezomp/bitmatch")
    (synopsis
     "A macro to allow matching, binding, and packing the individual bits of integers.")
    (description
     "This package provides a macro to allow matching, binding, and packing the
individual bits of integers.")
    (license license:mpl2.0)))

(define-public rust-itm-0.9
  (package
    (name "rust-itm")
    (version "0.9.0-rc.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "itm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "04abrp84620daxcihl0s79cmr6vrqzbaqvyc2xqaqf5j921y02fz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitmatch" ,rust-bitmatch-0.1)
                       ("rust-bitvec" ,rust-bitvec-1)
                       ("rust-nix" ,rust-nix-0.23)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/rtic-scope/itm")
    (synopsis
     "A decoding library for the ARM Cortex-M ITM/DWT packet protocol")
    (description
     "This package provides a decoding library for the ARM Cortex-M ITM/DWT packet
protocol")
    (license (list license:expat license:asl2.0))))

(define-public rust-tracing-core-0.1
  (package
    (name "rust-tracing-core")
    (version "0.1.31")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16pp28izw9c41m7c55qsghlz07r9ark8lzd3x6ig3xhxg89vhm89"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-valuable" ,rust-valuable-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Core primitives for application-level tracing.
")
    (description "Core primitives for application-level tracing.")
    (license license:expat)))

(define-public rust-tracing-attributes-0.1
  (package
    (name "rust-tracing-attributes")
    (version "0.1.24")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing-attributes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0x3spb5h4m56035lrvrchbyhg8pxrg4sk0qij8d0ni815b5f6mqg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://tokio.rs")
    (synopsis
     "Procedural macro attributes for automatically instrumenting functions.
")
    (description
     "Procedural macro attributes for automatically instrumenting functions.")
    (license license:expat)))

(define-public rust-tracing-0.1
  (package
    (name "rust-tracing")
    (version "0.1.38")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kc1mpsh00l2zd9wryf1jyzwvilmbjdg5dmnn240rx6k2flgd76g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tracing-attributes" ,rust-tracing-attributes-0.1)
                       ("rust-tracing-core" ,rust-tracing-core-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Application-level tracing for Rust.
")
    (description "Application-level tracing for Rust.")
    (license license:expat)))

(define-public rust-svg-0.13
  (package
    (name "rust-svg")
    (version "0.13.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "svg" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "04kim0zxjfcif7aksd4rwrsgxva5hr24hhjd6z94k13y6fnibn02"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bodoni/svg")
    (synopsis "The package provides an SVG composer and parser.")
    (description "The package provides an SVG composer and parser.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-unsafe-libyaml-0.2
  (package
    (name "rust-unsafe-libyaml")
    (version "0.2.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unsafe-libyaml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "19l0v20x83dvxbr68rqvs9hvawaqd929hia1nldfahlhamm80r8q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dtolnay/unsafe-libyaml")
    (synopsis "libyaml transpiled to rust by c2rust")
    (description "libyaml transpiled to rust by c2rust")
    (license license:expat)))

(define-public rust-serde-yaml-0.9
  (package
    (name "rust-serde-yaml")
    (version "0.9.21")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_yaml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1714w6f5b2g4svha9r96cirz05mc0d9xfaxkcrabzqvxxkiq9mnr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-unsafe-libyaml" ,rust-unsafe-libyaml-0.2))))
    (home-page "https://github.com/dtolnay/serde-yaml")
    (synopsis "YAML data format for Serde")
    (description "YAML data format for Serde")
    (license (list license:expat license:asl2.0))))

(define-public rust-scroll-derive-0.11
  (package
    (name "rust-scroll-derive")
    (version "0.11.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "scroll_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03i5qn4jfcl2iwxhfvw9kf48a656ycbf5km99xr1wcnibjnadgdx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/m4b/scroll")
    (synopsis
     "A macros 1.1 derive implementation for Pread and Pwrite traits from the scroll crate")
    (description
     "This package provides a macros 1.1 derive implementation for Pread and Pwrite
traits from the scroll crate")
    (license license:expat)))

(define-public rust-scroll-0.11
  (package
    (name "rust-scroll")
    (version "0.11.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "scroll" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1nhrhpzf95pxbcjjy222blwf8rl3adws6vsqax0yzyxsa6snbi84"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-scroll-derive" ,rust-scroll-derive-0.11))))
    (home-page "https://github.com/m4b/scroll")
    (synopsis
     "A suite of powerful, extensible, generic, endian-aware Read/Write traits for byte buffers")
    (description
     "This package provides a suite of powerful, extensible, generic, endian-aware
Read/Write traits for byte buffers")
    (license license:expat)))

(define-public rust-probe-rs-target-0.18
  (package
    (name "rust-probe-rs-target")
    (version "0.18.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "probe-rs-target" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ka5qanjgf2gvm69j7mg3rysf7xsm6winss1ah5km3qj741xhx2b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-jep106" ,rust-jep106-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/probe-rs/probe-rs")
    (synopsis "Target description schema for probe-rs.")
    (description "Target description schema for probe-rs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hashbrown-0.13
  (package
    (name "rust-hashbrown")
    (version "0.13.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hashbrown" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03ji3n19j4b6mf2wlla81vsixcmlivglp6hgk79d1pcxfcrw38s3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bumpalo" ,rust-bumpalo-3)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-lang/hashbrown")
    (synopsis "A Rust port of Google's SwissTable hash map")
    (description
     "This package provides a Rust port of Google's SwissTable hash map")
    (license (list license:expat license:asl2.0))))

(define-public rust-object-0.30
  (package
    (name "rust-object")
    (version "0.30.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "object" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "11f3cfd7b54ij1rwvrp9837nhszjdndxr4f4iyxazkyrhq5nid03"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-crc32fast" ,rust-crc32fast-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.13)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-wasmparser" ,rust-wasmparser-0.57))))
    (home-page "https://github.com/gimli-rs/object")
    (synopsis
     "A unified interface for reading and writing object file formats.")
    (description
     "This package provides a unified interface for reading and writing object file
formats.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-libftdi1-source-lgpl-1
  (package
    (name "rust-libftdi1-source-lgpl")
    (version "1.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libftdi1-source-lgpl" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cgx15xiv796nadpzw4mzmnqg690dv2gxkmhqmcqzdy7726r24j4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/tanriol/libftdi1-sys")
    (synopsis
     "libFTDI source code bundle for libftdi1-sys (internal use only)")
    (description
     "libFTDI source code bundle for libftdi1-sys (internal use only)")
    (license (list license:lgpl2.1 license:expat))))

(define-public rust-libftdi1-sys-1
  (package
    (name "rust-libftdi1-sys")
    (version "1.1.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libftdi1-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0f13pb49172gbcm5bdv96cpjbxj15z4w8q4a7kn3plf7fa495xiz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.59)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libftdi1-source-lgpl" ,rust-libftdi1-source-lgpl-1)
                       ("rust-libusb1-sys" ,rust-libusb1-sys-0.6)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-vcpkg" ,rust-vcpkg-0.2))))
    (home-page "https://github.com/tanriol/libftdi1-sys")
    (synopsis "FFI bindings for libftdi1")
    (description "FFI bindings for libftdi1")
    (license license:expat)))

(define-public rust-kmp-0.1
  (package
    (name "rust-kmp")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "kmp" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0a1093n8v20p43jvg2ima5clisyp23h5n34z3v616hm6b6mxs6qk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://gitlab.com/bit-refined/kmp/")
    (synopsis
     "Various functions using the KnuthâMorrisâPratt algorithm to efficiently find patterns.")
    (description
     "Various functions using the KnuthâMorrisâPratt algorithm to efficiently find
patterns.")
    (license license:lgpl3+)))

(define-public rust-jep106-0.2
  (package
    (name "rust-jep106")
    (version "0.2.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "jep106" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1c50q10qv6hps8k2s75qd79jpqnarjjgd3vhi3jpzr3nw4xb74zz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Yatekii/jep106")
    (synopsis "A pollable collection of all JEP106 manufacturer codes.")
    (description
     "This package provides a pollable collection of all JEP106 manufacturer codes.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libusb1-sys-0.6
  (package
    (name "rust-libusb1-sys")
    (version "0.6.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libusb1-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "09sznaf1lkahb6rfz2j0zbrcm2viz1d1wl8qlk4z4ia2rspy5l7r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-vcpkg" ,rust-vcpkg-0.2))))
    (home-page "https://github.com/a1ien/rusb")
    (synopsis "FFI bindings for libusb.")
    (description "FFI bindings for libusb.")
    (license license:expat)))

(define-public rust-rusb-0.9
  (package
    (name "rust-rusb")
    (version "0.9.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rusb" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lf5hpvka5rr19bpww3mk8gi75xkr54gl79cf6za7cgr2ilw7a24"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-libusb1-sys" ,rust-libusb1-sys-0.6))))
    (home-page "https://github.com/a1ien/rusb")
    (synopsis "Rust library for accessing USB devices.")
    (description "Rust library for accessing USB devices.")
    (license license:expat)))

(define-public rust-jaylink-0.3
  (package
    (name "rust-jaylink")
    (version "0.3.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "jaylink" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1w0d1fghfc4ymshh97syw7342s8ada5wily1hibdi5w3w0sik29d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rusb" ,rust-rusb-0.9))))
    (home-page "https://github.com/jonas-schievink/jaylink.git")
    (synopsis "Library to communicate with J-Link USB devices")
    (description "Library to communicate with J-Link USB devices")
    (license license:bsd-0)))

(define-public rust-ihex-3
  (package
    (name "rust-ihex")
    (version "3.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ihex" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wlzfyy5fsqgpki5vdapw0jjczqdm6813fgd3661wf5vfi3phnin"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "http://github.com/martinmroz/ihex")
    (synopsis
     "A Rust library for parsing and generating Intel HEX (or IHEX) objects. This format is commonly used for representing compiled program code and data to be loaded into a microcontroller, flash memory or ROM.")
    (description
     "This package provides a Rust library for parsing and generating Intel HEX (or
IHEX) objects.  This format is commonly used for representing compiled program
code and data to be loaded into a microcontroller, flash memory or ROM.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libudev-sys-0.1
  (package
    (name "rust-libudev-sys")
    (version "0.1.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libudev-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "09236fdzlx9l0dlrsc6xx21v5x8flpfm3d5rjq9jr5ivlas6k11w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/dcuddeback/libudev-sys")
    (synopsis "FFI bindings to libudev")
    (description "FFI bindings to libudev")
    (license license:expat)))

(define-public rust-udev-0.7
  (package
    (name "rust-udev")
    (version "0.7.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "udev" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06hr927z0fdn7ay0p817b9x19i5fagmpmvz95yhl4d1pf3bbpgaf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-libudev-sys" ,rust-libudev-sys-0.1)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-mio" ,rust-mio-0.7)
                       ("rust-mio" ,rust-mio-0.6)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/Smithay/udev-rs")
    (synopsis "libudev bindings for Rust")
    (description "libudev bindings for Rust")
    (license license:expat)))

(define-public rust-hidapi-2
  (package
    (name "rust-hidapi")
    (version "2.3.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hidapi" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06s3mvr0yrv14fkp9iwks3q700ri895h8f6an9pi2pk1fyxiv10z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-nix" ,rust-nix-0.26)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-udev" ,rust-udev-0.7)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/ruabmbua/hidapi-rs")
    (synopsis "Rust-y wrapper around hidapi")
    (description "Rust-y wrapper around hidapi")
    (license license:expat)))

(define-public rust-quickcheck-0.3
  (package
    (name "rust-quickcheck")
    (version "0.3.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quickcheck" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "01a6s6lmnjld9lahbl54qp7h7x2hnkkzhcyr2gdhbk460sj3scqb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-env-logger" ,rust-env-logger-0.3)
                       ("rust-log" ,rust-log-0.3)
                       ("rust-rand" ,rust-rand-0.3))))
    (home-page "https://github.com/BurntSushi/quickcheck")
    (synopsis "Automatic property based testing with shrinking.")
    (description "Automatic property based testing with shrinking.")
    (license (list license:unlicense license:expat))))

(define-public rust-quickcheck-macros-0.2
  (package
    (name "rust-quickcheck-macros")
    (version "0.2.29")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quickcheck_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1fdcv882b81q64fsy3d77kqd4r9cimd5w15w15p6zphys07zhphx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-quickcheck" ,rust-quickcheck-0.3))))
    (home-page "https://github.com/BurntSushi/quickcheck")
    (synopsis "A macro attribute for quickcheck.")
    (description "This package provides a macro attribute for quickcheck.")
    (license (list license:unlicense license:expat))))

(define-public rust-itertools-0.4
  (package
    (name "rust-itertools")
    (version "0.4.19")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "itertools" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0gxwcmxyq7fmccdqclfzyg4wnb2b445g8n3fqqyz8n30nmpbbaf4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-quickcheck" ,rust-quickcheck-0.2))))
    (home-page "https://github.com/rust-itertools/itertools")
    (synopsis
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (description
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hexdump-0.1
  (package
    (name "rust-hexdump")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hexdump" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wh555ab0c570fmkbng1jamy9d0pgdqivgkqi1vszwq2vgd860p4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                       ("rust-itertools" ,rust-itertools-0.4)
                       ("rust-quickcheck" ,rust-quickcheck-0.2)
                       ("rust-quickcheck-macros" ,rust-quickcheck-macros-0.2))))
    (home-page "https://github.com/tbu-/hexdump")
    (synopsis "Easy hexdump to stdout or as an iterator")
    (description "Easy hexdump to stdout or as an iterator")
    (license (list license:expat license:asl2.0))))

(define-public rust-gimli-0.27
  (package
    (name "rust-gimli")
    (version "0.27.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gimli" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1d5v6jjchf4872jynjsg5ni4vankm1341bas8qindygb6g9962md"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-fallible-iterator" ,rust-fallible-iterator-0.2)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))))
    (home-page "https://github.com/gimli-rs/gimli")
    (synopsis "A library for reading and writing the DWARF debugging format.")
    (description
     "This package provides a library for reading and writing the DWARF debugging
format.")
    (license (list license:expat license:asl2.0))))

(define-public rust-enum-primitive-derive-0.2
  (package
    (name "rust-enum-primitive-derive")
    (version "0.2.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "enum-primitive-derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03ibjjx8dc4akpq8ck24qda5ix4jybz9jagfxykd0s6vxb2vjxf3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://gitlab.com/cardoe/enum-primitive-derive")
    (synopsis
     "enum_primitive implementation using procedural macros to have a custom derive")
    (description
     "enum_primitive implementation using procedural macros to have a custom derive")
    (license license:expat)))

(define-public rust-bitfield-0.14
  (package
    (name "rust-bitfield")
    (version "0.14.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bitfield" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1b26k9acwss4qvrl60lf9n83l17d4hj47n5rmpd3iigf9j9n0zid"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dzamlo/rust-bitfield")
    (synopsis "This crate provides macros to generate bitfield-like struct.")
    (description
     "This crate provides macros to generate bitfield-like struct.")
    (license (list license:expat license:asl2.0))))

(define-public rust-anyhow-1
  (package
    (name "rust-anyhow")
    (version "1.0.71")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "anyhow" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1f6rm4c9nlp0wazm80wlw45zpmb48nv24x2227zyidz0y0c0czcw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "https://github.com/dtolnay/anyhow")
    (synopsis "Flexible concrete Error type built on std::error::Error")
    (description "Flexible concrete Error type built on std::error::Error")
    (license (list license:expat license:asl2.0))))

(define-public rust-probe-rs-0.18
  (package
    (name "rust-probe-rs")
    (version "0.18.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "probe-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03s65ni4d63k00ijgg9zxfby9w65ypnnvccd88gdc82n68pn1prn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-bitfield" ,rust-bitfield-0.14)
                       ("rust-bitvec" ,rust-bitvec-1)
                       ("rust-enum-primitive-derive" ,rust-enum-primitive-derive-0.2)
                       ("rust-gimli" ,rust-gimli-0.27)
                       ("rust-hexdump" ,rust-hexdump-0.1)
                       ("rust-hidapi" ,rust-hidapi-2)
                       ("rust-ihex" ,rust-ihex-3)
                       ("rust-jaylink" ,rust-jaylink-0.3)
                       ("rust-jep106" ,rust-jep106-0.2)
                       ("rust-kmp" ,rust-kmp-0.1)
                       ("rust-libftdi1-sys" ,rust-libftdi1-sys-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-object" ,rust-object-0.30)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-probe-rs-target" ,rust-probe-rs-target-0.18)
                       ("rust-probe-rs-target" ,rust-probe-rs-target-0.18)
                       ("rust-rusb" ,rust-rusb-0.9)
                       ("rust-scroll" ,rust-scroll-0.11)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-svg" ,rust-svg-0.13)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1))
       #:cargo-development-inputs (("rust-clap" ,rust-clap-4)
                                   ("rust-itm" ,rust-itm-0.9)
                                   ("rust-pretty-env-logger" ,rust-pretty-env-logger-0.4)
                                   ("rust-rand" ,rust-rand-0.8)
                                   ("rust-serde" ,rust-serde-1)
                                   ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/probe-rs/probe-rs")
    (synopsis
     "A collection of on chip debugging tools to communicate with microchips.")
    (description
     "This package provides a collection of on chip debugging tools to communicate
with microchips.")
    (license (list license:expat license:asl2.0))))

