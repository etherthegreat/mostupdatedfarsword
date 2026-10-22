extends Control

var factionScene = preload("res://faction.tscn")

var factionList: Array = []

func addFaction(Name: String, Loyalty: int, factionLeader: governor = null) -> void:
	# If no leader provided, create a placeholder so faction.visualizeSelf() doesn't crash
	var leader = factionLeader
	if leader == null:
		leader = governor.new()
		leader.buildSelf("Unknown Leader", 1)
	var newFaction = factionScene.instantiate()
	newFaction.buildSelf(Name, Loyalty, leader)
	factionList.append(newFaction)

signal newRewardSend
func forwardRewardType(rewardType):
	emit_signal("newRewardSend", rewardType)
