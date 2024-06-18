(define-module (th packages video))
(use-modules (gnu packages)
            (guix packages)
            (guix download)
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

w-scan2
