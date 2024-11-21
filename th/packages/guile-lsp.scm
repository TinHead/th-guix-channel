(define-module (th packages guile-lsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages texinfo)
  #:use-module (guix build utils)
  #:use-module (guix utils)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 popen)
  #:use-module (srfi srfi-26)
  #:use-module (gnu packages guile-xyz))

(define %source-dir (getcwd))

(define-public guile-fibers-nopatch
  (package
    (name "guile-fibers-nopatch")
    (version "1.3.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wingo/fibers")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0wvdi4l58f9a5c9wi3cdc9l1bniscsixb6w2zj86mch7j7j814lc"))
              (patches
               (search-patches "guile-fibers-libevent-32-bit.patch"
                               "guile-fibers-libevent-timeout.patch"))))
    (build-system gnu-build-system)
    (arguments
     (list #:make-flags
           #~(list "GUILE_AUTO_COMPILE=0")
           #:phases
           (if (target-x86-64?)
               #~%standard-phases
               #~(modify-phases %standard-phases
                   (add-before 'check 'disable-some-tests
                     (lambda _
                       ;; This test can take more than an hour on some systems.
                       (substitute* "tests/basic.scm"
                         ((".*spawn-fiber loop-to-1e4.*") ""))

                       ;; These tests can take more than an hour and/or segfault.
                       (substitute* "Makefile"
                         (("tests/speedup.scm") ""))

                       (when #$(target-aarch64?)
                         ;; The tests below have issues on aarch64 systems.
                         ;; They pass on an Apple M1 but take a very long time
                         ;; on a Hetzner aarch64 VM.  Skip them.
                         (substitute* "tests/basic.scm"
                           ((".*spawn-fiber-chain 5000000.*") ""))
                         (substitute* "tests/channels.scm"
                           ((".*assert-run-fibers-terminates .*pingpong.*") "")))))
                   #$@(if (%current-target-system)
                          ; #~((add-after 'unpack 'apply-cross-build-fix-patch
                               ; (lambda _
                                 ; (let ((patch-file
                                        ; #$(local-file
                                           ; (search-patch
                                            ; "guile-fibers-cross-build-fix.patch"))))
                                   ; (invoke "patch" "--force" "-p1" "-i"
                                           ; patch-file)))))
                          #~())))))
    (native-inputs
     (list texinfo pkg-config autoconf-2.71 automake libtool
           guile-3.0            ;for 'guild compile
           ;; Gettext brings 'AC_LIB_LINKFLAGS_FROM_LIBS'
           gettext-minimal))
    (inputs
     (append (list guile-3.0)           ;for libguile-3.0.so
             (if (target-hurd?)
                 (list libevent)
                 '())))
    (synopsis "Lightweight concurrency facility for Guile")
    (description
     "Fibers is a Guile library that implements a a lightweight concurrency
facility, inspired by systems like Concurrent ML, Go, and Erlang.  A fiber is
like a \"goroutine\" from the Go language: a lightweight thread-like
abstraction.  Systems built with Fibers can scale up to millions of concurrent
fibers, tens of thousands of concurrent socket connections, and many parallel
cores.  The Fibers library also provides Concurrent ML-like channels for
communication between fibers.

Note that Fibers makes use of some Guile 2.1/2.2-specific features and
is not available for Guile 2.0.")
    (home-page "https://github.com/wingo/fibers")
    (properties '((upstream-name . "fibers")))
    (license license:lgpl3+)))
  
(define-public guile-fibers
  (package
    (inherit guile-fibers-nopatch)
    (version "1.1.2")
    (name "guile-fibers")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wingo/fibers")
                    (commit (string-append "v" version))))
              (file-name (git-file-name "guile-fibers" version))
              (sha256
               (base32
                "0ll63d7202clapg1k4bilbnlmfa4qvpjnsd7chbkka4kxf5klilc"))
              (patches
               (search-patches "guile-fibers-wait-for-io-readiness.patch"
                               "guile-fibers-epoll-instance-is-dead.patch"
                               "guile-fibers-fd-finalizer-leak.patch"))))
    (native-inputs
     (list texinfo pkg-config autoconf automake libtool
           guile-3.0            ;for 'guild compile
           ;; Gettext brings 'AC_LIB_LINKFLAGS_FROM_LIBS'
           gettext-minimal))
    (inputs
     (list guile-3.0))                            ;for libguile-3.0.so
    (supported-systems
     ;; This version requires 'epoll' and is thus limited to Linux-based
     ;; systems, which is fixed in 1.2.0:
     ;; <https://github.com/wingo/fibers/pull/53>.
     (filter (cut string-suffix? "-linux" <>) %supported-systems))))
  
(define-public guile-json-rpc
  (let ((version "0.4.5")
        (revision "a")
        (commit "70192263f3947624400803e00fa37e69b9e574a3"))
    (package
     (name "guile-json-rpc")
     (version (git-version version revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/rgherdt/scheme-json-rpc")
             (commit commit)))
       (sha256
        (base32
         "0356hm6phcfgvwvx3ys6b927v40jzb7qrfgvql7g78na24zp2cmi"))))
     (build-system gnu-build-system)
     (arguments
      (list
       #:phases
       #~(modify-phases %standard-phases
                        (add-after 'unpack 'move-to-guile-directory
                                   (lambda _
                                     (chdir "./guile"))))))

     (inputs
      (list guile-srfi-145 guile-srfi-180))
     (native-inputs
      (list autoconf
            automake
            pkg-config
            texinfo
            guile-3.0))
     (synopsis "An implementation of the JSON-RPC for Guile.")
     (description "@code{scheme-json-rpc} allows calling procedures
on remote servers by exchanging JSON objects.  It implements the
@url{jsonrpc specifications, https://www.jsonrpc.org/specification}.
The low-level API strives to be R7RS compliant, relying on some SRFI's
when needed.")
     (home-page "https://codeberg.org/rgherdt/scheme-json-rpc")
     (license license:expat))))

(define-public guile-lsp-server
    (package
     (name "guile-lsp-server")
     (version "0.4.4")
     (source 
      (origin
        (method url-fetch)
        (uri (string-append "https://codeberg.org/rgherdt/scheme-lsp-server/archive/" version ".tar.gz"))
        (sha256
           (base32
              "166r7wpfzc1az50b5767aqgnxqwrmn527marawmmgjhl4xnm4anz"))))
     (build-system gnu-build-system)
     (arguments
      (list
       #:phases
       #~(modify-phases %standard-phases
                        (add-after 'unpack 'move-to-guile-directory
                                   (lambda _
                                     (chdir "./guile"))))))

     (native-inputs
      (list autoconf
            automake
            pkg-config
            texinfo
            guile-3.0))
     (propagated-inputs
      (list guile-3.0
            guile-json-rpc
            guile-srfi-145
            guile-srfi-180
            guile-irregex))
     (synopsis "LSP (Language Server Protocol) server for Guile.")
     (description "Provides a library (lsp-server) and an executable
@code{guile-lsp-server} that can be used by LSP clients in order to
provide IDE functionality for Guile Scheme.")
     (home-page "https://codeberg.org/rgherdt/scheme-lsp-server")
     (license license:expat)))

guile-fibers
