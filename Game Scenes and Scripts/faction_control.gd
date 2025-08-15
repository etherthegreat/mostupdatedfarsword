extends Control

var factionScene = preload("res://faction.tscn")

var factionList: Array = []

func addFaction(ID, LOYALTY, GOVERNOR):
	var newFaction = factionScene.instantiate()
	newFaction.buildSelf(ID, LOYALTY, GOVERNOR)
	$FactionPanel/FactionContainer.add_child(newFaction)
	factionList.append(newFaction)
	pass
