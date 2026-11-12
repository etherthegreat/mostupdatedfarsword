# Pax Americana fonts

Three pixel fonts by Sister SpaceDesk, built into Godot fonts by `scripts/build_fonts.py`.

| Font file | Her sheet | Used for |
|---|---|---|
| `pax_body.fnt` | `source_sister/small_black.png` | Default font for the whole game |
| `pax_body_bold.fnt` | same, thickened 1px by the script | `[b]` in RichTextLabels |
| `pax_body_outline.fnt`, `pax_body_bold_outline.fnt` | same, with a 1px black outline drawn in | Text over art (pixel fonts ignore `outline_size`) |
| `pax_map.fnt` | same outlined glyphs, free-scaling | Tile and country names on the map |
| `pax_header.fnt` | `source_sister/large_grey.png` | Theme variation `PaxHeader` / `PaxHeaderButton` |
| `pax_title.fnt` | `source_sister/two_toned.png` | Theme variation `PaxTitle` |

## Whose work is whose

- `source_sister/` holds her original sheets, untouched. Every letter she drew is cut straight from these.
- `source_standin/` holds placeholder glyphs by Claude for characters she has not drawn yet.
  - `FOR_APPROVAL.png` shows her glyphs in black and the stand-ins in orange. Send her this.
  - `*_standins.png` are the stand-ins alone at native size, to open in Procreate.
  - `*_standins.txt` are the editable source for the stand-ins.

When she draws a real version of a stand-in, add it to her sheet, list it in the
row tables in `build_fonts.py`, delete it from the `.txt`, and rebuild.

## Rebuilding

    python3 scripts/build_fonts.py

## Using the fonts

`pax_theme.tres` is the project theme (Project Settings > GUI > Theme > Custom), so the
body font applies everywhere with no per-node setup. For a header or title, set a
Label's Theme > Type Variation to `PaxHeader` or `PaxTitle`.

Sizes snap to whole multiples so pixels stay square:

| Font | 1x | 2x | 3x | 4x |
|---|---|---|---|---|
| Body | up to 10 | 11-17 | 18-24 | 25-31 |
| Header | up to 14 | 15-24 | 25-34 | 35-44 |
| Title | up to 22 | 23-37 | 38-52 | 53-67 |

The `.fnt.import` files set `scaling_mode=1` (integer only); `pax_map` alone uses 2
(any size), because map names are fitted to tiles and zoom with the camera. Keep
those values if you reimport.

## Fitting text in code

`pax_text.gd` picks the largest clean size at which text fits a box, wraps button
labels, and applies the outlined font:

    const PaxText = preload("res://fonts/pax_text.gd")
    PaxText.fit(label, Vector2(300, 60))            # Label
    PaxText.fit_button(button, "Text", Vector2(300, 80))
    PaxText.outline(label)

Avoid font sizes below 11: the body font drops to 1x there and is too small to read.
Header and Title are capitals-only: lowercase text shows as capitals, and any
character they lack falls back to the body font.
