(use-modules (guix packages)
	     (gnu packages linux)
	     (gnu packages admin)
             (guix download)
	     (th-guix-channel iprange)	
	     (wg-peers\test_peer)
	     (gnu packages curl)
             (guix build-system gnu)
             (guix licenses))

(package
  (name "firehol")
  (version "3.1.7")
  (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/firehol/firehol/releases/download/v3.1.7/firehol-" version
                                ".tar.gz"))
            (sha256
             (base32
              "1xd8h8bnvybiarvpcxv1f3ijvhp5h8i5aarzcdlpgxy8chpwxlag"))))
  (build-system gnu-build-system)
  (inputs 
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
