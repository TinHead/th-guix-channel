(define-module (th packages web)
  #:use-module (ice-9 match)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix cvs-download)
  #:use-module (guix hg-download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system ant)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system perl)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system scons)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages web)
  #:use-module (gnu packages lua)
  )

(define nginx-socket-cloexec
  (package
    (inherit nginx)
    (name "nginx-socket-cloexec") ;required for lua-resty-shell
    (source
     (origin
       (inherit (package-source nginx))
       (patches (append (search-patches "nginx-socket-cloexec.patch")
                        (origin-patches (package-source nginx))))))))
(define-public nginx-lua-module-2
  (package
    (inherit nginx)
    (name "nginx-lua-module-2")
    (version "0.10.27")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openresty/lua-nginx-module")
             (commit (string-append "v" version))))
       (file-name (git-file-name "lua-nginx-module" version))
       (sha256
        (base32 "14nqsm5vqrjzs1sy4m6fp30gmwrgar94h6h8c4r5ypwm1nmb7wha"))))
    (build-system gnu-build-system)
    (inputs
     `(("nginx-sources" ,(package-source nginx-socket-cloexec))
       ("luajit" ,luajit)
       ,@(package-inputs nginx)))
    (arguments
     (substitute-keyword-arguments
         `(#:make-flags '("modules")
           #:modules ((guix build utils)
                      (guix build gnu-build-system)
                      (ice-9 popen)
                      (ice-9 regex)
                      (ice-9 textual-ports))
           ,@(package-arguments nginx)
           #:configure-flags '("--add-dynamic-module=." "--with-compat"))
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'unpack 'unpack-nginx-sources
              (lambda* (#:key inputs native-inputs #:allow-other-keys)
                (begin
                  ;; The nginx source code is part of the module’s source.
                  (format #t "decompressing nginx source code~%")
                  (let ((tar (assoc-ref inputs "tar"))
                        (nginx-srcs (assoc-ref inputs "nginx-sources")))
                    (invoke (string-append tar "/bin/tar")
                            "xvf" nginx-srcs "--strip-components=1"))
                  #t)))
            (add-before 'configure 'set-luajit-env
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((luajit (assoc-ref inputs "luajit")))
                  (setenv "LUAJIT_LIB"
                          (string-append luajit "/lib"))
                  (setenv "LUAJIT_INC"
                          (string-append luajit "/include/luajit-2.1"))
                  #t)))
            (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((modules-dir (string-append (assoc-ref outputs "out")
                                                  "/etc/nginx/modules")))
                  (install-file "objs/ngx_http_lua_module.so" modules-dir)
                  #t)))
            (delete 'fix-root-dirs)
            (delete 'install-man-page)))))
    (synopsis "NGINX module for Lua programming language support")
    (description "This NGINX module provides a scripting support with Lua
programming language.")))

nginx-lua-module
