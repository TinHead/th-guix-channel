(define-module (th services wg-exporter)
  #:use-module (gnu services)
  #:use-module (gnu packages base)
  #:use-module (gnu services shepherd)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (guix)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (th packages wireguard-go-exporter)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:export (wg-exporter-configuration
            wg-exporter-configuration?
            wg-exporter-service-type
            ))

;;;
;;; Prometheus node exporter
;;;

(define-record-type* <wg-exporter-configuration>
  wg-exporter-configuration
  make-wg-exporter-configuration
  wg-exporter-configuration?
  (package wg-exporter-configuration-package
            (default wireguard-go-exporter))
  (web-listen wg-exporter-web-listen
                      (default ":9586"))
  (web-metrics-url wg-exporter-web-metrics-url
                     (default "/metrics"))
  (interface wg-exporter-interface
                     (default "wg0"))
  (conf-file      wg-exporter-conf-file
                      (default "/etc/wireguard/wg0.conf")))


(define wg-exporter-shepherd-service
  (match-lambda
    (( $ <wg-exporter-configuration>
         package web-listen web-metrics-url interface conf-file)
     (list
      (shepherd-service
       (documentation "Prometheus wireguard exporter.")
       (provision '(wg-exporter))
       (requirement '(networking))
       (start #~(make-forkexec-constructor
                 (list #$(file-append package "/bin/wireguard_go_exporter")
                       "-p" #$web-listen
                       "-a" #$web-metrics-url
                       "-i" #$interface
                       "-c" #$conf-file
                       )
                 #:log-file "/var/log/wg-node-exporter.log"))
       (stop #~(make-kill-destructor)))))))


(define wg-exporter-service-type
  (service-type
   (name 'wg-exporter)
   (description
    "Run @command{prometheus_wireguard_exporter} to serve Wireguard metrics to
Prometheus.")
   (extensions
    (list
     (service-extension shepherd-root-service-type
                        wg-exporter-shepherd-service)))
   (default-value (wg-exporter-configuration))))
