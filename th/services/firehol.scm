(define-module (th services firehol)
  #:use-module (gnu services)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu services shepherd)
  #:use-module (th packages firehol)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:export (firehol-configuration
            firehol-configuration?
            firehol-interface
            firehol-router
            firehol-service-type
            serialize-firehol-config
            ))


;;; Firehol service definition

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

(define (serialize-router-name field value)
  #~(string-append "router " #$value )
)

(define (serialize-router-inface field value)
  #~(string-append " inface " #$value )
)

(define (serialize-router-outface field value)
  #~(string-append " outface " #$value )
)

(define (serialize-interface-custom-name field value)
  #~(string-append " " #$value)
)

(define (serialize-list-of-interfaces field value)
  #~(string-append #$@(map (cut serialize-configuration <>
                                firehol-interface-fields)
                           value)))
(define (serialize-list-of-routers field value)
  #~(string-append #$@(map (cut serialize-configuration <>
                                firehol-router-fields)
                           value)))
                          
(define (serialize-extra-opts field value)
   #~(string-append " " #$value "\n")
)

(define (serialize-firehol-config config)
  (mixed-text-file
  "firehol.conf"
  #~(string-append #$(serialize-configuration config firehol-configuration-fields)))
)

(define (serialize-policy field value)
   (string-append "    policy " value "\n"))

(define (list-of-string? lst)
  (every string? lst)
)

(define (serialize-list-of-string field lst)
  (string-append "    " (string-join lst "\n") "\n")
)

(define-configuration firehol-interface
  (name
    (string "eth0")
    "Interface device name"
    (serializer serialize-interface-name))
  (custom-name
    (string "lan")
    "Interface friendly name"
    (serializer serialize-interface-custom-name))
  (extra-opts
    (string "")
    "Extra options as a string to add to this intreface - ie src ip dst ip"
    (serializer serialize-extra-opts))
  (policy
    (string "drop")
    "Policy for this interface defaults to drop everything"
    (serializer serialize-policy))
  (rules
    (list-of-string '("client all deny"))
    "List of rules to apply on interface"
    (serializer serialize-list-of-string))
)

(define-configuration firehol-router
 (name
  (string "lan")
  "Router name"
  (serializer serialize-router-name))
 (inface
  (string "eth0")
  "Input interface"
  (serializer serialize-router-inface))
 (outface
  (string "eth1")
  "Output interface"
  (serializer serialize-router-outface))
 (extra-opts
  (string "")
  "Extra options - ie src dst etc"
  (serializer serialize-extra-opts))
 (rules
  (list-of-string '("client all deny"))
  "Rules to apply on this router"
  (serializer serialize-list-of-string)) 
)

(define (list-of-routers? lst)
  (every firehol-router? lst)
)

(define (list-of-interfaces? lst)
  (every firehol-interface? lst) 
)

(define-configuration firehol-configuration
  (version
    (string "6")
    "File version"
    (serializer serialize-version))
  (interfaces
    (list-of-interfaces '())
    "List of interface definitions"
    (serializer serialize-list-of-interfaces))
  (routers
    (list-of-routers  '())
    "List of router definitions"
    (serializer serialize-list-of-routers))
)


(define (firehol-shepherd-service config)
 (match-record config <firehol-configuration>
    (version)
    ; (let* ((config-file (firehol-configuration-file config))))
  (list (shepherd-service
    (documentation "Run firehol")
    (provision '(firehol))
    (requirement '(networking))
    (one-shot? #t)
    (start #~(make-forkexec-constructor 
              (list #$(file-append firehol "/sbin/firehol") #$(serialize-firehol-config config) "start")
              #:environment-variables 
                (list 
                "FIREHOL_LOAD_KERNEL_MODULES=0"
                (string-append "PATH=$PATH:" 
                  #$(file-append coreutils "/bin/")
                  ":"
                  #$(file-append gzip "/bin")))))
    (stop  #~(system* (string-append #$firehol "/sbin/firehol") "stop"))
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
