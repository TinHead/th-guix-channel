(define-module (th services podman)
  #:use-module (gnu services docker)
  #:use-module (gnu packages containers)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  
  #:export podman-service-type)

(define (%oci-image-loader name image tag)
  (let ((docker (file-append podman "/bin/podman"))
        (tarball (lower-oci-image name image)))
    (with-imported-modules '((guix build utils))
      (program-file (format #f "~a-image-loader" name)
       #~(begin
           (use-modules (guix build utils)
                        (ice-9 popen)
                        (ice-9 rdelim))

           (format #t "Loading image for ~a from ~a...~%" #$name #$tarball)
           (define line
             (read-line
              (open-input-pipe
               (string-append #$docker " load -i " #$tarball))))

           (unless (or (eof-object? line)
                       (string-null? line))
             (format #t "~a~%" line)
             (let ((repository&tag
                    (string-drop line
                                 (string-length
                                   "Loaded image: "))))

               (invoke #$docker "tag" repository&tag #$tag)
               (format #t "Tagged ~a with ~a...~%" #$tarball #$tag))))))))

(define (oci-podman-shepherd-service config)
  (define (guess-name name image)
    (if (maybe-value-set? name)
        name
        (string-append "podman-"
                       (basename
                        (if (string? image)
                            (first (string-split image #\:))
                            (oci-image-repository image))))))

  (let* ((docker (file-append podman "/bin/podman"))
         (actions (oci-container-configuration-shepherd-actions config))
         (auto-start?
          (oci-container-configuration-auto-start? config))
         (user (oci-container-configuration-user config))
         (group (oci-container-configuration-group config))
         (host-environment
          (oci-container-configuration-host-environment config))
         (command (oci-container-configuration-command config))
         (log-file (oci-container-configuration-log-file config))
         (provision (oci-container-configuration-provision config))
         (requirement (oci-container-configuration-requirement config))
         (respawn?
          (oci-container-configuration-respawn? config))
         (image (oci-container-configuration-image config))
         (image-reference (oci-image-reference image))
         (options (oci-container-configuration->options config))
         (name (guess-name provision image))
         (extra-arguments
          (oci-container-configuration-extra-arguments config)))

    (shepherd-service (provision `(,(string->symbol name)))
                      (requirement `(dockerd user-processes ,@requirement))
                      (respawn? respawn?)
                      (auto-start? auto-start?)
                      (documentation
                       (string-append
                        "Podman backed Shepherd service for "
                        (if (oci-image? image) name image) "."))
                      (start
                       #~(lambda ()
                           #$@(if (oci-image? image)
                                  #~((invoke #$(%oci-image-loader
                                                name image image-reference)))
                                  #~())
                           (fork+exec-command
                            ;; docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
                            (list #$docker "run" "--rm" "--name" #$name
                                  #$@options #$@extra-arguments
                                  #$image-reference #$@command)
                            #:user #$user
                            #:group #$group
                            #$@(if (maybe-value-set? log-file)
                                   (list #:log-file log-file)
                                   '())
                            #:environment-variables
                            (list #$@host-environment))))
                      (stop
                       #~(lambda _
                           (invoke #$docker "rm" "-f" #$name)))
                      (actions
                       (if (oci-image? image)
                           '()
                           (append
                            (list
                             (shepherd-action
                              (name 'pull)
                              (documentation
                               (format #f "Pull ~a's image (~a)."
                                       name image))
                              (procedure
                               #~(lambda _
                                   (invoke #$docker "pull" #$image)))))
                            actions))))))

(define %oci-container-accounts
  (list (user-account
         (name "podman-container")
         (comment "OCI services account")
         (group "podman")
         (system? #t)
         (home-directory "/var/empty")
         (shell (file-append shadow "/sbin/nologin")))))

(define (configs->shepherd-services configs)
  (map oci-podman-shepherd-service configs))

(define oci-podman-service-type
  (service-type (name 'oci-container)
                (extensions (list (service-extension profile-service-type
                                                     (lambda _ (list docker-cli)))
                                  (service-extension account-service-type
                                                     (const %oci-container-accounts))
                                  (service-extension shepherd-root-service-type
                                                     configs->shepherd-services)))
                (default-value '())
                (extend append)
                (compose concatenate)
                (description
                 "This service allows the management of OCI
containers as Shepherd services.")))
