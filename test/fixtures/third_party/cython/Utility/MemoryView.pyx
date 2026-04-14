# Reduced from Cython's MemoryView.pyx utility style.

# cython: language_level=3
# cython: binding=False

cimport cython

cdef extern from "Python.h":
    ctypedef struct PyObject
    int PyIndex_Check(object)
    PyObject *PyExc_IndexError

cdef extern from *:
    ctypedef struct __pyx_memoryview "__pyx_memoryview_obj":
        Py_buffer view
        PyObject *obj
        const __Pyx_TypeInfo *typeinfo

    ctypedef struct {{memviewslice_name}}:
        __pyx_memoryview *memview
        char *data
        Py_ssize_t shape[{{max_dims}}]
        Py_ssize_t strides[{{max_dims}}]

    void __PYX_INC_MEMVIEW({{memviewslice_name}} *memslice, int have_gil)

@cython.collection_type("sequence")
@cname("__pyx_array")
cdef class array:
    cdef:
        char *data
        Py_ssize_t len
        char *format
        int ndim
        Py_ssize_t *_shape
        Py_ssize_t *_strides

    cdef get_memview(self):
        return self
