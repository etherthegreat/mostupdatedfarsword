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
		"Nature Sanctuaries":
			faithBelief = false
		"Conservative Orthodoxy":
			faithBelief = false
		"Sanctioned Cadaver Research":
			faithBelief = false
		"Temple Height Restrictions":
			faithBelief = false
		"George Washington":
			faithBelief = true
		"Benjamin Franklin":
			faithBelief = true
		"Abigail Adams":
			faithBelief = true
		"Alexander Hamilton":
			faithBelief = true
		"Phillis Wheatley":
			faithBelief = true
		"Thomas Jefferson":
			faithBelief = true
		"Abraham Lincoln":
			faithBelief = true
		"Harriet Tubman":
			faithBelief = true
		"Frederick Douglass":
			faithBelief = true
		"Sitting Bull":
			faithBelief = true
		"Sojourner Truth":
			faithBelief = true
		"Chief Joseph":
			faithBelief = true
		"Theodore Roosevelt":
			faithBelief = true
		"Susan B. Anthony":
			faithBelief = true
		"Ida B. Wells":
			faithBelief = true
		"Eleanor Roosevelt":
			faithBelief = true
		"Martin Luther King Jr.":
			faithBelief = true
		"Cesar Chavez":
			faithBelief = true
		"Jimmy Carter":
			faithBelief = true
		"Dolores Huerta":
			faithBelief = true
	pass
