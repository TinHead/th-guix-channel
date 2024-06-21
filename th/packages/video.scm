(define-module (th packages video))
(use-modules (gnu packages)
             (gnu packages autotools)(gnu packages version-control)
             (gnu packages gettext)
            (guix packages)
            (guix download)
            (guix git-download)
            (guix build-system gnu)
            (guix licenses))

(define-public w-scan2
  (package
    (name "w-scan2")
    (version "1.0.15")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/stefantalpalaru/w_scan2/archive/refs/tags/"
                           version ".tar.gz"))
       (sha256
        (base32 "1k08lbhg57iq9p6mq938czaa1lh6ypkn7jaclcg1kb10pl8qzh8b"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags '("CFLAGS=-O2 -g -fcommon")))
    (synopsis "Scan ATSC/DVB-C/DVB-S/DVB-T channels")
    (description
     "This is a fork of w_scan command line utility used to perform frequency scans for
DVB and ATSC transmissions without initial tuning data.  It can print the
result in several formats:
@itemize
@item VDR channels.conf,
@item czap/tzap/xine/mplayer channels.conf,
@item Gstreamer dvbsrc plugin,
@item VLC xspf playlist,
@item XML,
@item initial tuning data for scan or dvbv5-scan.
@end itemize\n")
    (home-page "https://github.com/stefantalpalaru/w_scan2")
    (license gpl2+)))

(define-public mumudvb
  (package
    (name "mumudvb")
    (version "2.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
          (url "https://github.com/braice/MuMuDVB.git")
          (commit "1bf93e55ba484f93c5b81c5c549ea23d17fbc8c9")))
       (sha256
        (base32 "1vz6gg1q4agr3ljs0wywrkjr7g2q1sl0kjbx8sa42bi348x0zlmx"))))
    (build-system gnu-build-system)
      (native-inputs
   `(("gettext" ,gettext-minimal)))
    (inputs (list autoconf automake git-minimal))
    (arguments
     `(#:configure-flags '("CFLAGS=-O2 -g -fcommon")))
    (synopsis "A DVB IPTV streaming software")
    (description "MuMuDVB (Multi Multicast DVB) is a program that redistributes streams from DVB or ATSC (Digital Television) on a network (also called IPTV) using multicasting or HTTP unicast.It supports satellite, terrestrial and cable TV, in clear or scrambled channels and run on PC as well as several embedded platforms. It is intended to multicast (the stream is sent once and the network equipments split the data for the different clients) a whole DVB transponder (set of channels sent on the same carrier frequency) by assigning each channel a different multicast group. It detects the different services present as well as their important parameters for streaming, rewrite the main DVB tables to show clients only the right stream in each group.")
    (home-page "https://github.com/stefantalpalaru/w_scan2")
    (license gpl2+)))

mumudvb
