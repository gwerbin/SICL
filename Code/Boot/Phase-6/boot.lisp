(cl:in-package #:sicl-boot-phase-6)

(defun load-alexandria (e5)
  (load-asdf-system '#:alexandria e5))

(defun load-clostrum (e5)
  ;; FIXME: undefine all environment functions here.
  (loop for name in '(env:type-expander
                      env:fdefinition)
        do (env:fmakunbound (env:client e5) e5 name))
  ;; Since we are not using file-compilation semantics, Clostrum is
  ;; not definining these variables.
  (setf (env:special-variable
         (env:client e5) e5 'clostrum-implementation::*run-time-operators* t)
        '())
  (setf (env:special-variable
         (env:client e5) e5 'clostrum-implementation::*run-time-accessors* t)
        '())
  (setf (env:special-variable
         (env:client e5) e5 'clostrum-implementation::*compilation-operators* t)
        '())
  (load-asdf-system '#:clostrum e5)
  (load-asdf-system '#:clostrum/virtual e5))

(defun load-acclimation (e5)
  (load-asdf-system '#:acclimation e5))

(defun load-trucler (e5)
  (load-asdf-system '#:trucler-base e5)
  (load-asdf-system '#:trucler-reference e5))

(defun boot (boot)
  (format *trace-output* "Start phase 6~%")
  (with-accessors ((e3 sicl-boot:e3)
                   (e4 sicl-boot:e4)
                   (e5 sicl-boot:e5))
      boot
    (setf (env:fdefinition (env:client e5) e5 'sicl-clos::update-header)
          (lambda (to from)
            (setf (slot-value to 'sicl-boot::%class)
                  (slot-value from 'sicl-boot::%class))
            (setf (slot-value to 'sicl-boot::%rack)
                  (slot-value from 'sicl-boot::%rack))))
    (load-source-file "CLOS/update-instance-defgenerics.lisp" e5)
    (load-source-file "CLOS/change-class-defgenerics.lisp" e5)
    (load-source-file "CLOS/built-in-method-combinations.lisp" e5)
    (enable-deftype e5)
    (enable-printing e5)
    (enable-conditions e5)
    (setf (env:fdefinition (env:client e5) e5 'proclaim)
          (constantly nil))
    (setf (env:fdefinition (env:client e5) e5 'documentation)
          (constantly nil))
    (setf (env:fdefinition (env:client e5) e5 '(setf documentation))
          (lambda (new-value x doc-type)
            (declare (ignore x doc-type))
            new-value))
    (load-source-file "Data-and-control-flow/define-modify-macro-defmacro.lisp" e5)
    ;; Fake this macro for now
    (setf (env:macro-function (env:client e5) e5 'with-standard-io-syntax)
          (lambda (form environment)
            (declare (ignore environment))
            `(progn ,@(rest form))))
    (load-source-file "Data-and-control-flow/setf-defmacro.lisp" e5)
    (load-source-file "Data-and-control-flow/values-define-setf-expander.lisp" e5)
    (sicl-boot::load-asdf-system '#:sicl-hash-table-base e5)
    (sicl-boot::load-asdf-system '#:sicl-hash-table e5)
    (import-functions-from-host '(intern) e5)
    (load-alexandria e5)
    (load-clostrum e5)
    (load-acclimation e5)
    (load-trucler e5)))
