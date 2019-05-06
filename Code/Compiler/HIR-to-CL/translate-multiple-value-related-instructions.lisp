(cl:in-package #:sicl-hir-to-cl)

(defmethod translate (client (instruction cleavir-ir:multiple-to-fixed-instruction) context)
  (let ((outputs (cleavir-ir:outputs instruction))
        (successor (first (cleavir-ir:successors instruction))))
    (append `(,(loop for output in outputs
                     collect `(setq ,(cleavir-ir:name output)
                                    (pop ,(values-location context)))))
            (translate client successor context))))

(defmethod translate (client (instruction cleavir-ir:fixed-to-multiple-instruction) context)
  (let ((inputs (cleavir-ir:inputs instruction))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(setq ,(values-location context)
                 (list ,(mapcar #'cleavir-ir:name inputs)))
          (translate client successor context))))
