extends Button

class_name beliefButton

@export var exportUpdatedTexture: Texture
var updatedTexture: Texture

@export var exportBeliefName: String

var beliefName


func updateButton():
	updatedTexture = exportUpdatedTexture
	icon = updatedTexture
	disabled = true
	pass
