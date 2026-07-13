extends Node


var tile_data: Dictionary = {}
var loaded: bool = false


func _ready() -> void:
	load_tiles("res://data/tiles_final.csv")


func load_tiles(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("TileDatabase: Could not open CSV at: " + path)
		return

	# Read header row
	var headers = file.get_csv_line()

	# Read each tile row
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue  # skip empty rows (like your blank rows 5, 20, 125, 138)

		var entry: Dictionary = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()

		# Convert numeric fields
		var num = entry.get("number", "0").to_int()
		if num == 0:
			continue  # skip blank/invalid rows
		entry["number"] = num
		entry["corruption"] = entry.get("corruption", "0").to_int()
		entry["winterScore"] = entry.get("winterScore", "0").to_int()
		# Parse buildings from "barracks:3|farm:1|dock:2" into Dictionary
		entry["buildings"] = parse_buildings(entry.get("buildings", ""))

		# Parse specialFeature from "Fort McHenry|Chesapeake Shipyards" into Array
		entry["specialFeatures"] = parse_special_features(entry.get("specialFeature", ""))

		tile_data[num] = entry

	file.close()
	loaded = true


func parse_buildings(building_string: String) -> Dictionary:
	var buildings: Dictionary = {}
	if building_string.strip_edges() == "":
		return buildings
	var pairs = building_string.split("|")
	for pair in pairs:
		var parts = pair.split(":")
		if parts.size() == 2:
			var building_name = parts[0].strip_edges()
			var building_level = parts[1].strip_edges().to_int()
			if building_name != "" and building_level > 0:
				buildings[building_name] = building_level
	return buildings


func parse_special_features(feature_string: String) -> Array:
	if feature_string.strip_edges() == "":
		return []
	var features = feature_string.split("|")
	var result: Array = []
	for f in features:
		var trimmed = f.strip_edges()
		if trimmed != "":
			result.append(trimmed)
	return result


func get_tile(tile_number: int) -> Dictionary:
	if not loaded:
		push_error("TileDatabase: Tried to get tile before data was loaded!")
		return {}
	return tile_data.get(tile_number, {})


func get_tile_name(tile_number: int) -> String:
	return get_tile(tile_number).get("tileName", "Unknown")


func get_tile_owner(tile_number: int) -> String:
	return get_tile(tile_number).get("country", "Neutral")


func get_all_tile_numbers() -> Array:
	return tile_data.keys()
