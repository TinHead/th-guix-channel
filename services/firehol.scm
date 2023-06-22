(define-module (services firehol)
  #:use-module (gnu services)
  #:use-module (gnu services shephard)
  #:use-module (packages firehol)
  #:use-module (gnu records)
  #:export (firehol-configuration))

(define-record-type* <firhol-configuration>
  firehol-confguration make-firehol-configuration
  firehol-configuration?
  (version firehol-configuration-version (default 6))
  )