(define-module (th services dnsmasq)
  #:use-module (gnu services)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu services shepherd)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:export (dnsmasq-configuration
            dnsmasq-configuration?
            dnsmasq-service-type
            serialize-dnsmasq-config
            ))


(define (uglify-field-name field-name)
  (let ((str (symbol->string field-name)))
    ;; field? -> is-field
    (if (string-suffix? "?" str)
        (string-append "is-" (string-drop-right str 1))
        str)))

; (define (serialize-version field value)
  ; #~(string-append #$(uglify-field-name field) " " #$value "\n"))

; (define (serialize-interface-name field value)
;   #~(string-append "interface4 " #$value )
; )

; (define (serialize-router-name field value)
;   #~(string-append "router4 " #$value )
; )

; (define (serialize-router-inface field value)
;   #~(string-append " inface " #$value )
; )

; (define (serialize-router-outface field value)
;   #~(string-append " outface " #$value )
; )

(define (serialize-interface-name field value)
   #~(string-append "interface=" #$value "\n")
)

(define (serialize-list-of-interfaces field value)
   #~(string-append #$@(map (cut serialize-configuration <>
                                 dnsmasq-interface-fields)
                            value)))
; (define (serialize-list-of-routers field value)
;   #~(string-append #$@(map (cut serialize-configuration <>
;                                 firehol-router-fields)
;                            value)))
                          
; (define (serialize-extra-opts field value)
;    #~(string-append " " #$value "\n")
; )

(define (serialize-dnsmasq-config config)
  (mixed-text-file
  "dnsmasq.conf"
  #~(string-append #$(serialize-configuration config dnsmasq-configuration-fields)))
)

; (define (serialize-policy field value)
;    (string-append "    policy " value "\n"))

(define (list-of-string? lst)
  (every string? lst)
)

(define (serialize-list-of-string field lst)
  (string-append (string-join lst "\n") "\n")
)

(define-configuration dnsmasq-interface
  (name
    (string "eth0")
    "Interface device name to listen for dhcp on"
    (serializer serialize-interface-name))
  ; (custom-name
  ;   (string "lan")
  ;   "Interface friendly name"
  ;   (serializer serialize-interface-custom-name))
  ; (extra-opts
  ;   (string "")
  ;   "Extra options as a string to add to this intreface - ie src ip dst ip"
  ;   (serializer serialize-extra-opts))
  ; (policy
  ;   (string "drop")
  ;   "Policy for this interface defaults to drop everything"
  ;   (serializer serialize-policy))
  ; (rules
  ;   (list-of-string '("client all deny"))
  ;   "List of rules to apply on interface"
  ;   (serializer serialize-list-of-string))
)

; (define-configuration firehol-router
;  (name
;   (string "lan")
;   "Router name"
;   (serializer serialize-router-name))
;  (inface
;   (string "eth0")
;   "Input interface"
;   (serializer serialize-router-inface))
;  (outface
;   (string "eth1")
;   "Output interface"
;   (serializer serialize-router-outface))
;  (extra-opts
;   (string "")
;   "Extra options - ie src dst etc"
;   (serializer serialize-extra-opts))
;  (rules
;   (list-of-string '("client all deny"))
;   "Rules to apply on this router"
;   (serializer serialize-list-of-string)) 
; )

; (define (list-of-routers? lst)
;   (every firehol-router? lst)
; )

(define (list-of-interfaces? lst)
   (every dnsmasq-interface? lst) 
)

(define-configuration dnsmasq-configuration
  (custom-opts
    (list-of-string '("domain-needed" 
                      "bogus-priv"))
    "Define a list of options as strings to add at the beginning of the config"
    (serializer serialize-list-of-string))
  (delegate-local-ns
    (list-of-string '())
    "Define a list of domains sent to otheri local DNS servers eg: server=/localnet/192.168.0.1"
   (serializer serialize-list-of-string))
  (local-domains
    (list-of-string '())
    "Define a list local domains eg: local=/localdom/"
   (serializer serialize-list-of-string))
  (domains
    (list-of-string '())
    "List of domains"
    (serializer serialize-list-of-string))
  (dhcp-ranges
    (list-of-string '())
    "List of of dhcp ranges"
    (serializer serialize-list-of-string))
  (force-addr
    (list-of-string '())
    "Define a list of domains to bind to ip eg: address=/example.com/127.0.0.1"
   (serializer serialize-list-of-string))
  (interfaces
    (list-of-interfaces '())
    "List of interface definitions"
    (serializer serialize-list-of-interfaces))
  (dhcp-hosts
    (list-of-strings  '())
    "List of host  definitions"
    (serializer serialize-list-of-string))
  (dhcp-opts
    (list-of-strings  '())
    "List of dhcp-opts definitions"
    (serializer serialize-list-of-string))
  (srv-host
    (list-of-strings  '())
    "List of SRV host  definitions"
    (serializer serialize-list-of-string))
  (txt-record
    (list-of-strings  '())
    "List of TXT record  definitions"
    (serializer serialize-list-of-string))
  (cname-record
    (list-of-strings  '())
    "List of CNAME record  definitions"
    (serializer serialize-list-of-string))
)


(define (dnsmasq-shepherd-service config)
  (list (shepherd-service
    (documentation "Run Dnsmasq")
    (provision '(dnsmasq))
    (requirement '(networking))
    (start #~(make-forkexec-constructor 
              (list #$(file-append dnsmasq "/sbin/dnsmasq") "--keep-in-foreground" "--pid-file=/run/dnsmasq.pid" (string-append "--config-file=" #$(serialize-dnsmasq-config config)))
              #:pid-file "/run/dnsmasq.pid")) 
    (stop  #~(make-kill-destructor))
    )))
    
(define dnsmasq-service-type
  (service-type
    (name "dnsmasq")
    (description "Dnsmasq with config file")
    (extensions
      (list
        (service-extension shepherd-root-service-type dnsmasq-shepherd-service)))
    (default-value (dnsmasq-configuration))))
