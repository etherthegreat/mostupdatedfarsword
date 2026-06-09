extends Control

class_name MilMod



var milModType : String

var milModDescription : String

var milModTexture: Texture

var infantryMod: bool
var rangedMod: bool
var siegeMod: bool
var civilianMod: bool

var commanderMod: bool

var resourceMod: bool

var milModResource: String

var marineMod: bool
var entrenchMod: bool
var terrainMod: bool
var terrainType: String

var disabled: bool

var newArea2D: Area2D
var newCollissionArea2D: CollisionShape2D

func buildSelf(Type):
	#print("AHHHHHHHHHHHH", Type)
	milModType = Type
	infantryMod = false
	rangedMod = false
	siegeMod = false
	resourceMod = false
	commanderMod = false
	civilianMod = false
	marineMod = false
	entrenchMod = false
	terrainMod = false
	terrainType = ""
	#$Sprite2D/InfoPanel.visible = false
	match milModType:
		#COUNTRY MILMODS
		"Berserkers":
			infantryMod = true
			milModDescription = str("[i]Warriors are expected to kill or die trying:[/i][color= green] + 3 attack per level[/color],[color= red] -2 Harmony Per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/manpowerREALLYSMALL.png")
			milModResource = "Harmony"
		#WEAPONS
		"ClubBleed":
			infantryMod = true
			milModDescription = str("CLUB: [color=green] +2 Attack, +1 Defense per Level[/color], [color= red] -1 Weapons per Level")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Weapons"
		"AtlatlPierce":
			rangedMod = true
			milModDescription = str("ATLATL: [color=green] +1 Attack, +2 Defense per Level[/color], [color= red] -1 Weapons per Level")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/atlatlreallysmall.png")
			milModResource = "Weapons"
		#WEAPONORE
		"Wood":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are carved from wood[i]:[color= green] + 1 Attack per Level[/color], [color= red] -1 Wood per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Wood"
		"Copper":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are shaped by copper[i]:[color= green] + 2 Attack per Level[/color],[color= red] -1 Metal per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Iron":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are forged from iron[i]:[color= green] + 3 Attack per Level[/color],[color= red] -3 Metal per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Gold":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are built of gold,[i]:[color= green] + 2 Attack per Level[/color],[color= red] -1 Metal, -3 Gold per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Floodstone":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are birthed from floodstone,[i]:[color= green] + 3 Attack per Level[/color],[color= red] -2 Metal, -2 Magic per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		#CommanderMods
		"Visionary":
			commanderMod = true
			milModDescription = str("[i]This Unit's commander is a genius,[i]:[color= green] + 3 Attack per Level, + 10% speed[/color],")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Champion of the Sun":
			commanderMod = true
			milModDescription = str("[i]While the sun is up, this unit will march,[i]:[color= green] + 1 Attack per Level, + 10% speed[/color],")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Healer":
			commanderMod = true
			milModDescription = str("[i]This unit can heal super quick like da flash,[i]:[color= green] +10 reinforce rate,")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Translator":
			civilianMod = true
			milModDescription = str("This unit has been equipped with ancient dictionaries enabling them to writings from the past.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Science"
		"Seeder":
			civilianMod = true
			milModDescription = str("This unit has a bag of seeds, enabling it to change the agricultural output of the tile it is in.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "Food"
		"Wooden Tools":
			civilianMod = true
			milModDescription = str("This unit has tools made of wood.")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/manpowerREALLYSMALL.png")
			milModResource = "Wood"
		"Metal Tools":
			civilianMod = true
			milModDescription = str("This unit has tools made of metal.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Metal"
		"Steel Tools":
			civilianMod = true
			milModDescription = str("This Unit's tools are forged from advanced steel.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Metal"
		"Constructor":
			civilianMod = true
			milModDescription = str("This Unit's tools are forged from advanced steel.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Wood"
		"Adventurer":
			civilianMod = true
			milModDescription = str("This Unit is trained in exploring ruins, spelunking caves, and adventuring across the map.")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Food"
		"Scholar":
			civilianMod = true
			milModDescription = str("This unit has been educated and spread literacy, build libraries, and improve science output.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Science"
		"Entertainer":
			civilianMod = true
			milModDescription = str("This unit can entertain, soothe, sing, and bathe those in its care.")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/atlatlreallysmall.png")
			milModResource = "Influence"
		"Harvester":
			civilianMod = true
			milModDescription = str("This unit can collect crops, chop wood, clear brush, and manage rural areas.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Food"
		"Prospector":
			civilianMod = true
			milModDescription = str("This unit is trained in the art of prospecting and can build mines or discovery tile metals.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Wood"
		"Druid":
			civilianMod = true
			milModDescription = str("This unit has been trained in the Druidic arts and is capable at clearing corruption and can turn into animals.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Magic"
		"Chain":
			commanderMod = true
			milModDescription = str("[i]This Unit wears long chains, block [i]:[color= green] +5% Melee, +40% Ranged, + 5% Spell[/color], damage")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Weapons"
		"Shell":
			commanderMod = true
			milModDescription = str("[i]This Unit wears a fully-enclose shell, block [i]:[color= green] + 50% Spell[/color], damage")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Weapons"
		# ── TIER 1 MIL MODS ───────────────────────────────────────────────────
		"Woodsman":
			infantryMod = true
			terrainMod = true
			terrainType = "Woods"
			milModDescription = str("[i]Trained in forest fighting:[/i][color= green] +2 Attack, +2 Defense per Level in Woods terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Swamp Legs":
			infantryMod = true
			terrainMod = true
			terrainType = "Wetlands"
			milModDescription = str("[i]At home in the marshes:[/i][color= green] +2 Attack, +2 Defense per Level in Wetlands terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Hill Runner":
			infantryMod = true
			terrainMod = true
			terrainType = "Foothills"
			milModDescription = str("[i]Born on high ground:[/i][color= green] +2 Attack, +2 Defense per Level in Foothills terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Street Tough":
			infantryMod = true
			terrainMod = true
			terrainType = "Metro"
			milModDescription = str("[i]Raised fighting in alleyways:[/i][color= green] +2 Attack per Level in Metro or Suburbs terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Farmhand":
			infantryMod = true
			terrainMod = true
			terrainType = "Farmlands"
			milModDescription = str("[i]Knows every row of every field:[/i][color= green] +1 Attack per Level in Farmlands terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Saber Drill":
			infantryMod = true
			milModDescription = str("[i]Relentless close-combat drilling:[/i][color= green] +3 Attack per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Marksman":
			rangedMod = true
			milModDescription = str("[i]Trained to shoot straight and true:[/i][color= green] +2 Ranged Attack per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Steady Line":
			infantryMod = true
			milModDescription = str("[i]Hold the line at all costs:[/i][color= green] +3 Defense per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Quick Reload":
			rangedMod = true
			milModDescription = str("[i]Powder and ball, faster than any rival:[/i][color= green] Reload reduced by 1 round[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Powder & Shot":
			siegeMod = true
			milModDescription = str("[i]The cannons never run dry:[/i][color= green] +3 Siege Attack per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Fortified Position":
			commanderMod = true
			milModDescription = str("[i]The fortifications hold the line:[/i][color= green] All units +3 Defense per Level in tiles with Barracks or Fortress[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Coastal Watch":
			commanderMod = true
			milModDescription = str("[i]Eyes on every inlet and estuary:[/i][color= green] All units +2 Defense per Level when adjacent to naval tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── TIER 2 MIL MODS ───────────────────────────────────────────────────
		"Marine":
			commanderMod = true
			marineMod = true
			milModDescription = str("[i]Land and sea are one battlefield:[/i][color= green] Army may launch melee attacks into adjacent naval tile neighbors[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Guerrilla Tactics":
			infantryMod = true
			terrainMod = true
			terrainType = "Woods"
			milModDescription = str("[i]Strike fast, vanish faster:[/i][color= green] +4 Attack, +4 Defense per Level in Woods or Wetlands terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Double Shot":
			siegeMod = true
			milModDescription = str("[i]Load two rounds before the smoke clears:[/i][color= green] Siege fires twice per round — second shot at 50% power[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Iron Bayonet":
			infantryMod = true
			milModDescription = str("[i]The first charge carries iron conviction:[/i][color= green] +5 Attack per Level in first battle round[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Sharpshooter":
			rangedMod = true
			milModDescription = str("[i]No cover is safe from this unit's aim:[/i][color= green] Ranged attacks ignore 2 enemy Defense per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Corrupted Ground":
			commanderMod = true
			milModDescription = str("[i]This army cleanses the land they march through:[/i][color= green] Army presence reduces tile corruption by 1 per turn[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Rallying Voice":
			commanderMod = true
			milModDescription = str("[i]No soldier routs while the commander still stands:[/i][color= green] Morale loss reduced; rout threshold lowered to 15%[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Night Raider":
			commanderMod = true
			milModDescription = str("[i]Strike under cover of darkness:[/i][color= green] Army may move and attack in the same turn without penalty[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Flanking Drill":
			infantryMod = true
			milModDescription = str("[i]Always find the open flank:[/i][color= green] +3 Attack per Level when fighting in a contested tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Vanguard":
			commanderMod = true
			milModDescription = str("[i]The first into the breach:[/i][color= green] All units +4 Attack per Level on first engagement in a fresh tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Siege Line":
			siegeMod = true
			milModDescription = str("[i]Walls and ramparts are merely delays:[/i][color= green] Siege attacks against fortified tiles suffer no defensive penalty[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Cleaner":
			commanderMod = true
			milModDescription = str("[i]Order restored, one tile at a time:[/i][color= green] Army presence reduces tile moral decay by 1 per turn[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		# ── TIER 3 MIL MODS ───────────────────────────────────────────────────
		"Entrenched":
			commanderMod = true
			entrenchMod = true
			milModDescription = str("[i]This ground is ours to keep:[/i][color= green] After 3 stationary turns, all units gain +5 Defense per Level — lost on movement[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Continental Line":
			commanderMod = true
			milModDescription = str("[i]The pride of the revolution, standing firm:[/i][color= green] All units +2 Attack, +2 Defense per Level permanently[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Last Stand":
			infantryMod = true
			milModDescription = str("[i]With nothing left to lose, they fight like lions:[/i][color= green] Units below 25% manpower gain +6 Attack per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Terror":
			commanderMod = true
			milModDescription = str("[i]The enemy trembles before this army's name:[/i][color= green] Enemy loses 10 Morale at the start of each battle round[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Iron Wall":
			commanderMod = true
			milModDescription = str("[i]No invader passes this line:[/i][color= green] +8 Defense per Level when defending the commander's home tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Rampart":
			commanderMod = true
			milModDescription = str("[i]Every stone in this fortress knows their name:[/i][color= green] +5 Defense per Level in any Fortress tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Naval Supremacy":
			commanderMod = true
			marineMod = true
			milModDescription = str("[i]The sea bows to this army's will:[/i][color= green] Marine melee attacks deal +5 additional damage per Level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Ghost March":
			commanderMod = true
			milModDescription = str("[i]They pass through the enemy's reach like smoke:[/i][color= green] Army ignores enemy zone of control[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Undaunted":
			commanderMod = true
			milModDescription = str("[i]Fear has no purchase on this army:[/i][color= green] Ignore the first retreat check each battle[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Double Cannonade":
			siegeMod = true
			milModDescription = str("[i]Two volleys where any lesser battery gives one:[/i][color= green] Siege fires twice per round AND +3 Attack per Level on all shots[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Liberator's Will":
			commanderMod = true
			milModDescription = str("[i]Every liberated tile fuels the fire:[/i][color= green] After liberating a tile, +15% manpower and commander gains +2 Loyalty[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"The Long March":
			commanderMod = true
			milModDescription = str("[i]Miles are nothing to those who've marched through hell:[/i][color= green] +2 Movement Points; full movement may be used before attacking[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
	$Sprite2D/InfoPanel/MilModNameLabel.text = str(milModType)
	$Sprite2D/InfoPanel/MilModDescriptionLabel.text = str(milModDescription)
	$Sprite2D.texture = milModTexture
	newArea2D = $Area2D
	newCollissionArea2D = $Area2D/CollisionShape2D
	#print("Area2D", newArea2D, "newCollisionarea2d", newCollissionArea2D)
	pass

var mouseDetected: bool

func disableMilModType(ResourceType):
	if ResourceType == milModResource:
		disabled = true
	elif ResourceType == "All":
		disabled = true
	pass

func enableMilModType(ResourceType):
	if ResourceType == milModResource:
		disabled = false
	elif ResourceType == "All":
		disabled = false
	pass

func _process(delta: float) -> void:
	if mouseDetected == true:
		if $Sprite2D/InfoPanel.visible == false:
			$Sprite2D/InfoPanel.show()
			#print("what the fuck")
			return
		else:
			return
	else:
		if $Sprite2D/InfoPanel.visible == true:
			$Sprite2D/InfoPanel.hide()
			return
		else:
			return


func _on_area_2d_mouse_entered() -> void:
	mouseDetected = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	mouseDetected = false
	pass # Replace with function body.
