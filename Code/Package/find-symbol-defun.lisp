(cl:in-package #:sicl-package)

(defgeneric generic-find-symbol (symbol-name package))

(defmethod generic-find-symbol ((symbol-name string) (package package))
  (multiple-value-bind (symbol status)
      (find-present-symbol symbol-name package)
    (if (null status)
        (loop for used-package in (use-list package)
              do (multiple-value-bind (symbol status)
                     (find-present-symbol symbol-name used-package)
                   (unless (null status)
                     (return-from generic-find-symbol
                       (values symbol :inherited))))
              finally (return (values nil nil)))
        (values symbol status))))

(defun find-symbol (symbol-name &optional (package-designator *package*))
  (let ((package (package-designator-to-package package-designator)))
    (generic-find-symbol symbol-name package)))
