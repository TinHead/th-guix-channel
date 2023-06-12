(define-module (packages firehol)
#:use-module (gnu packages)
#:use-module (guix packages)
#:use-module (gnu packages linux)
#:use-module (gnu packages admin)
#:use-module (guix download)
#:use-module (packages iprange)	
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

            (patches (search-patches "firehol-sysconfdir.patch"))))  
  (build-system gnu-build-system)
  (arguments
  `(#:configure-flags '("--localstatedir=/var")))
  (propagated-inputs 
	(list util-linux 
	      iproute
	      iptables
	      ipset
	      inetutils
	      module-init-tools
	      procps
	      iprange
	      curl)
  )
  (synopsis "Firhol - firewall for humans")
  (description
   "Firehol")
  (home-page "https://firehol.org/")
  (license gpl2))
)