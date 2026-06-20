extends Control

var funeral = load("res://art assets/AmericanRevolutionArt/End Art/IMG_1775.PNG")
var DCDown = load("res://art assets/AmericanRevolutionArt/End Art/IMG_1778.PNG")
var britishWhiteHouseElection = load("res://art assets/AmericanRevolutionArt/End Art/IMG_1782.PNG")
var endlessBattle = load("res://art assets/AmericanRevolutionArt/End Art/IMG_1784.PNG")
var stalemate = load("res://art assets/AmericanRevolutionArt/End Art/IMG_1783.PNG")

var date: String
var turn: String


func _ready() -> void:
	visible = false
	$GameOver.pressed.connect(_on_return_pressed)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")


func endGame(endType, endDate, endTurn):
	date = endDate
	turn = str("Turn ", endTurn)
	$DateLabel.text = date
	$TurnLabel.text = turn
	visible = true
	match endType:
		"funeral":
			funeralEnd()
		"DCdown":
			DCdownEnd()
		"britishWhiteHouse":
			britishWhiteHouseEnd()
		"endlessBattle":
			endlessBattleEnd()
		"stalemate":
			stalemateEnd()
	_fade_in_scene_sprite()


func _fade_in_scene_sprite() -> void:
	$SceneSprite.modulate = Color(0, 0, 0, 1)
	var tween := create_tween()
	tween.tween_property($SceneSprite, "modulate", Color(1, 1, 1, 1), 5.0)


func funeralEnd():
	$SceneSprite.texture = funeral
	$endingHeadlineLabel.text = "Death of the President"
	$endTextLabel.text = "July 4, 2026

President Ualani Carlisle was reported MIA after a recent encounter with British troops.  After Secret Service agents cleared the battlefield, they positively identified the president as deceased.  

Whether or not America survives will not be determined by Ualani Carlisle."
	pass

func DCdownEnd():
	$SceneSprite.texture = DCDown
	$endingHeadlineLabel.text = "DC Down!"
	$endTextLabel.text = "The capitol has fallen.  Our seat of government is in the hands of the enemy.  The representatives, senators, military staff, and bureacracy are in the hands of the enemy.

America once again falls to British dominance."
	pass

func britishWhiteHouseEnd():
	$SceneSprite.texture = britishWhiteHouseElection
	$endingHeadlineLabel.text = "A Predator in the White House!"
	$endTextLabel.text = "A British puppet, controlled by coordinated blackmail over his documented abuses across the board, has been granted the highest seat of American power.
	
	The people have spoken.  God save the King."
	pass

func endlessBattleEnd():
	$SceneSprite.texture = endlessBattle
	$endingHeadlineLabel.text = "Every State a Battlefield"
	$endTextLabel.text = "The United States of America continues it's fight of resistance against the invader King George III without President Ualani.
	
	The fight goes on."
	pass

func stalemateEnd():
	$SceneSprite.texture = stalemate
	$endingHeadlineLabel.text = "Demilitarized Zones of America"
	$endTextLabel.text = "The United States has become a bunker.  Environmental decay spreads from the West.  British troops invade from the coast.  The citizenry fights for their very lives.
	
	The fight goes on."
	pass
