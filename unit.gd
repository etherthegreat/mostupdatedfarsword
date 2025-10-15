extends Control

class_name Unit

var playerCountry: country

var unitType: String
var unitLevel: int

var unitDefensiveScore: int #per level
var unitOffensiveScore: int #per level

#every single type of modifier as a bool
#this is just a template, the unit will use this to build themselves
var piercing: bool = false
var bleed: bool = false
var crushing: bool = false
var ranged: bool = false
var melee: bool = false
var monster: bool = false

var unitMetal: ore
var unitWeapon: Weapon

var unitImage: Texture2D

var unitMaxManpower: int
var unitCurrentManpower: int
var unitStrength: int

var militaryModifierList: Array = []

const milModScene = preload("res://mil_mod.tscn")

signal getUnitInfo
signal updateArmy
func buildSelf():
	#calculateManpower()
	unitCurrentManpower = (90 * unitLevel)
	unitMaxManpower = ( 100 * unitLevel)
	calculateWeaponAdditions
	getUnitAttributes()
	pass

func getUnitAttributes():
	calculateWeaponAdditions()
	emit_signal("getUnitInfo", unitType, self)
	print("unit militaryModifiersList", militaryModifierList)
	print("unit offensive score", unitOffensiveScore)
	print("mil mod list in unit", militaryModifierList)
	#print("Getting Attributes Success")
	pass

func addMilMod(mM):
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(mM.milModType)
	militaryModifierList.append(newMilMod)
	emit_signal("updateArmy")
	pass

func calculateOreMilMod():
	var newMilMod = milModScene.instantiate()
	#var oreString: String = unitMetal.oreType
	newMilMod.buildSelf(str(unitMetal.oreType))
	militaryModifierList.append(newMilMod)
	calculateMilModChange(newMilMod)
	pass

func addOreMilMod(milModType):
	var newUnitMetal = ore.new()
	var oreImage: Texture
	newUnitMetal.buildSelf(milModType)
	unitMetal = newUnitMetal
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(milModType)
	militaryModifierList.append(newMilMod)
	calculateMilModChange(newMilMod)
	emit_signal("updateArmy")
	pass

func removeMilMod(Type):
	for MilMod in militaryModifierList:
		if MilMod != null:
			if MilMod.milModType == Type:
				MilMod.queue_free()
				militaryModifierList.erase(MilMod)
		else:
			militaryModifierList.erase(MilMod)
	pass

func addWeapon(Type):
	var newWeapon = Weapon.new()
	newWeapon.weaponType = Type
	newWeapon.buildSelf()
	if newWeapon.melee == true:
		unitType = "Infantry"
	elif newWeapon.ranged == true:
		unitType = "Ranged"
	elif newWeapon.siege == true:
		unitType = "Siege"
	unitWeapon = newWeapon
	print("Successful addition of new weapon")
	getUnitAttributes()
	pass

func refillManpower(RR):
	unitCurrentManpower += RR
	if unitCurrentManpower > unitMaxManpower:
		unitCurrentManpower = unitMaxManpower
	pass

func calculateWeaponAdditions():
	match unitWeapon.weaponType:
		"Atlatl":
			unitOffensiveScore += 3
			unitDefensiveScore += 1
			var AtlatlPierce = milModScene.instantiate()
			AtlatlPierce.buildSelf("AtlatlPierce")
			addMilMod(AtlatlPierce)
		"Club":
			unitOffensiveScore += 2
			unitDefensiveScore += 2
			var ClubBleed = milModScene.instantiate()
			ClubBleed.buildSelf("ClubBleed")
			addMilMod(ClubBleed)
			#var Berserkers = milModScene.instantiate()
			#Berserkers.buildSelf("Berserkers")
			#addMilMod(Berserkers)
			
	pass

func removeWeaponAdditions():
	match unitWeapon.weaponType:
		"Atlatl":
			unitOffensiveScore -= 3
			unitDefensiveScore -= 1
			removeMilMod("AtlatlPierce")
		"Club":
			unitOffensiveScore -=2
			unitDefensiveScore -=2
			removeMilMod("ClubBleed")
			for MilMod in militaryModifierList:
				if MilMod.milModType == "Berserkers":
					militaryModifierList.erase(MilMod)
					removeMilMod("Berserkers")
				elif MilMod.milModType == "ClubBleed":
					militaryModifierList.erase(MilMod)
					removeMilMod("ClubBleed")
	unitWeapon.queue_free()
	unitWeapon = null
	print("Succesful purge of unitWeapon")
	pass

func removeOreMilMod(oreType):
	for MilMod in militaryModifierList:
		if MilMod.milModType == unitMetal.oreType:
			#print("HOMOSEXUASL")
			match MilMod.milModType:
				"Copper":
					unitOffensiveScore -= 2
					#unitDefensiveScore -= 1
				"Iron":
					unitOffensiveScore -=3
					#unitDefensiveScore -=2
				"Wood":
					unitOffensiveScore -= 1
				"Gold":
					unitOffensiveScore -= 1
				"Floodstone":
					unitOffensiveScore -= 5
			removeMilMod(MilMod.milModType)
	unitMetal.queue_free()
	pass

func disableMilModType(Type):
	for MilMod in militaryModifierList:
		MilMod.disableMilModType(Type)
	pass

func enableMilModType(Type):
	for MilMod in militaryModifierList:
		MilMod.enableMilModType(Type)
	pass

func calculateMilModChange(newMilMod):
	match newMilMod.milModType:
		"Berserkers":
			unitOffensiveScore += 3
		"ClubBleed":
			unitOffensiveScore += 4
		"AtlatlePierce":
			unitOffensiveScore += 3
		"Copper":
			unitOffensiveScore += 2
		"Iron":
			unitOffensiveScore += 3
		"Wood":
			unitOffensiveScore += 1
		"Gold":
			unitOffensiveScore += 1
		"Floodstone":
			unitOffensiveScore += 5
		"Visionary:":
			unitOffensiveScore += 5
func matchPlayerTemplateScores():
	
	pass
