extends Control

class_name beliefButton

var bbName: String
var bbImage: Texture
var bbPurchased: bool
var bbBWImage: Texture
var bbCost : int
var beliefDesc: String

#for testing

#beliefDesc = "We worship the tree of life because everybody else seems to be doing it and wed hate to be left out on the coolest, hippest religious imagery"
#bbName = "Tree of Life"

func buildSelf(id, image, bwImage, purch, cost, hint):
	$TitleRichLabel.bbcode_enabled = true
	bbName = id
	bbImage = image
	bbBWImage = bwImage
	bbPurchased = purch
	bbCost = cost
	beliefDesc = hint
	$BeliefPanel/BeliefSprite.texture = image
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	pass

func makePurchaseable():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.GREEN)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbImage
	pass

func cantAfford():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.GRAY)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbBWImage
	pass

func purchased():
	$TitleRichLabel.clear()
	$TitleRichLabel.push_color(Color.NAVAJO_WHITE)
	$TitleRichLabel.push_hint(str(beliefDesc, "Faith: ", bbCost))
	$TitleRichLabel.append_text(bbName)
	$BeliefPanel/BeliefSprite.texture = bbImage
	pass

signal LabelClicked

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("Left Click"):
		if bbPurchased == false:
			emit_signal("LabelClicked", bbName, bbCost, bbImage, beliefDesc)
	pass # Replace with function body.
