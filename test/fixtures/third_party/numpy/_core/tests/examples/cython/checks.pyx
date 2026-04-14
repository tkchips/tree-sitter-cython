# Reduced from NumPy's _core/tests/examples/cython/checks.pyx style.

#cython: language_level=3

cimport numpy as cnp

cnp.import_array()


def get_datetime_iso_8601_strlen():
    return cnp.get_datetime_iso_8601_strlen(0, cnp.NPY_FR_ns)


def convert_datetime64_to_datetimestruct():
    cdef:
        cnp.npy_datetimestruct dts
        cnp.PyArray_DatetimeMetaData meta
        cnp.int64_t value = 1647374515260292

    meta.base = cnp.NPY_FR_us
    meta.num = 1
    cnp.convert_datetime64_to_datetimestruct(&meta, value, &dts)
    return dts


cdef cnp.broadcast multiiter_from_broadcast_obj(object bcast):
    cdef dict iter_map = {
        1: cnp.PyArray_MultiIterNew1,
        2: cnp.PyArray_MultiIterNew2,
        3: cnp.PyArray_MultiIterNew3,
    }
    arrays = [x.base for x in bcast.iters]
    cdef cnp.broadcast result = iter_map[len(arrays)](*arrays)
    return result


cdef cnp.NpyIter* npyiter_from_nditer_obj(object it):
    cdef:
        cnp.NpyIter* cit
        cnp.PyArray_Descr* op_dtypes[3]
        cnp.npy_uint32 op_flags[3]
        cnp.PyArrayObject* ops[3]
        cnp.npy_uint32 flags = 0

    for i in range(it.nop):
        op_flags[i] = cnp.NPY_ITER_READONLY
        op_dtypes[i] = cnp.PyArray_DESCR(it.operands[i])
        ops[i] = <cnp.PyArrayObject*>it.operands[i]

    cit = cnp.NpyIter_MultiNew(
        it.nop,
        &ops[0],
        flags,
        cnp.NPY_KEEPORDER,
        cnp.NPY_NO_CASTING,
        &op_flags[0],
        <cnp.PyArray_Descr**>NULL,
    )
    return cit
