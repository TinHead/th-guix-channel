(define-module (packages upsd)
 #:use-module (guix packages)
 #:use-module (gnu packages avahi)
 #:use-module (gnu packages freeipmi)
 #:use-module (gnu packages gd)
 #:use-module (gnu packages networking)
 #:use-module (gnu packages check)
 #:use-module (gnu packages libusb)
 #:use-module (gnu packages pkg-config)
 #:use-module (gnu packages tls)
 #:use-module (gnu packages version-control)
 #:use-module (gnu packages xorg)
 #:use-module (gnu packages autotools)
 #:use-module (guix download)
 #:use-module (guix utils)
 #:use-module (guix build-system gnu)
 #:use-module (guix licenses))
            
(define-public upsd
  (package
    (name "upsd")
    (version "2.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://networkupstools.org/source/" (version-major+minor version)
             "/nut-" version ".tar.gz"))
       (sha256
        (base32
         "1rdzjbvm6qyz9kz1jmdq0fszq0500q97plsknrq7qyvrv84agrf3"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       `("--with-usb=yes"
         "--with-openssl"
         ;; nut supports a bridge to the powerman-daemon to handle
         ;; powerman-supported devices.  For this bridge, powerman is
         ;; required.
         "--without-powerman"
         ,(string-append "--with-udev-dir="
                         (assoc-ref %outputs "out")
                         "/lib/udev"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-libgd-check
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "configure"
               (("-L/usr/X11R6/lib")
                ;; without --static, it won't find zlib and libjpeg
                "$(pkg-config --static --libs gdlib)"))
             #t))
         (add-before 'build 'fix-search-paths
           (lambda* (#:key inputs outputs #:allow-other-keys)
             ;; nutscan will search libraries only under output/lib, and in
             ;; some standard path (e.g., /usr/lib).  Add correct paths here
             (substitute* "tools/nut-scanner/nutscan-init.c"
               (("LIBDIR,")
                (string-append
                 "LIBDIR,\n"
                 (string-join
                  (map (lambda (label)
                         (string-append "\"" (assoc-ref inputs label) "/lib/\""))
                       '("avahi" "freeipmi" "libusb" "neon" "net-snmp"))
                  ",\n")
                 ",\n")))
             #t)))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("cppunit" ,cppunit)
       ("pkg-config" ,pkg-config)
       ("openssl" ,openssl-1.1)))
    (inputs
     `(("avahi" ,avahi)
       ("libusb" ,libusb-compat)
       ("libltdl" ,libltdl)
       ;; libxpm and libx11 required when cgi is enabled
       ("libxpm" ,libxpm)
       ("libx11" ,libx11)
       ("freeipmi" ,freeipmi)
       ("gd" ,gd)
       ("neon" ,neon)
       ("openssl" ,openssl); -1.1)
       ("net-snmp" ,net-snmp)))
    (home-page "https://networkupstools.org")
    (license
     (list
      ;; - most files under gpl2+
      gpl2+
      ;; - scripts/python/ under gpl3+
      gpl3+
      ;; - scripts/perl/Nut.pm same as perl (either gpl1+ or artistic)
      gpl1+ 
      artistic2.0))
    (synopsis "Collection of programs for monitoring and administering UPS")
    (description "Network @acronym{UPS, Uninterruptible Power Supply} Tools is
a collection of programs which provide a common interface for monitoring and
administering @acronym{UPS} @acronym{PDU,Power Distribution Unit} and
@acronym{SCD, Solar Controller Device} hardware.  It uses a layered approach
to connect all of the parts.  Drivers are provided for a wide assortment of
+equipment.")))