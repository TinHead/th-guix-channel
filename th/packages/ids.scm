(define-module (th packages ids))
(use-modules (gnu packages)
             (gnu packages autotools)
             (gnu packages admin)
             (gnu packages version-control)
             (gnu packages gettext)
             (gnu packages pkg-config)
             (gnu packages python)
             (gnu packages serialization)
             (gnu packages curl)
             (gnu packages web)
             (gnu packages compression)
             (gnu packages libunwind)
             (gnu packages rust)
             (gnu packages rust-apps)
             (gnu packages debian)
             (gnu packages libevent)
             (gnu packages databases)
             (gnu packages check)
             (gnu packages mpi)
             (gnu packages lua)
             (gnu packages flex)
             (gnu packages tls)
             (nonguix build-system chromium-binary)
            (guix packages)
            (guix download)
            (guix git-download)
            (guix build-system gnu)
            (guix build-system cmake)
            (gnu packages pcre)
            ((guix licenses) #:prefix license:))

; (define-public suricata
;   (package
;     (name "suricata")
;     (version "7.0.6")
;     (source
;      (origin
;        (method url-fetch)
;        (uri (string-append "https://launchpadlibrarian.net/736978366/suricata_" version "-0ubuntu2_amd64.deb"))
;        (sha256
;         (base32 "166g4gcpp0j30gifhd5z988dk1dw594rkrj1fciw8hb97i7gq5w7"))))
;     (build-system chromium-binary-build-system)
;     (arguments
;      `(#:patchelf-plan
;        `(("usr/bin/suricata" ("lz4"
;                               "libevent"
;                               "hiredis")))
;        #:phases
;        (modify-phases %standard-phases
;                       (replace 'binary-unpack
;                                (lambda* (#:key inputs #:allow-other-keys)
;                                         (let ((source (assoc-ref inputs "source")))
;                                           (invoke "ls" "-al")
;                                           (invoke "dpkg-deb" "-R" "suricata_7.0.6-0ubuntu2_amd64.deb" ".")
;                                           (delete-file-recursively "DEBIAN")
;                                           (delete-file "suricata_7.0.6-0ubuntu2_amd64.deb")
;                                           (delete-file "environment-variables")
;                                           )))
;                       (delete 'install-wrapper))))
;     (inputs (list dpkg libevent hiredis zstd pkg-config pcre2 python libyaml curl jansson libpcap libcap-ng lz4 rust rust-cargo libunwind zlib))
;     (synopsis "Suricata is a network Intrusion Detection System, Intrusion Prevention System and Network Security Monitoring engine ")
;     (description
;      "Suricata is a network IDS, IPS and NSM engine developed by the OISF and the Suricata community.")
;     (home-page "https://suricata.io/")

; ))

(define-public libdaq
  (package
    (name "libdaq")
    (version "3.0.16")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/snort3/libdaq/archive/refs/tags/v" version ".tar.gz"))
       (sha256
        (base32 "10izyjj1ifv28j585cflvd10k0cknjqy1cryfp131hm6m32l3ii0"))))
    (build-system gnu-build-system)
    (arguments
      `(#:tests? #f))
    ;  `(#:patchelf-plan
    ;    `(("usr/bin/suricata" ("lz4"
    ;                           "libevent"
    ;                           "hiredis")))
    ;    #:phases
    ;    (modify-phases %standard-phases
    ;                   (replace 'binary-unpack
    ;                            (lambda* (#:key inputs #:allow-other-keys)
    ;                                     (let ((source (assoc-ref inputs "source")))
    ;                                       (invoke "ls" "-al")
    ;                                       (invoke "dpkg-deb" "-R" "suricata_7.0.6-0ubuntu2_amd64.deb" ".")
    ;                                       (delete-file-recursively "DEBIAN")
    ;                                       (delete-file "suricata_7.0.6-0ubuntu2_amd64.deb")
    ;                                       (delete-file "environment-variables")
    ;                                       )))
    ;                   (delete 'install-wrapper))))
    (inputs (list pkg-config autoconf automake libtool libpcap cmocka))
    (synopsis "LibDAQ: The Data AcQuisition Library")
    (description
     "LibDAQ is a pluggable abstraction layer for interacting with a data source (traditionally a network interface or network data plane). Applications using LibDAQ use the library API defined in daq.h to load, configure, and interact with pluggable DAQ modules.")
    (home-page "https://github.com/snort3/libdaq")
    (license license:gpl2)))

(define-public libdnet
  (package
    (name "libdnet")
    (version "1.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-" version ".tar.gz"))
       (sha256
        (base32 "1jc3ylcc6indrk6is7qn48cp6lhk8v4vlvmcvaqqafyqqxsj5a54"))))
    (build-system gnu-build-system)
    (arguments
      `(#:tests? #f))
    ;  `(#:patchelf-plan
    ;    `(("usr/bin/suricata" ("lz4"
    ;                           "libevent"
    ;                           "hiredis")))
    ;    #:phases
    ;    (modify-phases %standard-phases
    ;                   (replace 'binary-unpack
    ;                            (lambda* (#:key inputs #:allow-other-keys)
    ;                                     (let ((source (assoc-ref inputs "source")))
    ;                                       (invoke "ls" "-al")
    ;                                       (invoke "dpkg-deb" "-R" "suricata_7.0.6-0ubuntu2_amd64.deb" ".")
    ;                                       (delete-file-recursively "DEBIAN")
    ;                                       (delete-file "suricata_7.0.6-0ubuntu2_amd64.deb")
    ;                                       (delete-file "environment-variables")
    ;                                       )))
    ;                   (delete 'install-wrapper))))
    (inputs (list pkg-config autoconf automake libtool libpcap check))
    (synopsis "libdnet provides a simplified, portable interface to several low-level networking routines.")
    (description
     "libdnet provides a simplified, portable interface to several low-level networking routines, including network address manipulation, kernel arp(4) cache and route(4) table lookup and manipulation, network firewalling, network interface lookup and manipulation, IP tunnelling, and raw IP packet and Ethernet frame transmission.")
    (home-page "https://github.com/ofalk/libdnet")
    (license #f)))

(define-public snort
  (package
    (name "snort")
    (version "3.3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/snort3/snort3/archive/refs/tags/" version ".tar.gz"))
       (sha256
        (base32 "0zgq9nqj31gkw2c6h35n8y3pz47sbgmpg7hs1lk841b50i282dsd"))))
    (build-system cmake-build-system)
    (arguments
      `(#:tests? #f))
    ; (arguments
    ;  `(#:patchelf-plan
    ;    `(("usr/bin/suricata" ("lz4"
    ;                           "libevent"
    ;                           "hiredis")))
    ;    #:phases
    ;    (modify-phases %standard-phases
    ;                   (replace 'binary-unpack
    ;                            (lambda* (#:key inputs #:allow-other-keys)
    ;                                     (let ((source (assoc-ref inputs "source")))
    ;                                       (invoke "ls" "-al")
    ;                                       (invoke "dpkg-deb" "-R" "suricata_7.0.6-0ubuntu2_amd64.deb" ".")
    ;                                       (delete-file-recursively "DEBIAN")
    ;                                       (delete-file "suricata_7.0.6-0ubuntu2_amd64.deb")
    ;                                       (delete-file "environment-variables")
    ;                                       )))
    ;                   (delete 'install-wrapper))))
    (inputs (list pkg-config hwloc openssl luajit pcre2 pcre libpcap zlib libdaq libdnet flex `(,hwloc "lib")))
    (synopsis "Suricata is a network Intrusion Detection System, Intrusion Prevention System and Network Security Monitoring engine ")
    (description
     "Suricata is a network IDS, IPS and NSM engine developed by the OISF and the Suricata community.")
    (home-page "https://suricata.io/")
    (license license:gpl2+)))

snort
