(cl:in-package #:sicl-sequence)

(defun map (result-type function sequence &rest more-sequences)
  (if (null result-type)
      (apply #'map-for-effect function sequence more-sequences)
      (with-reified-result-type (prototype result-type)
        (if (listp prototype)
            (sicl-utilities:with-collectors ((result collect))
              (let ((function (function-designator-function function)))
                (declare (function function))
                (flet ((fn (&rest arguments)
                         (collect (apply function arguments))))
                  (declare (dynamic-extent #'fn))
                  (apply #'map-for-effect #'fn sequence more-sequences)
                  (result))))
            (let ((length 0))
              (declare (array-length length))
              (flet ((count (&rest args)
                       (declare (ignore args))
                       (incf length)))
                (declare (dynamic-extent #'count))
                (apply #'map-for-effect #'count sequence more-sequences))
              (apply
               #'map-into
               (make-sequence-like prototype length)
               function sequence more-sequences))))))

(define-compiler-macro map
    (&whole form result-type function sequence &rest more-sequences &environment env)
  (if (constantp result-type)
      (let* ((sequences (list* sequence more-sequences))
             (type (or (eval result-type)
                       (return-from map
                         `(map-for-effect ,function ,@sequences))))
             (prototype (reify-sequence-type-specifier type env))
             (arguments (loop repeat (length sequences) collect (gensym)))
             (bindings (loop for sequence in sequences collect `(,(gensym) ,sequence))))
        (sicl-utilities:once-only (function)
          `(let ((,function (function-designator-function ,function)) ,@bindings)
             (declare (function ,function))
             (the
              ,type
              ,(if (listp prototype)
                   (sicl-utilities:with-gensyms (result collect fn)
                     `(sicl-utilities:with-collectors ((,result ,collect))
                        (declare (dynamic-extent (function ,collect)))
                        (flet ((,fn (,@arguments)
                                 (,collect (funcall ,function ,@arguments))))
                          (declare (dynamic-extent (function ,fn)))
                          (map-for-effect (function ,fn) ,@(mapcar #'first bindings))
                          (,result))))
                   (sicl-utilities:with-gensyms (length fn)
                     `(let ((,length 0))
                        (declare (array-length ,length))
                        (flet ((,fn (,@arguments)
                                 (declare (ignore ,@arguments))
                                 (incf ,length)))
                          (declare (dynamic-extent (function ,fn)))
                          (map-for-effect (function ,fn) ,@(mapcar #'first bindings)))
                        (map-into (make-sequence-like ',prototype ,length)
                                  ,function
                                  ,@(mapcar #'first bindings)))))))))
      form))
