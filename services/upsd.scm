(define-module (services upsd)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix records)
  #:use-module (guix modules)
  #:use-module (guix gexp)
  #:use-module (packages upsd)
  #:use-module (srfi srfi-1)
  #:export (upsd-configuration
            upsd-configuration?
            upsd-service-type
            ))

  (define-record-type* <upsd-configuration>
    upsd-configuration make-upsd-configuration
    upsd-configuration?
    (upsd           upsd-configuration-upsd
                    (default upsd))
    (pid-file       upsd-configuration-pid-file
                    (default "/var/run/upsd.pid"))
    (port-number    upsd-configuration-port-number
                    (default 3493))
    (max-age        upsd-configuration-max-age
                    (default 15))
    (tracking-delay upsd-configuration-tracking-delay
                    (default 3600))
    (listen         upsd-configuration-listen
                    (default "127.0.0.1")))

  (define (upsd-activation config)
    "Return the activation gexp for CONFIG"
    #~(begin
        (use-modules (guix build utils))
        (mkdir -p "/etc/upsd")))

    (define (upsd-config-file config)
      "Return the upsd config file corresponding to CONFIG"
      (computed-file
      "upsd.conf"
      #~(begin
      (use-modules (ice-9 match))
      (call-with-output-file #$output
      (lamba (port)
        (display "#generated by 'upsd service'\n" port)
        (format port "MAXAGE ~a\n" 
                #$(number->string
                  (upsd-configuration-max-age config)))
        (format port "TRACKINGDELAY ~a\n"
                #$(number->string
                  (upsd-configuration-tracking-delay config)))
        (format port "LISTEN ~a ~a\n"
                #$(upsd-configuration-listen config)
                #$(number->string (upsd-configuration-port-number config))))))))
                
  (define (upsd-shepherd-service config)
    "Return a <shepherd-service> for upsd with CONFIG"
    (define upsd (upsd-configuration-upsd config))

    (define pid-file 
      (upsd-configuration-pid-file config))

    (define config-file
      (upsd-config-file config))
    (define upsd-command
      #~(list (string-append #$upsd "/sbin/upsd")
              "-P" #$pid-file
              "-B"))
    (define requires '(networking))
    (list (shepherd-service
          (documentation "Upsd UPS daemon.")
          (requirement requires)
          (provision '(upsd))
          (start #~(make-forkexec-condtructor #$upsd-command
                                              #:pid-file #$pid-file))
          (stop #~(make-kill-destructor))
          (actions (list (shepherd-configuration-action config-file))))))
            

  (define upsd-service-type 
    (service-type (name "upsd")
                  (description "UPS monitoring daemon")
                  (extensions 
                    (list 
                      (service-extension shepherd-root-service-type 
                        upsd-shepherd-service)
                      (service-extension activation-service-type
                        upsd-activation)))
                  (compose concatenate)
                  (default-value (upsd-configuration))))
  
   