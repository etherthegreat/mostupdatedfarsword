extends Node

var country_data: Dictionary = {}
var loaded: bool = false


func _ready() -> void:
	load_countries("res://data/countries/countries.csv")


func load_countries(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("CountryDatabase: Could not open CSV at: " + path)
		return

	var headers = file.get_csv_line()

	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue

		var entry: Dictionary = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()

		var cid = entry.get("CID", "")
		if cid == "":
			continue

		# Integer fields
		for field in ["primaryCapital", "armyReinforceRate", "mandateThreshold",
				"foodStorageMax", "spellBaseCost", "startFood", "startWood",
				"startMetal", "startFaith", "startMagic", "startWeapons",
				"startScience", "startCulture", "startMandate", "startInfluence",
				"startManpower", "startingArmyTile"]:
			entry[field] = entry.get(field, "0").to_int()

		# Float fields
		entry["startGold"]    = entry.get("startGold", "0").to_float()
		entry["startHarmony"] = entry.get("startHarmony", "0").to_float()

		# Pipe-separated list fields
		for field in ["startingTechs", "startingBeliefs", "startingTraditions",
				"startingLaws", "startingMilMods"]:
			entry[field] = parse_list(entry.get(field, ""))

		# "Sons of Liberty:20|Continental Congress:30" -> [{name, loyalty}]
		entry["startingFactions"] = parse_factions(entry.get("startingFactions", ""))

		# "Patrick Henry:1|Abigail Adams:1" -> [{type, level}]
		entry["startingGovernors"] = parse_governors(entry.get("startingGovernors", ""))

		country_data[cid] = entry

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


func parse_factions(s: String) -> Array:
	if s.strip_edges() == "":
		return []
	var result = []
	for entry in s.split("|"):
		var parts = entry.strip_edges().split(":")
		if parts.size() >= 2:
			result.append({
				"name":    parts[0].strip_edges(),
				"loyalty": parts[1].strip_edges().to_int(),
			})
	return result


func parse_governors(s: String) -> Array:
	if s.strip_edges() == "":
		return []
	var result = []
	for entry in s.split("|"):
		var parts = entry.strip_edges().split(":")
		if parts.size() >= 2:
			result.append({
				"type":  parts[0].strip_edges(),
				"level": parts[1].strip_edges().to_int(),
			})
	return result


func get_country(cid: String) -> Dictionary:
	if not loaded:
		push_error("CountryDatabase: Accessed before loaded!")
		return {}
	return country_data.get(cid, {})


func get_all_CIDs() -> Array:
	if not loaded:
		push_error("CountryDatabase: Accessed before loaded!")
		return []
	return country_data.keys()
