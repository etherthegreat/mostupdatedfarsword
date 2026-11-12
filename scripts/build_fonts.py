#!/usr/bin/env python3
"""Build the Pax Americana bitmap fonts.

    python3 scripts/build_fonts.py        (run from the repo root)

Inputs
  fonts/source_sister/*.png    Sister SpaceDesk's original sheets. Never edited.
  fonts/source_standin/*.txt   Stand-in glyphs drawn as text ('#' = pixel).
                               Placeholders for characters she has not drawn yet.

Outputs
  fonts/pax_body.fnt   + .png  small black font  -> default UI font
  fonts/pax_body_bold.fnt      the same, thickened 1px (for bold)
  fonts/pax_body_outline.fnt, pax_body_bold_outline.fnt
                               the same with a baked 1px black outline
  fonts/pax_map.fnt            outlined, free-scaling: names drawn on the map
  fonts/pax_header.fnt + .png  large grey font   -> headers
  fonts/pax_title.fnt  + .png  two-toned font    -> titles
  fonts/source_standin/FOR_APPROVAL.png          side-by-side review sheet
  fonts/source_standin/<font>_standins.png       stand-ins only, native size,
                                                 transparent (open in Procreate)

Godot reads the .fnt files directly as Font resources. Every glyph has its own
measured width, so text is proportionally spaced.
"""
import os
import sys
from PIL import Image
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONTS = os.path.join(ROOT, "fonts")
SISTER = os.path.join(FONTS, "source_sister")
STANDIN = os.path.join(FONTS, "source_standin")

DARK = (55, 85, 59)      # two-toned outline
LIGHT = (128, 186, 153)  # two-toned fill
UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


# ───────────────────────── glyph container ─────────────────────────
class Glyph:
    """rgba: HxWx4 uint8. top: rows from the baseline up to the glyph's first row
    (positive = above). The baseline sits under the bottom pixel of a capital."""
    def __init__(self, rgba, top, standin=False):
        self.rgba, self.top, self.standin = rgba, top, standin

    @property
    def w(self): return self.rgba.shape[1]
    @property
    def h(self): return self.rgba.shape[0]


def trim(mask_rgba, top):
    """Crop empty rows/cols, keeping the vertical position right."""
    ink = mask_rgba[..., 3] > 0
    ys, xs = np.where(ink)
    y0, y1, x0, x1 = ys.min(), ys.max(), xs.min(), xs.max()
    return Glyph(mask_rgba[y0:y1 + 1, x0:x1 + 1].copy(), top - y0)


# ───────────────────────── her sheets ─────────────────────────
def load_native(path, native=None):
    """Load a sheet at one-art-pixel-per-image-pixel. `native` un-does an
    upscaled export by sampling the centre of every block."""
    a = np.array(Image.open(path).convert("RGBA"))
    if native:
        s = a.shape[0] / native
        idx = ((np.arange(native) + 0.5) * s).astype(int)
        a = a[idx][:, idx]
    return a


def slice_rows(a, rows, colour=None):
    """rows: list of (y0, y1, baseline_y, chars, xranges|None, erase|None).
    Without xranges, letters are found by the empty columns between them."""
    ink = a[..., 3] > 127           # drops the faint stray brush specks
    out = {}
    for y0, y1, base, chars, xr, erase in rows:
        band = ink[y0:y1 + 1].copy()
        for (x, y) in (erase or []):
            band[y - y0, x] = False
        if xr is None:
            cols = band.any(0)
            xr, start = [], None
            for x, on in enumerate(list(cols) + [False]):
                if on and start is None: start = x
                if not on and start is not None:
                    xr.append((start, x - 1)); start = None
        else:
            covered = np.zeros(band.shape[1], bool)
            for x0, x1 in xr: covered[x0:x1 + 1] = True
            assert not (band.any(0) & ~covered).any(), f"ink outside ranges in row {chars!r}"
        assert len(xr) == len(chars), f"{chars!r}: found {len(xr)} letters, expected {len(chars)}"
        for ch, (x0, x1) in zip(chars, xr):
            m = band[:, x0:x1 + 1]
            rgba = np.zeros(m.shape + (4,), np.uint8)
            if colour is None:
                rgba[m] = (255, 255, 255, 255)       # white: takes any font colour
            else:
                src = a[y0:y1 + 1, x0:x1 + 1]
                light = src[..., 1] > 130
                rgba[m & light] = LIGHT + (255,)
                rgba[m & ~light] = DARK + (255,)
            out[ch] = trim(rgba, base - y0 + 1)
    return out


