extends RefCounted
## Helpers for laying out text in the pixel fonts.
##
## Pixel fonts only look right at whole multiples of their native size, so text
## cannot be shrunk a point at a time to squeeze into a box. These helpers measure
## the real text and pick the largest clean size that fits.
##
## Use from any script:
##     const PaxText = preload("res://fonts/pax_text.gd")
##     PaxText.fit(my_label, Vector2(300, 60))

## Font sizes at which the body font draws at 2x, 3x, 4x ... (see fonts/README.md).
const X2 := 14
const X3 := 21
const X4 := 28
const X5 := 35
const X6 := 42

## Common ladders, largest first.
const SIZES_BODY: Array[int] = [X4, X3, X2]
const SIZES_HEADLINE: Array[int] = [X6, X5, X4, X3, X2]
const SIZES_SMALL: Array[int] = [X3, X2]


## Height in pixels that `text` needs at `font_size` when wrapped to `width`.
## Pass width <= 0 for a single unwrapped line.
static func measure(font: Font, text: String, font_size: int, width: float, line_spacing: float = 3.0) -> Vector2:
	if text == "":
		return Vector2(0, font.get_height(font_size))
	var w: float = width if width > 0.0 else -1.0
	var sz: Vector2 = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, w, font_size)
	var line_h: float = font.get_height(font_size)
	var lines: int = maxi(1, int(round(sz.y / line_h)))
	sz.y += line_spacing * float(lines - 1)
	return sz


## Number of lines `text` takes at `font_size` when wrapped to `width`.
static func line_count(font: Font, text: String, font_size: int, width: float) -> int:
	if text == "":
		return 1
	var sz: Vector2 = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, width, font_size)
	return maxi(1, int(round(sz.y / font.get_height(font_size))))


## Largest size in `sizes` (largest first) at which `text` fits inside `box`.
## With wrap = false the text must fit on one line. Returns the smallest size when
## nothing fits; check `fits()` if the caller needs to know.
static func best_size(font: Font, text: String, box: Vector2, sizes: Array[int], wrap: bool = true, line_spacing: float = 3.0) -> int:
	for fs in sizes:
		if fits(font, text, box, fs, wrap, line_spacing):
			return fs
	return sizes[sizes.size() - 1]


static func fits(font: Font, text: String, box: Vector2, font_size: int, wrap: bool = true, line_spacing: float = 3.0) -> bool:
	var sz: Vector2 = measure(font, text, font_size, box.x if wrap else -1.0, line_spacing)
	if sz.y > box.y + 0.5:
		return false
	if not wrap:
		return sz.x <= box.x + 0.5
	# A single word wider than the box cannot wrap; it would spill out sideways.
	for word in text.split(" ", false):
		for piece in word.split("\n", false):
			if font.get_string_size(piece, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > box.x + 0.5:
				return false
	return true


## Set a Label's or Button's font size to the largest in `sizes` that fits `box`.
## Returns true if the text fits at the chosen size.
static func fit(ctrl: Control, box: Vector2, sizes: Array[int] = SIZES_BODY, wrap: bool = true) -> bool:
	var font: Font = ctrl.get_theme_font("font")
	var text: String = str(ctrl.get("text"))
	var spacing: float = 3.0
	if ctrl is Label:
		spacing = float(ctrl.get_theme_constant("line_spacing"))
	var fs: int = best_size(font, text, box, sizes, wrap, spacing)
	ctrl.add_theme_font_size_override("font_size", fs)
	return fits(font, text, box, fs, wrap, spacing)


## Break `text` into lines no wider than `width`, at word boundaries.
static func wrap_lines(font: Font, text: String, font_size: int, width: float) -> PackedStringArray:
	var out: PackedStringArray = []
	for para in text.split("\n"):
		var line: String = ""
		for word in para.split(" ", false):
			var trial: String = word if line == "" else line + " " + word
			if line != "" and font.get_string_size(trial, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > width:
				out.append(line)
				line = word
			else:
				line = trial
		out.append(line)
	return out


## Fit a Button's label inside `box` (the clear area of the button art). Buttons
## wrap to their own full width, which lets text run to the very edge of the art,
## so the line breaks are placed here instead. Returns true if the text fits.
static func fit_button(b: Button, text: String, box: Vector2, sizes: Array[int] = SIZES_BODY) -> bool:
	var font: Font = b.get_theme_font("font")
	b.autowrap_mode = TextServer.AUTOWRAP_OFF
	var chosen: int = sizes[sizes.size() - 1]
	var ok: bool = false
	for fs in sizes:
		if _button_lines_fit(font, wrap_lines(font, text, fs, box.x), fs, box):
			chosen = fs
			ok = true
			break
	b.add_theme_font_size_override("font_size", chosen)
	b.text = "\n".join(wrap_lines(font, text, chosen, box.x))
	return ok


static func _button_lines_fit(font: Font, lines: PackedStringArray, font_size: int, box: Vector2) -> bool:
	if float(lines.size()) * font.get_height(font_size) > box.y + 0.5:
		return false
	for l in lines:
		if font.get_string_size(l, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > box.x + 0.5:
			return false
	return true


## Give a Label or Button a black outline. Pixel fonts ignore Godot's
## `outline_size`, so this swaps in the font that has the outline drawn in.
## The control's font colour still works: it tints the letters, not the outline.
static func outline(ctrl: Control, bold: bool = false) -> void:
	var path: String = "res://fonts/pax_body_bold_outline.fnt" if bold else "res://fonts/pax_body_outline.fnt"
	ctrl.add_theme_font_override("font", load(path))
