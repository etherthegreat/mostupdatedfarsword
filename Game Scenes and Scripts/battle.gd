extends Node2D

class_name Battle
#Armies
var defendingArmies: Array = []
var attackingArmies: Array = []
#Leaders
var defendingLeaders: Array = []
var attackingLeaders: Array = []
#Wizards
var defendingWizards: Array = []
var attackingWizards: Array = []
#Units
var defendingMeleeUnits: Array = []
var defendingRangedUnits: Array = []
var attackingMeleeUnits: Array = []
var attackingRangedUnits: Array = []
#Army Strength
var averageDefendingArmyStrength: int
var averageAttackingArmyStrength: int
