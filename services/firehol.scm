(define-module (services firehol)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (packages firehol)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:export (firehol-configuration
            firehol-configuration?
            firehol-interface
            firehol-service-type
            ))


(define-record-type* <firehol-src>
  firehol-src make-firehol-src 
  firehol-src?
  (ip firehol-src-ip (default "10.0.0.1"))
  (deny firehol-src-deny (default #f))
)

(define-record-type* <firehol-interface>
  firehol-interface make-firehol-interface
  firehol-interface?
  (name firehol-interface-name (default "eth0"))
  (myname firehol-interface-myname (default "wan"))
  (src <firehol-src>)
)

(define-record-type* <firehol-configuration>
  firehol-configuration make-firehol-configuration
  firehol-configuration?
  (version firehol-configuration-version (default 6))
  (interfaces firehol-configuration-interfaces (list-of <firehol-interface>))
  )
  
(define* (configuration-file config)
"Return a firehol configuration"
 (plain-file "firehol.conf"
  (string-append
    "version" firehol-configuration-version "\n"
    (string-join (firehol-configuration-interfaces config))    
  )))


(define (firehol-shepherd-service config)
  "Return as service"
  (shepherd-service
    (documentation "Runf firehol")
    (provision '(firehol))
    (requirement '(networking))
    (start #~(make-forkexec-constructor 
              (list "firehol" "--start" "--debug" "/etc/firehol/firehol.conf")))
    (stop  #~(make-kill-destructor))
    (actions (list (shepherd-configuration-action config)))))))
    ))))
(define firehol-service-type
  (service-type
    (name "firehol")
    (description "Firehol")
    (extensions
      (list
        (service-extension shepherd-root-service-type firehol-shepherd-service)))
    (default-value (firehol-configuration))))
