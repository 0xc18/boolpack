# cython: boundscheck=False, wraparound=False, initializedcheck=False
import struct
from libc.stdint cimport uint8_t, uint16_t

cdef dict VERSION_TO_BITS = {
    1: 128,
    2: 256,
    3: 1024,
}

cdef list VERSIONS = [
    (1, 128),
    (2, 256),
    (3, 1024),
]


def bools_to_bytes(list bools):
    cdef Py_ssize_t length = len(bools)
    cdef int version = 0
    cdef int max_bits = 0

    for version, max_bits in VERSIONS:
        if length <= max_bits:
            break
    else:
        raise ValueError("list too large (max 1024 bits)")

    cdef Py_ssize_t nbytes = (max_bits + 7) // 8
    cdef bytearray data = bytearray(nbytes)

    cdef Py_ssize_t i
    for i in range(length):
        if bools[i]:
            data[i >> 3] |= <uint8_t>(1 << (i & 7))

    return struct.pack("<BH", version, <uint16_t>length) + data


def bytes_to_bools(bytes blob):
    if len(blob) < 3:
        raise ValueError("data too short")

    cdef uint8_t version
    cdef uint16_t length
    version, length = struct.unpack_from("<BH", blob, 0)

    if version not in VERSION_TO_BITS:
        raise ValueError("unknown version")

    cdef int max_bits = VERSION_TO_BITS[version]
    cdef Py_ssize_t expected_bytes = (max_bits + 7) // 8

    cdef bytes data = blob[3:]
    if len(data) != expected_bytes:
        raise ValueError("invalid data size")

    cdef list out = [False] * length
    cdef Py_ssize_t i
    for i in range(length):
        out[i] = (data[i >> 3] & (1 << (i & 7))) != 0

    return out
