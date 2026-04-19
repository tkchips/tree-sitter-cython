
# Extension types

# ==============================================================
# Cython class
# ==============================================================

cdef class Shrubbery_0:
    cdef int width
    cdef int height

    def __init__(self, w, h):
        self.width = w
        self.height = h

# ==============================================================
# Cython Static Attributes
# ==============================================================

cdef class Shrubbery_1:
    cdef public int width, height

    cdef readonly float depth

# ==============================================================
# Cython Dynamic Attributes
# ==============================================================

cdef class Animal:
    cdef int number_of_legs
    def __init__(self, int number_of_legs):
        self.number_of_legs = number_of_legs

class ExtendableAnimal(Animal):
    pass

dog = ExtendableAnimal(4)
dog.has_tail = True

# ==============================================================
# Cython Dynamic Attributes 2
# ==============================================================

cdef Shrubbery another_shrubbery(Shrubbery sh1):
    cdef Shrubbery sh2
    return sh2

# ==============================================================
# Type Testing and Casting
# ==============================================================

print( (<Shrubbery>quest()).width )
print( (<Shrubbery?>quest()).width )

# ==============================================================
# Python function declared as an extension type with a not None clause
# ==============================================================

def widen_shrubbery(Shrubbery sh not None, extra_width):
    sh.width = sh.width + extra_width

# ==============================================================
# C Method in Cython class
# ==============================================================

cdef class Parrot:
    cdef void describe(self):
        pass


cdef class Norwegian(Parrot):
    cdef void describe(self):
        Parrot.describe(self)
        pass

# ==============================================================
# Cython GIL
# ==============================================================

with nogil:
    pass

with gil:
    pass

# ==============================================================
# Function with gil
# ==============================================================

cdef void my_callback(void *data) with gil:
    pass

# ==============================================================
# Conditional Acquiring / Releasing the GIL
# ==============================================================

with nogil(True):
    pass

with gil(False):
    pass

# ==============================================================
# Declaring a function as callable without the GIL
# ==============================================================

cdef void my_gil_free_func(int spam) nogil:
    pass

# ==============================================================
# Fused Types 1
# ==============================================================

ctypedef fused char_or_float:
    char
    double

cpdef char_or_float plus_one(char_or_float var):
    return var + 1

# ==============================================================
# Fused Types 2
# ==============================================================

ctypedef double my_double
ctypedef fused fused_type:
    int
    my_double

# ==============================================================
# Using Fused Types
# ==============================================================

cdef cfunc(my_fused_type arg1, my_fused_type arg2):
    return arg1 + arg2

# ==============================================================
# Fused Types and Arrays
# ==============================================================

cdef myfunc(fused_type[:, :] x):
   pass

cdef otherfunc(fused_type *x):
    pass

# ==============================================================
# Fused Types 3
# ==============================================================

ctypedef fused my_fused_type:
    int[:, ::1]
    float[:, ::1]

def func(my_fused_type array):
    print("func called:", cython.typeof(array))

func["int[:, ::1]"](myarray)


# ==============================================================
# Fused Types 4
# ==============================================================

myfunc[int](fused_type)

# ==============================================================
# Fused Types 5
# ==============================================================

(<object (*)(float, int)> myfunc)(f, i)

# ==============================================================
Type Checking Specializations
# ==============================================================

cdef cython.integral myfunc(cython.integral i, bunch_of_types s):
    
    if cython.integral is int:
        print('i is int')
    elif cython.integral is long:
        print('i is long')
    else:
        print('i is short')

    if bunch_of_types in string_t:
        print("s is a string!")
    return i * 2

# ==============================================================
Conditional GIL Acquiring / Releasing
# ==============================================================

ctypedef fused double_or_object:
    double
    object

def increment(double_or_object x):
    with nogil(double_or_object is not object):
        x = x + 1
    return x
