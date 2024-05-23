(define-module (th services wireguard-etc)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu services dbus)
  #:use-module (gnu services mcron)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages vpn)
  #:use-module (guix modules)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (guix i18n)
  #:use-module (guix deprecation)
  #:use-module (guix)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:export (wireguard-peer
            wireguard-peer?
            wireguard-peer-name
            wireguard-peer-endpoint
            wireguard-peer-allowed-ips
            wireguard-peer-public-key
            wireguard-peer-preshared-key
            wireguard-peer-keep-alive

            wireguard-configuration
            wireguard-configuration?
            wireguard-configuration-wireguard
            wireguard-configuration-interface
            wireguard-configuration-addresses
            wireguard-configuration-port
            wireguard-configuration-dns
            wireguard-configuration-monitor-ips?
            wireguard-configuration-monitor-ips-interval
            wireguard-configuration-private-key
            wireguard-configuration-peers
            wireguard-configuration-pre-up
            wireguard-configuration-post-up
            wireguard-configuration-pre-down
            wireguard-configuration-post-down
            wireguard-configuration-table

            wireguard-service-type))

;;;
;;; Wireguard.
;;;

(define-record-type* <wireguard-peer>
  wireguard-peer make-wireguard-peer
  wireguard-peer?
  (name              wireguard-peer-name)
  (endpoint          wireguard-peer-endpoint
                     (default #f))     ;string
  (public-key        wireguard-peer-public-key)   ;string
  (preshared-key     wireguard-peer-preshared-key
                     (default #f))     ;string
  (allowed-ips       wireguard-peer-allowed-ips) ;list of strings
  (keep-alive        wireguard-peer-keep-alive
                     (default #f)))    ;integer

(define-record-type* <wireguard-configuration>
  wireguard-configuration make-wireguard-configuration
  wireguard-configuration?
  (wireguard          wireguard-configuration-wireguard ;file-like
                      (default wireguard-tools))
  (interface          wireguard-configuration-interface ;string
                      (default "wg0"))
  (addresses          wireguard-configuration-addresses ;string
                      (default '("10.0.0.1/32")))
  (port               wireguard-configuration-port ;integer
                      (default 51820))
  (private-key        wireguard-configuration-private-key ;string
                      (default "/etc/wireguard/private.key"))
  (peers              wireguard-configuration-peers ;list of <wiregard-peer>
                      (default '()))
  (dns                wireguard-configuration-dns ;list of strings
                      (default '()))
  (monitor-ips?       wireguard-configuration-monitor-ips? ;boolean
                      (default #f))
  (monitor-ips-interval wireguard-configuration-monitor-ips-interval
                        (default '(next-minute (range 0 60 5)))) ;string | list
  (pre-up             wireguard-configuration-pre-up ;list of strings
                      (default '()))
  (post-up            wireguard-configuration-post-up ;list of strings
                      (default '()))
  (pre-down           wireguard-configuration-pre-down ;list of strings
                      (default '()))
  (post-down          wireguard-configuration-post-down ;list of strings
                      (default '()))
  (table              wireguard-configuration-table ;string
                      (default "auto")))

(define (wireguard-configuration-file config)
  (define (peer->config peer)
    (match-record peer <wireguard-peer>
      (name public-key endpoint allowed-ips keep-alive)
      (let ((lines (list
                    (format #f "[Peer]   #~a" name)
                    (format #f "PublicKey = ~a" public-key)
                    (format #f "AllowedIPs = ~{~a~^, ~}" allowed-ips)
                    (format #f "~@[Endpoint = ~a~]" endpoint)
                    (format #f "~@[PersistentKeepalive = ~a~]" keep-alive))))
        (string-join (remove string-null? lines) "\n"))))

  (define (peers->preshared-keys peer keys)
    (let ((public-key (wireguard-peer-public-key peer))
          (preshared-key (wireguard-peer-preshared-key peer)))
      (if preshared-key
          (cons* public-key preshared-key keys)
          keys)))

  (match-record config <wireguard-configuration>
    (wireguard interface addresses port private-key peers dns
               pre-up post-up pre-down post-down table)
    (let* ((config-file (string-append interface ".conf"))
           (peer-keys (fold peers->preshared-keys (list) peers))
           (peers (map peer->config peers))
           (config
            (computed-file
             "wireguard-config"
             #~(begin
                 (use-modules (ice-9 format)
                              (srfi srfi-1))

                 (define lines
                   (list
                    "[Interface]"
                    #$@(if (null? addresses)
                           '()
                           (list (format #f "Address = ~{~a~^, ~}"
                                         addresses)))
                    (format #f "~@[Table = ~a~]" #$table)
                    #$@(if (null? pre-up)
                           '()
                           (list (format #f "~{PreUp = ~a~%~}" pre-up)))
                    (format #f "PostUp = ~a set %i private-key ~a\
~{ peer ~a preshared-key ~a~}" #$(file-append wireguard "/bin/wg")
#$private-key '#$peer-keys)
                    #$@(if (null? post-up)
                           '()
                           (list (format #f "~{PostUp = ~a~%~}" post-up)))
                    #$@(if (null? pre-down)
                           '()
                           (list (format #f "~{PreDown = ~a~%~}" pre-down)))
                    #$@(if (null? post-down)
                           '()
                           (list (format #f "~{PostDown = ~a~%~}" post-down)))
                    (format #f "~@[ListenPort = ~a~]" #$port)
                    #$@(if (null? dns)
                           '()
                           (list (format #f "DNS = ~{~a~^, ~}" dns)))))

                 (mkdir #$output)
                 (chdir #$output)
                 (call-with-output-file #$config-file
                   (lambda (port)
                     (format port "~a~%~%~{~a~%~^~%~}"
                             (string-join (remove string-null? lines) "\n")
                             '#$peers)))
    ; (display (string-append #$output "/" #$interface ".conf")); (string-append "/etc/wireguard/" #$interface ".conf" ))            
                 ))))
      (file-append config "/" config-file)
      ; (display (file-append config "/" config-file))
      ; (display (string-append ((@ (guile) getenv) "out") "/" "home" ".conf"))
      ; (display config)
      ; (display out)
      )))

(define (wireguard-activation config)
  (match-record config <wireguard-configuration>
    (private-key wireguard interface)

        (copy-file (wireguard-configuration-file config) (string-append "/etc/wireguard/" #$interface ".conf" ))
         #~(begin
        (use-modules (guix build utils)
                     (ice-9 popen)
                     (ice-9 rdelim))
        (mkdir-p (dirname #$private-key))
        (unless (file-exists? #$private-key)
          (let* ((pipe
                  (open-input-pipe (string-append
                                    #$(file-append wireguard "/bin/wg")
                                    " genkey")))
                 (key (read-line pipe)))
            (call-with-output-file #$private-key
              (lambda (port)
                (display key port)))
            (chmod #$private-key #o400)
            (close-pipe pipe))))))

;;; XXX: Copied from (guix scripts pack), changing define to define*.
(define-syntax-rule (define-with-source (variable args ...) body body* ...)
  "Bind VARIABLE to a procedure accepting ARGS defined as BODY, also setting
its source property."
  (begin
    (define* (variable args ...)
      body body* ...)
    (eval-when (load eval)
      (set-procedure-property! variable 'source
                               '(define* (variable args ...) body body* ...)))))

(define (wireguard-service-name interface)
  "Return the WireGuard service name (a symbol) configured to use INTERFACE."
  (symbol-append 'wireguard- (string->symbol interface)))

(define-with-source (strip-port/maybe endpoint #:key ipv6?)
  "Strip the colon and port, if present in ENDPOINT, a string."
  (if ipv6?
      (if (string-prefix? "[" endpoint)
          (first (string-split (string-drop endpoint 1) #\])) ;ipv6
          endpoint)
      (first (string-split endpoint #\:)))) ;ipv4

(define* (ipv4-address? address)
  "Predicate to check whether ADDRESS is a valid IPv4 address."
  (let ((address (strip-port/maybe address)))
    (false-if-exception
     (->bool (getaddrinfo address #f AI_NUMERICHOST AF_INET)))))

(define* (ipv6-address? address)
  "Predicate to check whether ADDRESS is a valid IPv6 address."
  (let ((address (strip-port/maybe address #:ipv6? #t)))
    (false-if-exception
     (->bool (getaddrinfo address #f AI_NUMERICHOST AF_INET6)))))

(define (host-name? name)
  "Predicate to check whether NAME is a host name, i.e. not an IP address."
  (not (or (ipv6-address? name) (ipv4-address? name))))

(define (endpoint-host-names peers)
  "Return an association list of endpoint host names keyed by their peer
public key, if any."
  (reverse
   (fold (lambda (peer host-names)
           (let ((public-key (wireguard-peer-public-key peer))
                 (endpoint (wireguard-peer-endpoint peer)))
             (if (and endpoint (host-name? endpoint))
                 (cons (cons public-key endpoint) host-names)
                 host-names)))
         '()
         peers)))

(define (wireguard-shepherd-service config)
  (match-record config <wireguard-configuration>
    (wireguard interface)
    (let ((wg-quick (file-append wireguard "/bin/wg-quick"))
          (config (wireguard-configuration-file config)))
      (list (shepherd-service
             (requirement '(networking))
             (provision (list (wireguard-service-name interface)))
             (start #~(lambda _
                       (invoke #$wg-quick "up" #$config)))
             (stop #~(lambda _
                       (invoke #$wg-quick "down" #$config)
                       #f))                       ;stopped!
             (actions (list (shepherd-configuration-action config)))
             (documentation "Run the Wireguard VPN tunnel"))))))

(define (wireguard-monitoring-jobs config)
  ;; Loosely based on WireGuard's own 'reresolve-dns.sh' shell script (see:
  ;; https://raw.githubusercontent.com/WireGuard/wireguard-tools/
  ;; master/contrib/reresolve-dns/reresolve-dns.sh).
  (match-record config <wireguard-configuration>
    (interface monitor-ips? monitor-ips-interval peers)
    (let ((host-names (endpoint-host-names peers)))
      (if monitor-ips?
          (if (null? host-names)
              (begin
                (warn "monitor-ips? is #t but no host name to monitor")
                '())
              ;; The mcron monitor job may be a string or a list; ungexp strips
              ;; one quote level, which must be added back when a list is
              ;; provided.
              (list
               #~(job
                  (if (string? #$monitor-ips-interval)
                      #$monitor-ips-interval
                      '#$monitor-ips-interval)
                  #$(program-file
                     (format #f "wireguard-~a-monitoring" interface)
                     (with-imported-modules (source-module-closure
                                             '((gnu services herd)
                                               (guix build utils)))
                       #~(begin
                           (use-modules (gnu services herd)
                                        (guix build utils)
                                        (ice-9 popen)
                                        (ice-9 match)
                                        (ice-9 textual-ports)
                                        (srfi srfi-1)
                                        (srfi srfi-26))

                           (define (resolve-host name)
                             "Return the IP address resolved from NAME."
                             (let* ((ai (car (getaddrinfo name)))
                                    (sa (addrinfo:addr ai)))
                               (inet-ntop (sockaddr:fam sa)
                                          (sockaddr:addr sa))))

                           (define wg #$(file-append wireguard-tools "/bin/wg"))

                           #$(procedure-source strip-port/maybe)

                           (define service-name '#$(wireguard-service-name
                                                    interface))

                           (when (live-service-running
                                  (current-service service-name))
                             (let* ((pipe (open-pipe* OPEN_READ wg "show"
                                                      #$interface "endpoints"))
                                    (lines (string-split (get-string-all pipe)
                                                         #\newline))
                                    ;; IPS is an association list mapping
                                    ;; public keys to IP addresses.
                                    (ips (map (match-lambda
                                                ((public-key ip)
                                                 (cons public-key
                                                       (strip-port/maybe ip))))
                                              (map (cut string-split <> #\tab)
                                                   (remove string-null?
                                                           lines)))))
                               (close-pipe pipe)
                               (for-each
                                (match-lambda
                                  ((key . host-name)
                                   (let ((resolved-ip (resolve-host
                                                       (strip-port/maybe
                                                        host-name)))
                                         (current-ip (assoc-ref ips key)))
                                     (unless (string=? resolved-ip current-ip)
                                       (format #t "resetting `~a' peer \
endpoint to `~a' due to stale IP (`~a' instead of `~a')~%"
                                               key host-name
                                               current-ip resolved-ip)
                                       (invoke wg "set" #$interface "peer" key
                                               "endpoint" host-name)))))
                                '#$host-names)))))))))
          '()))))                     ;monitor-ips? is #f

(define wireguard-service-type
  (service-type
   (name 'wireguard)
   (extensions
    (list (service-extension shepherd-root-service-type
                             wireguard-shepherd-service)
          (service-extension activation-service-type
                             wireguard-activation)
          (service-extension profile-service-type
                             (compose list
                                      wireguard-configuration-wireguard))
          (service-extension mcron-service-type
                             wireguard-monitoring-jobs)))
   (description "Set up Wireguard @acronym{VPN, Virtual Private Network}
tunnels.")))
