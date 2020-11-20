(cl:in-package #:sicl-boot-phase-5)

;;; Object allocation in E4 is required only in order to create class
;;; prototypes when classes are finalized.  Right now, we finalize
;;; classes before we have enabled object creation in E5, so we need
;;; to be able to create class prototypes in E4.  However, we should
;;; investigate whether we could delay finalization until we have
;;; object creation enabled in E5.
(defun enable-object-allocation-in-e4 (e4)
  (setf (env:fdefinition (env:client e4) e4 'sicl-clos::allocate-general-instance)
        (lambda (class size)
          (make-instance 'sicl-boot:header
            :class class
            :rack (make-array size :initial-element 10000000))))
  (load-source-file "CLOS/stamp-offset-defconstant.lisp" e4)
  (load-source-file "CLOS/effective-slot-definition-class-support.lisp" e4)
  (load-source-file "CLOS/effective-slot-definition-class-defgeneric.lisp" e4)
  (load-source-file "CLOS/effective-slot-definition-class-defmethods.lisp" e4)
  ;; These were already loaded in phase 3 because they were needed for
  ;; the finalization of built-in classes.
  ;; (load-source-file "CLOS/class-finalization-defgenerics.lisp" e4)
  ;; (load-source-file "CLOS/class-finalization-defmethods.lisp" e4)
  (load-source-file "CLOS/allocate-instance-support.lisp" e4)
  (load-source-file "CLOS/allocate-instance-defgenerics.lisp" e4)
  (load-source-file "CLOS/allocate-instance-defmethods.lisp" e4))

;; (defun enable-object-initialization (e4 e5)
;;   (setf (env:constant-variable (env:client e4) e4 'sicl-clos::+unbound-slot-value+)
;;         10000000)
;;   (load-source-file "CLOS/slot-bound-using-index.lisp" e4)
;;   (load-source-file "CLOS/standard-instance-access.lisp" e4)
;;   (import-functions-from-host '(slot-unbound) e4)
;;   (with-intercepted-function-cells
;;       (e4
;;        (class-of
;;         (list (lambda (object)
;;                 (slot-value object 'sicl-boot::%class)))))
;;     (load-source-file "CLOS/slot-value-etc-support.lisp" e4))
;;   (load-source-file "CLOS/instance-slots-offset-defconstant.lisp" e4)
;;   (load-source-file "CLOS/shared-initialize-support.lisp" e4)
;;   (load-source-file "CLOS/shared-initialize-defgenerics.lisp" e5)
;;   (with-intercepted-function-cells
;;       (e5
;;        (sicl-clos::shared-initialize-default-using-class
;;         (env:function-cell
;;          (env:client e4) e4 'sicl-clos::shared-initialize-default-using-class)))
;;     (load-source-file "CLOS/shared-initialize-defmethods.lisp" e5))
;;   (load-source-file "CLOS/initialize-instance-support.lisp" e5)
;;   (load-source-file "CLOS/initialize-instance-defgenerics.lisp" e5)
;;   (load-source-file "CLOS/initialize-instance-defmethods.lisp" e5))

;; (defun enable-make-instance (e4 e5)
;;   (with-intercepted-function-cells
;;       (e4
;;        (find-class
;;         (env:function-cell (env:client e4) e4 'find-class))
;;        (initialize-instance
;;         (env:function-cell (env:client e5) e5 'initialize-instance)))
;;     (load-source-file "CLOS/make-instance-support.lisp" e4))
;;   (load-source-file "CLOS/make-instance-defgenerics.lisp" e4)
;;   (load-source-file "CLOS/make-instance-defmethods.lisp" e4))

(defun enable-object-creation-in-e4 (e4 e5)
  (declare (ignore e5))
  (enable-object-allocation-in-e4 e4)
  ;; When we create effective method functions and discriminating
  ;; functions for functions in E5, we call COMPILE in E4.  And
  ;; COMPILE in E4 will call MAKE-INSTANCE in order to create methods
  ;; (through MAKE-METHOD).  However, the MAKE-INSTANCE that is then
  ;; called is in E3.  But the compilation will signal an error if
  ;; MAKE-INSTANCE is not defined in the environment of compilation,
  ;; so we define it as an error function in E4.
  (define-error-functions '(make-instance) e4))
  ;; (enable-object-initialization e4 e5)
  ;; (enable-make-instance e4 e5))