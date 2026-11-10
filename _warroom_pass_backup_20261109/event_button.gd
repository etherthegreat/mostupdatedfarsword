extends Control

#class_name EventButtonControl

var _btn_data: Dictionary = {}

signal button_chosen(btn_data: Dictionary)

# ── Reward strip ─────────────────────────────────────────────────────────────
# The button carries the lore of the response; the strip under it carries the
# mechanics as quick beats ("[food] +10 · +5 Morale"). Swap any icon here.
const ICON_DIR := "res://art assets/finishedAssets/manaicons/"   # same icons as the top resource bar
const RESOURCE_ICONS := {
	"food":      "fooda.png",
	"gold":      "currency.png",
	"weapons":   "Weapons.png",
	"wood":      "wood.png",
	"metal":     "metal.png",
	"science":   "science2.png",
	"magic":     "Magic.png",
	"faith":     "faith.png",
	"manpower":  "manpower.png",
	"culture":   "Culture.png",
	"mandate":   "Mandate.png",
	"harmony":   "Harmony.png",
	"influence": "Influence 1.png",
}
const RESOURCE_NAMES := { "gold": "Dollars" }   # player-facing names that differ from the data key
const ICON_PX := 22

const COL_GOOD  := "#d4f2b4"
const COL_BAD   := "#ffb4a2"
const COL_STORY := "#f1e3c0"
const COL_SCENE := "#f7b8d2"
const BEAT_SEP  := "   "


func setup(btn_data: Dictionary) -> void:
	_btn_data = btn_data
	var b: Button = $EventButton
	b.text = btn_data.get("button_text", "Choose")
	b.tooltip_text = _describe_effect(btn_data)
	# No focus outline (it was highlighting the first button on open).
	b.focus_mode = Control.FOCUS_NONE
	# Wrap long labels and clip so nothing spills past the button art.
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.clip_text = true
	# Shrink the font for longer labels so they stay on the button.
	var n: int = b.text.length()
	var fs: int = 27
	if n > 30:
		fs = 18
	elif n > 22:
		fs = 21
	elif n > 16:
		fs = 24
	b.add_theme_font_size_override("font_size", fs)
	_apply_rewards(btn_data)


func _apply_rewards(d: Dictionary) -> void:
	var lbl = get_node_or_null("RewardLabel")
	if lbl == null:
		return
	lbl.text = "[center]" + BEAT_SEP.join(_reward_beats(d)) + "[/center]"


