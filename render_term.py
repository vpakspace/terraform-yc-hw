#!/usr/bin/env python3
"""Рендер текста (вывода терминала) в PNG с тёмной темой и заголовком-табом.

Использование:
    python3 render_term.py OUTPUT.png "Заголовок окна" < input.txt
    python3 render_term.py OUTPUT.png "Заголовок окна" input.txt
"""
import sys
import re
from PIL import Image, ImageDraw, ImageFont

ANSI_RE = re.compile(r"\x1b\[[0-9;]*[A-Za-z]")

FONT_REG = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"
FONT_BLD = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"

# Палитра в духе Catppuccin Mocha
BG = (30, 30, 46)
BAR = (49, 50, 68)
FG = (205, 214, 244)
PROMPT = (166, 227, 161)   # зелёный для строк с $
DIM = (127, 132, 156)
DOTS = [(237, 135, 150), (238, 212, 159), (166, 227, 161)]


def main():
    out = sys.argv[1]
    title = sys.argv[2] if len(sys.argv) > 2 else "terminal"
    if len(sys.argv) > 3:
        with open(sys.argv[3], "r", encoding="utf-8", errors="replace") as f:
            text = f.read()
    else:
        text = sys.stdin.read()

    text = ANSI_RE.sub("", text).replace("\t", "    ")
    lines = text.rstrip("\n").split("\n")
    if not lines:
        lines = [""]

    size = 15
    font = ImageFont.truetype(FONT_REG, size)
    font_b = ImageFont.truetype(FONT_BLD, size)

    # метрики моноширинного символа
    tmp = Image.new("RGB", (10, 10))
    d0 = ImageDraw.Draw(tmp)
    bbox = d0.textbbox((0, 0), "M", font=font)
    ch_w = bbox[2] - bbox[0]
    line_h = size + 8

    pad = 16
    bar_h = 34
    max_cols = max((len(l) for l in lines), default=1)
    max_cols = max(max_cols, len(title) + 10, 60)
    width = pad * 2 + ch_w * max_cols
    height = bar_h + pad * 2 + line_h * len(lines)

    img = Image.new("RGB", (width, height), BG)
    d = ImageDraw.Draw(img)

    # верхняя панель-таб
    d.rectangle([0, 0, width, bar_h], fill=BAR)
    for i, c in enumerate(DOTS):
        cx = 16 + i * 20
        d.ellipse([cx, bar_h // 2 - 6, cx + 12, bar_h // 2 + 6], fill=c)
    tw = d.textlength(title, font=font_b)
    d.text(((width - tw) / 2, bar_h / 2 - size / 2 - 1), title, font=font_b, fill=DIM)

    y = bar_h + pad
    for l in lines:
        stripped = l.lstrip()
        if stripped.startswith("$ ") or stripped.startswith("vladspace@") or stripped.startswith("# "):
            color = PROMPT
        else:
            color = FG
        d.text((pad, y), l, font=font, fill=color)
        y += line_h

    img.save(out)
    print(f"saved {out} ({width}x{height})")


if __name__ == "__main__":
    main()
