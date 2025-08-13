extends Node2D

class_name belief

var beliefType: String
var faithBelief: bool

func buildBelief():
	if beliefType == "TYLA DYN":
		faithBelief = true
	if beliefType == "Gentle Shepherds":
		faithBelief = false
	pass
