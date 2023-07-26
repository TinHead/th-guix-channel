(define-module (th services firehol)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (th packages firehol)
  #:use-module (guix records)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:export (firehol-configuration
            firehol-configuration?
            firehol-interface
            firehol-service-type
            serialize-firehol-config
            ))


(define (uglify-field-name field-name)
  (let ((str (symbol->string field-name)))
    ;; field? -> is-field
    (if (string-suffix? "?" str)
        (string-append "is-" (string-drop-right str 1))
        str)))

(define (serialize-version field value)
  #~(string-append #$(uglify-field-name field) " " #$value "\n"))

(define (serialize-interface-name field value)
  #~(string-append "interface " #$value )
)

(define (serialize-interface-custom-name field value)
  #~(string-append " " #$value)
)

;(define (serialize-list-of-interfaces field value))
(define (serialize-list-of-interfaces field value)
  #~(string-append #$@(map (cut serialize-configuration <>
                                firehol-interface-fields)
                           value)))
(define (serialize-firehol-config config)
  (mixed-text-file
  "firehol.conf"
  #~(string-append #$(serialize-configuration config firehol-configuration-fields)))
)

(define (ip-add? obj)
   (string? obj)
)

(define (ip-deny? obj)
   (boolean? obj)
)

(define-maybe ip-add)
(define-maybe ip-deny)

(define (serialize-ip-add field value)
  #~(if (equal? #$(uglify-field-name field) "ip")
          (string-append " " #$value "\n")))

(define (serialize-ip-deny field value)
   (if (maybe-value-set? value)
           (string-append " not")))


; (define-maybe/no-serialization firehol-interface-src)

; (define-configuration firehol-interface-src
;   (ip
;     (maybe-string "192.168.1.0/24")
;     "Source IP address(es)":
;     (serializer serialize-ip))
;   (deny
;     (maybe-boolean #f)
;     "Deny source ip(s) if true"
;     (serializer serialize-ip)
;     )
; )

(define myconf (firehol-configuration (version "6")(interfaces 
(list(firehol-interface (name "rth0")(custom-name "dssd")(ip "1234"))(firehol-interface(name "eth2")(custom-name "int")(deny #t)(ip "1234"))))))


(define-configuration firehol-interface
  (name
    (string "eth0")
    "Interface device name"
    (serializer serialize-interface-name))
  (custom-name
    (string "lan")
    "Interface friendly name"
    (serializer serialize-interface-custom-name))
  (deny
    maybe-ip-deny
    "Deny source ip(s) if true"
    )
  (ip
    maybe-ip-add
    "Source IP address(es)"
    )
    
  ; (src
    ; (maybe-firehol-interface-src)
    ; "If specified set a source IP to allow or deny from"
    ; (serializer no-serialization))
    ; )
)

(define (list-of-interfaces? lst)
  (every firehol-interface? lst) 
)

(define-configuration firehol-configuration
  (version
    (string "5")
    "File version"
    (serializer serialize-version))
  (interfaces
    (list-of-interfaces '())
    "List of interface definitions"
    (serializer serialize-list-of-interfaces))
)


(define (firehol-shepherd-service config)
 (match-record config <firehol-configuration>
    (version)
    ; (let* ((config-file (firehol-configuration-file config))))
  (list (shepherd-service
    (documentation "Run firehol")
    (provision '(firehol))
    (requirement '(networking))
    (start #~(make-forkexec-constructor 
              (list #$(file-append firehol "/sbin/firehol") #$(serialize-firehol-config config) "start")))
    (stop  #~(make-kill-destructor))
    ; (actions (list (shepherd-configuration-action config)))))))
    ))))
    
(define firehol-service-type
  (service-type
    (name "firehol")
    (description "Firehol")
    (extensions
      (list
        (service-extension shepherd-root-service-type firehol-shepherd-service)))
    (default-value (firehol-configuration))))
