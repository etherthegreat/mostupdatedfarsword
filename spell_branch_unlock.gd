extends Control

class_name spellBranchUnlock

@export var typeEXP: String
@export var costEXP: int

var spellType: String
var spellLevel: int
var spellCost: int
var spellSchool: String

var layer1tex: Texture
var layer2tex: Texture
var layer3tex: Texture

var spellImage: Texture

var infoDic: Dictionary = {
}

var magicDic: Dictionary = {
}

signal returnTranslatedInfo
func buildSelf():
	spellCost = costEXP
	spellType = typeEXP
	
	match spellType:
		"healingPotion":
			#spellLevel = 1
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
		"draughtOfKnowledge":
			#spellLevel = 2
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			print("RETURNDEBUG 1221", spellType)
		"fireworks":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
		"fleetingFoot":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"focusingDust":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Focus Dust.PNG")
		"goldenTouch":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Golden Touch.PNG")
		"paralysis":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Paralysis.PNG")
		"poison":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Poison.PNG")
		"slimeSoldier":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Soldier.PNG")
		"slimeWeapons":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Weapons.PNG")
		"slimeSpitter":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Spitter.PNG")
		"fleetingFoot":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"waterbreathing":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Waterbreathing.PNG")
	$Tex1.texture = layer1tex
	$Tex2.texture = layer2tex
	$Tex3.texture = layer3tex
	$spelliconsprite.texture = spellImage
	$SpellIconSpritepanel.texture = spellImage
	emit_signal("returnTranslatedInfo", spellType, self)
	pass

func giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellStr, spellDesc, schoolType):
	print("RETURN DEBUG GIVESPELL INFO")
	infoDic= {
		"schoolPoints": schoolPoints,
		"turnsUntil": turnsUntil,
		"unlocked": unlocked,
		"spell": spellStr,
		"description": spellDesc,
		"type": schoolType
	}
	print("RETURN DESCRIPTION", infoDic.description)
	if infoDic.description != null:
		$SpellDescription.append_text(infoDic.description)
		$SpellNameLabel.text = infoDic.spell
	
	$schoolpointslabel.text = infoDic.schoolPoints
	$turnsuntillabel.text = infoDic.turnsUntil
	print("RETURNTTRANSLATED INFO DEBUG")
	pass


func update(amount, amountPerTurn):
	$SchoolPointsRichTextLabel.clear()
	$unlocksRichTextLabel2.clear()
	print("DEBUG RETURN UPDATE")
	$SchoolPointsRichTextLabel.append_text(str(amount, "/", spellCost))
	if amount >= spellCost:
		$unlocksRichTextLabel2.append_text("unlocked")
		$Tex1.modulate = Color(1, 1, 1)
		$Tex2.modulate = Color(1, 1, 1)
		$Tex3.modulate = Color(1, 1, 1)
	else:
		$Tex1.modulate = Color(0, 0, 0)
		$Tex2.modulate = Color(0, 0, 0)
		$Tex3.modulate = Color(0, 0, 0)
		if amount > 0:
			var turnsUntilVar: int = (spellCost - amount) / amountPerTurn
			$unlocksRichTextLabel2.append_text(str(turnsUntilVar))
	pass


func _on_area_2d_mouse_entered() -> void:
	$PanelSprite.visible = true
	$SpellDescription.visible = true
	$SpellNameLabel.visible = true
	$SpellIconSpritepanel.visible = true
	$SchoolPointsRichTextLabel.visible = true
	$unlocksRichTextLabel2.visible = true
	$schoolpointslabel.visible = true
	$turnsuntillabel.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	$PanelSprite.visible = false
	$SpellDescription.visible = false
	$SpellNameLabel.visible = false
	$SpellIconSpritepanel.visible = false
	$SchoolPointsRichTextLabel.visible = false
	$unlocksRichTextLabel2.visible = false
	$schoolpointslabel.visible = false
	$turnsuntillabel.visible = false
	pass # Replace with function body.
