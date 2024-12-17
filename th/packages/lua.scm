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

(define-public lua-resty-core30
  (package
    (name "lua-resty-core30")
    (version "0.1.30")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/openresty/lua-resty-core")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0lklm91hda7xx5j89bbqmn1i1van4dqgd33iiqhz3y960blwnb5s"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((luajit-major+minor ,(version-major+minor (package-version lua)))
                (package-lua-resty (lambda (input output)
                                     (mkdir-p (string-append output "/lib/lua"))
                                     (copy-recursively (string-append input "/lib/resty")
                                                       (string-append output "/lib/lua/resty"))
                                     (copy-recursively (string-append input "/lib/ngx")
                                                       (string-append output "/lib/ngx"))
                                     (symlink (string-append output "/lib/lua/resty")
                                              (string-append output "/lib/resty")))))
           (package-lua-resty (assoc-ref %build-inputs "source")
                              (assoc-ref %outputs "out")))
         #t)))
    (home-page "https://github.com/openresty/lua-resty-core")
    (synopsis "Lua API for NGINX")
    (description "This package provides a FFI-based Lua API for
@code{ngx_http_lua_module} or @code{ngx_stream_lua_module}.")
    (license license:bsd-2)))

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
              (method url-fetch)
              (uri (string-append
                    "https://github.com/mpx/lua-cjson/archive/refs/tags/"
                    version ".tar.gz"))
              ; (file-name (git-file-name name version))
              (sha256
               (base32 "1kfqfxhbhrlanazfqvrh420zcyvm4k9ib8ys32ijgpvfsnbgcjc4" ))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:make-flags
       (let* ((lua (assoc-ref %build-inputs "lua"))
              (lua-include (string-append lua "/include/lua5.3")))
         (list (string-append "CC=" ,(cc-for-target))
               (string-append "LUA_INCLUDE_DIR=" lua-include)))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
        (replace 'build
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((lua (assoc-ref inputs "lua"))
                    (lua-include (string-append lua "/include/lua5.3")))

               ;; Move into the 'lua-cjson' directory where source files exist
               ;; Compile the CJSON library into a shared object
               (invoke "gcc" "-shared" "-fPIC" "-O2"
                       (string-append "-I" lua-include)
                       "-o" "cjson.so"
                       "lua_cjson.c" "strbuf.c" "fpconv.c")
               #t)))
                      (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (lib-dir (string-append out "/lib/lua/5.3"))
                    (share-dir (string-append out "/share/lua/5.3")))

               ;; Move into the 'lua-cjson' directory
                              ;; Create the directories
               (mkdir-p lib-dir)
               (mkdir-p share-dir)

               ;; Install the compiled shared library
               (install-file "cjson.so" lib-dir)
               (invoke "ls" "-al" "lua/cjson")
               ;; Install the Lua helper script
               ; (install-file "lua/cjson.lua" share-dir)
               #t))))))
    (inputs
     `(("lua" ,lua)))
    (home-page "https://github.com/mpx/lua-cjson")
    (synopsis "Fast JSON parsing and encoding support for Lua")
    (description
     "Lua CJSON provides fast JSON parsing and encoding support for Lua,
based on the cJSON library.")
    (license license:expat)))

; lua-resty-openid
 lua-cjson
; lua-resty-http
; lua-resty-core30
