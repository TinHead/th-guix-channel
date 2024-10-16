(define-module (th packages zola)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages tls)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages libbsd)
  ; #:use-module (guix licenses) #:prefix license: 
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

(use-modules ((guix licenses) #:prefix license:) 
              (gnu packages xorg)
              (gnu packages linux)
              (gnu packages xdisorg))

(define-public zola-bin
  (package
    (name "zola-bin")
    (version "0.19.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/getzola/zola/releases/download/v" version "/zola-v" version "-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32
         "176daxl3z9zsjjzn1404p5q7dkldrk48dgaf4v5xsa66hsdyd607"))))
    
    (inputs
     (list `(,gcc "lib") glibc libbsd openssl-1.1 libxcb libxau libxdmcp zlib `(,zstd "lib") libxkbcommon alsa-lib))
;     (native-inputs
;      (list gzip libbsd))
; ;    (let hx (string-append  ("helix-" version "-x86_64-linux/hx")))
    (build-system binary-build-system)
    (arguments
      `(#:install-plan
        `(("zola" "bin/"))
        #:patchelf-plan
        `(
          ("zola" ("gcc" "glibc")) 
        )))
    (synopsis "Zola blog generator.")
    (description "A fast static site generator in a single binary with everything built-in..")
    (home-page "https://www.getzola.org")
    (license #f)
))

zola-bin
