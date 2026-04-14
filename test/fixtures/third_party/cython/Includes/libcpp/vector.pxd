# Reduced from Cython's libcpp/vector.pxd declaration style.

cdef extern from "<vector>" namespace "std" nogil:
    cdef cppclass vector[T, ALLOCATOR=*]:
        ctypedef T value_type
        ctypedef ALLOCATOR allocator_type
        ctypedef size_t size_type
        ctypedef ptrdiff_t difference_type

        cppclass iterator:
            iterator() except +
            iterator(iterator&) except +
            T& operator*()
            iterator operator++()
            iterator operator--()
            difference_type operator-(iterator)
            bint operator==(iterator)
            bint operator!=(iterator)

        vector() except +
        vector(size_type, const T&) except +
        vector& vector[InputIt](InputIt, InputIt) except +
        void assign[InputIt](InputIt, InputIt) except +

        iterator begin()
        iterator end()
        bint empty()
        size_type size()
        void push_back(const T&) except +
        T& operator[](size_type)
        T* data()
