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
  (src firehol-interface-src)
)

(define-record-type* <firehol-configuration>
  firehol-configuration make-firehol-configuration
  firehol-configuration?
  (version firehol-configuration-version (default 6))
  (interfaces firehol-configuration-interfaces (default '()))
  (conffile firehole-configuration-file (default configuration-file))
  )
  
(define* (firehol-configuration-file config)
  "Return a firehol configuration"
  (define (src->config src)
    (let ((ip (firehol-src-ip))
          (deny (firehol-src-deny)))
        (format #f "src ~a \n"
          (if deny
            (format #f "!~a" ip)
            ip))))
  (define (interface->config interface)
    (let ((name (firehol-interface-name interface))
          (myname (firehol-interface-myname interface))
          (src (firehol-interface-src interface)))
        (format #f "interface ~a ~a ~a "
          name
          myname
          (if src
            (format #f "~a" src)
            "" )
          )))
  (match-record config <firehol-configuration>
    (interfaces src)
    (let* (interfaces (map interface->config interfaces))
          (src (map src->config src))
          (config-file "firehol.conf")
          (config
            (computed-file
              "firehol-confg"
              #~(begin
              (mkdir #$output)
              (chdir #$output)
              (call-with-output-file #$config-file
              (lambda (port)
                     (let ((format (@ (ice-9 format) format)))
                       (format port 
                        (list #$interfaces))))))))))
 ;(plain-file "firehol.conf"
 ; (string-append
 ;   "version" firehol-configuration-version "\n"
 ;   (string-join (firehol-configuration-interfaces config))    
  )


(define (firehol-shepherd-service config)
 (match-record config <firehol-configuration>
    (version interfaces conffile)
  (list (shepherd-service
    (documentation "Runf firehol")
    (provision '(firehol))
    (requirement '(networking))
    (start #~(make-forkexec-constructor 
              (list #$(file-append firehol "/sbin/firehol") #$(configuration-file config) "start")))
    (stop  #~(make-kill-destructor))
    ; (actions (list (shepherd-configuration-action config)))))))
    ))))
    
(define firehol-service-type
  (service-type
    (name "firehol")
    (description "Firehol")
    (extensions
      (list
        (service-extension shepherd-root-service-type firehol-shepherd-service)))))
    ;(default-value (firehol-configuration))))
