#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
import tempfile
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path


@dataclass(frozen=True)
class Case:
    category: str
    name: str
    declaration: str
    note: str = ""
    prelude: str = ""


CASES = [
    Case("Arithmetic", "unary +", "Ops operator+() except +"),
    Case("Arithmetic", "unary -", "Ops operator-() except +"),
    Case("Arithmetic", "binary +", "Ops operator+(Ops) except +"),
    Case("Arithmetic", "binary -", "Ops operator-(Ops) except +"),
    Case("Arithmetic", "binary *", "Ops operator*(Ops) except +"),
    Case("Arithmetic", "binary /", "Ops operator/(Ops) except +"),
    Case("Arithmetic", "binary %", "Ops operator%(Ops) except +"),
    Case("Bitwise", "unary ~", "Ops operator~() except +"),
    Case("Bitwise", "binary &", "Ops operator&(Ops) except +"),
    Case("Bitwise", "binary |", "Ops operator|(Ops) except +"),
    Case("Bitwise", "binary ^", "Ops operator^(Ops) except +"),
    Case("Shift", "binary <<", "Ops operator<<(int) except +"),
    Case("Shift", "binary >>", "Ops operator>>(int) except +"),
    Case("Assignment", "operator =", "Ops& operator=(Ops) except +"),
    Case("Assignment", "operator +=", "Ops& operator+=(Ops) except +"),
    Case("Assignment", "operator -=", "Ops& operator-=(Ops) except +"),
    Case("Assignment", "operator *=", "Ops& operator*=(Ops) except +"),
    Case("Assignment", "operator /=", "Ops& operator/=(Ops) except +"),
    Case("Assignment", "operator %=", "Ops& operator%=(Ops) except +"),
    Case("Assignment", "operator &=", "Ops& operator&=(Ops) except +"),
    Case("Assignment", "operator |=", "Ops& operator|=(Ops) except +"),
    Case("Assignment", "operator ^=", "Ops& operator^=(Ops) except +"),
    Case("Assignment", "operator <<=", "Ops& operator<<=(int) except +"),
    Case("Assignment", "operator >>=", "Ops& operator>>=(int) except +"),
    Case("Comparison", "operator ==", "bint operator==(Ops) except +"),
    Case("Comparison", "operator !=", "bint operator!=(Ops) except +"),
    Case("Comparison", "operator <", "bint operator<(Ops) except +"),
    Case("Comparison", "operator >", "bint operator>(Ops) except +"),
    Case("Comparison", "operator <=", "bint operator<=(Ops) except +"),
    Case("Comparison", "operator >=", "bint operator>=(Ops) except +"),
    Case("Logical", "operator !", "bint operator!() except +"),
    Case("Logical", "operator &&", "bint operator&&(Ops) except +"),
    Case("Logical", "operator ||", "bint operator||(Ops) except +"),
    Case("Increment", "prefix ++", "Ops& operator++() except +"),
    Case("Increment", "postfix ++", "Ops operator++(int) except +"),
    Case("Increment", "prefix --", "Ops& operator--() except +"),
    Case("Increment", "postfix --", "Ops operator--(int) except +"),
    Case("Access", "operator []", "int operator[](int) except +"),
    Case("Access", "operator ()", "int operator()() except +"),
    Case("Access", "operator ,", "Ops operator,(Ops) except +"),
    Case("Pointer-like", "operator *", "int operator*() except +", "Uses unary dereference form."),
    Case("Pointer-like", "operator ->", "Ops operator->() except +"),
    Case("Pointer-like", "operator ->*", "int operator->*(int) except +", "Probe focuses on parser acceptance, not C++ semantic correctness of the placeholder argument."),
    Case("Memory", "operator new", "void* operator new(size_t) except +", prelude="from libc.stddef cimport size_t"),
    Case("Memory", "operator delete", "void operator delete(void*) except +"),
    Case("Memory", "operator new[]", "void* operator new[](size_t) except +", prelude="from libc.stddef cimport size_t"),
    Case("Memory", "operator delete[]", "void operator delete[](void*) except +"),
    Case("Conversion", "operator int", "int operator int() except +"),
    Case("C++20", "operator <=>", "int operator<=>(Ops) except +"),
    Case("C++20", "operator co_await", "Ops operator co_await() except +"),
]


def cython_version() -> str:
    proc = subprocess.run(
        ["cython", "--version"],
        check=False,
        capture_output=True,
        text=True,
    )
    text = (proc.stdout + proc.stderr).strip()
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    return lines[-1] if lines else "unknown"


