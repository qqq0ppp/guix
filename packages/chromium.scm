(use-modules (guix packages)
             (guix build-system trivial)
             (gnu packages chromium)
             (gnu packages bash)
             (gnu packages base))
(package
 (inherit ungoogled-chromium)
 (name "chromium")
 (native-inputs '())
 (inputs `(("bash" ,bash-minimal)
           ("ungoogled-chromium" ,ungoogled-chromium)
           ("glibc-locales" ,glibc-utf8-locales)))
 (build-system trivial-build-system)
 (arguments
  '(#:modules
     ((guix build utils))
    #:builder
     (begin
      (use-modules (guix build utils))
      (let* ((bash (assoc-ref %build-inputs "bash"))
             (chromium (assoc-ref %build-inputs "ungoogled-chromium"))
             (locales (assoc-ref %build-inputs "glibc-locales"))
             (out (assoc-ref %outputs "out"))
             (exe (string-append out "/bin/chromium")))
        (setenv "GUIX_LOCPATH" (string-append locales "/lib/locale"))
        (setlocale LC_ALL "en_US.utf8")
        (mkdir-p (dirname exe))
        (symlink (string-append chromium "/bin/chromedriver")
                 (string-append out "/bin/chromedriver"))
        (call-with-output-file exe
          (lambda (port)
            (format port "#!~a
exec ~a --user-data-dir=/home/me/backup/chromium-user-data $@"
                    (string-append bash "/bin/bash")
                    (string-append chromium "/bin/chromium"))))
        (chmod exe #o555)
        (copy-recursively (string-append chromium "/share")
                          (string-append out "/share"))
        (substitute* (string-append out "/share/applications/chromium.desktop")
                     ((chromium) out))
        #t)))))
