(cl:in-package #:sicl-boot-phase-5)

(defun boot (boot)
  (format *trace-output* "Start of phase 5~%")
  (with-accessors ((e3 sicl-boot:e3)
                   (e4 sicl-boot:e4)
                   (e5 sicl-boot:e5)
                   (e6 sicl-boot:e6))
      boot
    (change-class e5 'environment)
    (import-from-host boot)
    (sicl-boot:enable-class-finalization #'load-fasl e3 e4)
    (finalize-all-classes boot)
    (sicl-boot:enable-defmethod #'load-fasl e4 e5)
    (enable-allocate-instance e4)
    (define-class-of e5)
    (enable-object-initialization boot)
    (load-fasl "Conditionals/macros.fasl" e4)
    (sicl-boot:enable-method-combinations #'load-fasl e4 e5)
    (define-stamp e5)
    (define-compile e4 e5)
    (sicl-boot:enable-generic-function-invocation #'load-fasl e4 e5)
    (sicl-boot:define-accessor-generic-functions #'load-fasl e4 e5 e6)
    (enable-class-initialization boot)
    (sicl-boot:create-mop-classes #'load-fasl e5)
    (load-fasl "CLOS/satiation.fasl" e5)))
