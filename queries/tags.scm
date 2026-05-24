(module
  (expression_statement
    (assignment left: (identifier) @name) @definition.constant))

(class_definition
  name: (identifier) @name) @definition.class

(cdef_class_definition
  name: (identifier) @name) @definition.class

(function_definition
  name: (identifier) @name) @definition.function

(cdef_function_definition
  name: (identifier) @name) @definition.function

(c_function_declaration
  name: (identifier) @name) @definition.function

(ctypedef_statement
  name: (identifier) @name) @definition.type

(ctypedef_struct_definition
  name: (identifier) @name) @definition.type

(ctypedef_fused_definition
  name: (identifier) @name) @definition.type

(cython_def_statement
  name: (identifier) @name) @definition.constant

(cython_property_definition
  name: (identifier) @name) @definition.property

(call
  function: [
    (identifier) @name
    (attribute
      attribute: (identifier) @name)
  ]) @reference.call
