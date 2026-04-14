# Third-party Cython fixtures

These fixtures are reduced parser inputs based on Cython files from widely used projects. They are not meant to compile; they keep the syntax patterns that are useful for parser regression tests while trimming project-specific dependencies.

The Node test in `bindings/node/third_party_fixtures_test.js` parses every `.pyx`, `.pxd`, and `.pxi` file under this directory and fails if the parse tree contains an `ERROR` node. Some fixtures are expected to fail until the grammar grows support for more Cython and C++ declaration syntax.

Fixture groups:

- `cython/`: declarations modeled after Cython's own includes and utility modules.
- `numpy/`: declarations and examples modeled after NumPy's Cython API tests and random examples.
- `lxml/`: declarations modeled after lxml's libxml include files.
- `upstream/`: copied `.pyx`, `.pxd`, and `.pxi` fixtures from locally installed Cython 3.2.4, NumPy 2.4.3, and lxml 4.9.3 packages, preserving their package-relative paths.
