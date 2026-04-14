# Third-party parser error map

Each row has a matching regression case in `test/corpus/third_party_failures.txt`.
The expected trees describe the intended no-`ERROR` parse shape; they are expected
to fail until `grammar.js` learns the corresponding syntax.

| Corpus case | Representative source | Current parser symptom |
| --- | --- | --- |
| `cdef extern namespace option` | `upstream/Cython/Includes/libcpp/vector.pxd:1` | `namespace "std"` becomes an `ERROR` inside `cdef_extern_block`. |
| `C++ cppclass template` | `upstream/Cython/Includes/libcpp/vector.pxd:2` | `cppclass vector[T,ALLOCATOR=*]` is parsed as a broken `cdef_statement`. |
| `C++ constructors, operators, and except plus` | `upstream/Cython/Includes/libcpp/vector.pxd:13` | constructor declarations, `operator*`, and `except +` recover as `ERROR`/Python expressions. |
| `templated C function declaration` | `upstream/Cython/Includes/libcpp/algorithm.pxd:8` | `all_of[Iter, Pred](...)` splits into a variable declaration plus stray list/call nodes. |
| `forward ctypedef struct` | `upstream/Cython/Includes/cpython/bytes.pxd:4` | `ctypedef struct va_list` needs a body/name shape the grammar does not support. |
| `renamed ctypedef struct body` | `upstream/Cython/Utility/MemoryView.pyx:18` | Cython C-name string after a struct name is parsed as an `ERROR`. |
| `cdef struct body` | `upstream/Cython/Includes/posix/resource.pxd:30` | `cdef struct rlimit:` is recovered as a bad `cdef_statement`. |
| `bare struct body` | `upstream/Cython/Includes/libc/time.pxd:8` | `struct timespec:` is not accepted as a C declaration block item. |
| `cdef union body` | `upstream/Cython/Includes/posix/signal.pxd:6` | `cdef union sigval:` follows the same unsupported path as `cdef struct`. |
| `cdef enum body` | `upstream/numpy/__init__.pxd:104` | `cdef enum NPY_TYPES:` is parsed as assignment/error recovery. |
| `anonymous cdef enum body` | `upstream/Cython/Includes/cpython/buffer.pxd:5` | `cdef enum:` without a name is not supported. |
| `ctypedef enum values` | `upstream/lxml/includes/tree.pxd:26` | enum members with `= integer` parse as Python assignments, not enum members. |
| `unnamed C parameters` | `upstream/Cython/Includes/libc/math.pxd:28` | declarations like `float acosf(float)` create missing parameter names. |
| `C varargs declaration` | `upstream/Cython/Includes/cpython/exc.pxd:123` | `...` inside C parameters becomes an `ERROR`/ellipsis expression. |
| `function pointer typedef` | `upstream/lxml/includes/xmlerror.pxd:841` | `ctypedef void (*func)(...)` is parsed as nested Python calls. |
| `function pointer parameter` | `upstream/Cython/Includes/libc/stdlib.pxd:38` | `void (*function)()` inside parameters is recovered as tuple/list-splat syntax. |
| `C array declarators` | `upstream/numpy/_core/tests/examples/cython/checks.pyx:40` | `ops[3]` is parsed as a separate Python list/subscript after the declaration. |
| `typed cdef block` | `upstream/numpy/_core/tests/examples/cython/checks.pyx:14` | `cdef:` blocks recover as malformed assignment/expressions. |
| `dotted C types` | `upstream/lxml/xmlid.pxi:82` | `tree.xmlHashTable*` and `np.npy_bool` do not parse as `c_type`. |
| `untyped public class attributes` | `upstream/Cython/Plex/Scanners.pxd:10` | `cdef public stream` lacks an accepted type/name split. |
| `pxd cdef and cpdef method declarations` | `upstream/Cython/Plex/Actions.pxd:2` | body-less `cdef perform(...)` and `cpdef add(...)` are not accepted in `.pxd` classes. |
| `pxd default star parameter` | `upstream/Cython/Compiler/Code.pxd:10` | `replace_empty_lines=*` becomes an invalid list-splat default. |
| `ctypedef extension class` | `upstream/Cython/Includes/cpython/bool.pxd:8` | `ctypedef class __builtin__.bool [object ...]` parses as subscript/error recovery. |
| `ctypedef extern extension class` | `upstream/Cython/Includes/cpython/datetime.pxd:43` | `ctypedef extern class ...[object ...]` is split into a typedef plus broken subscript. |
| `public extension class with cname spec` | `upstream/lxml/classlookup.pxi:6` | `cdef public class ... [type ..., object ...]` is not supported. |
| `cdef public api function` | `upstream/lxml/public-api.pxi:3` | `public api` function modifiers parse as a variable declaration plus stray call. |
| `Cython typed Python parameter` | `upstream/numpy/random/_examples/cython/extending.pyx:18` | `def uniform_mean(Py_ssize_t n)` creates an `ERROR` in Python parameters. |
| `Cython typed keyword parameter` | `upstream/lxml/cleanup.pxi:74` | `bint with_tail=True` is split into an error plus normal default parameter. |
| `Cython not None parameter` | `upstream/lxml/xinclude.pxi:27` | `_Element node not None` is not recognized as a parameter constraint. |
| `C cast expression` | `upstream/lxml/proxy.pxi:14` | `<_Element>c_node` parses as comparison/error recovery. |
| `dotted pointer C cast expression` | `upstream/lxml/xpath.pxi:32` | `<xpath.xmlXPathContext*>ctxt` creates an `ERROR` before a binary expression. |
| `C char literal prefix` | `upstream/lxml/objectify.pyx:63` | `c'.'` is tokenized as an identifier plus string, not a C string literal. |
| `function with gil modifier` | `upstream/lxml/xslt.pxi:67` | `with gil` after a cdef function signature becomes an `ERROR`. |
| `extern declaration statement` | `upstream/Cython/Includes/openmp.pxd:13` | leading `extern void ... nogil` is parsed as plain identifiers/calls. |
| `Cython utility template placeholders` | `upstream/Cython/Utility/CpdefEnums.pyx:19` | `{{name}}` placeholders parse as nested Python set literals. |
| `inline C code in extern block` | `upstream/Cython/Includes/libc/threads.pxd:4` | raw C string blocks inside `cdef extern from *` are not statement-wrapped consistently. |
| `C alias function declaration` | `upstream/Cython/Includes/cpython/contextvars.pxd:85` | C-name string before parameter list is treated as a separate string/call. |
| `C alias object declaration` | `upstream/Cython/Utility/MemoryView.pyx:95` | C-name string after a `cdef object` declarator becomes a separate string statement. |
| `noexcept function pointer typedef` | `upstream/Cython/Includes/libc/signal.pxd:3` | `noexcept nogil` on a function pointer typedef is recovered as identifiers after an error. |
