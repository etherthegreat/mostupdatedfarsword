extends Control

class_name Unit

var playerCountry: country

var unitType: String
var unitLevel: int

var unitDefensiveScore: float #per level
var unitOffensiveScore: float #per level
var unitRangedOffence: float
var unitRangedDefence: float
var unitMagicDefence: float

var weaponOffence: float
var weaponDefence: float
var weaponRangedOffence: float
var weaponRangedDefence: float
var weaponSpellDefence: float
var weaponMaxShield: float

var oreMaxShield: float

var armorMeleeBlock: float
var armorRangedBlock: float
var armorSpellBlock: float

var unitOre: ore
var unitWeapon: Weapon
var weaponString: String
var unitArmor: Armor

var unitImage: Texture2D

var unitMaxManpower: int
var unitCurrentManpower: int

var unitMaxWeapons: int
var unitCurrentWeapons: int

var unitShield: int
var unitMaxShield: int

var militaryModifierList: Array = []

const milModScene = preload("res://mil_mod.tscn")

const weaponScene = preload("res://weapon.tscn")
const oreScene = preload("res://ore.tscn")
const armorScene = preload("res://armor.tscn")

signal getUnitInfo
signal updateArmy

func buildSelf(parentCountry, Type, Level, WeaponType, OreType, ArmorType, CurMan, CurWeapons): #add current manpower, maxmanpower, currentwepaons, maxweaposn
	#calculateManpower()
	playerCountry = parentCountry
	unitType = Type
	unitLevel = Level
	var newWeapon = weaponScene.instantiate()
	#newWeapon.updateSelf(WeaponType)
	unitWeapon = newWeapon
	changeWeapon(WeaponType)
	var newOre = oreScene.instantiate()
	#newOre.updateSelf(OreType)
	unitOre = newOre
	changeOre(OreType)
	var newArmor = armorScene.instantiate()
	#newArmor.updateSelf(ArmorType)
	unitArmor = newArmor
	changeArmor(ArmorType)
	unitCurrentManpower = CurMan
	unitCurrentWeapons = CurWeapons
	getUnitAttributes()
	pass

func getUnitAttributes(): # call whenever anything changes the unit, signal to the ui to update
	unitOffensiveScore = 0
	unitDefensiveScore = 0
	unitRangedOffence = 0
	unitRangedDefence = 0
	unitMagicDefence = 0
	unitMaxShield = 0
	unitMaxManpower = (100 * unitLevel)
	unitMaxWeapons = (100 * unitLevel)
	for MilMod in militaryModifierList:
		removeMilMod(MilMod)
	emit_signal("getUnitInfo", unitType, self) #retrieves national modifiers, 
	#attempts to sort by type but not currently functioning
	calculateWeaponsOresArmor()
	calculateGrossValues()
	#signal to the unitUI to update itself here.  this will keep the player's information always up to date
	pass

func calculateWeaponsOresArmor():
	weaponOffence = unitWeapon.weaponOffensiveIncrease
	weaponDefence = unitWeapon.weaponDefensiveIncrease
	weaponRangedOffence = unitWeapon.rangedOffensiveIncrease
	print(weaponRangedOffence, "PIE")
	weaponRangedDefence = unitWeapon.rangedDefensiveIncrease
	print("unit weapon offensive", unitWeapon.weaponType, unitWeapon.weaponOffensiveIncrease)
	for MilMod in unitWeapon.weaponMilMods:
		addMilMod(MilMod)
	oreMaxShield = unitOre.oreMaxShield
	for MilMod in unitOre.oreMilMods:
		addMilMod(MilMod)
	armorMeleeBlock = unitArmor.armorMeleeBlock
	armorRangedBlock = unitArmor.armorRangedBlock
	armorSpellBlock = unitArmor.armorSpellBlock
	for MilMod in unitArmor.armorMilMods:
		addMilMod(MilMod)
	pass

func calculateGrossValues():
	var manPowerEffect: float = (unitCurrentManpower/unitMaxManpower)
	var weaponsPowerEffect: float = (unitCurrentWeapons/unitMaxWeapons)
	var grossUnitOffence: float = (unitLevel * weaponOffence)
	#these numbers are all guesses btw, don't forget that
	var grossUnitDefence : float = (unitLevel * weaponDefence)
	var grossRangedOffence: float = (unitLevel * weaponRangedOffence)
	var grossRangedDefence: float = (unitLevel * weaponRangedDefence)
	unitOffensiveScore += ((unitLevel * grossUnitOffence) * ((manPowerEffect+weaponsPowerEffect)/2))
	unitRangedOffence += ((unitLevel * grossRangedOffence) * ((manPowerEffect+weaponsPowerEffect)/2))
	unitMaxShield += ((unitLevel * oreMaxShield))
	unitDefensiveScore += (armorMeleeBlock * .1)
	unitRangedDefence += (armorRangedBlock * .1)
	unitMagicDefence += (armorSpellBlock * .1)# to make percentages
	print("caLCULATE gross values", unitRangedOffence, unitOffensiveScore)
	pass
#add special super weapons gained from ruins and exploration, balance going heavy exploration with the other playthroughs
#exploration should be as valid a strategy as building super tall or expanding wide.
func calculateMilMods():
	if militaryModifierList != null:
		for MilMod in militaryModifierList:
			print(MilMod.milModType, "MODTYPE")
			if MilMod.disabled != false:
				match MilMod.milModType:
					"AtlatlPierce":
						unitRangedOffence *= (1.05)
					"ClubBleed":
						unitOffensiveScore *= (1.05)
					"Copper":
						unitMagicDefence += (0.02 * unitLevel)
					"Gold":
						unitMagicDefence += (0.04 * unitLevel)
					"Scale":
						unitMaxShield += (unitLevel * 7)
					"Chain":
						unitRangedOffence += unitLevel
					"Cast":
						unitOffensiveScore += unitLevel
	pass

func addMilMod(mM):
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(mM.milModType)
	militaryModifierList.append(newMilMod)
	pass

func removeMilMod(milMod):
	for MilMod in militaryModifierList:
		if MilMod == milMod:
			MilMod.queue_free()
			militaryModifierList.erase(MilMod)
		else:
			militaryModifierList.erase(MilMod)
	pass

func changeWeapon(Type):
	unitWeapon.updateSelf(Type)
	weaponString = Type
	pass

func changeArmor(Type):
	unitArmor.updateSelf(Type)
	pass

func changeOre(Type):
	unitOre.updateSelf(Type)
	pass

func refillManpower(RR):
	unitCurrentManpower += RR
	if unitCurrentManpower > unitMaxManpower:
		unitCurrentManpower = unitMaxManpower
	pass

func disableMilModType(Type):
	for MilMod in militaryModifierList:
		MilMod.disableMilModType(Type)
	pass

func enableMilModType(Type):
	for MilMod in militaryModifierList:
		MilMod.enableMilModType(Type)
	pass
