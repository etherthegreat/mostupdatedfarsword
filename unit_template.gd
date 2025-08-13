extends Node2D

class_name UnitTemplate

var unitType: String

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

var unitImage: Texture2D
