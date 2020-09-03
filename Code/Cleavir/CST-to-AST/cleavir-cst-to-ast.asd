(cl:in-package #:asdf-user)

(defsystem :cleavir-cst-to-ast
  :depends-on (:concrete-syntax-tree
               :concrete-syntax-tree-destructuring
               :cleavir-code-utilities
               :cleavir-ast
	       :cleavir-ast-transformations
	       :cleavir-primop
	       :cleavir-environment
	       :cleavir-compilation-policy
               :cleavir-ctype
               :acclimation)
  :serial t
  :components
  ((:file "packages")
   (:file "conditions")
   (:file "condition-reporters-english")
   (:file "environment-augmentation")
   (:file "environment-query")
   (:file "variables")
   (:file "generic-functions")
   (:file "convert-function-reference")
   (:file "convert-special-binding")
   (:file "utilities")
   (:file "set-or-bind-variable")
   (:file "process-progn")
   (:file "convert-sequence")
   (:file "convert-variable")
   (:file "convert")
   (:file "process-init-parameter")
   (:file "itemize-declaration-specifiers")
   (:file "itemize-lambda-list")
   (:file "lambda-list-from-parameter-groups")
   (:file "convert-setq")
   (:file "convert-let-and-letstar")
   (:file "convert-code")
   (:file "convert-lambda-call")
   (:file "convert-constant")
   (:file "convert-special")
   (:file "convert-primop")
   (:file "convert-cst")
   (:file "cst-to-ast")))
