
# Test

# ==============================================================
# C global variable 
# ==============================================================

cdef int a_global_variable_0
cdef int a_global_variable_1 = 42

# ==============================================================
# C local variable in function
# ==============================================================

def func_0():
    cdef int i, j, k
    cdef float f
    cdef float[42] g
    cdef float *h

# ==============================================================
# C local variable with initialization
# ==============================================================

def func_1():
    cdef int i = 42, j, k
    cdef int a = 0, b = 1, c = 2
    cdef float f = 3.14
    cdef float[4] g = [0.0, 1.0, 2.0, 3.0]
    cdef float *h = &f
    cdef double complex z = 1.0 + 2.0j

# ==============================================================
# C base types
# ==============================================================

def func_2():
    cdef bint b
    cdef char c
    cdef signed char sc
    cdef unsigned char uc
    cdef short s
    cdef unsigned short us
    cdef int i
    cdef unsigned int ui
    cdef long l
    cdef unsigned long ul
    cdef long long ll
    cdef unsigned long long ull
    cdef float f
    cdef double d
    cdef long double ld
    cdef float complex f_c
    cdef double complex d_c
    cdef long double complex ld_c
    cdef size_t ss
    cdef Py_ssize_t pss
    cdef Py_hash_t ph
    cdef Py_UCS4 pu

# ==============================================================
# ctypedef statements
# ==============================================================

ctypedef unsigned long ULong
ctypedef int* IntPtr

# ==============================================================
# C Arrays
# ==============================================================

def func_3():
    cdef float[42] g
    cdef int[5][5][5] f
    cdef char[4] *ptr_char_array
    cdef (char *)[4] array_ptr_char
    cdef int[4] arr1, arr2

# ==============================================================
# C Structs
# ==============================================================

cdef struct Point:
    double x
    double y

def func_4():
    cdef Point p
    p.x = 1.0
    p.y = 2.0

cdef packed struct StructArray:
    int[4] spam
    signed char[5] eggs

# ==============================================================
# C Unions
# ==============================================================

cdef union Food:
    int spam
    float eggs

# ==============================================================
# C Enums
# ==============================================================

cdef enum CheeseType:
    cheddar, edam,
    camembert

cdef enum CheeseType_:
    cheddar_ 
    edam_
    camembert_

cdef enum CheeseType__:
    cheddar__, 
    edam__,
    camembert__

cdef enum CheeseState:
    hard = 1 
    soft = 2
    runny = 3

cdef enum CheeseState_:
    hard_ = 1,
    soft_ = 2,
    runny_ = 3

# ==============================================================
# cpdef Enum
# ==============================================================

cpdef enum CheeseState__:
    hard__ = 1
    soft__ = 2
    runny__ = 3

# ==============================================================
# C tuple like
# ==============================================================

cdef (double, int) bar

# ==============================================================
# C type qualifiers
# ==============================================================

def use_qualifiers():
    cdef volatile int i = 5
    cdef const int a
    cdef const int *value1
    cdef int * const value2
    cdef const int * const value3

# ==============================================================
# C Extern Types TODO
# ==============================================================

cdef class Shrubbery:
    cdef int width
    cdef int height

    def __init__(self, w, h):
        self.width = w
        self.height = h

    def describe(self):
        print("This shrubbery is", self.width,
              "by", self.height, "cubits.")

# ==============================================================
# Grouping multiple C declarations
# ==============================================================

cdef:
    struct Spam:
        int tons

    int i
    float a
    Spam *p

    void f(Spam *s) except *:
        print(s.tons, "Tons of spam")

# ==============================================================
# C functions
# ==============================================================

def spam(int i, char *s):
    pass

cdef int eggs(unsigned long l, float f):
    pass

# ==============================================================
# C functions with tuple like return type
# ==============================================================

cdef (int, float) chips((long, long, double) t):
    pass

# ==============================================================
# Python functions with Python types in parameters
# ==============================================================

def spam(python_i, python_s):
    cdef int i = python_i
    cdef char* s = python_s

# ==============================================================
# Python objects as parameters and return values
# ==============================================================

cdef eggs1(x, y):
    pass

# ==============================================================
# Python objects as parameters and return values with type annotations
# ==============================================================

# I know that the following code is vaild Cython code

# cdef object ftang(object int):

# ==============================================================
# Optional Arguments
# ==============================================================

cdef class A:
    cdef foo(self):
        pass


cdef class B(A):
    cdef foo(self, x=None):
        pass


cdef class C(B):
    cpdef foo(self, x=True, int k=3):
        pass
    
# ==============================================================
# Optional Arguments in functions declarations TODO: only in pxd
# ==============================================================

# cdef class B(A):
#     cdef foo(self, x=*)

# cdef class C(B):
#     cpdef foo(self, x=*, int k=*)

# ==============================================================
# Terminate the list of positional arguments
# =============================================================

def g(a, b, *, c, d):
    pass

# ==============================================================
# Keyword-only Arguments
# ==============================================================

def ff(a, b, *args, c, d = 42, e, **kwds):
    pass

# ==============================================================
# Functions Pointers
# ==============================================================

cdef int(*ptr_add)(int, int)

cdef struct Bar:
    int sum(int a, int b)

# ==============================================================
# Error return values
# ==============================================================

cdef int func_with_error() except -1:
    pass

cdef int func_with_error_0() except? -1:
    pass

cdef int func_with_error_1() except *:
    pass

# Only extern functions can throw C++ exceptions.
# cdef int func_with_error_2() except +:
#     pass

cdef int func_without_error() noexcept:
    pass

# ==============================================================
# type casting
# ==============================================================
cdef char *char_ptr
cdef float *float_ptr
float_ptr = <float*>char_ptr