(define-module (th packages helix-editor)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary))

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
    (license mpl2.0)
))

helix-editor-bin
