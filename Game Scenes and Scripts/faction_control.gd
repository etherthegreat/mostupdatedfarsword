extends Control

var factionScene = preload("res://faction.tscn")

var factionList: Array = []

func addFaction(ID, LOYALTY, GOVERNOR):
	var newFaction = factionScene.instantiate()
	newFaction.buildSelf(ID, LOYALTY, GOVERNOR)
	newFaction.sendRewardType.connect(forwardRewardType)
	$FactionPanel/FactionContainer.add_child(newFaction)
	factionList.append(newFaction)
	pass

signal newRewardSend
func forwardRewardType(rewardType):
	emit_signal("newRewardSend", rewardType)
	pass
