extends RefCounted
# ═════════════════════════════════════════════════════════════════════════════
# RUN SCORE — GUI pass 2026-10-26
# The arcade maths behind the end-of-run screen. Pure logic, no nodes, so it can be
# tested headless and tuned from the constants below.
#
#   NAME REBUILT   your biggest single connected territory ÷ all the land your
#                  nation claims. This is the snake name made into a number: one
#                  fused UNITED STATES across the whole claim = 100%.
#   LAND RECLAIMED every claimed tile you hold, connected or not.
#   THE VOTE       average election pressure across your tiles.
#   OUTCOME        how the war ended.
#
# world.gd builds the tile list with _score_tiles() and calls build_report().
# ═════════════════════════════════════════════════════════════════════════════

# ── Tuning ───────────────────────────────────────────────────────────────────
const PTS_NAME := 45.0
const PTS_LAND := 25.0
const PTS_VOTE := 15.0
const PTS_OUTCOME := 15.0
const VOTE_FULL := 40.0          # average election pressure that earns full VOTE points
# end_type → share of PTS_OUTCOME.  "" + won = clean victory.
const OUTCOME_SHARE := {
	"win": 1.0, "stalemate": 0.4, "endlessBattle": 0.2,
	"britishWhiteHouse": 0.0, "DCdown": 0.0, "funeral": 0.0,
}
# [min score, letter, title]. S also needs a victory; any loss caps at LOSS_CAP.
const GRADES := [
	[88.0, "S", "Pax Americana"],
	[75.0, "A", "The Republic Restored"],
	[60.0, "B", "Hard-Won Ground"],
	[45.0, "C", "Holding the Line"],
	[30.0, "D", "A Scattered Republic"],
	[0.0, "F", "Border Gore"],
]
const LOSS_CAP := "B"
const RECORDS_PATH := "user://pax_run_records.cfg"

# Land a nation fights to rebuild. US = every tile in a US state (not Canada, not the
# Bahamas); Canada = its provinces. Uses the tile's CSV state, so it never changes.
static func claims(cid: String, state: String) -> bool:
	if state == "" or state == "BA":
		return false
	var canadian := state.begins_with("CA")
	if cid == "CA":
		return canadian
	return not canadian


# tiles: [{id, owner, start_owner, state, nb: [ids]}]
# Measures one nation's hold on its claim, either now or at the start of the run.
static func measure(tiles: Array, cid: String, at_start: bool = false) -> Dictionary:
	var byId := {}
	var mine := {}
	var claim := 0
	for t in tiles:
		byId[int(t.id)] = t
		if not claims(cid, str(t.state)):
			continue
		claim += 1
		var o := str(t.start_owner) if at_start else str(t.owner)
		if o == cid:
			mine[int(t.id)] = true
	# connected pieces of held claim land
	var seen := {}
	var sizes: Array = []
	for id in mine:
		if seen.has(id):
			continue
		var n := 0
		var stack: Array = [id]
		seen[id] = true
		while not stack.is_empty():
			var cur = stack.pop_back()
			n += 1
			for nb in byId[cur].nb:
				if mine.has(int(nb)) and not seen.has(int(nb)):
					seen[int(nb)] = true
					stack.append(int(nb))
		sizes.append(n)
	sizes.sort()
	sizes.reverse()
	var largest: int = sizes[0] if not sizes.is_empty() else 0
	var c := maxf(1.0, float(claim))
	return {
		"claim": claim, "held": mine.size(), "largest": largest,
		"pieces": sizes.size(), "sizes": sizes,
		"name_pct": float(largest) / c, "land_pct": float(mine.size()) / c,
	}


