(cl:in-package #:asdf-user)

(defsystem :sicl-boot-phase1
  :depends-on (:sicl-extrinsic-environment)
  :serial t
  :components
  ((:file "packages")
   (:file "temporary-standard-class")
   (:file "fill")
   (:file "environment")))
