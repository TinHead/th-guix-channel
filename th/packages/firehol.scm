(define-module (th packages firehol)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (gnu packages base)
#:use-module (gnu packages linux)
#:use-module (gnu packages admin)
#:use-module (guix download)
#:use-module (th packages iprange)	
#:use-module (gnu packages curl)
#:use-module (guix build-system gnu)
#:use-module (guix licenses))

(define-public firehol
(package
  (name "firehol")
  (version "3.1.7")
  (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/firehol/firehol/releases/download/v3.1.7/firehol-" version
                                ".tar.gz"))
            (sha256
             (base32
              "1xd8h8bnvybiarvpcxv1f3ijvhp5h8i5aarzcdlpgxy8chpwxlag")
              )

            (patches 
             (search-patches "firehol-sysconfdir.patch"
                             "firehol-uname.patch"))))  
  (build-system gnu-build-system)
  (arguments
  `(#:configure-flags '("--localstatedir=/var")
   (#:phases
    modify-phases %standard-phases
     (add-after 'install 'wrap-program
     (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (wrap-program (string-append out "/sbin/firehol")
                 `("PATH" ":" prefix
                   ,(map (lambda (input)
                           (string-append (assoc-ref inputs input) "/bin"))
                         '("readlink"
                           "dirname"))))))))))
  (propagated-inputs 
	(list util-linux
        coreutils 
	      iproute
	      iptables
	      ipset
	      inetutils
	      module-init-tools
	      procps
	      iprange
	      curl)
  )
  (synopsis "Firehol - firewall for humans")
  (description
   "Firehol")
  (home-page "https://firehol.org/")
  (license gpl2))
)