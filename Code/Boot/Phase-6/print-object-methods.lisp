(cl:in-package #:sicl-boot-phase-6)

(defmethod print-object ((object sicl-boot::host-package) stream)
  (princ "#<<HOST-PACKAGE " stream)
  (princ (package-name object) stream)
  (princ ">>") stream)

(defun print-symbol (symbol stream)
  (princ (package-name (symbol-package symbol)) stream)
  (princ ":" stream)
  (princ (symbol-name symbol) stream))

(defmethod print-object ((object sicl-boot::host-symbol) stream)
  (princ "#<<HOST-SYMBOL " stream)
  (print-symbol object stream)
  (princ ">>") stream)

(defmethod print-object ((object standard-generic-function) stream)
  (princ "#<<STANDARD-GENERIC-FUNCTION " stream)
  (let ((name (sicl-clos:generic-function-name object)))
    (if (symbolp name)
        (print-symbol name stream)
        (progn (princ "(SETF " stream)
               (print-symbol (second name) stream)
               (princ ")" stream))))
  (princ ">>") stream)

(defmethod print-object ((object built-in-class) stream)
  (princ "#<<BUILT-IN-CLASS " stream)
  (print-symbol (class-name object) stream)
  (princ ">>") stream)

(defmethod print-object ((object standard-class) stream)
  (princ "#<<STANDARD-CLASS " stream)
  (print-symbol (class-name object) stream)
  (princ ">>") stream)

(defmethod print-object ((object sicl-clos:forward-referenced-class) stream)
  (princ "#<<FORWARD-REFERENCED-CLASS " stream)
  (print-symbol (class-name object) stream)
  (princ ">>") stream)

(defmethod print-object ((object sicl-conditions:condition-class) stream)
  (princ "#<<CONDITION-CLASS " stream)
  (print-symbol (class-name object) stream)
  (princ ">>") stream)

(defmethod print-object ((object structure-class) stream)
  (princ "#<<STRUCTURE-CLASS " stream)
  (print-symbol (class-name object) stream)
  (princ ">>") stream)

(defmethod print-object ((object standard-method) stream)
  (princ "#<<STANDARD-METHOD" stream)
  (princ ">>") stream)
