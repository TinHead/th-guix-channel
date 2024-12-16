(define-module (th packages lua)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages lua)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages))



(define-public lua-resty-openid
  (package
    (name "lua-resty-openid")
    (version "1.8.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zmartzone/lua-resty-openidc")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "16w08phvd8kmci8frxk8dsqhf5q3l0xv745fdgsm45ycwrchsa9d"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((luajit-major+minor ,(version-major+minor (package-version lua)))
                (package-lua-resty (lambda (input output)
                                     (mkdir-p (string-append output "/lib/lua/" luajit-major+minor))
                                     (copy-recursively (string-append input "/lib/resty")
                                                       (string-append output "/lib/lua/" luajit-major+minor  "/resty"))
                                     (symlink (string-append output "/lib/lua/" luajit-major+minor "/resty")
                                              (string-append output "/lib/resty")))))
           (package-lua-resty (assoc-ref %build-inputs "source")
                              (assoc-ref %outputs "out")))
         #t)))
    (home-page "https://github.com/openresty/lua-resty-lrucache")
    (synopsis "Lua LRU cache based on the LuaJIT FFI")
    (description
     "This package provides Lua LRU cache based on the LuaJIT FFI.")
    (license license:bsd-2)))


(define-public lua-resty-http
  (package
    (name "lua-resty-http")
    (version "0.17.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ledgetech/lua-resty-http")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0xllxaph4r5sk2xc6cpji9i537vr2cgc7n7q7qpq6a8q6jkwy79y"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((luajit-major+minor ,(version-major+minor (package-version lua)))
                (package-lua-resty (lambda (input output)
                                     (mkdir-p (string-append output "/lib/lua/" luajit-major+minor))
                                     (copy-recursively (string-append input "/lib/resty")
                                                       (string-append output "/lib/lua/" luajit-major+minor  "/resty"))
                                     (symlink (string-append output "/lib/lua/" luajit-major+minor "/resty")
                                              (string-append output "/lib/resty")))))
           (package-lua-resty (assoc-ref %build-inputs "source")
                              (assoc-ref %outputs "out")))
         #t)))
    (home-page "https://github.com/openresty/lua-resty-lrucache")
    (synopsis "Lua LRU cache based on the LuaJIT FFI")
    (description
     "This package provides Lua LRU cache based on the LuaJIT FFI.")
    (license license:bsd-2)))


(define-public lua-cjson
  (package
    (name "lua-cjson")
    (version "2.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mpx/lua-cjson")
                    (commit (string-append "" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1i0k5l0cwysgy77azr2y51fn0zz9v5pj6j9gb1w8k5qhw99im291"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((luajit-major+minor ,(version-major+minor (package-version lua)))
                (package-lua-resty (lambda (input output)
                                     (mkdir-p (string-append output "/lib/lua/" luajit-major+minor))
                                     (copy-recursively (string-append input "/lua")
                                                       (string-append output "/lib/lua/" luajit-major+minor ))
                                     (symlink (string-append output "/lib/lua/" luajit-major+minor )
                                              (string-append output "/lib/resty")))))
           (package-lua-resty (assoc-ref %build-inputs "source")
                              (assoc-ref %outputs "out")))
         #t)))
    (home-page "https://github.com/openresty/lua-resty-lrucache")
    (synopsis "Lua LRU cache based on the LuaJIT FFI")
    (description
     "This package provides Lua LRU cache based on the LuaJIT FFI.")
    (license license:bsd-2)))

; lua-resty-openid
; lua-cjson
lua-resty-http
