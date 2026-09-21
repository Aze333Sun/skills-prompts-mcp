"""
Mermaid 图表渲染为 PNG 的可复用脚本

用法：
    python render_mermaid.py input.md output_dir [-p PREFIX] [-q] [--mode {online,local}]

渲染模式：
    online  (默认) 使用 mermaid-py + mermaid.ink 在线服务
                       —— 需联网，且图表文本会上传至第三方服务。
    local           使用 Playwright + Chromium 本地离线渲染
                       —— 离线/内网可用，图表内容不外传，适合敏感业务。
                       —— 需额外安装：pip install playwright && playwright install chromium
                       —— mermaid.min.js 优先读取本地 assets/mermaid.min.js；
                          缺失时首次自动从 CDN 拉取并缓存（缓存后完全离线可用）。
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.request
from pathlib import Path

# 同时支持 ``` 和 ~~~ 围栏，容忍 CRLF
MERMAID_BLOCK_RE = re.compile(
    r"^(?:```|~~~)mermaid[ \t]*\r?\n(.*?)^(?:```|~~~)[ \t]*$",
    re.MULTILINE | re.DOTALL | re.IGNORECASE,
)

# mermaid.min.js 的 CDN 来源（仅首次本地缓存时联网）
MERMAID_CDN_URL = "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"

# 脚本所在目录（用于缓存 assets/mermaid.min.js）
SCRIPT_DIR = Path(__file__).resolve().parent
ASSETS_DIR = SCRIPT_DIR / "assets"


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


# --------------------------------------------------------------------------- #
# 在线模式：mermaid-py + mermaid.ink
# --------------------------------------------------------------------------- #
def _render_online(mermaid_code: str, output_path: Path) -> tuple[bool, str]:
    """渲染单个 Mermaid 代码为 PNG（在线 mermaid.ink 服务）。"""
    try:
        from mermaid import Mermaid
        from mermaid.graph import Graph
    except ImportError as e:
        return False, f"缺少依赖 mermaid-py（请执行 pip install -r requirements.txt）：{e}"

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        # Graph 名字用 ASCII，避免中文/特殊字符引发的问题
        graph = Graph("mermaid", mermaid_code)
        Mermaid(graph).to_png(str(output_path))
        return True, ""
    except Exception as e:
        # 针对常见失败场景给出可操作提示，帮助调用方走「渲染失败分支」
        msg = str(e)
        low = msg.lower()
        hint = ""
        if "importerror" in low or "modulenotfound" in low:
            hint = "（缺少 mermaid-py，请执行 pip install -r requirements.txt）"
        elif "ink" in low or "connection" in low or "timeout" in low or "connect" in low:
            hint = ("（疑似离线/内网导致 mermaid.ink 在线渲染不可达；"
                    "请改用本地离线模式：python render_mermaid.py ... --mode local）")
        return False, f"{type(e).__name__}: {msg}{hint}"


# --------------------------------------------------------------------------- #
# 本地离线模式：Playwright + Chromium
# --------------------------------------------------------------------------- #
def _get_mermaid_js() -> tuple[str | None, str]:
    """获取 mermaid.min.js 文本。

    返回 (js_text, error)。优先级：
        1. 环境变量 MERMAID_JS_PATH 指向的本地文件
        2. 脚本同目录 assets/mermaid.min.js（缓存）
        3. 上述均无则首次从 CDN 拉取并缓存（之后离线可用）
    """
    candidates: list[Path] = []
    env_path = os.environ.get("MERMAID_JS_PATH")
    if env_path:
        candidates.append(Path(env_path))
    candidates.append(ASSETS_DIR / "mermaid.min.js")

    for p in candidates:
        if p.is_file():
            try:
                return p.read_text(encoding="utf-8"), ""
            except Exception as e:  # noqa: BLE001
                return None, f"读取本地 mermaid.min.js 失败（{p}）：{e}"

    # 未找到本地文件：尝试从 CDN 拉取并缓存（仅需联网一次）
    try:
        ASSETS_DIR.mkdir(parents=True, exist_ok=True)
        cache = ASSETS_DIR / "mermaid.min.js"
        print(f"本地未找到 mermaid.min.js，首次从 CDN 拉取并缓存到 {cache} ...",
              file=sys.stderr)
        req = urllib.request.Request(
            MERMAID_CDN_URL, headers={"User-Agent": "render_mermaid/1.0"}
        )
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read().decode("utf-8")
        cache.write_text(data, encoding="utf-8")
        return data, ""
    except Exception as e:  # noqa: BLE001
        return None, (
            f"本地未找到 mermaid.min.js 且无法从 CDN 拉取（{type(e).__name__}: {e}）。\n"
            f"请手动下载 {MERMAID_CDN_URL} 保存到 {ASSETS_DIR / 'mermaid.min.js'}，"
            f"或设置环境变量 MERMAID_JS_PATH 指向本地文件后重试。"
        )


def _build_html(mermaid_code: str, mermaid_js: str) -> str:
    """构造本地渲染用的 HTML。

    mermaid 代码以 JSON 字符串形式写入 textContent，避免 HTML 转义破坏
    `<`、`>`、`&` 等字符；随后调用 mermaid.run() 触发渲染。
    """
    code_js = json.dumps(mermaid_code, ensure_ascii=False)
    # 防御 </script> 提前闭合：把 </ 转义为 <\/
    code_js = code_js.replace("</", "<\\/")
    return f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<style>
  body {{ margin: 0; padding: 8px; background: #ffffff; }}
  .mermaid {{ font-family: 'Microsoft YaHei', 'PingFang SC', 'SimHei', sans-serif; }}
</style>
<script>{mermaid_js}</script>
</head>
<body>
<div class="mermaid" id="g"></div>
<script>
  (async function() {{
    var code = {code_js};
    document.getElementById('g').textContent = code;
    mermaid.initialize({{ startOnLoad: false, securityLevel: 'loose', theme: 'default' }});
    try {{
      await mermaid.parse(code);
    }} catch (e) {{
      var errEl = document.createElement('div');
      errEl.id = 'render-error';
      errEl.textContent = 'MERMAID_PARSE_ERROR: ' + (e && e.message ? e.message : String(e));
      document.body.appendChild(errEl);
      return;
    }}
    await mermaid.run({{ querySelector: '#g' }});
  }})();
</script>
</body>
</html>"""


