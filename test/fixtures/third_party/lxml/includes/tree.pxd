# Reduced from lxml's includes/tree.pxd declaration style.

from libc cimport stdio
from libc.string cimport const_char, const_uchar

cdef extern from "libxml/xmlstring.h":
    ctypedef unsigned char xmlChar
    ctypedef const xmlChar const_xmlChar "const xmlChar"
    cdef int xmlStrlen(const_xmlChar* str) nogil
    cdef xmlChar* xmlStrdup(const_xmlChar* cur) nogil
    cdef const_xmlChar* _xcstr "(const xmlChar*)PyBytes_AS_STRING" (object s)

cdef extern from "libxml/encoding.h":
    ctypedef enum xmlCharEncoding:
        XML_CHAR_ENCODING_ERROR = -1
        XML_CHAR_ENCODING_NONE = 0
        XML_CHAR_ENCODING_UTF8 = 1

    ctypedef struct xmlCharEncodingHandler
    cdef xmlCharEncodingHandler* xmlFindCharEncodingHandler(char* name) nogil
    ctypedef int (*xmlCharEncodingOutputFunc)(
        unsigned char *out_buf,
        int *outlen,
        const_uchar *in_buf,
        int *inlen,
    )

cdef extern from "libxml/tree.h":
    ctypedef struct xmlDoc
    ctypedef struct xmlAttr

    ctypedef enum xmlElementType:
        XML_ELEMENT_NODE = 1
        XML_ATTRIBUTE_NODE = 2
        XML_TEXT_NODE = 3

    ctypedef struct xmlNs:
        const_xmlChar* href
        const_xmlChar* prefix
        xmlNs* next

    ctypedef struct xmlNode:
        void* _private
        xmlElementType type
        const_xmlChar* name
        xmlNode* children
        xmlNode* parent
        xmlDoc* doc
        xmlAttr* properties
        xmlNs* ns
