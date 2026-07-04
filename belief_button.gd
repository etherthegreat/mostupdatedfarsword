extends Control

class_name beliefButton

var bbName: String
var bbImage: Texture
var bbPurchased: bool
var bbBWImage: Texture
var bbCost : int
var beliefDesc: String
var borderImage: Texture

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
	beliefDesc = hint
	var _cs = get_tree().current_scene
	if _cs != null:
		var _pc = _cs.get("playerCountryNode")
		if _pc != null and _pc.has_method("belief_effect_text"):
			var _fx: String = _pc.belief_effect_text(id)
			if _fx != "":
				beliefDesc = str(hint, "\n", _fx, "  ")
	borderImage = border
	$BeliefPanel/BeliefBorderSprite.texture = border
	$BeliefPanel/BeliefSprite.texture = image
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)

func makePurchaseable():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.GREEN)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbImage

func cantAfford():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.GRAY)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbBWImage

func purchased():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.NAVAJO_WHITE)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbImage

signal LabelClicked

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("Left Click"):
		if bbPurchased == false:
			emit_signal("LabelClicked", bbName, bbCost, bbImage, beliefDesc, borderImage)
