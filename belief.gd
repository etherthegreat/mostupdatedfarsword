extends Node2D

class_name belief

var beliefType: String
var faithBelief: bool

func buildBelief(type):
	match type:
		# ── American Doctrines ───────────────────────────────────────────────────
		"Social Security Act":
			faithBelief = false
		"National Monument Act":
			faithBelief = false
		"Lacey Wildlife Act":
			faithBelief = false
		"Sherman Antitrust Act":
			faithBelief = false
		"Federal Arts Endowment":
			faithBelief = false
		"Homestead Act":
			faithBelief = false
		"Defense Production Act":
			faithBelief = false
		"Wilderness Act":
			faithBelief = false
		"First Amendment":
			faithBelief = false
		"National Research Act":
			faithBelief = false
		"Height of Buildings Act":
			faithBelief = false
		# ── Canadian Doctrines ───────────────────────────────────────────────────
		"Canada Wildlife Act":
			faithBelief = false
		"Canada Council for the Arts Act":
			faithBelief = false
		"Dominion Lands Act":
			faithBelief = false
		"Historic Sites and Monuments Act":
			faithBelief = false
		"Combines Investigation Act":
			faithBelief = false
		"Canada Health Act":
			faithBelief = false
		"National Parks Act":
			faithBelief = false
		"Charter of Rights and Freedoms":
			faithBelief = false
		"Medical Research Council Act":
			faithBelief = false
		"National Building Code of Canada":
			faithBelief = false
		"War Measures Act":
			faithBelief = false
		# ── American Icons ───────────────────────────────────────────────────────
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
		# ── Canadian Icons ───────────────────────────────────────────────────────
		"John A. Macdonald":
			faithBelief = true
		"George-Étienne Cartier":
			faithBelief = true
		"Wilfrid Laurier":
			faithBelief = true
		"Agnes Macphail":
			faithBelief = true
		"Laura Secord":
			faithBelief = true
		"Louis-Hippolyte LaFontaine":
			faithBelief = true
		"Tommy Douglas":
			faithBelief = true
		"Viola Desmond":
			faithBelief = true
		"Lester B. Pearson":
			faithBelief = true
		"Louis Riel":
			faithBelief = true
		"Emily Murphy":
			faithBelief = true
		"Nellie McClung":
			faithBelief = true
		"Terry Fox":
			faithBelief = true
		"Chief Dan George":
			faithBelief = true
		"Buffy Sainte-Marie":
			faithBelief = true
		"David Suzuki":
			faithBelief = true
		"Roméo Dallaire":
			faithBelief = true
		"Thérèse Casgrain":
			faithBelief = true
		"Mary Two-Axe Earley":
			faithBelief = true
		"Pierre Elliott Trudeau":
			faithBelief = true
	pass
