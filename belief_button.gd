extends Control

class_name beliefButton

var bbName: String
var bbImage: Texture
var bbPurchased: bool
var bbBWImage: Texture
var bbCost : int
var beliefDesc: String
var borderImage: Texture
var _rawHint: String = ""   # description as passed in, before effect-text enrichment

#for testing

#beliefDesc = "We worship the tree of life because everybody else seems to be doing it and wed hate to be left out on the coolest, hippest religious imagery"
#bbName = "Tree of Life"

func buildSelf(id, image, bwImage, purch, cost, hint, border):
	$TitleRichLabel.bbcode_enabled = true
	bbName = id
	bbImage = image
	bbBWImage = bwImage
	bbPurchased = purch
	bbCost = cost
	_rawHint = hint
	beliefDesc = _enriched_desc()   # get_tree() may be null here (built before add_child) — guarded
	borderImage = border
	$BeliefPanel/BeliefBorderSprite.texture = border
	$BeliefPanel/BeliefSprite.texture = image
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)

# Append the belief's mechanical effect text to the description, if the player
# country node is reachable. Returns the plain hint when it isn't (e.g. this
# button is built before it's added to the scene tree, so get_tree() is null).
func _enriched_desc() -> String:
	var _tree = get_tree()
	if _tree == null:
		return _rawHint
	var _cs = _tree.current_scene
	if _cs != null:
		var _pc = _cs.get("playerCountryNode")
		if _pc != null and _pc.has_method("belief_effect_text"):
			var _fx: String = _pc.belief_effect_text(bbName)
			if _fx != "":
				return str(_rawHint, "\n", _fx, "  ")
	return _rawHint

# By the time _ready fires the button is in the tree, so get_tree() resolves and
# we can enrich the tooltip that buildSelf couldn't reach.
func _ready() -> void:
	var _new_desc := _enriched_desc()
	if _new_desc != beliefDesc:
		beliefDesc = _new_desc
		$TitleRichLabel.clear()
		$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
		$TitleRichLabel.append_text(bbName)

func makePurchaseable():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.GREEN)
	$