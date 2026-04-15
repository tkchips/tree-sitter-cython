# Cython `cppclass` 运算符重载支持测试报告

## 概览 😺

- 测试对象：系统安装的 `Cython version 0.29.14`
- 测试方式：为每个运算符单独生成一个最小 `.pxd + .pyx`，使用 `cython --cplus` 验证 `cppclass` 声明语法是否被接受
- 生成时间：2026-04-15 10:14:41 UTC
- 结果汇总：✅ 29 / 50，❌ 21 / 50

## 结论速览 🚦

- `Cython 0.29.14` 只支持一部分经典运算符声明，常见算术、比较、赋值、下标、调用、逗号都可以。🎯
- `operator->`、`operator->*`、转换运算符、`operator new/delete`、`operator<=>`、`operator co_await` 不支持。🚫
- 这个测试验证的是 `cppclass` 中“声明能不能写”，不是 C++ 语义完整性，也不是运行时调用行为。🧪

## 明细 📋

| 分类 | 运算符 | 声明探针 | 结果 | 首条信息 | 备注 |
| --- | --- | --- | --- | --- | --- |
| Arithmetic | unary + | `Ops operator+() except +` | ✅ 支持 |  |  |
| Arithmetic | unary - | `Ops operator-() except +` | ✅ 支持 |  |  |
| Arithmetic | binary + | `Ops operator+(Ops) except +` | ✅ 支持 |  |  |
| Arithmetic | binary - | `Ops operator-(Ops) except +` | ✅ 支持 |  |  |
| Arithmetic | binary * | `Ops operator*(Ops) except +` | ✅ 支持 |  |  |
| Arithmetic | binary / | `Ops operator/(Ops) except +` | ✅ 支持 |  |  |
| Arithmetic | binary % | `Ops operator%(Ops) except +` | ✅ 支持 |  |  |
| Bitwise | unary ~ | `Ops operator~() except +` | ✅ 支持 |  |  |
| Bitwise | binary & | `Ops operator&(Ops) except +` | ✅ 支持 |  |  |
| Bitwise | binary \| | `Ops operator\|(Ops) except +` | ✅ 支持 |  |  |
| Bitwise | binary ^ | `Ops operator^(Ops) except +` | ✅ 支持 |  |  |
| Shift | binary << | `Ops operator<<(int) except +` | ✅ 支持 |  |  |
| Shift | binary >> | `Ops operator>>(int) except +` | ✅ 支持 |  |  |
| Assignment | operator = | `Ops& operator=(Ops) except +` | ✅ 支持 |  |  |
| Assignment | operator += | `Ops& operator+=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '+=' not yet supported. |  |
| Assignment | operator -= | `Ops& operator-=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '-=' not yet supported. |  |
| Assignment | operator *= | `Ops& operator*=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '*=' not yet supported. |  |
| Assignment | operator /= | `Ops& operator/=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '/=' not yet supported. |  |
| Assignment | operator %= | `Ops& operator%=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '%=' not yet supported. |  |
| Assignment | operator &= | `Ops& operator&=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '&=' not yet supported. |  |
| Assignment | operator \|= | `Ops& operator\|=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '\|=' not yet supported. |  |
| Assignment | operator ^= | `Ops& operator^=(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '^=' not yet supported. |  |
| Assignment | operator <<= | `Ops& operator<<=(int) except +` | ❌ 不支持 | ops_operator.pxd:4:24: Overloading operator '<<=' not yet supported. |  |
| Assignment | operator >>= | `Ops& operator>>=(int) except +` | ❌ 不支持 | ops_operator.pxd:4:24: Overloading operator '>>=' not yet supported. |  |
| Comparison | operator == | `bint operator==(Ops) except +` | ✅ 支持 |  |  |
| Comparison | operator != | `bint operator!=(Ops) except +` | ✅ 支持 |  |  |
| Comparison | operator < | `bint operator<(Ops) except +` | ✅ 支持 |  |  |
| Comparison | operator > | `bint operator>(Ops) except +` | ✅ 支持 |  |  |
| Comparison | operator <= | `bint operator<=(Ops) except +` | ✅ 支持 |  |  |
| Comparison | operator >= | `bint operator>=(Ops) except +` | ✅ 支持 |  |  |
| Logical | operator ! | `bint operator!() except +` | ✅ 支持 |  |  |
| Logical | operator && | `bint operator&&(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '&&' not yet supported. |  |
| Logical | operator \|\| | `bint operator\|\|(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:23: Overloading operator '\|\|' not yet supported. |  |
| Increment | prefix ++ | `Ops& operator++() except +` | ✅ 支持 |  |  |
| Increment | postfix ++ | `Ops operator++(int) except +` | ✅ 支持 |  |  |
| Increment | prefix -- | `Ops& operator--() except +` | ✅ 支持 |  |  |
| Increment | postfix -- | `Ops operator--(int) except +` | ✅ 支持 |  |  |
| Access | operator [] | `int operator[](int) except +` | ✅ 支持 |  |  |
| Access | operator () | `int operator()() except +` | ✅ 支持 |  |  |
| Access | operator , | `Ops operator,(Ops) except +` | ✅ 支持 |  |  |
| Pointer-like | operator * | `int operator*() except +` | ✅ 支持 |  | Uses unary dereference form. |
| Pointer-like | operator -> | `Ops operator->() except +` | ❌ 不支持 | ops_operator.pxd:4:22: Overloading operator '->' not yet supported. |  |
| Pointer-like | operator ->* | `int operator->*(int) except +` | ❌ 不支持 | ops_operator.pxd:4:22: Overloading operator '->' not yet supported. | Probe focuses on parser acceptance, not C++ semantic correctness of the placeholder argument. |
| Memory | operator new | `void* operator new(size_t) except +` | ❌ 不支持 | ops_operator_new.pxd:5:23: Overloading operator 'new' not yet supported. |  |
| Memory | operator delete | `void operator delete(void*) except +` | ❌ 不支持 | ops_operator_delete.pxd:4:22: Overloading operator 'delete' not yet supported. |  |
| Memory | operator new[] | `void* operator new[](size_t) except +` | ❌ 不支持 | ops_operator_new.pxd:5:23: Overloading operator 'new' not yet supported. |  |
| Memory | operator delete[] | `void operator delete[](void*) except +` | ❌ 不支持 | ops_operator_delete.pxd:4:22: Overloading operator 'delete' not yet supported. |  |
| Conversion | operator int | `int operator int() except +` | ❌ 不支持 | ops_operator_int.pxd:4:21: Overloading operator 'int' not yet supported. |  |
| C++20 | operator <=> | `int operator<=>(Ops) except +` | ❌ 不支持 | ops_operator.pxd:4:22: Syntax error in C variable declaration |  |
| C++20 | operator co_await | `Ops operator co_await() except +` | ❌ 不支持 | ops_operator_co_await.pxd:4:21: Overloading operator 'co_await' not yet supported. |  |

## 未纳入范围的点 🧭

- 用户自定义字面量 `operator""...` 不是 `cppclass` 成员运算符，这次没有纳入。📝
- `?:`、`.`、`.*`、`::`、`sizeof` 这类本来就不能在 C++ 里重载，也没有纳入。🙅

## 复现命令 🛠️

```bash
python3 scripts/test_cppclass_operators.py --report reports/cython_cppclass_operator_report.md --json reports/cython_cppclass_operator_report.json
```
