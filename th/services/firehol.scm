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
  #~(string-append "interface " #$value "\n")
)

;(define (serialize-list-of-interfaces field value))
(define (serialize-list-of-interfaces field value)
  #~(string-append #$@(map (cut serialize-configuration <>
                                firehol-interface-fields)
                           value)))

(define (list-of-interfaces? lst)
  (every firehol-interface? lst)
  
)

(define (serialize-firehol-config config)
  (mixed-text-file
  "firehol.conf"
  #~(string-append #$(serialize-configuration config firehol-configuration-fields)))
)

(define-configuration firehol-interface
  (name
  (string "eth0")
  "Interface name"
  (serializer serialize-interface-name))
)

(define-configuration firehol-configuration
  (version
    (string "5")
    "File version"
    (serializer serialize-version))
  (interfaces
    (list-of-interfaces '())
    "List of interface definitions"
    (serializer serialize-interfaces))
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
