# Reduced from Cython's libc/math.pxd declaration style.

cdef extern from "math.h" nogil:
    double sin(double x)
    double cos(double x)
    double tan(double x)
    double sqrt(double x)
    double pow(double x, double y)

cdef extern from "math.h":
    double HUGE_VAL
    float HUGE_VALF
    long double HUGE_VALL
