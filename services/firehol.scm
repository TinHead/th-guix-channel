(define-module (services firehol)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (packages firehol)
  #:use-module (guix records)
  #:export (firehol-configuration))

(define-record-type* <firehol-configuration>
  firehol-confguration make-firehol-configuration
  firehol-configuration?
  (version firehol-configuration-version (default 6))
  )