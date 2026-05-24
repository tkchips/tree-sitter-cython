; Python and Cython highlighting

; Identifier naming conventions

(identifier) @variable

((identifier) @constructor
 (#match? @constructor "^[A-Z]"))

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z_]*$"))

; Definitions

(function_definition
  name: (identifier) @function)

(cdef_function_definition
  name: (identifier) @function)

(c_function_declaration
  name: (identifier) @function)

(class_definition
  name: (identifier) @constructor)

(cdef_class_definition
  name: (identifier) @constructor)

(ctypedef_statement
  name: (identifier) @type)

(ctypedef_struct_definition
  name: (identifier) @type)

(ctypedef_fused_definition
  name: (identifier) @type)

(cython_property_definition
  name: (identifier) @property)

(cython_def_statement
  name: (identifier) @constant)

(c_declarator
  name: (identifier) @variable)

(c_parameter
  name: (identifier) @variable)

; Function calls

(decorator) @function
(decorator
  (identifier) @function)

(call
  function: (attribute attribute: (identifier) @function.method))
(call
  function: (identifier) @function)

; Builtin functions and constants

((call
  function: (identifier) @function.builtin)
 (#match?
   @function.builtin
   "^(abs|all|any|ascii|bin|bool|breakpoint|bytearray|bytes|callable|chr|classmethod|compile|complex|delattr|dict|dir|divmod|enumerate|eval|exec|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|isinstance|issubclass|iter|len|list|locals|map|max|memoryview|min|next|object|oct|open|ord|pow|print|property|range|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|vars|zip|__import__)$"))

((identifier) @constant.builtin
 (#match?
   @constant.builtin
   "^(NotImplemented|Ellipsis|__debug__|__name__|__file__|__doc__|__package__|__loader__|__spec__|__builtins__)$"))

; Types

(type (identifier) @type)
(c_type (identifier) @type)
(c_function_declaration return_type: (c_type (identifier) @type))
(cdef_function_definition return_type: (c_type (identifier) @type))
(c_variable_declaration type: (c_type (identifier) @type))
(cdef_statement type: (c_type (identifier) @type))
(ctypedef_statement type: (c_type (identifier) @type))

((identifier) @type.builtin
 (#match?
   @type.builtin
   "^(bint|char|short|int|long|float|double|void|object|Py_ssize_t|size_t|ssize_t|ptrdiff_t|uint8_t|uint16_t|uint32_t|uint64_t|int8_t|int16_t|int32_t|int64_t|intp_t|uintp_t|complex)$"))

; Properties and attributes

(attribute attribute: (identifier) @property)

; Literals

[
  (none)
  (true)
  (false)
] @constant.builtin

[
  (integer)
  (float)
] @number

(comment) @comment
(string) @string
(escape_sequence) @escape

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @embedded

; Operators

[
  "-"
  "-="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "&="
  "%"
  "%="
  "^"
  "^="
  "+"
  "->"
  "+="
  "<"
  "<<"
  "<<="
  "<="
  "<>"
  "="
  ":="
  "=="
  ">"
  ">="
  ">>"
  ">>="
  "|"
  "|="
  "~"
  "@="
  "and"
  "in"
  "is"
  "not"
  "or"
  "is not"
  "not in"
] @operator

; Python and Cython keywords

[
  "as"
  "assert"
  "async"
  "await"
  "break"
  "case"
  "class"
  "continue"
  "const"
  "def"
  "del"
  "elif"
  "else"
  "except"
  "exec"
  "finally"
  "for"
  "from"
  "global"
  "if"
  "import"
  "lambda"
  "match"
  "nonlocal"
  "pass"
  "print"
  "raise"
  "return"
  "try"
  "while"
  "with"
  "yield"
  "cdef"
  "cpdef"
  "ctypedef"
  "cimport"
  "include"
  "extern"
  "nogil"
  "api"
  "inline"
  "public"
  "readonly"
  "fused"
  "property"
  "DEF"
  "IF"
  "ELIF"
  "ELSE"
] @keyword
