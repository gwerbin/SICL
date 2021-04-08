(cl:in-package #:common-lisp-user)

(defpackage #:sicl-register-arrangement
  (:use #:common-lisp)
  (:export #:arrangement
           #:attribution
           #:copy-arrangement
           #:lexical-locations-in-register
           #:lexical-location-has-attributed-register-p
           #:lexical-location-has-attributed-stack-slot-p
           #:unattributed-register-count
           #:attribute-stack-slot
           #:attribute-register
           #:unattribute-register
           #:trim-arrangement
           #:copy-register-attribution
           #:delete-attribution))
