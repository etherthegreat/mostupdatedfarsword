extends Node
 
var army_templates: Dictionary = {}  # keyed by countryCID
var loaded: bool = false
 
 
func _ready() -> void:
	load_templates("res://data/armies/army_templates.csv")
 
 
func load_templates(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("ArmyDatabase: Could not open CSV at: " + path)
		return
 
	var headers = file.get_csv_line()
 
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue
 
		var entry: Dictionary = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()
 
		entry["spawnTile"] = entry.get("spawnTile", "1").to_int()
		entry["armyMods"]  = parse_list(entry.get("armyMods", ""))
		entry["units"]     = parse_units(entry.get("units", ""))
 
		var cid = entry.get("countryCID", "")
		if cid != "":
			# A country can have multiple template armies — store as array
			if not army_templates.has(cid):
				army_templates[cid] = []
			army_templates[cid].append(entry)
 
	file.close()
	loaded = true
 
 
func parse_list(s: String) -> Array:
	if s.strip_edges() == "":
		return []
	var result = []
	for item in s.split("|"):
		var trimmed = item.strip_edges()
		if trimmed != "":
			result.append(trimmed)
	return result
 
 
func parse_units(s: String) -> Array:
	# "Infantry:Brown Bess:Continental:3:300:300|Cavalry:Cavalry Saber:Cavalry:2:200:0"
	# -> Array of {unitType, weaponType, uniformType, level, manpower, weapons}
	if s.strip_edges() == "":
		return []
	var result = []
	for unit_str in s.split("|"):
		var parts = unit_str.strip_edges().split(":")
		if parts.size() >= 6:
			result.append({
				"unitType":    parts[0].strip_edges(),
				"weaponType":  parts[1].strip_edges(),
				"uniformType": parts[2].strip_edges(),
				"level":       parts[3].strip_edges().to_int(),
				"manpower":    parts[4].strip_edges().to_int(),
				"weapons":     parts[5].strip_edges().to_int(),
			})
	return result
 
 
func get_templates_for_country(cid: String) -> Array:
	if not loaded:
		push_error("ArmyDatabase: Accessed before loaded!")
		return []
	return army_templates.get(cid, [])