# info: {cid, won, end_type, reason, turn, date, now, start, peak_pct, vote_avg, name_pieces}
static func build_report(info: Dictionary) -> Dictionary:
	var now: Dictionary = info.now
	var won: bool = info.get("won", false)
	var end_type: String = str(info.get("end_type", ""))
	var okey := "win" if won else end_type
	var vote_avg: float = float(info.get("vote_avg", 0.0))
	var vote_k := clampf(vote_avg / VOTE_FULL, 0.0, 1.0)
	var out_k: float = float(OUTCOME_SHARE.get(okey, 0.0))

	var rows: Array = [
		{"key": "name", "label": "NAME REBUILT", "pts": PTS_NAME * now.name_pct, "max": PTS_NAME,
			"detail": "%d of %d claimed tiles joined as one" % [now.largest, now.claim]},
		{"key": "land", "label": "LAND RECLAIMED", "pts": PTS_LAND * now.land_pct, "max": PTS_LAND,
			"detail": "%d tiles held  (started with %d)" % [now.held, info.start.held]},
		{"key": "vote", "label": "THE VOTE", "pts": PTS_VOTE * vote_k, "max": PTS_VOTE,
			"detail": "average election pressure %+d" % roundi(vote_avg)},
		{"key": "outcome", "label": "OUTCOME", "pts": PTS_OUTCOME * out_k, "max": PTS_OUTCOME,
			"detail": _outcome_word(okey)},
	]
	var score := 0.0
	for r in rows:
		score += float(r.pts)
	score = clampf(score, 0.0, 100.0)
	var g := grade_for(score, won)
	return {
		"cid": info.cid, "won": won, "end_type": end_type, "reason": str(info.get("reason", "")),
		"turn": int(info.get("turn", 100)), "date": str(info.get("date", "")),
		"score": roundi(score), "grade": g[0], "title": g[1], "rows": rows,
		"now": now, "start": info.start, "peak_pct": maxf(float(info.get("peak_pct", 0.0)), float(now.name_pct)),
		"name_pieces": info.get("name_pieces", []), "tip": _tip(rows, now),
	}


static func grade_for(score: float, won: bool) -> Array:
	var capIdx := 0
	if not won:
		for i in GRADES.size():
			if GRADES[i][1] == LOSS_CAP:
				capIdx = i
	for i in GRADES.size():
		if score >= GRADES[i][0]:
			var j := maxi(i, capIdx)
			return [GRADES[j][1], GRADES[j][2]]
	return [GRADES[-1][1], GRADES[-1][2]]


static func grade_rank(letter: String) -> int:
	for i in GRADES.size():
		if GRADES[i][1] == letter:
			return GRADES.size() - i
	return 0


static func _outcome_word(k: String) -> String:
	match k:
		"win": return "Victory — the Crown is gone"
		"stalemate": return "Stalemate — peace, but the Crown holds land"
		"endlessBattle": return "Endless war — no peace by the election"
		"britishWhiteHouse": return "Lost the election to a Crown puppet"
		"DCdown": return "Washington fell"
		"funeral": return "The President fell in battle"
	return "Defeat"


static func _tip(rows: Array, now: Dictionary) -> String:
	# Point at the weakest share — the thing that would move the grade most next run.
	var total := 0.0
	for r in rows:
		total += float(r.pts)
	if total >= float(GRADES[0][0]):
		return "Flawless. The name is whole — now beat %d." % roundi(total)
	var worst = rows[0]
	for r in rows:
		if float(r.pts) / float(r.max) < float(worst.pts) / float(worst.max):
			worst = r
	match str(worst.key):
		"name":
			if int(now.pieces) > 1:
				return "Next run: join your %d pockets. One fused name beats scattered land." % int(now.pieces)
			return "Next run: push the name outward — every tile on its spine counts."
		"land":
			return "Next run: liberate faster early. Land taken before turn 30 snowballs."
		"vote":
			return "Next run: hold rallies in your heartland — the Crown campaigns from turn 90."
		_:
			return "Next run: finish the war. A clean victory is the only road to S."


# ── Records ─────────────────────────────────────────────────────────────────
# Returns {runs, best_score, best_grade, best_name, new_best} after counting this run.
static func record_run(report: Dictionary) -> Dictionary:
	var cfg := ConfigFile.new()
	cfg.load(RECORDS_PATH)   # missing file is fine — starts empty
	var sec := str(report.cid)
	var runs: int = int(cfg.get_value(sec, "runs", 0)) + 1
	var best_score: int = int(cfg.get_value(sec, "best_score", -1))
	var best_grade: String = str(cfg.get_value(sec, "best_grade", ""))
	var best_name: float = float(cfg.get_value(sec, "best_name", 0.0))
	var new_best: bool = int(report.score) > best_score
	if new_best:
		best_score = int(report.score)
		best_grade = str(report.grade)
	best_name = maxf(best_name, float(report.now.name_pct))
	cfg.set_value(sec, "runs", runs)
	cfg.set_value(sec, "best_score", best_score)
	cfg.set_value(sec, "best_grade", best_grade)
	cfg.set_value(sec, "best_name", best_name)
	cfg.save(RECORDS_PATH)
	return {"runs": runs, "best_score": best_score, "best_grade": best_grade,
		"best_name": best_name, "new_best": new_best and runs > 1, "first": runs == 1}
