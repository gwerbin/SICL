(cl:in-package #:sicl-package)

(defun unintern (symbol &optional (package-designator *package*))
  (let ((package (package-designator-to-package package-designator))
        (name (symbol-name symbol)))
    (if (symbol-is-present-p symbol package)
        (progn
          (remhash name (external-symbols package))
          (remhash name (internal-symbols package))
          (when (member symbol (shadowing-symbols package))
            (setf (shadowing-symbols package)
                  (remove symbol (shadowing-symbols package)))
            (let ((conflicts '()))
              (loop for used-package in (use-list package)
                    do (multiple-value-bind (symbol present-p)
                           (find-external-symbol name used-package)
                         (when present-p
                           (pushnew symbol conflicts :test #'eq))))
              (when (> (length conflicts) 1)
                (let ((choice (resolve-conflict name package)))
                  (setf (gethash name (internal-symbols package))
                        choice)
                  (push choice (shadowing-symbols package))))))
          t)
        nil)))
