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
            dnsmasq-host
            serialize-dnsmasq-config
            ))


(define (uglify-field-name field-name)
  (let ((str (symbol->string field-name)))
    ;; field? -> is-field
    (if (string-suffix? "?" str)
        (string-append "is-" (string-drop-right str 1))
        str)))

(define (serialize-host-name field value)
   #~(string-append "," #$value "\n"))

(define (serialize-mac-addr field value)
  #~(string-append "dhcp-host=" #$value))

(define (serialize-ip-addr field value)
  #~(string-append "," #$value))

(define (serialize-list-of-hosts field value)
   #~(string-append #$@(map (cut serialize-configuration <>
                                 dnsmasq-host-fields)
                            value)))
(define (serialize-dnsmasq-config config)
  (mixed-text-file
  "dnsmasq.conf"
  #~(string-append #$(serialize-configuration config dnsmasq-configuration-fields))))

(define (list-of-string? lst)
  (every string? lst)
)

(define (serialize-list-of-string field lst)
  (string-append (string-join lst "\n") "\n")
)

(define-configuration dnsmasq-host
   (host-name
     (string "myhostname")
     "Hostname of the device"
     (serializer serialize-host-name))
   (mac-addr
     (string "00:11:11:22:33:55")
     "MAC address of the device"
     (serializer serialize-mac-addr))
   (ip-addr
     (string "192.168.1.111")
     "IP address for the device"
     (serializer serialize-ip-addr)))

(define (list-of-hosts? lst)
   (every dnsmasq-host? lst)
)

; (define (list-of-interfaces? lst)
;    (every dnsmasq-interface? lst) 
; )

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
  (listen
    (list-of-strings '())
    "List of listen definitions"
    (serializer serialize-list-of-string))
  (dhcp-hosts
    (list-of-hosts  '())
    "List of host  definitions"
    (serializer serialize-list-of-hosts))
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
              (list #$(file-append dnsmasq "/sbin/dnsmasq") "--keep-in-foreground" "--pid-file=/run/dnsmasq.pid" (string-append "--conf-file=" #$(serialize-dnsmasq-config config)))
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
