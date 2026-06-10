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

var toolMod: bool
var stormMod: bool
var stormType: String        # storm type this mod counters ("Fog", "Blizzard", etc.)
var culturalMod: bool
var culturalState: String    # state code this mod is exclusive to (e.g. "TN", "VA")

var disabled: bool
var turnsRemaining: int = -1   # -1 = permanent; ≥1 = turns left; removed at 0
var isNegative: bool = false

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
	toolMod = false
	stormMod = false
	stormType = ""
	culturalMod = false
	culturalState = ""
	turnsRemaining = -1
	isNegative     = false
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
		# ── MYTHIC WEAPON MODS ────────────────────────────────────────────────────
		"BatSweep":
			infantryMod = true
			milModDescription = str("[i]A swing for the fences:[/i][color= green] +10% attack; first hit ignores shields[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"TridentPierce":
			rangedMod = true
			marineMod = true
			milModDescription = str("[i]Sea god's mercy:[/i][color= green] Pierces shields; +3 attack per level near naval tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"MythicAtlatl":
			rangedMod = true
			milModDescription = str("[i]The ancient art, perfected:[/i][color= green] +2 ranged per level; critical hits stun target 1 turn[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/atlatlreallysmall.png")
			milModResource = "None"
		"SharpShot":
			rangedMod = true
			milModDescription = str("[i]No cover can save them:[/i][color= green] Ignores 4 enemy defense per level; terrain cover ignored[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"PirateVolley":
			rangedMod = true
			milModDescription = str("[i]Blackbeard fires twice, and smiles:[/i][color= green] Fires twice per ranged round; +5 enemy morale terror[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"CylinderFire":
			rangedMod = true
			milModDescription = str("[i]Six shots, then speed-loader:[/i][color= green] No reload for first 3 shots; 2-turn reload thereafter[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"RocketBarrage":
			siegeMod = true
			milModDescription = str("[i]Light the fuse and run:[/i][color= green] Massive area damage; leaves fire modifier on tile for 2 turns[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"TrebuchetLaunch":
			siegeMod = true
			milModDescription = str("[i]Physics applied to stone:[/i][color= green] +50% siege damage vs Fortress tiles; stuns defenders 1 round[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"AerialBombing":
			siegeMod = true
			commanderMod = true
			milModDescription = str("[i]Death from above — the future is now:[/i][color= green] Ignores all ground defensive bonuses; terrifies enemy[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── UNIFORM MODS ──────────────────────────────────────────────────────────
		"QuickDraw":
			infantryMod = true
			milModDescription = str("[i]First shot wins the duel:[/i][color= green] First ranged attack each battle deals +5 bonus damage[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"HardeeDisc":
			infantryMod = true
			milModDescription = str("[i]Dress right, dress — hold the line:[/i][color= green] +3 defense per level when an adjacent friendly unit is present[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		# ── STORM COUNTER MODS ────────────────────────────────────────────────────
		"Fog-Born":
			commanderMod = true
			stormMod = true
			stormType = "Fog"
			milModDescription = str("[i]The fog is their home:[/i][color= green] +5 attack per level in Fog storm tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Storm Rider":
			commanderMod = true
			stormMod = true
			stormType = "Any"
			milModDescription = str("[i]Storms are just weather to this army:[/i][color= green] Movement not reduced by any active storm[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Thunder Proof":
			commanderMod = true
			stormMod = true
			stormType = "Thunderstorm"
			milModDescription = str("[i]Thunder cannot shake what iron resolve has hardened:[/i][color= green] Immune to Thunderstorm morale penalty[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Blizzard March":
			commanderMod = true
			stormMod = true
			stormType = "Blizzard"
			milModDescription = str("[i]Valley Forge was just training:[/i][color= green] No movement or supply penalty in Blizzard tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Hurricane Eyes":
			commanderMod = true
			stormMod = true
			stormType = "Hurricane"
			milModDescription = str("[i]In the eye, nothing is calmer:[/i][color= green] +5 attack per level in Hurricane storm tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Tornado Dancer":
			commanderMod = true
			stormMod = true
			stormType = "Tornado"
			milModDescription = str("[i]Move with it, not against it:[/i][color= green] Army ignores Tornado scatter and manpower drain effects[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Nor'easter Veteran":
			commanderMod = true
			stormMod = true
			stormType = "Nor'easter"
			milModDescription = str("[i]Born in nor'easter country:[/i][color= green] +3 defense per level in Nor'easter tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Rain Reader":
			rangedMod = true
			stormMod = true
			stormType = "Thunderstorm"
			milModDescription = str("[i]Reads the rain like a map:[/i][color= green] +3 ranged attack per level during Thunderstorm[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"White Out Walker":
			infantryMod = true
			stormMod = true
			stormType = "Blizzard"
			milModDescription = str("[i]The white-out is their invisibility cloak:[/i][color= green] +3 attack per level during Blizzard[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Storm Chaser":
			commanderMod = true
			stormMod = true
			stormType = "Any"
			milModDescription = str("[i]Follows the tempest, never behind it:[/i][color= green] +1 movement point in any active storm tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Lightning Rod":
			siegeMod = true
			stormMod = true
			stormType = "Thunderstorm"
			milModDescription = str("[i]Harness the lightning, aim the cannon:[/i][color= green] Artillery units ignore storm ranged accuracy penalty[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Eye of the Storm":
			commanderMod = true
			stormMod = true
			stormType = "Any"
			milModDescription = str("[i]Calm inside the chaos:[/i][color= green] +4 attack, +4 defense per level while any storm is active in tile[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── CULTURAL / STATE-SPECIFIC MODS ────────────────────────────────────────
		"Country Musician":
			commanderMod = true
			culturalMod = true
			culturalState = "TN"
			milModDescription = str("[i]Tennessee born and bred — a song for every march:[/i][color= green] +3 morale; +2 attack per level in Farmlands[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Virginia Gentry":
			commanderMod = true
			culturalMod = true
			culturalState = "VA"
			milModDescription = str("[i]The Virginia cavalry tradition runs deep:[/i][color= green] +3 ranged defense per level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Minuteman's Pride":
			commanderMod = true
			culturalMod = true
			culturalState = "MA"
			milModDescription = str("[i]The shot heard 'round the world started here:[/i][color= green] +5 attack per level in the first 3 battle rounds[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Quaker Steel":
			commanderMod = true
			culturalMod = true
			culturalState = "PA"
			milModDescription = str("[i]Peaceful people, formidable defenders:[/i][color= green] +2 defense per level; -1 attack per level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Georgia Peach":
			infantryMod = true
			culturalMod = true
			culturalState = "GA"
			milModDescription = str("[i]Georgia grit runs deeper than the red clay:[/i][color= green] +3 food efficiency; +1 ranged per level[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Backcountry Rider":
			infantryMod = true
			terrainMod = true
			terrainType = "Woods"
			culturalMod = true
			culturalState = "SC"
			milModDescription = str("[i]The Carolina backcountry bred this fighter:[/i][color= green] +4 attack per level in Woods terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Harbor Watch":
			commanderMod = true
			marineMod = true
			culturalMod = true
			culturalState = "NY"
			milModDescription = str("[i]New York never sleeps, and neither does its harbor guard:[/i][color= green] +3 attack per level near naval tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Chesapeake Sailor":
			commanderMod = true
			marineMod = true
			culturalMod = true
			culturalState = "MD"
			milModDescription = str("[i]Grew up on the bay, fights like it:[/i][color= green] +2 melee per level; Marine melee attack enabled[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Frontier Marksman":
			rangedMod = true
			terrainMod = true
			terrainType = "Foothills"
			culturalMod = true
			culturalState = "KY"
			milModDescription = str("[i]Kentucky long rifle, mountain-born aim:[/i][color= green] +4 ranged per level in Foothills terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"River Runner":
			commanderMod = true
			culturalMod = true
			culturalState = "OH"
			milModDescription = str("[i]Ohio's rivers are roads to those who know them:[/i][color= green] +2 movement points; +2 attack per level near water tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Everglades Tracker":
			infantryMod = true
			terrainMod = true
			terrainType = "Wetlands"
			culturalMod = true
			culturalState = "FL"
			milModDescription = str("[i]The swamp doesn't slow what the swamp raised:[/i][color= green] +4 attack and defense per level in Wetlands[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Bayou Warrior":
			infantryMod = true
			terrainMod = true
			terrainType = "Wetlands"
			culturalMod = true
			culturalState = "LA"
			milModDescription = str("[i]The bayou forged a different kind of soldier:[/i][color= green] +5 attack per level in Wetlands terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		# ── TOOL MODS (expanded civilian capability list) ─────────────────────────
		"Cartographer":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit maps explored tiles, revealing terrain bonuses and hidden resources.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Science"
		"Herbalist":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit gathers medicinal herbs, healing +5 manpower per turn in the tile.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Food"
		"Engineer":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit builds roads and improves existing structures faster than standard workers.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Wood"
		"Blacksmith":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit reduces weapon upkeep costs by 1 per level per turn for stationed armies.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Metal"
		"Physician":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit provides advanced medical care, restoring +10 manpower per turn to armies in the tile.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Food"
		"Merchant":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit conducts trade, generating +3 gold per turn for the treasury.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Gold"
		"Preacher":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit delivers sermons that raise tile governor loyalty by +5 per turn.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "Influence"
		"Architect":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit designs buildings more efficiently, reducing construction costs by 15%.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Wood"
		"Hunter":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit hunts game in the surrounding wilderness, generating +5 food per turn.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Food"
		"Fisherman":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit fishes from rivers or coastlines, generating +3 food per turn near water tiles.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "Food"
		"Surveyor":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit surveys the land, revealing terrain bonuses of all adjacent tiles.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Science"
		"Trapper":
			civilianMod = true
			toolMod = true
			milModDescription = str("This unit sets trap lines through the wilderness, generating +2 food and +1 trade per turn.")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "Food"
		"Park Ranger":
			civilianMod = true
			toolMod = true
			milModDescription = str("[i]Knows every trail, every hazard, every bad thing in the dirt:[/i][color=green] Army is immune to corruption-based disease[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"President":
			commanderMod = true
			milModDescription = str("[i]The Republic moves when she moves:[/i][color=green] +3 movement points per turn[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Election Season":
			commanderMod = true
			milModDescription = str("[i]History is watching. Keep up.:[/i][color=green] +3 movement points per turn, for the rest of the game[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── STATE / PROVINCIAL GUARD MODS ───────────────────────────────────────
		# Each grants +2 attack and +2 defence per level when in a matching state tile.
		"Pennsylvania Guard":
			culturalMod = true
			culturalState = "PA"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Pennsylvania tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Virginia Guard":
			culturalMod = true
			culturalState = "VA"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Virginia tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"New York Guard":
			culturalMod = true
			culturalState = "NY"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in New York tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Massachusetts Guard":
			culturalMod = true
			culturalState = "MA"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Massachusetts tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Maryland Guard":
			culturalMod = true
			culturalState = "MD"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Maryland tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"North Carolina Guard":
			culturalMod = true
			culturalState = "NC"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in North Carolina tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"South Carolina Guard":
			culturalMod = true
			culturalState = "SC"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in South Carolina tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Georgia Guard":
			culturalMod = true
			culturalState = "GA"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Georgia tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Connecticut Guard":
			culturalMod = true
			culturalState = "CT"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Connecticut tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"New Jersey Guard":
			culturalMod = true
			culturalState = "NJ"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in New Jersey tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Delaware Guard":
			culturalMod = true
			culturalState = "DE"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Delaware tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"New Hampshire Guard":
			culturalMod = true
			culturalState = "NH"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in New Hampshire tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Rhode Island Guard":
			culturalMod = true
			culturalState = "RI"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Rhode Island tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Vermont Guard":
			culturalMod = true
			culturalState = "VT"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Vermont tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Maine Guard":
			culturalMod = true
			culturalState = "ME"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Maine tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Tennessee Guard":
			culturalMod = true
			culturalState = "TN"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Tennessee tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Alabama Guard":
			culturalMod = true
			culturalState = "AL"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Alabama tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Florida Guard":
			culturalMod = true
			culturalState = "FL"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Florida tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"West Virginia Guard":
			culturalMod = true
			culturalState = "WV"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in West Virginia tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"DC Guard":
			culturalMod = true
			culturalState = "DC"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Washington DC tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Quebec Guard":
			culturalMod = true
			culturalState = "CA - QB"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Quebec tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Ontario Guard":
			culturalMod = true
			culturalState = "CA - OT"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Ontario tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Nova Scotia Guard":
			culturalMod = true
			culturalState = "CA - NS"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Nova Scotia tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"New Brunswick Guard":
			culturalMod = true
			culturalState = "CA - NB"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in New Brunswick tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Prince Edward Island Guard":
			culturalMod = true
			culturalState = "CA - PEI"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Prince Edward Island tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Bahamas Guard":
			culturalMod = true
			culturalState = "BA"
			commanderMod = true
			milModDescription = str("[i]Home soil, home rules:[/i][color=green] +2 Attack, +2 Defence per Level in Bahamas tiles[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── PROTECTOR BUFFS ──────────────────────────────────────────────────────
		# Applied via magic (cast_protector_buff outcome). Drain magic each turn.
		"Mothman Presence":
			commanderMod = true
			milModDescription = str("[i]It has been watching for decades. Now it watches for you.:[/i][color=green] +20 Ranged Attack, +15 Ranged Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Jersey Devil's Fury":
			commanderMod = true
			milModDescription = str("[i]Born wrong, fights right. Absolutely territorial.:[/i][color=green] +25 Attack, +10 Ranged, +10 Block[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Bigfoot's Solidarity":
			commanderMod = true
			milModDescription = str("[i]Eleven counties of footprints. Solidarity through presence.:[/i][color=green] +30 Block, +15 Attack[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Thunderbird's Sovereignty":
			commanderMod = true
			milModDescription = str("[i]Ancient skies reclaiming what was taken.:[/i][color=green] +25 Ranged Attack, +10 Melee Attack[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Headless Terror":
			commanderMod = true
			milModDescription = str("[i]Can't aim. Compensates with enthusiasm. Enemies flee on contact.:[/i][color=green] +20 Attack, +10 Block; attackers become Terrified[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Chessie's Blessing":
			commanderMod = true
			milModDescription = str("[i]The Chesapeake remembers who protected her.:[/i][color=green] +20 Block, +15 Ranged Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Bell Witch's Harassment":
			commanderMod = true
			milModDescription = str("[i]She operates on her own terms. Psychological pressure is her weapon.:[/i][color=green] +15 Attack, +20 Defence; attackers become Demoralized[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Old Ironsides' Hull":
			commanderMod = true
			milModDescription = str("[i]Unsinkable. Refuses retirement. Has eaten admirals.:[/i][color=green] +30 Shield, +20 Block[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Valley Forge's Will":
			commanderMod = true
			milModDescription = str("[i]Not Washington. The army itself. Frozen, starved, stayed.:[/i][color=green] +10 Attack, +25 Block, +20 Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Snallygaster's Claim":
			commanderMod = true
			milModDescription = str("[i]Half-reptile, half-bird, entirely done with your presence.:[/i][color=green] +20 Attack, +10 Ranged, +10 Block[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Paul Revere's Ride":
			commanderMod = true
			milModDescription = str("[i]Agitated. Fast. Loud. One more ride.:[/i][color=green] +15 Ranged, +10 Attack, +3 Movement[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Liberty Bell's Resonance":
			commanderMod = true
			milModDescription = str("[i]Cracked. Resonant. The crack is a feature.:[/i][color=green] +25 Block, +15 Ranged Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Green Mountain Haunting":
			commanderMod = true
			milModDescription = str("[i]Invisible. Productive. Haunting as a form of caretaking.:[/i][color=green] +20 Block, +15 Ranged Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Presidential Decree":
			commanderMod = true
			milModDescription = str("[i]Four presidents arguing. Washington chairs. Roosevelt interrupts.:[/i][color=green] +20 Attack, +20 Block, +15 Ranged, +15 Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Skunk Ape's Domain":
			commanderMod = true
			milModDescription = str("[i]Massive. Fragrant. Passionate about swamp sovereignty.:[/i][color=green] +20 Attack, +15 Block[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Eternal Vigilance":
			commanderMod = true
			milModDescription = str("[i]Ready. Always. The first shot echoes still.:[/i][color=green] +25 Block, +10 Attack[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Lincoln's Mandate":
			commanderMod = true
			milModDescription = str("[i]2am wisdom. Unfinished business. The arc bends toward justice.:[/i][color=green] +15 Attack, +15 Block, +15 Ranged, +10 Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Le Wendigo's Hunger":
			commanderMod = true
			milModDescription = str("[i]The hunger is not metaphorical.:[/i][color=green] +30 Melee Attack[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Loup-Garou's Frenzy":
			commanderMod = true
			milModDescription = str("[i]The moon is always full enough.:[/i][color=green] +25 Attack, +15 Block, +10 Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Feux Follets' Misdirection":
			commanderMod = true
			milModDescription = str("[i]Follow the lights. Or don't. They'll find you anyway.:[/i][color=green] +25 Ranged Defence, +15 Block[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Mishepeshu's Depths":
			commanderMod = true
			milModDescription = str("[i]The water panther guards what the water touches.:[/i][color=green] +20 Block, +20 Ranged Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"La Corriveau's Cage":
			commanderMod = true
			milModDescription = str("[i]She was executed. She did not agree with the verdict.:[/i][color=green] +20 Ranged, +15 Attack[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Le Carcajou's Tenacity":
			commanderMod = true
			milModDescription = str("[i]The wolverine does not stop. It is not familiar with stopping.:[/i][color=green] +20 Attack, +15 Block, +10 Defence[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"La Chasse-Galerie":
			commanderMod = true
			milModDescription = str("[i]The flying canoe goes where canoes should not go.:[/i][color=green] +15 Attack, +15 Ranged, +4 Movement[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Le Gougou's Terror":
			commanderMod = true
			milModDescription = str("[i]The Gougou makes a sound. No one describes it twice.:[/i][color=green] +15 Attack, +20 Defence; attackers become Terrified for 3 turns[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		# ── ICON BELIEF MODS ─────────────────────────────────────────────────────
		"Crossing of the Delaware":
			commanderMod = true
			milModDescription = str("[i]A midnight river, a freezing dawn, and the world changed:[/i][color= green] All units +3 Defense per Level in tiles with Barracks or Fortress[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Combahee River Raid":
			infantryMod = true
			milModDescription = str("[i]She led three gunboats and freed 700 souls — no hesitation:[/i][color= green] +5 Attack per Level in first battle round[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Emancipation Advance":
			commanderMod = true
			milModDescription = str("[i]A nation divided cannot stand — but it can march:[/i][color= green] All units +2 Attack, +2 Defense per Level permanently[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Rough Rider's Charge":
			infantryMod = true
			terrainMod = true
			terrainType = "Woods"
			milModDescription = str("[i]San Juan Hill taken at a gallop — Bully!:[/i][color= green] +4 Attack, +4 Defense per Level in Woods or Wetlands terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"North Star Address":
			commanderMod = true
			milModDescription = str("[i]Once he found his voice, nothing could silence it:[/i][color= green] Morale loss reduced; rout threshold lowered to 15%[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
		"Little Bighorn Ambush":
			infantryMod = true
			terrainMod = true
			terrainType = "Woods"
			milModDescription = str("[i]He saw it in a vision before it happened — thousands of soldiers falling:[/i][color= green] +2 Attack, +2 Defense per Level in Woods terrain[/color]")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		# ── NEGATIVE STATUS EFFECTS ──────────────────────────────────────────────
		"Stunned":
			isNegative = true
			milModDescription = "[i]Dazed and unable to act:[/i][color=red] Cannot make melee attacks this turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Suppressed":
			isNegative = true
			milModDescription = "[i]Pinned under fire:[/i][color=red] Cannot fire ranged attacks this turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Shaken":
			isNegative = true
			milModDescription = "[i]Formation broken:[/i][color=red] Melee block halved[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Terrified":
			isNegative = true
			milModDescription = "[i]Frozen in fear:[/i][color=red] Melee attack −50%, melee block −30%[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Routed":
			isNegative = true
			milModDescription = "[i]Fleeing the field:[/i][color=red] Cannot attack; melee attack zeroed; ranged defence halved[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Burning":
			isNegative = true
			milModDescription = "[i]The ranks are on fire:[/i][color=red] Loses manpower each turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Blinded":
			isNegative = true
			milModDescription = "[i]Can't see a thing:[/i][color=red] Ranged attack and ranged defence halved[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Hexed":
			isNegative = true
			milModDescription = "[i]Cursed by dark magic:[/i][color=red] Magic defence eliminated[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Diseased":
			isNegative = true
			milModDescription = "[i]Plague has struck the ranks:[/i][color=red] Loses manpower each turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Waterlogged":
			isNegative = true
			stormMod = true
			stormType = "Thunderstorm"
			milModDescription = "[i]Soaked to the bone:[/i][color=red] Melee and ranged attack −20%[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Frostbitten":
			isNegative = true
			stormMod = true
			stormType = "Blizzard"
			milModDescription = "[i]Fingers too cold to hold a weapon:[/i][color=red] Melee and ranged attack −30%[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Demoralized":
			isNegative = true
			milModDescription = "[i]Spirit broken:[/i][color=red] Melee attack −20%, block −20%, all mil mods disabled[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Exhausted":
			isNegative = true
			milModDescription = "[i]Worn out from the march:[/i][color=red] Movement reduced to 1 this turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Bogged Down":
			isNegative = true
			milModDescription = "[i]Stuck fast:[/i][color=red] Cannot move this turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Pacified":
			isNegative = true
			milModDescription = "[i]Ordered to stand down:[/i][color=red] Cannot initiate attacks this turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Supply Cut":
			isNegative = true
			milModDescription = "[i]Supplies intercepted:[/i][color=red] Cannot reinforce or resupply[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Quarantined":
			isNegative = true
			milModDescription = "[i]Plague quarantine in effect:[/i][color=red] No reinforcement; manpower drains each turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Seduced":
			isNegative = true
			milModDescription = "[i]The commander has found better things to do:[/i][color=red] Melee zeroed; cannot attack[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Starstruck":
			isNegative = true
			milModDescription = "[i]Encountered a celebrity. Requested autograph. Please advise.:[/i][color=red] All stats −30%[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Hangover":
			isNegative = true
			milModDescription = "[i]Someone opened the wrong cask.:[/i][color=red] All stats −50%[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Love-Struck":
			isNegative = true
			milModDescription = "[i]Cupid's arrow strikes without warning.:[/i][color=red] Melee attack −70%, block −70%; cannot attack[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Mutinous":
			isNegative = true
			milModDescription = "[i]The ranks are restless.:[/i][color=red] Melee attack −40%; 50% chance army refuses orders each turn[/color]"
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
	if has_node("Sprite2D"):
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
