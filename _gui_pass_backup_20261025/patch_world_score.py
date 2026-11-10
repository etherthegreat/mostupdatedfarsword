import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()

def rep(old, new, count=1):
    global s
    n = s.count(old)
    if n != count:
        sys.exit("MATCH FAIL (%d): %r" % (n, old[:80]))
    s = s.replace(old, new)

# 1. remember which nation started the run (Play Again restarts as it)
rep("""func newGameBuild(CID, gameLang, isCoop: bool = false):
	currentWorldTurn = 1
""", """func newGameBuild(CID, gameLang, isCoop: bool = false):
	currentWorldTurn = 1
	_runStartCid = str(CID)
""")

# 2. game over -> score screen
rep("""	print("[GameOver] won=", won, "  reason=", reason, "  end_type=", end_type)
	if not won and end_type != "":
		var ending = get_node_or_null("CanvasLayer/EndingSceneControl")
		if ending != null:
			ending.endGame(end_type, _format_game_date(), currentWorldTurn)
			return
	var panel = get_node_or_null("CanvasLayer/GameOverPanel")
""", """	print("[GameOver] won=", won, "  reason=", reason, "  end_type=", end_type)
	if not won and end_type != "":
		var ending = get_node_or_null("CanvasLayer/EndingSceneControl")
		if ending != null:
			ending.endGame(end_type, _format_game_date(), currentWorldTurn)
			# GUI pass 2026-10-26: the score screen takes over the ending's exit button.
			var exitBtn = ending.get_node_or_null("GameOver")
			if exitBtn != null:
				exitBtn.visible = false
			_show_run_score(won, reason, end_type, RUN_SCORE_AFTER_ART)
			return
	if _show_run_score(won, reason, end_type, RUN_SCORE_AFTER_WIN):
		return
	var panel = get_node_or_null("CanvasLayer/GameOverPanel")
""")

# 3. track the best the name ever got during the run
rep("""	_snakeNames.rebuild_from_world($TileController, $CountryController, shown, false)
	_snakeSig = _snakeNames.ownership_signature($TileController)
""", """	_snakeNames.rebuild_from_world($TileController, $CountryController, shown, false)
	_snakeSig = _snakeNames.ownership_signature($TileController)
	_trackRunPeak()
""")
rep("""	_snakeNames.rebuild_from_world($TileController, $CountryController, shown, true)

func refreshMapLabels""", """	_snakeNames.rebuild_from_world($TileController, $CountryController, shown, true)
	_trackRunPeak()

func refreshMapLabels""")

s = s.rstrip("\n") + "\n" + open(sys.argv[2], encoding="utf-8").read()
open(p, "w", encoding="utf-8", newline="\n").write(s)
print("patched OK")