def _render_local(mermaid_code: str, output_path: Path, mermaid_js: str) -> tuple[bool, str]:
    """渲染单个 Mermaid 代码为 PNG（Playwright + Chromium 本地离线）。"""
    try:
        from playwright.sync_api import sync_playwright
    except ImportError as e:
        return False, (
            f"缺少依赖 playwright（请执行 pip install playwright && playwright install chromium）：{e}"
        )

    tmp_html = None
    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        html = _build_html(mermaid_code, mermaid_js)
        tmp_html = output_path.with_suffix(".html")
        tmp_html.write_text(html, encoding="utf-8")

        with sync_playwright() as p:
            browser = p.chromium.launch(args=["--no-sandbox"])
            page = browser.new_page(device_scale_factor=2)
            page.goto(tmp_html.as_uri())
            # 先检测 mermaid.parse 抛出的语法错误（避免把「错误炸弹」SVG 当成功截图）
            err_el = None
            try:
                err_el = page.wait_for_selector("#render-error", timeout=10000)
            except Exception:  # noqa: BLE001  # 超时即无语法错误
                err_el = None
            if err_el is not None:
                parse_msg = (err_el.text_content() or "").strip()
                browser.close()
                return False, f"Mermaid 语法/解析错误：{parse_msg[:300]}"
            try:
                page.wait_for_selector(".mermaid svg", timeout=30000)
            except Exception as e:  # noqa: BLE001
                err_text = page.evaluate(
                    "() => (document.querySelector('.mermaid') || {}).textContent || ''"
                )
                browser.close()
                return False, f"Mermaid 渲染超时/失败：{err_text[:200]}（{type(e).__name__}）"
            element = page.query_selector(".mermaid svg")
            if element is None:
                browser.close()
                return False, "未生成 SVG 元素"
            element.screenshot(path=str(output_path))
            browser.close()
        return True, ""
    except Exception as e:  # noqa: BLE001
        msg = str(e)
        low = msg.lower()
        hint = ""
        if "playwright" in low or "chromium" in low or "browser" in low or "executable" in low:
            hint = "（本地浏览器后端缺失，请执行：playwright install chromium）"
        return False, f"{type(e).__name__}: {msg}{hint}"
    finally:
        if tmp_html is not None and tmp_html.exists():
            try:
                tmp_html.unlink()
            except Exception:  # noqa: BLE001
                pass


# --------------------------------------------------------------------------- #
# 调度入口
# --------------------------------------------------------------------------- #
def render_mermaid_to_png(
    mermaid_code: str,
    output_path: Path,
    mode: str = "online",
    mermaid_js: str | None = None,
) -> tuple[bool, str]:
    """渲染单个 Mermaid 代码为 PNG。

    mode="local" 时要求 mermaid_js 已由调用方预加载（避免逐块重复读取/下载）。
    返回 (是否成功, 错误信息)。
    """
    if mode == "local":
        if mermaid_js is None:
            return False, "本地模式缺少 mermaid.min.js（请先通过 _get_mermaid_js 初始化）"
        return _render_local(mermaid_code, output_path, mermaid_js)
    return _render_online(mermaid_code, output_path)


def render_all(
    blocks: list[str],
    output_dir: Path,
    prefix: str,
    quiet: bool = False,
    mode: str = "online",
) -> tuple[int, int]:
    """批量渲染，返回 (成功数, 失败数)。"""
    mermaid_js: str | None = None
    if mode == "local":
        mermaid_js, err = _get_mermaid_js()
        if mermaid_js is None:
            print(f"FAIL: 本地模式初始化失败 -> {err}", file=sys.stderr)
            return 0, len(blocks)

    ok = fail = 0
    for i, code in enumerate(blocks, 1):
        out = output_dir / f"{prefix}_{i}.png"
        success, err = render_mermaid_to_png(code, out, mode=mode, mermaid_js=mermaid_js)
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
    parser.add_argument(
        "--mode",
        choices=["online", "local"],
        default="online",
        help="渲染模式：online=mermaid.ink 在线（默认）；local=Playwright 本地离线渲染",
    )
    args = parser.parse_args(argv)

    if not args.input_md.is_file():
        print(f"错误：找不到文件 {args.input_md}", file=sys.stderr)
        return 1

    text = args.input_md.read_text(encoding="utf-8")
    blocks = extract_mermaid_blocks(text)
    print(f"共发现 {len(blocks)} 个 mermaid 代码块（模式：{args.mode}）")

    if not blocks:
        print("没有可渲染的 mermaid 代码块")
        return 0

    args.output_dir.mkdir(parents=True, exist_ok=True)
    ok, fail = render_all(blocks, args.output_dir, args.prefix, args.quiet, args.mode)

    print(f"\n完成：成功 {ok}，失败 {fail}")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
