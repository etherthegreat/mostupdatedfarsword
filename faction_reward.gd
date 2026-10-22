extends Control

class_name factionReward

var factionRewardType: String
var factionRewardDescription: String
var factionRewardIcon: Texture

var factionRewardActivated: bool

func buildSelf(fRT, fRD, fRI):
	factionRewardActivated = false
	factionRewardType = fRT
	factionRewardDescription = fRD
	factionRewardIcon = fRI
	$RewardDescriptionPanel/RewardDescriptionLabel.text = factionRewardDescription
	$RewardSprite.texture = factionRewardIcon
	$RewardDescriptionPanel/RewardNameLabel.text = factionRewardType

func _on_area_2d_mouse_entered() -> void:
	$RewardDescriptionPanel.visible = true


func _on_area_2d_mouse_exited() -> void:
	$RewardDescriptionPanel.visible = false

signal emitRewardType
func rewardUnlocked():
	emit_signal("emitRewardType", factionRewardType)
