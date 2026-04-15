# Cython `cppclass` Operator Overloading Support Test Report

## Overview

- Test target: system-installed `Cython version 0.29.14`
- Test method: generate a minimal `.pxd + .pyx` pair for each operator, then use `cython --cplus` to verify whether the `cppclass` declaration syntax is accepted
- Generated at: 2026-04-15 10:14:41 UTC
- Summary: ✅ 29 / 50, ❌ 21 / 50

## Quick Conclusions

- `Cython 0.29.14` supports only a subset of classic operator declarations. Common arithmetic, comparison, assignment, subscript, call, and comma operators are accepted.
- `operator->`, `operator->*`, conversion operators, `operator new/delete`, `operator<=>`, and `operator co_await` are not supported.
- This test verifies whether declarations can be written inside `cppclass`; it does not validate full C++ semantic correctness or runtime call behavior.

## Details

| Category | Operator | Declaration Probe | Result | First Message | Notes |
| --- | --- | --- | --- | --- | --- |
| Arithmetic | unary + | `Ops operator+() except +` | ✅ Supported |  |  |
| Arithmetic | unary - | `Ops operator-() except +` | ✅ Supported |  |  |
| Arithmetic | binary + | `Ops operator+(Ops) except +` | ✅ Supported |  |  |
| Arithmetic | binary - | `Ops operator-(Ops) except +` | ✅ Supported |  |  |
| Arithmetic | binary * | `Ops operator*(Ops) except +` | ✅ Supported |  |  |
| Arithmetic | binary / | `Ops operator/(Ops) except +` | ✅ Supported |  |  |
| Arithmetic | binary % | `Ops operator%(Ops) except +` | ✅ Supported |  |  |
| Bitwise | unary ~ | `Ops operator~() except +` | ✅ Supported |  |  |
| Bitwise | binary & | `Ops operator&(Ops) except +` | ✅ Supported |  |  |
| Bitwise | binary \| | `Ops operator\|(Ops) except +` | ✅ Supported |  |  |
| Bitwise | binary ^ | `Ops operator^(Ops) except +` | ✅ Supported |  |  |
| Shift | binary << | `Ops operator<<(int) except +` | ✅ Supported |  |  |
| Shift | binary >> | `Ops operator>>(int) except +` | ✅ Supported |  |  |
| Assignment | operator = | `Ops& operator=(Ops) except +` | ✅ Supported |  |  |
| Assignment | operator += | `Ops& operator+=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '+=' not yet supported. |  |
| Assignment | operator -= | `Ops& operator-=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '-=' not yet supported. |  |
| Assignment | operator *= | `Ops& operator*=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '*=' not yet supported. |  |
| Assignment | operator /= | `Ops& operator/=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '/=' not yet supported. |  |
| Assignment | operator %= | `Ops& operator%=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '%=' not yet supported. |  |
| Assignment | operator &= | `Ops& operator&=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '&=' not yet supported. |  |
| Assignment | operator \|= | `Ops& operator\|=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '\|=' not yet supported. |  |
| Assignment | operator ^= | `Ops& operator^=(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '^=' not yet supported. |  |
| Assignment | operator <<= | `Ops& operator<<=(int) except +` | ❌ Not supported | ops_operator.pxd:4:24: Overloading operator '<<=' not yet supported. |  |
| Assignment | operator >>= | `Ops& operator>>=(int) except +` | ❌ Not supported | ops_operator.pxd:4:24: Overloading operator '>>=' not yet supported. |  |
| Comparison | operator == | `bint operator==(Ops) except +` | ✅ Supported |  |  |
| Comparison | operator != | `bint operator!=(Ops) except +` | ✅ Supported |  |  |
| Comparison | operator < | `bint operator<(Ops) except +` | ✅ Supported |  |  |
| Comparison | operator > | `bint operator>(Ops) except +` | ✅ Supported |  |  |
| Comparison | operator <= | `bint operator<=(Ops) except +` | ✅ Supported |  |  |
| Comparison | operator >= | `bint operator>=(Ops) except +` | ✅ Supported |  |  |
| Logical | operator ! | `bint operator!() except +` | ✅ Supported |  |  |
| Logical | operator && | `bint operator&&(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '&&' not yet supported. |  |
| Logical | operator \|\| | `bint operator\|\|(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:23: Overloading operator '\|\|' not yet supported. |  |
| Increment | prefix ++ | `Ops& operator++() except +` | ✅ Supported |  |  |
| Increment | postfix ++ | `Ops operator++(int) except +` | ✅ Supported |  |  |
| Increment | prefix -- | `Ops& operator--() except +` | ✅ Supported |  |  |
| Increment | postfix -- | `Ops operator--(int) except +` | ✅ Supported |  |  |
| Access | operator [] | `int operator[](int) except +` | ✅ Supported |  |  |
| Access | operator () | `int operator()() except +` | ✅ Supported |  |  |
| Access | operator , | `Ops operator,(Ops) except +` | ✅ Supported |  |  |
| Pointer-like | operator * | `int operator*() except +` | ✅ Supported |  | Uses unary dereference form. |
| Pointer-like | operator -> | `Ops operator->() except +` | ❌ Not supported | ops_operator.pxd:4:22: Overloading operator '->' not yet supported. |  |
| Pointer-like | operator ->* | `int operator->*(int) except +` | ❌ Not supported | ops_operator.pxd:4:22: Overloading operator '->' not yet supported. | The probe focuses on parser acceptance, not on the C++ semantic correctness of the placeholder argument. |
| Memory | operator new | `void* operator new(size_t) except +` | ❌ Not supported | ops_operator_new.pxd:5:23: Overloading operator 'new' not yet supported. |  |
| Memory | operator delete | `void operator delete(void*) except +` | ❌ Not supported | ops_operator_delete.pxd:4:22: Overloading operator 'delete' not yet supported. |  |
| Memory | operator new[] | `void* operator new[](size_t) except +` | ❌ Not supported | ops_operator_new.pxd:5:23: Overloading operator 'new' not yet supported. |  |
| Memory | operator delete[] | `void operator delete[](void*) except +` | ❌ Not supported | ops_operator_delete.pxd:4:22: Overloading operator 'delete' not yet supported. |  |
| Conversion | operator int | `int operator int() except +` | ❌ Not supported | ops_operator_int.pxd:4:21: Overloading operator 'int' not yet supported. |  |
| C++20 | operator <=> | `int operator<=>(Ops) except +` | ❌ Not supported | ops_operator.pxd:4:22: Syntax error in C variable declaration |  |
| C++20 | operator co_await | `Ops operator co_await() except +` | ❌ Not supported | ops_operator_co_await.pxd:4:21: Overloading operator 'co_await' not yet supported. |  |

## Out of Scope

- User-defined literals such as `operator""...` are not `cppclass` member operators, so they were not included in this run.
- Constructs such as `?:`, `.`, `.*`, `::`, and `sizeof` are not overloadable in C++ to begin with, so they were also excluded.

## Reproduction Command

```bash
python3 scripts/test_cppclass_operators.py --report reports/cython_cppclass_operator_report.md --json reports/cython_cppclass_operator_report.json
```
