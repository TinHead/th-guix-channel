(define-module (th packages bemenu)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system meson)
  
  #:use-module (guix download))

(define-public pinentry-bemenu
(package
  (name "pinentry-bemenu")
  (version "0.12.0")
  (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/t-8ch/pinentry-bemenu/archive/refs/tags/v" version
                                ".tar.gz"))
            (sha256
             (base32
              "111x975dbnhpcy8f2ny41ag77wamsg5h3ddnj2c65cgi5azp577m"))))
  (native-inputs
     (list pkg-config))
  (inputs
     (list bemenu libassuan libgpg-error popt))
  (build-system meson-build-system)
  (synopsis "Firhol - iprange tool")
  (description
   "Iprange")
  (home-page "https://firehol.org/")
  (license gpl3)))

