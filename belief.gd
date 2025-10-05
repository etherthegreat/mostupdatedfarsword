extends Node2D

class_name belief

var beliefType: String
var faithBelief: bool

func buildBelief(type):
	match type:
		"Healing Waters":
			faithBelief = false
		"Standing Stones":
			faithBelief = false
		"Sacred Groves":
			faithBelief = false
		"Valued Idolatry":
			faithBelief = false
		"Midsummer Celebrations":
			faithBelief = false
		"Tree of Life":
			faithBelief = false
		"Tower Control":
			faithBelief = false
		"BENAXTARA":
			faithBelief = true
	pass
