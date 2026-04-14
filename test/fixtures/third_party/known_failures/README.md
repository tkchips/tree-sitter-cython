# Known third-party fixture failures

These samples intentionally exercise syntax that may be ahead of the current grammar. Keep them in the main fixture tree so `npm test` exposes parser gaps immediately, then update this note as support lands.

See `ERRORS.md` for the current fixture-to-corpus error map.

Current themes to watch:

- C++ `cppclass` templates, operator declarations, and `except +` signatures.
- Cython typed `cdef:` blocks with C arrays and pointer casts.
- Function pointer typedefs and renamed C declarations.
- Cython utility-template placeholders used in generated support files.