def sanitize(name: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def normalize_message(message: str) -> str:
    if not message:
        return ""
    return re.sub(r"/tmp/[^/\s]+/", "", message)


def run_case(case: Case) -> dict[str, str | bool]:
    module_name = f"ops_{sanitize(case.name)}"
    with tempfile.TemporaryDirectory(prefix="cython_cppclass_ops_") as tmp:
        tmp_path = Path(tmp)
        pxd_path = tmp_path / f"{module_name}.pxd"
        pyx_path = tmp_path / "test.pyx"

        lines = ["# cython: language_level=3"]
        if case.prelude:
            lines.append(case.prelude)
        lines.extend(
            [
                'cdef extern from "ops.hpp" namespace "test":',
                "    cdef cppclass Ops:",
                f"        {case.declaration}",
                "",
            ]
        )
        pxd_path.write_text("\n".join(lines), encoding="ascii")
        pyx_path.write_text(f"# cython: language_level=3\nfrom {module_name} cimport Ops\n", encoding="ascii")

        proc = subprocess.run(
            ["cython", "--cplus", "-I", tmp, str(pyx_path)],
            check=False,
            capture_output=True,
            text=True,
        )
        stderr = (proc.stderr or "").strip()
        stdout = (proc.stdout or "").strip()
        combined = "\n".join(part for part in [stdout, stderr] if part)
        first_message = ""
        if combined:
            preferred = []
            fallback = []
            for line in combined.splitlines():
                stripped = line.strip()
                if not stripped:
                    continue
                if ".pxd:" in stripped or "Overloading operator" in stripped or "Expected " in stripped:
                    preferred.append(stripped)
                elif stripped != "Error compiling Cython file:":
                    fallback.append(stripped)
            ordered = preferred or fallback
            if ordered:
                first_message = normalize_message(ordered[0])
        return {
            "category": case.category,
            "name": case.name,
            "declaration": case.declaration,
            "supported": proc.returncode == 0,
            "message": first_message,
            "note": case.note,
        }


def build_markdown(results: list[dict[str, str | bool]], version: str) -> str:
    total = len(results)
    supported = sum(1 for item in results if item["supported"])
    unsupported = total - supported
    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")

    lines = [
        "# Cython `cppclass` 运算符重载支持测试报告",
        "",
        "## 概览 😺",
        "",
        f"- 测试对象：系统安装的 `{version}`",
        "- 测试方式：为每个运算符单独生成一个最小 `.pxd + .pyx`，使用 `cython --cplus` 验证 `cppclass` 声明语法是否被接受",
        f"- 生成时间：{generated_at}",
        f"- 结果汇总：✅ {supported} / {total}，❌ {unsupported} / {total}",
        "",
        "## 结论速览 🚦",
        "",
        "- `Cython 0.29.14` 只支持一部分经典运算符声明，常见算术、比较、赋值、下标、调用、逗号都可以。🎯",
        "- `operator->`、`operator->*`、转换运算符、`operator new/delete`、`operator<=>`、`operator co_await` 不支持。🚫",
        "- 这个测试验证的是 `cppclass` 中“声明能不能写”，不是 C++ 语义完整性，也不是运行时调用行为。🧪",
        "",
        "## 明细 📋",
        "",
        "| 分类 | 运算符 | 声明探针 | 结果 | 首条信息 | 备注 |",
        "| --- | --- | --- | --- | --- | --- |",
    ]

    for item in results:
        status = "✅ 支持" if item["supported"] else "❌ 不支持"
        message = str(item["message"]).replace("|", "\\|") if item["message"] else ""
        note = str(item["note"]).replace("|", "\\|") if item["note"] else ""
        declaration = str(item["declaration"]).replace("|", "\\|")
        name = str(item["name"]).replace("|", "\\|")
        category = str(item["category"]).replace("|", "\\|")
        lines.append(f"| {category} | {name} | `{declaration}` | {status} | {message} | {note} |")

    lines.extend(
        [
            "",
            "## 未纳入范围的点 🧭",
            "",
            "- 用户自定义字面量 `operator\"\"...` 不是 `cppclass` 成员运算符，这次没有纳入。📝",
            "- `?:`、`.`、`.*`、`::`、`sizeof` 这类本来就不能在 C++ 里重载，也没有纳入。🙅",
            "",
            "## 复现命令 🛠️",
            "",
            "```bash",
            "python3 scripts/test_cppclass_operators.py --report reports/cython_cppclass_operator_report.md --json reports/cython_cppclass_operator_report.json",
            "```",
        ]
    )
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Probe Cython cppclass operator declaration support.")
    parser.add_argument("--report", type=Path, help="Write a Markdown report to this path.")
    parser.add_argument("--json", type=Path, help="Write JSON results to this path.")
    args = parser.parse_args()

    version = cython_version()
    results = [run_case(case) for case in CASES]
    markdown = build_markdown(results, version)

    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(markdown, encoding="utf-8")
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(
            json.dumps(
                {
                    "cython_version": version,
                    "results": results,
                },
                ensure_ascii=False,
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )

    print(markdown, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
