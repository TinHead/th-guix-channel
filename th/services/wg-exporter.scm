(define-module (th services wg-exporter)
  #:use-module (gnu services)
  #:use-module (gnu packages base)
  #:use-module (gnu services shepherd)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (guix)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (th packages prometheus-exporters)
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
            (default rust-prometheus-wireguard-exporter-3))
  (web-listen-address wg-exporter-web-listen-address
                      (default "0.0.0.0"))
  (web-listen-port wg-exporter-web-listen-port
                      (default "9586"))
  (extra-options      wg-exporter-extra-options
                      (default '())))


(define wg-exporter-shepherd-service
  (match-lambda
    (( $ <wg-exporter-configuration>
         package web-listen-address web-listen-port extra-options)
     (list
      (shepherd-service
       (documentation "Prometheus wireguard exporter.")
       (provision '(wg-exporter))
       (requirement '(networking))
       (start #~(make-forkexec-constructor
                 (list #$(file-append package "/bin/prometheus_wireguard_exporter")
                       "-l" #$web-listen-address
                       "-p" #$web-listen-port
                       #$@extra-options)
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
