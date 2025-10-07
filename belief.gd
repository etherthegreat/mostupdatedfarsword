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
		"Benaxtara":
			faithBelief = true
		"Tyla-Dyn":
			faithBelief = true
		"Bibwey":
			faithBelief = true
		"Dilnith-Amen":
			faithBelief = true
		"Ornil-Ra":
			faithBelief = true
		"Fa Enepo":
			faithBelief = true
	pass
