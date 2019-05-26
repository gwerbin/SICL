(cl:in-package #:asdf-user)

(defsystem #:sicl-new-boot-phase-0
  :depends-on (#:sicl-hir-to-cl)
  :serial t
  :components
  ((:file "packages")
   (:file "import-from-host")
   (:file "define-defmacro")
   (:file "fill-environment")
   (:file "environment")))
