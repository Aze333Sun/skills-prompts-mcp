"""
Mermaid 图表渲染为 PNG 的可复用脚本

用法：
    python render_mermaid.py input.md output_dir [-p PREFIX] [-q]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# 同时支持 ``` 和 ~~~ 围栏，容忍 CRLF
MERMAID_BLOCK_RE = re.compile(
    r"^(?:```|~~~)mermaid[ \t]*\r?\n(.*?)^(?:```|~~~)[ \t]*$",
    re.MULTILINE | re.DOTALL | re.IGNORECASE,
)


def _setup_stdout() -> None:
    """在 Windows 上尽量保证输出 UTF-8，失败也无所谓。"""
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass


def extract_mermaid_blocks(md_text: str) -> list[str]:
    """从 Markdown 文本中提取所有 Mermaid 代码块。"""
    return [m.group(1).rstrip() for m in MERMAID_BLOCK_RE.finditer(md_text)]


def render_mermaid_to_png(mermaid_code: str, output_path: Path) -> tuple[bool, str]:
    """渲染单个 Mermaid 代码为 PNG。

    返回 (是否成功, 错误信息)。
    """
    try:
        from mermaid import Mermaid
        from mermaid.graph import Graph
    except ImportError as e:
        return False, f"缺少依赖 mermaid-py（pip install mermaid-py）：{e}"

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        # Graph 名字用 ASCII，避免中文/特殊字符引发的问题
        graph = Graph("mermaid", mermaid_code)
        Mermaid(graph).to_png(str(output_path))
        return True, ""
    except Exception as e:
        return False, f"{type(e).__name__}: {e}"


def render_all(
    blocks: list[str], output_dir: Path, prefix: str, quiet: bool = False
) -> tuple[int, int]:
    """批量渲染，返回 (成功数, 失败数)。"""
    ok = fail = 0
    for i, code in enumerate(blocks, 1):
        out = output_dir / f"{prefix}_{i}.png"
        success, err = render_mermaid_to_png(code, out)
        if success:
            ok += 1
            if not quiet:
                print(f"OK  : {out}")
        else:
            fail += 1
            print(f"FAIL: {out} -> {err}", file=sys.stderr)
    return ok, fail


def main(argv: list[str] | None = None) -> int:
    _setup_stdout()

    parser = argparse.ArgumentParser(
        description="把 Markdown 中的 Mermaid 代码块渲染成 PNG"
    )
    parser.add_argument("input_md", type=Path, help="输入 Markdown 文件")
    parser.add_argument("output_dir", type=Path, help="输出目录")
    parser.add_argument("-p", "--prefix", default="chart", help="输出文件名前缀（默认 chart）")
    parser.add_argument("-q", "--quiet", action="store_true", help="只输出失败信息")
    args = parser.parse_args(argv)

    if not args.input_md.is_file():
        print(f"错误：找不到文件 {args.input_md}", file=sys.stderr)
        return 1

    text = args.input_md.read_text(encoding="utf-8")
    blocks = extract_mermaid_blocks(text)
    print(f"共发现 {len(blocks)} 个 mermaid 代码块")

    if not blocks:
        print("没有可渲染的 mermaid 代码块")
        return 0

    args.output_dir.mkdir(parents=True, exist_ok=True)
    ok, fail = render_all(blocks, args.output_dir, args.prefix, args.quiet)

    print(f"\n完成：成功 {ok}，失败 {fail}")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
