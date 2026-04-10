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

var weaponOffence: int
var weaponDefence: int
var weaponRangedOffence: int
var weaponRangedDefence: int
var weaponSpellDefence: int
var weaponMaxShield: int

var oreMaxShield: int

var armorMeleeBlock: int
var armorRangedBlock: int
var armorSpellBlock: int

var unitOre: ore
var unitWeapon: Weapon
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

func buildSelf(parentCountry, Type, Level, WeaponType, OreType, ArmorType):
	#calculateManpower()
	unitType = Type
	unitLevel = Level
	var newWeapon = weaponScene.instantiate()
	newWeapon.updateSelf(WeaponType)
	unitWeapon = newWeapon
	var newOre = oreScene.instantiate()
	newOre.updateSelf(OreType)
	unitOre = newOre
	var newArmor = armorScene.instantiate()
	newArmor.updateSelf(ArmorType)
	unitArmor = newArmor
	unitCurrentManpower = (90 * unitLevel)
	unitMaxManpower = ( 100 * unitLevel)
	getUnitAttributes()
	pass

func getUnitAttributes(): # call whenever anything changes the unit, signal to the ui to update
	unitOffensiveScore = 0
	unitDefensiveScore = 0
	unitRangedOffence = 0
	unitRangedDefence = 0
	unitMagicDefence = 0
	unitMaxShield = 0
	for MilMod in militaryModifierList:
		removeMilMod(MilMod)
	emit_signal("getUnitInfo", unitType, self) #retrieves national modifiers, 
	#attempts to sort by type but not currently functioning
	calculateWeaponsOresArmor()
	calculateGrossValues()
	calculateMilMods()
	#signal to the unitUI to update itself here.  this will keep the player's information always up to date
	pass

func calculateWeaponsOresArmor():
	weaponOffence = unitWeapon.weaponOffensiveIncrease
	weaponDefence = unitWeapon.weaponDefensiveIncrease
	weaponRangedOffence = unitWeapon.rangedOffensiveIncrease
	weaponRangedDefence = unitWeapon.rangedDefensiveIncrease
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
	var manPowerEffect = (unitCurrentManpower/unitMaxManpower)
	var weaponsPowerEffect = (unitCurrentWeapons/unitMaxWeapons)
	var grossUnitOffence = (weaponOffence)
	#these numbers are all guesses btw, don't forget that
	var grossUnitDefence = (unitLevel * weaponDefence)
	var grossRangedOffence = (unitLevel * weaponRangedOffence)
	unitOffensiveScore = ((unitLevel * grossUnitOffence) * ((manPowerEffect+weaponsPowerEffect)/2))
	unitRangedOffence = ((unitLevel * grossUnitOffence) * ((manPowerEffect+weaponsPowerEffect)/2))
	unitMaxShield = ((unitLevel * oreMaxShield))
	unitDefensiveScore = (armorMeleeBlock * .1)
	unitRangedDefence = (armorRangedBlock * .1)
	unitMagicDefence = (armorSpellBlock * .1)# to make percentages
	pass
#add special super weapons gained from ruins and exploration, balance going heavy exploration with the other playthroughs
#exploration should be as valid a strategy as building super tall or expanding wide.
func calculateMilMods():
	if militaryModifierList != null:
		for MilMod in militaryModifierList:
			if MilMod.disabled != false:
				match MilMod.milModType:
					"AtatlPierce":
						unitRangedOffence * (1.05)
					"ClubBleed":
						unitOffensiveScore * (1.05)
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
	getUnitAttributes()
	pass

func changeArmor(Type):
	unitArmor.updateSelf(Type)
	getUnitAttributes()
	pass

func changeOre(Type):
	unitOre.updateSelf(Type)
	getUnitAttributes()
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
