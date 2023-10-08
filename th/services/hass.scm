(define-module (th services hass)
  #:use-module (gnu packages admin)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (small-guix services docker)


;(define hass-etc
;  (string-append %nas-etc/services "/prometheus"))

(define hass-version "2023.10.0")

(define hass-image
  (string-append "ghcr.io/home-assistant/home-assistant:" hass-version))

(define hass-dir "/etc/hass")

(define-configuration nas-prometheus-configuration
  (datadir
   (string "/var/lib/hass")
   "The directory where hass writes state.")
  (confdir
   (string hass-dir)
   "The configuration file to use for the Docker backed Shepherd service.")
  (image
   (string hass-image)
   "The image to use for the Docker backed Shepherd service.")
  (port
   (string "8123")
   "The port where prometheus will be exposed.")
  (no-serialization))

(define %hass-accounts
  (list (user-group
         (name "hass")
         (id 65534)
         (system? #t))
        (user-account
          (name "hass")
          (comment "Hass's Service Account")
          (uid 65534)
          (group "hass")
          (supplementary-groups '("tty" "dialout"))
          (system? #t)
          (home-directory "/var/empty")
          (shell (file-append shadow "/sbin/nologin")))))

(define (%hass-activation config)
  "Return an activation gexp for Prometheus."
  (let ((datadir (hass-configuration-datadir config)))
    #~(begin
        (use-modules (guix build utils))
        (let* ((user (getpwnam "hass"))
               (uid (passwd:uid user))
               (gid (passwd:gid user))
               (datadir #$datadir))
          (mkdir-p datadir)
          (chown datadir uid gid)))))

(define hass-configuration->oci-container-configuration
  (lambda (config)
    (let ((datadir
           (hass-configuration-datadir config))
          (image
           (hass-configuration-image config))
          (port
           (hass-configuration-port config))
          (config
           (hass-configuration-confdir config)))
      (list (oci-container-configuration
             (command
              '("--privileged"
                "--name hass"))
             (image image)
             (environment '(( "TZ" . "Europe/Bucharest")))
             (network "host")
             (ports
              `((,port . "8123"))
             (volumes
              `((,datadir . "/var/lib/hass")
                (,config . "/etc/hass/config:rw"))))))))

(define hass-service-type
  (service-type (name 'hass)
                (extensions (list (service-extension oci-container-service-type
                                                     hass-configuration->oci-container-configuration)
                                  (service-extension account-service-type
                                                     (const %hass-accounts))
                                  (service-extension activation-service-type
                                                     %hass-activation)))
                (default-value (hass-configuration))
                (description
                 "This service install a Docker backed Hass container.")))

)
