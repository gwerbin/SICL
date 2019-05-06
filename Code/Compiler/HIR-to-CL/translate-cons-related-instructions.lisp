(cl:in-package #:sicl-hir-to-cl)

(defmethod translate (client (instruction cleavir-ir:car-instruction) context)
  (let ((input (first (cleavir-ir:inputs instruction)))
        (output (first (cleavir-ir:outputs instruction)))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(setf ,(cleavir-ir:name output)
                 (car ,(cleavir-ir:name input)))
          (translate client successor context))))

(defmethod translate (client (instruction cleavir-ir:cdr-instruction) context)
  (let ((input (first (cleavir-ir:inputs instruction)))
        (output (first (cleavir-ir:outputs instruction)))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(setf ,(cleavir-ir:name output)
                 (cdr ,(cleavir-ir:name input)))
          (translate client successor context))))

(defmethod translate (client (instruction cleavir-ir:rplaca-instruction) context)
  (let ((inputs (cleavir-ir:inputs instruction))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(rplaca ,(cleavir-ir:name (first inputs))
                   ,(cleavir-ir:name (second inputs)))
          (translate client successor context))))

(defmethod translate (client (instruction cleavir-ir:rplacd-instruction) context)
  (let ((inputs (cleavir-ir:inputs instruction))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(rplacd ,(cleavir-ir:name (first inputs))
                   ,(cleavir-ir:name (second inputs)))
          (translate client successor context))))
