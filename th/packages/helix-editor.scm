(define-module (th packages helix-editor)
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

(define-public zed-editor-bin
  (package
    (name "zed-editor-bin")
    (version "latest")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz"))
       (sha256
        (base32
         "14f87zbcskixsnca9x3i4x9sk3kdqkf9psllp17jgasgmmhdyqkz"))))
    
    (inputs
     (list `(,gcc "lib") glibc libbsd openssl-1.1 libxcb libxau libxdmcp zlib `(,zstd "lib") libxkbcommon alsa-lib))
    (native-inputs
     (list gzip libbsd))
;    (let hx (string-append  ("helix-" version "-x86_64-linux/hx")))
    (build-system binary-build-system)
    (arguments
      `(#:install-plan
        `(("./" "/"))
        #:patchelf-plan
        `(
          ("lib/libXdmcp.so.6" ("libbsd"))
          ("lib/libasound.so.2" ("libc"))
          ("lib/libssl.so.1.1" ("openssl"))
          ("lib/libxcb-xkb.so.1" ("libxcb"))
          
          ("lib/libxcb.so.1" ("libxau" "libxdmcp")) 
          ("lib/libxkbcommon-x11.so.0" ("libxkbcommon" "libxcb")) 

          ("libexec/zed-editor" ("alsa-lib" "libxcb" "libxkbcommon" "openssl" "zlib" "zstd" "libc" "libxau" "libxdmcp" "gcc"))
          ("bin/zed" ("gcc")) 
        )))
    (synopsis "A post-modern text editor.")
    (description "A post-modern text editor.")
    (home-page "https://helix-editor.com/")
    (license license:mpl2.0)
))


(define-public helix-editor-bin
  (package
    (name "helix-editor-bin")
    (version "24.03")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/helix-editor/helix/releases/download/"
             version
             "/helix-"
	     version
	     "-x86_64-linux.tar.xz"))
       (sha256
        (base32
         "1z4v6wwcmbhqpwj6590860m6cx2f5a6402khpix91x7dgy090lmi"))))
    
;    (let hx (string-append  ("helix-" version "-x86_64-linux/hx")))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan
    ; (define hx (string-append  ("helix-" version "-x86_64-linux/hx")))
      `(("hx" "/bin/")
	("runtime/" "/bin/runtime/"))
      #:patchelf-plan
       `(("hx" ("gcc:lib" "glibc"))
	 ("runtime/grammars/astro.so" ("gcc:lib" "glibc"))
	 ("runtime/grammars/bash.so" ("gcc:lib" "glibc"))
	("runtime/grammars/beancount.so" ("gcc:lib" "glibc"))
        ("runtime/grammars/cpp.so" ("gcc:lib" "glibc"))
	("runtime/grammars/elm.so" ("gcc:lib" "glibc"))
	("runtime/grammars/fortran.so" ("gcc:lib" "glibc"))
	("runtime/grammars/gdscript.so" ("gcc:lib" "glibc"))
	("runtime/grammars/hcl.so" ("gcc:lib" "glibc"))
	("runtime/grammars/html.so" ("gcc:lib" "glibc"))
	("runtime/grammars/just.so" ("gcc:lib" "glibc"))
	("runtime/grammars/lean.so" ("gcc:lib" "glibc"))
	("runtime/grammars/nickel.so" ("gcc:lib" "glibc"))
	("runtime/grammars/nim.so" ("gcc:lib" "glibc"))
	("runtime/grammars/ocaml.so" ("gcc:lib" "glibc"))
	("runtime/grammars/ocaml-interface.so" ("gcc:lib" "glibc"))
	("runtime/grammars/org.so" ("gcc:lib" "glibc"))
	("runtime/grammars/perl.so" ("gcc:lib" "glibc"))
	("runtime/grammars/php.so" ("gcc:lib" "glibc"))
	("runtime/grammars/python.so" ("gcc:lib" "glibc"))
	("runtime/grammars/ruby.so" ("gcc:lib" "glibc"))
	("runtime/grammars/vue.so" ("gcc:lib" "glibc"))
	("runtime/grammars/fsharp.so" ("gcc:lib" "glibc"))
	("runtime/grammars/haskell-persistent.so" ("gcc:lib" "glibc"))
  	("runtime/grammars/yaml.so" ("gcc:lib" "glibc"))
		 )))
;;     #:phases
;     #~(modify-phases %standard-phases
;         (replace 'unpack
;           (lambda* (#:key inputs #:allow-other-keys)
;             (invoke "tar" "-xvf" (assoc-ref inputs "source")))))))
    (inputs
     `(("gcc:lib" ,gcc "lib")
       ("glibc" ,glibc)))
    (native-inputs
     `(("gzip" ,gzip)))
    (synopsis "A post-modern text editor.")
    (description "A post-modern text editor.")
    (home-page "https://helix-editor.com/")
    (license license:mpl2.0)
))

zed-editor-bin