# ───────────────────────── stand-ins ─────────────────────────
ACCENTS = {  # drawn above a base letter; rows listed top to bottom
    "acute": ["#"], "grave": ["#"], "macron": ["###"],
}


def parse_standins(path):
    """File format:
        @ U+0027 rise=3        <- rise: empty rows under the glyph; desc: rows below baseline
        #
        #
    """
    specs, cur = [], None
    for raw in open(path, encoding="utf-8"):
        line = raw.rstrip("\n")
        if line.startswith("@"):
            parts = line[1:].split("#")[0].split()
            cur = {"cp": int(parts[0][2:], 16), "rows": [], "opt": dict(p.split("=") for p in parts[1:])}
            specs.append(cur)
        elif cur is not None and line.strip() and set(line.strip()) <= set("#o."):
            cur["rows"].append(line.strip())
        elif not line.strip():
            cur = None
    return specs


def outline(fill):
    """Two-toned style: light fill wrapped in a 1px dark outline."""
    h, w = fill.shape
    p = np.zeros((h + 2, w + 2), bool); p[1:-1, 1:-1] = fill
    d = np.zeros_like(p)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            d |= np.roll(np.roll(p, dy, 0), dx, 1)
    rgba = np.zeros(p.shape + (4,), np.uint8)
    rgba[d] = DARK + (255,); rgba[p] = LIGHT + (255,)
    return rgba


