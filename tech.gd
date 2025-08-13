extends Node2D

class_name Technology

var techName: String

var techUnlockCost: int

func buildSelf():
	if techName == "Agriculture":
		techUnlockCost = 40
	if techName == "Early Tools":
		techUnlockCost = 60
	pass
