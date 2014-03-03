(cl:in-package #:common-lisp-user)

(asdf:defsystem :sicl-boot-phase2
  :depends-on (:sicl-code-utilities
	       :sicl-additional-conditions
	       :sicl-boot-phase1)
  :serial t
  :components
  ((:file "packages")
   (:file "rename-package-1")
   (:file "define-variables")
   (:file "list-utilities")
   (:file "defclass-support")
   (:file "defclass-defmacro")
   (:file "define-built-in-class-defmacro")
   (:file "defgeneric-defmacro")
   (:file "defmethod-support")
   (:file "defmethod-defmacro")
   (:file "make-method-lambda-support")
   (:file "make-method-lambda-defuns")
   (:file "mop-class-hierarchy")
   (:file "add-remove-direct-method-support")
   (:file "add-remove-direct-method-defuns")
   (:file "classp")
   (:file "compute-applicable-methods-support")
   (:file "compute-applicable-methods-defuns")
   (:file "compute-effective-method-support")
   (:file "compute-effective-method-support-a")
   (:file "method-combination-compute-effective-method-support")
   (:file "method-combination-compute-effective-method-defuns")
   (:file "compute-effective-method-defuns")
   (:file "discriminating-automaton")
   (:file "discriminating-tagbody")
   (:file "compute-discriminating-function-support")
   (:file "compute-discriminating-function-support-a")
   (:file "compute-discriminating-function-defuns")
   ;; Although we do not use the dependent maintenance facility, we
   ;; define the specified functions as ordinary functions that do
   ;; nothing, so that we can safely call them from other code.
   (:file "dependent-maintenance-support")
   (:file "dependent-maintenance-defuns")
   (:file "set-funcallable-instance-function")
   (:file "add-remove-method-support")
   (:file "add-remove-method-defuns")
   (:file "rename-package-2")))