def build_standins(path, glyphs, two_tone=False):
    out = {}
    for s in parse_standins(path):
        ch, opt = chr(s["cp"]), s["opt"]
        if "compose" in opt:                       # her letter + an accent of mine
            base_ch, acc = opt["compose"].split(",")
            b = glyphs[base_ch]
            arows = ACCENTS[acc]
            aw = len(arows[0])
            ax = {"acute": b.w // 2, "grave": b.w // 2 - 1, "macron": (b.w - aw) // 2}[acc]
            gap = 1
            h = len(arows) + gap + b.h
            rgba = np.zeros((h, b.w, 4), np.uint8)
            rgba[h - b.h:] = b.rgba
            for r, row in enumerate(arows):
                for c, v in enumerate(row):
                    if v != ".": rgba[r, ax + c] = (255, 255, 255, 255)
            g = Glyph(rgba, b.top + len(arows) + gap, standin=True)
        else:
            w = max(len(r) for r in s["rows"])
            m = np.array([[c != "." for c in r.ljust(w, ".")] for r in s["rows"]])
            rise, desc = int(opt.get("rise", 0)), int(opt.get("desc", 0))
            if two_tone:
                rgba = outline(m)
            else:
                rgba = np.zeros(m.shape + (4,), np.uint8); rgba[m] = (255, 255, 255, 255)
            g = trim(rgba, rgba.shape[0] + rise - desc)
            g.standin = True
        out[ch] = g
    return out


def embolden(g):
    rgba = np.zeros((g.h, g.w + 1, 4), np.uint8)
    rgba[:, :-1] = g.rgba
    rgba[:, 1:] = np.maximum(rgba[:, 1:], g.rgba)
    return Glyph(rgba, g.top, g.standin)


def outlined(g):
    """White glyph wrapped in a 1px black outline. Font colour tints the white
    and leaves the black alone, so this replaces Godot's outline_size (which
    pixel fonts cannot do)."""
    ink = g.rgba[..., 3] > 0
    p = np.zeros((g.h + 2, g.w + 2), bool); p[1:-1, 1:-1] = ink
    d = np.zeros_like(p)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            d |= np.roll(np.roll(p, dy, 0), dx, 1)
    rgba = np.zeros(p.shape + (4,), np.uint8)
    rgba[d] = (0, 0, 0, 255); rgba[p] = (255, 255, 255, 255)
    return Glyph(rgba, g.top + 1, g.standin)


# ───────────────────────── .fnt writer ─────────────────────────
def write_font(name, face, glyphs, aliases, size, line_h, base, space, gap=1, atlas_w=256, bleed=0):
    """bleed: pixels each glyph extends past its normal box on every side (the
    outlined font uses 1) without changing letter spacing."""
    """Pack glyphs into one PNG and describe them in AngelCode BMFont text format."""
    pad, x, y, rowh, place = 1, 1, 1, 0, {}
    for ch in sorted(glyphs):
        g = glyphs[ch]
        if x + g.w + pad > atlas_w: x, y, rowh = 1, y + rowh + pad, 0
        place[ch] = (x, y); x += g.w + pad; rowh = max(rowh, g.h)
    atlas_h = y + rowh + pad
    atlas = np.zeros((atlas_h, atlas_w, 4), np.uint8)
    for ch, (px, py) in place.items():
        g = glyphs[ch]; atlas[py:py + g.h, px:px + g.w] = g.rgba
    Image.fromarray(atlas).save(os.path.join(FONTS, name + ".png"))

    lines = [
        f'info face="{face}" size={size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=0 aa=1 padding=0,0,0,0 spacing=1,1 outline=0',
        f'common lineHeight={line_h} base={base} scaleW={atlas_w} scaleH={atlas_h} pages=1 packed=0 alphaChnl=0 redChnl=4 greenChnl=4 blueChnl=4',
        f'page id=0 file="{name}.png"',
    ]
    chars = [f"char id=32 x=0 y=0 width=0 height=0 xoffset=0 yoffset=0 xadvance={space} page=0 chnl=15",
             f"char id=160 x=0 y=0 width=0 height=0 xoffset=0 yoffset=0 xadvance={space} page=0 chnl=15"]
    entries = {ch: ch for ch in glyphs}
    entries.update({a: t for a, t in aliases.items() if t in glyphs and a not in glyphs})
    for ch in sorted(entries):
        src = entries[ch]; g = glyphs[src]; px, py = place[src]
        chars.append(f"char id={ord(ch)} x={px} y={py} width={g.w} height={g.h} xoffset={-bleed} "
                     f"yoffset={base - g.top} xadvance={g.w - 2 * bleed + gap} page=0 chnl=15")
    lines.append(f"chars count={len(chars)}")
    with open(os.path.join(FONTS, name + ".fnt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines + chars) + "\n")
    return entries


# ───────────────────────── review sheets ─────────────────────────
def render(text, glyphs, entries, space, tint=None, standin_tint=None, gap=1):
    """Lay out one line of text; returns RGBA array and baseline row."""
    up = max(g.top for g in glyphs.values()); down = max(g.h - g.top for g in glyphs.values())
    width = sum((glyphs[entries[c]].w + gap) if c in entries else space for c in text) + 1
    img = np.zeros((up + down, max(width, 1), 4), np.uint8); x = 0
    for c in text:
        if c not in entries: x += space; continue
        g = glyphs[entries[c]]; px = g.rgba.copy()
        t = standin_tint if (g.standin and standin_tint) else tint
        if t is not None:
            white = (px[..., :3] == 255).all(-1) & (px[..., 3] > 0)
            px[white] = t + (255,)
        y = up - g.top
        img[y:y + g.h, x:x + g.w] = np.where(px[..., 3:4] > 0, px, img[y:y + g.h, x:x + g.w])
        x += g.w + gap
    return img


def standin_sheet(name, glyphs):
    """Stand-ins only, native size, transparent, dark pixels: ready for Procreate."""
    s = {c: g for c, g in glyphs.items() if g.standin}
    if not s: return
    up = max(g.top for g in s.values()); down = max(g.h - g.top for g in s.values())
    cell_h = up + down + 2; per = 12
    cell_w = max(g.w for g in s.values()) + 3
    rows = (len(s) + per - 1) // per
    img = np.zeros((rows * cell_h + 1, per * cell_w + 1, 4), np.uint8)
    for i, c in enumerate(sorted(s)):
        g = s[c]; px = g.rgba.copy()
        white = (px[..., :3] == 255).all(-1) & (px[..., 3] > 0); px[white] = (0, 0, 0, 255)
        x = (i % per) * cell_w + 2; y = (i // per) * cell_h + 1 + up - g.top
        img[y:y + g.h, x:x + g.w] = px
    Image.fromarray(img).save(os.path.join(STANDIN, name + "_standins.png"))


def approval_sheet(fonts):
    """One picture: her glyphs in black, stand-ins in orange, plus sample lines."""
    INK, ORANGE, BG, LABEL = (20, 20, 20), (224, 96, 16), (246, 244, 238, 255), (90, 90, 90)
    body = fonts[0]

    def label(t):  # labels are set in her own small font
        r = render(t, body["glyphs"], body["entries"], body["space"], tint=LABEL, standin_tint=LABEL)
        return np.kron(r, np.ones((2, 2, 1), np.uint8))

    blocks = []
    for f in fonts:
        k = f["zoom"]; g, e, sp, gp = f["glyphs"], f["entries"], f["space"], f["gap"]
        hers = "".join(sorted(c for c in g if not g[c].standin))
        mine = "".join(sorted(c for c in g if g[c].standin))
        blocks.append(label(f"{f['title']}"))
        blocks.append(label("Sister SpaceDesk originals:"))
        for i in range(0, len(hers), f["wrap"]):
            blocks.append(np.kron(render(" ".join(hers[i:i + f["wrap"]]), g, e, sp, INK, INK, gp), np.ones((k, k, 1), np.uint8)))
        blocks.append(label("Stand-ins by Claude, to approve or redraw (orange):"))
        for i in range(0, len(mine), f["wrap"]):
            blocks.append(np.kron(render(" ".join(mine[i:i + f["wrap"]]), g, e, sp, INK, ORANGE, gp), np.ones((k, k, 1), np.uint8)))
        blocks.append(label("In use:"))
        for line in f["samples"]:
            blocks.append(np.kron(render(line, g, e, sp, INK, ORANGE, gp), np.ones((k, k, 1), np.uint8)))
        blocks.append(np.zeros((18, 4, 4), np.uint8))
    W = max(b.shape[1] for b in blocks) + 40
    H = sum(b.shape[0] + 12 for b in blocks) + 28
    sheet = np.zeros((H, W, 4), np.uint8); sheet[:] = BG; y = 20
    for b in blocks:
        reg = sheet[y:y + b.shape[0], 20:20 + b.shape[1]]
        reg[:] = np.where(b[..., 3:4] > 0, b, reg); y += b.shape[0] + 12
    Image.fromarray(sheet).convert("RGB").save(os.path.join(STANDIN, "FOR_APPROVAL.png"))


# ───────────────────────── the three fonts ─────────────────────────
def main():
    # Small black font: complete alphabet, 5px capitals.
    a = load_native(os.path.join(SISTER, "small_black.png"))
    body = slice_rows(a, [
        (2, 6, 6, "ABCDEFGHIJK", None, None),
        (8, 12, 12, "LMNOPQRSTUV", None, None),
        (14, 18, 18, "WXYZ", None, None),
        (20, 27, 25, "abcdefghijkl", None, [(41, 27)]),              # (41,27) is the top of the t below
        (27, 34, 32, "mnopqrstuvw", None, [(35, 27), (36, 27)]),     # tail of the g above
        (35, 39, 38, "xyz", None, None),
        (42, 46, 46, "1234567890", None, None),
        (50, 57, 56, '$.!,?:;"+–=×÷-',
         [(3, 7), (9, 9), (12, 12), (15, 15), (17, 20), (22, 22), (25, 25), (27, 29), (31, 35),
          (38, 42), (45, 49), (51, 55), (57, 61), (64, 66)], None),
        (61, 67, 66, "([{}])~#%/\\^∨",
         [(2, 3), (5, 6), (7, 9), (11, 13), (14, 15), (17, 18), (21, 25), (28, 32), (35, 41),
          (44, 46), (48, 50), (52, 56), (58, 62)], None),
    ])
    body.update(build_standins(os.path.join(STANDIN, "body_standins.txt"), body))
    body_alias = {
        "—": "–", "−": "–", "─": "–",   # em dash, minus, box line -> her long dash
        "’": "'", "‘": "'", "ʻ": "'", "`": "'",        # curly quotes, okina
        "“": '"', "”": '"',
        "✕": "×", "‚": ",",                            # the CSVs use U+201A as a comma
    }
    # "size" is the font size at which Godot draws this 1:1. At 7, the game's
    # existing sizes 11-17 draw at 2x, 18-24 at 3x, 25-31 at 4x.
    e_body = write_font("pax_body", "Pax Body", body, body_alias, size=7, line_h=9, base=7, space=3)
    # Bold is derived automatically: every glyph thickened one pixel to the right.
    bold = {c: embolden(g) for c, g in body.items()}
    write_font("pax_body_bold", "Pax Body Bold", bold, body_alias, size=7, line_h=9, base=7, space=4)
    # Outlined variants (regular and bold) for text drawn over art or the map.
    write_font("pax_body_outline", "Pax Body Outline", {c: outlined(g) for c, g in body.items()},
               body_alias, size=7, line_h=9, base=7, space=3, bleed=1)
    write_font("pax_body_bold_outline", "Pax Body Bold Outline", {c: outlined(g) for c, g in bold.items()},
               body_alias, size=7, line_h=9, base=7, space=4, bleed=1)
    # Map names are fitted to each tile and zoom with the camera, so they need
    # in-between sizes. Same outlined glyphs; its .import allows any size.
    write_font("pax_map", "Pax Map", {c: outlined(g) for c, g in body.items()},
               body_alias, size=7, line_h=9, base=7, space=3, bleed=1)

    # Large grey font: capitals and digits, 10px tall, 2px strokes.
    a = load_native(os.path.join(SISTER, "large_grey.png"))
    head = slice_rows(a, [
        (1, 10, 10, "ABCDEF", None, None), (12, 21, 21, "GHIJKL", None, None),
        (23, 32, 32, "MNOPQR", None, None), (34, 43, 43, "STUVWX", None, None),
        (45, 54, 54, "YZ1234", None, None), (56, 65, 65, "567890", None, None),
    ])
    head.update(build_standins(os.path.join(STANDIN, "header_standins.txt"), head))
    caps_alias = {c.lower(): c for c in UPPER}                        # lowercase text shows as capitals
    caps_alias.update({"\u00e9": "E", "\u00e8": "E", "\u00c9": "E", "\u00c8": "E",   # accents are dropped on
                       "\u00d3": "O", "\u00f3": "O", "\u0101": "A", "\u0100": "A"})  # the capitals-only fonts
    head_alias = dict(caps_alias, **{"’": "'", "‘": "'", "ʻ": "'", "“": '"', "”": '"',
                                     "–": "—", "−": "-", "‚": ","})
    e_head = write_font("pax_header", "Pax Header", head, head_alias, size=10, line_h=14, base=11, space=6, gap=2)

    # Two-toned font: capitals only, 15px tall with its outline. The sheet was
    # exported at 1000px; 112 is its true size.
    a = load_native(os.path.join(SISTER, "two_toned.png"), native=112)
    title = slice_rows(a, [
        (23, 37, 37, "ABCDEFG", None, None), (40, 54, 54, "HIJKLMN", None, None),
        (57, 71, 71, "OPQRSTU", None, None), (74, 88, 88, "VWXYZ", None, None),
    ], colour=True)
    title.update(build_standins(os.path.join(STANDIN, "title_standins.txt"), title, two_tone=True))
    title_alias = dict(caps_alias, **{"’": "'", "‘": "'", "ʻ": "'", "–": "—", "−": "-"})
    e_title = write_font("pax_title", "Pax Title", title, title_alias, size=15, line_h=19, base=17, space=7, gap=2)

    for n, g in (("body", body), ("header", head), ("title", title)):
        standin_sheet(n, g)
    approval_sheet([
        dict(title="1. SMALL FONT (body text)", glyphs=body, entries=e_body, space=3, gap=1, zoom=5, wrap=32,
             samples=["Lincoln's Ghost & the Republic — don't wait.",
                      "Café · Québec · Montréal | +2 → <5> * me@home_1 …",
                      "• ✓ ★ ● ○ ± ≈ ↔ › É È Ó ā"]),
        dict(title="2. LARGE FONT (headers)", glyphs=head, entries=e_head, space=6, gap=2, zoom=3, wrap=20,
             samples=["LINCOLN'S GHOST: 1861", "WAR & PEACE (50%) - GO!", "WHO, ME? \"YES\"; +2 / 3 = 4"]),
        dict(title="3. TWO-TONED FONT (titles)", glyphs=title, entries=e_title, space=7, gap=2, zoom=2, wrap=13,
             samples=["PAX AMERICANA", "1861 - 1865: WAR!", "LINCOLN'S GHOST & CO.", "0123456789 ?,"]),
    ])
    for n, g in (("pax_body", body), ("pax_header", head), ("pax_title", title)):
        hers = sum(1 for x in g.values() if not x.standin)
        print(f"{n}: {hers} glyphs from Sister SpaceDesk, {len(g) - hers} stand-ins")


if __name__ == "__main__":
    sys.exit(main())