# One short beat per mechanical effect. Designer hover text (button_tooltip) wins.
func _reward_beats(d: Dictionary) -> Array:
	var beats: Array = []
	var tip: String = str(d.get("button_tooltip", "")).strip_edges()
	var ot: String  = str(d.get("outcome_type", "")).strip_edges()
	var ov: String  = str(d.get("outcome_value", "")).strip_edges()
	var amt: int    = int(d.get("outcome_amount", 0))

	if tip != "":
		beats.append(_beat(tip, COL_STORY))
	else:
		match ot:
			"resource_change":
				beats.append(_res_beat(ov.to_lower(), amt))
			"resource_bundle":
				for pair in ov.split(","):
					var kv = pair.split(":")
					if kv.size() == 2:
						beats.append(_res_beat(kv[0].strip_edges().to_lower(), int(kv[1].strip_edges())))
			"morale_boost":             beats.append(_num_beat(amt, "Morale"))
			"harmony_boost":            beats.append(_num_beat(amt, "Harmony"))
			"claim_change":             beats.append(_num_beat(amt, "Claim"))
			"loyalty_change":           beats.append(_num_beat(amt, "Loyalty"))
			"governor_loyalty_change":  beats.append(_num_beat(amt, "Commander Loyalty"))
			"tile_moral_decay_change":  beats.append(_num_beat(amt, "Moral Decay", true))
			"election_pressure_change": beats.append(_num_beat(amt, "Election Pressure"))
			"army_buff":                beats.append(_num_beat(amt, "Army " + _pretty(ov)))
			"tile_yield":               beats.append(_num_beat(amt, _pretty(ov) + " Yield"))
			"add_mil_mod":              beats.append(_beat("Gain: " + _pretty(ov), COL_GOOD))
			"add_law":                  beats.append(_beat("Law: " + _pretty(ov), COL_GOOD))
			"add_spell":                beats.append(_beat("Spell: " + _pretty(ov), COL_GOOD))
			"add_tech":                 beats.append(_beat("Discovery", COL_GOOD))
			"add_governor":             beats.append(_beat("New Commander", COL_GOOD))
			"promote_commander":        beats.append(_beat("Commendation", COL_GOOD))
			"set_governor_perk":        beats.append(_beat("Commander Perk", COL_GOOD))
			"form_alliance":            beats.append(_beat("Alliance", COL_GOOD))
			"repair_fort":              beats.append(_beat("Fort Repaired", COL_GOOD))
			"reveal_tiles", "reveal_british_tiles":
				beats.append(_beat("Scouted", COL_GOOD))
			"set_mission_flag", "set_mission_flag_own":
				beats.append(_beat("New Objective", COL_STORY))
			"remove_governor":          beats.append(_beat("Commander Dismissed", COL_BAD))
			"replace_state_governors":  beats.append(_beat("State Purge", COL_BAD))
			"pardon_state_governors":   beats.append(_beat("Pardons", COL_GOOD))
			"disable_building":         beats.append(_beat(_pretty(ov) + " Shut", COL_BAD))
			"set_flag", "trigger_event", "nothing", "":
				pass
			_:
				beats.append(_beat(_pretty(ot), COL_STORY))

	var loy: int = int(d.get("loyalty_change", 0))
	if loy != 0:
		beats.append(_num_beat(loy, "Loyalty"))

	var btype: String = str(d.get("button_type", "standard"))
	if btype in ["explicit", "kinky_lewd", "sensual"]:
		beats.append(_beat("Scene", COL_SCENE))

	# Quiet story beats only when nothing mechanical is on the line.
	if beats.is_empty():
		if ot == "trigger_event" or str(d.get("next_event_id", "")).strip_edges() != "":
			beats.append(_beat("The story continues", COL_STORY, true))
		elif ot == "set_flag":
			beats.append(_beat("Remembered", COL_STORY, true))
	return beats


func _res_beat(res: String, amt: int) -> String:
	var icon := ""
	if RESOURCE_ICONS.has(res) and ResourceLoader.exists(ICON_DIR + RESOURCE_ICONS[res]):
		icon = "[img=%dx%d]%s[/img] " % [ICON_PX, ICON_PX, ICON_DIR + RESOURCE_ICONS[res]]
	var label: String = "" if icon != "" else " " + RESOURCE_NAMES.get(res, _pretty(res))
	var col := COL_GOOD if amt >= 0 else COL_BAD
	return icon + "[color=%s]%s%s[/color]" % [col, _signed(amt), label]


func _num_beat(amt: int, label: String, lower_is_better: bool = false) -> String:
	if amt == 0:
		return _beat(label, COL_GOOD)
	var good: bool = (amt > 0) != lower_is_better
	return "[color=%s]%s %s[/color]" % [COL_GOOD if good else COL_BAD, _signed(amt), _esc(label)]


func _beat(text: String, col: String, italic: bool = false) -> String:
	var t := "[color=%s]%s[/color]" % [col, _esc(text)]
	return "[i]" + t + "[/i]" if italic else t


func _signed(n: int) -> String:
	return ("+" + str(n)) if n >= 0 else str(n)


func _pretty(s: String) -> String:
	return s.replace("_", " ").capitalize()


func _esc(s: String) -> String:
	return s.replace("[", "[lb]")


func _describe_effect(d: Dictionary) -> String:
	# Explicit hover text wins; otherwise auto-describe the mechanical outcome.
	var explicit: String = str(d.get("button_tooltip", "")).strip_edges()
	if explicit != "":
		return explicit
	var ot: String = str(d.get("outcome_type", ""))
	var ov: String = str(d.get("outcome_value", ""))
	match ot:
		"resource_bundle":
			var parts: Array = []
			for pair in ov.split(","):
				var kv = pair.split(":")
				if kv.size() == 2:
					parts.append("+" + kv[1].strip_edges() + " " + kv[0].strip_edges().capitalize())
			return " · ".join(parts)
		"resource_change":
			return "+" + str(d.get("outcome_amount", "")) + " " + ov.capitalize()
		"add_mil_mod":
			return "Gain: " + ov.capitalize()
		"morale_boost":
			return "Boosts national morale"
		_:
			return ""

func _on_event_button_pressed() -> void:
	emit_signal("button_chosen", _btn_data)
