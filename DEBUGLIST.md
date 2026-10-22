# DEBUGLIST — Uprisings: Revolution (Farsword)

*Living pre-launch debug list. Triage findings below; playtest session logs appended/linked as we go.*

**Engine:** Godot 4.4 · **Scope:** visual + audio glitches (per request), plus the lifecycle/runtime bugs that produce them · **Date:** 2026-06-26
**Method:** full static sweep of 104 scripts / ~29k lines, three parallel deep-audits (signals, UI-state, node-lifecycle), then **manual verification of every P0/P1 against the actual source.** Each finding is tagged **✓ verified** (I read the code path myself) or **◑ candidate** (agent-traced, plausible, confirm in-editor).

---

## TL;DR — what matters this week

1. **One root-cause bug is responsible for most of the "tiny glitches": armies that die in the most common ways are never fully cleaned up.** Their on-map token keeps running and throws freed-instance errors *every frame, forever*, and leaves dangling references that crash the next attack/click near them. Fixing one function kills four separate symptoms. **(P0-1)**
2. **Army movement multiplies every turn.** A signal is re-connected to the same buttons each turn with no guard, so by turn N a single click issues N moves. **(P0-2)**
3. **The game currently ships silent.** Zero audio assets, zero `AudioStreamPlayer` nodes, every `AudioManager` call commented out. This is a **product decision to make now**, not a glitch to fix. **(DECISION-A)**
4. **Don't update the engine.** Stay on 4.4; the only safe move is the 4.4 → 4.4.1 patch. Everything 4.5+ waits until after launch. **(DECISION-B)**

Two of the audit's flashier "Critical" findings were **false positives** — I've documented them below so you don't waste time chasing them.

---

## P0 — Fix before launch

### P0-1 · Dead armies are never torn down → permanent per-frame errors + cascade crashes ✓ verified
**Files:** `country.gd:598-605` (`_on_army_destroyed`), `army_path_follow.gd:81-119` (`_process`), `path_control.gd:304`, `barracks_button.gd:34-35`

**What the player sees:** After you win a ranged attack, win/lose any AI battle, or kill an attacker with a melee counter, the console begins spamming `Invalid access to property 'maxManpower' on a previously freed instance` — and never stops. Frame rate degrades as more armies die over a session. The next attack or right-click near where an army died can hard-error (`Nonexistent function 'deleteBattle' … on a freed instance`).

**Root cause:** There are two army-death paths. The clean one sets `army.deleteMode = true`, which lets `army_path_follow._process` null out the path-point button's `stationedAPF`/`stationedArmy` and free both nodes (`army_path_follow.gd:115-119`). But `_on_army_destroyed` — the path taken by ranged attacks, AI battles, and melee counter-kills — frees the army directly (`army.queue_free()`) **without** setting `deleteMode` and **without** freeing the path-follower. The guard in `_process` is `if thisArmy == null:` (line 82) — a freed instance is **not null**, so it falls straight through to `refreshHealthBar()` → `thisArmy.maxManpower`. The orphaned follower also leaves `pathPointButton.stationedAPF` pointing at freed memory, which is what later blows up `deleteNeighborBattles` and the melee midpoint (`path_control.gd:304`). The same freed reference hits `barracks_button.updateSelf()` (`barracksArmy.updateArmyUI()` on a dead army).

**Fix (one teardown helper resolves all four symptoms):** In `_on_army_destroyed`, *before* freeing, find the army's path-point button and clear it, then free the follower:
```gdscript
func _on_army_destroyed(army: Army) -> void:
    if army.commander != null:
        emit_signal("commanderFallen", army.commander, army.ArmyName, army.inTile)
    countryArmyList.erase(army)
    # NEW: tear down the on-map token so nothing references a freed army
    if army.inTile != null:
        army.inTile.stationedArmy = null
        var ppb = army.inTile.tileSpawnPoint   # the PathPointButton
        if is_instance_valid(ppb):
            if is_instance_valid(ppb.stationedAPF):
                ppb.stationedAPF.queue_free()
            ppb.stationedAPF = null
            ppb.stationedArmy = null
            ppb.occupied = false
    emit_signal("countryArmyDestroyed", army)
    army.queue_free()
```
**Defense-in-depth (do this too):** change `army_path_follow.gd:82` to `if not is_instance_valid(thisArmy): queue_free(); return`, and change the `!= null` guards on `selectedAPF`/`stationedAPF` (`path_control.gd:130, 304`; `world.gd:5269`) to `is_instance_valid(...)`. A freed-but-non-null reference is the recurring trap across this codebase.

---

### P0-2 · Army-move signal re-connects every turn → moves multiply ✓ verified
**File:** `path_control.gd:157-164` (`connectPathPoints`), called from `world.gd:1586` and `world.gd:1678`

**What the player sees:** Early game feels fine; by mid-game, clicking a path point to move an army issues the move **multiple times** — movement points drained several times over, an ordered attack resolving repeatedly. It scales with turn count, so it looks like "random" escalating jank.

**Root cause:** `connectPathPoints` loops the **persistent** children of `$PathPointsControl` and does `pathPointButton.pathPointClicked.connect(calculateArmyMovement)` with no `is_connected` guard. It's called once per turn (`_activate_player`, world.gd:1586) and again on UI refresh (world.gd:1678), so each button accumulates a new identical connection every turn. Turn N → N handlers per click.

**Fix:** Guard the connection (the codebase already uses this exact pattern at `world.gd:1716-1721`):
```gdscript
for pathPointButton in $PathPointsControl.get_children():
    if not pathPointButton.pathPointClicked.is_connected(calculateArmyMovement):
        pathPointButton.pathPointClicked.connect(calculateArmyMovement)
    pathPointButton.buildSelf()
```
*Better long-term:* connect once when the buttons are built; keep only `buildSelf()` (the per-turn refresh) in this loop.

---

## P1 — High priority

### P1-1 · Duplicate UI-signal connections in `updatePlayerUI` → buttons fire twice ✓ verified (pattern), ◑ per-line symptoms
**File:** `world.gd:1670-1711` (≈18 connects) and `spell_schools_control.gd:8-24` via `connectSchools()`

`updatePlayerUI()` re-runs on every co-op player switch and on event outcomes, re-connecting persistent panel signals with no guard — while the block right below it (`1716-1721`) *is* guarded, which confirms the hazard is known. Symptoms once duplicated: melee/ranged buttons issue **two** combat orders, placing a building / adding a law / casting a spell each run twice, tile-info updates run N times. **Fix:** wrap each connect in `is_connected`, or hoist the one-time wiring into a run-once `_connect_player_ui_signals()` and leave only data-refresh in `updatePlayerUI`.

### P1-2 · Build button: affordability gate uses raw cost, label shows calculated cost ✓ verified
**File:** `new_building_button.gd:40-78`

Labels display `goldCalculatedCost = goldCost * countryConstructionCostMod` (line 44) but the disable checks compare against raw `goldCost` (lines 71-78). Whenever the construction-cost modifier ≠ 1, the **shown price and the enable/disable state disagree** — a building reads as affordable but is greyed out (or vice-versa). Also `<=` disables at *exactly* enough resources (off-by-one even at mod = 1). **Fix:** gate on the calculated costs with `<`:
```gdscript
if player.TotalDollars < goldCalculatedCost: $Button.disabled = true
# …food/wood/metal likewise, all using *CalculatedCost and <
```

### P1-3 · Barracks "Add New Army" never comes back after the army dies ✓ verified
**File:** `barracks_button.gd:21-35`

`addPrebuiltArmy` hides `$AddNewArmyButton` and shows the built-army panel one-directionally. Nothing restores it when the army is destroyed, so the barracks is stuck displaying a dead army and you can't raise a replacement — and `updateSelf` dereferences the freed army (ties into P0-1). **Fix:** in `updateSelf`, when `not is_instance_valid(barracksArmy)`: show `$AddNewArmyButton`, hide `builtArmyInfoPanel`, clear the name, null `barracksArmy`.

### P1-4 · Tile info panel keeps the previous tile's governor / wizard / crop ✓ verified
**File:** `tile_info_panel.gd:53-77` and `matchTileNaturals` (117-135)

The governor-button and wizard-label updates are nested **inside** `for tileEcoModifier in tile.tileEcoModifiers:` (line 53). Select a tile that has eco-modifiers (governor shows), then one with an empty `tileEcoModifiers` array — the loop never runs, so the **old tile's governor portrait, name, and wizard text persist**. Likewise `matchTileNaturals` only ever *sets* `$CropSprite.texture` (no `else`), so a previous crop icon lingers on a crop-less tile. **Fix:** move the governor/wizard update out of the `for` loop so it runs once per tile unconditionally, and add `else` branches that clear the crop/terrain/governor visuals when the value is null.

### P1-5 · Stale child sub-panels re-appear on reselect ◑ candidate
**File:** `tile_info_panel.gd:27-82` (`displayTileInfo`) + `:101-114`

`displayTileInfo` never resets `$GovernorSelection.visible` / `$governorTileControlPanel.visible`. Open a tile's governor picker, click a different tile → the previous tile's picker stays overlaid. Same class of bug as the ArmyPanel action-tooltip (`ActionInfoPanelControl`) staying visible on reopen. **Fix:** force these children hidden at the top of `displayTileInfo` (and the army equivalent in `updateArmyFunc`), or add them to `canvas_layer.closeAllPanels()`.

---

## P2 — Medium (polish / lower-frequency)

| ID | File:line | Symptom | Fix | Status |
|----|-----------|---------|-----|--------|
| P2-1 | `world.gd:5354-5359` (`rangedPressed`) | Ranged attack builds a battle against **every** adjacent enemy, not the chosen one | Target a single PPB like melee does | ◑ |
| P2-2 | `tile.gd:1321-1333` | Hovering a tile, then switching map mode, restores the tile to its **old** overlay color on mouse-exit | Re-derive color from current map mode instead of restoring a cached value | ◑ |
| P2-3 | `unit_ui.gd:93-128` | Weapon/ore picker visibly rebuilds then hides on first click (needs 2 clicks); both lists can be open at once | Only rebuild when opening; hide the sibling list | ◑ |
| P2-4 | `tile_info_panel.gd` (`displayTileInfo`) | `$Outputs` text from the previous tile lingers until you hover a new output | `$Outputs.clear()` at top of `displayTileInfo` | ✓ |
| P2-5 | `tile.gd:427` (`build_self_from_save`) | Loading a save where a tile has no matching spawn point throws `Node not found` and aborts tile load | Use `get_node_or_null` + guard, matching lines 347/375 | ✓ |
| P2-6 | `world.gd:3126, 6420, 6428` | Republic-collapse / anarchist deaths free armies with a bare `queue_free()` → same orphaned-token spam as P0-1 | Route through the P0-1 teardown helper | ✓ |
| P2-7 | `AudioManager.gd:68-74` (`stop_sfx`) | `stop_sfx` looks up `_sfx_cache.get(name)` but the cache is keyed by full path → always nil, function is dead | Key the lookup by `SFX_DIR + name + ".ogg"` | ✓ |

---

## Decisions for you (not bugs)

### DECISION-A · The game is currently silent
No `.ogg`/`.wav`/`.mp3` assets exist anywhere in the project, no scene contains an `AudioStreamPlayer`, and **every** `AudioManager.play_*` call is commented out (`world.gd:2270, 2373, 2385, 5595, 5612, 5648`). The `AudioManager` autoload is well-built and ready, but nothing drives it. So "audio glitches" isn't really fixable — the question is **do you intend to ship with sound next week?**
- **If yes:** you need (1) audio files dropped into `res://audio/sfx/` and `res://audio/music/`, (2) the commented calls un-commented, (3) the `stop_sfx` cache-key fix (P2-7), and (4) a quick check that the `Music`/`SFX`/`Ambient` buses exist in Project Settings (the manager assumes them). Also verify `play_music`'s loop logic — it sets `stream.loop` behind a `has_method("set_loop")` check that won't be true for the `loop` *property*, so looping may silently not apply.
- **If no (ship silent, patch audio post-launch):** that's a legitimate call for a solo launch — just make it deliberately, and maybe note "music & SFX coming soon" so reviewers don't read silence as a bug.

I'd lean toward **a tiny audio MVP** if you can get even 5-6 SFX and one music loop: silence reads as "unfinished" to a lot of players, and the system is already built to accept them.

### DECISION-B · Engine version
Stay on **4.4**. Take the **4.4 → 4.4.1** patch (same minor version, fixes 4.4 regressions + an mbedTLS security hole, no breaking changes) on a branch with a smoke-test. Skip 4.5/4.6/4.7 until after launch — three feature releases of breaking changes a week out is how silent glitches become loud ones.

---

## Rejected findings (don't chase these)

- **"Spy action buttons stick" / "DMA button sticks"** (`civilian_action_buttons.gd:27-41`) — **false positive.** Those buttons are `has_node()`-guarded stubs that don't exist in the scene yet (the comments literally say "add … to this scene to activate"). They never display, so they can't stick. *When* you add them, remember to reset them in the block at the top of `updateUI`.
- **"Spell-targeting calls non-existent `activateSpellMode` / `activateMilitarySpellMode` / `normalMode`"** — **unverified / misnamed.** Grep finds neither those calls nor those definitions anywhere. There may be a real spell-targeting reset issue, but this specific claim isn't supported by the code.

## Spot-checked clean (so you don't re-audit)
`battle.applyBattleResults` same-frame access after `queue_free` (safe — Godot defers the free to end of frame) · all `randi() % size` sites (guarded by `is_empty`/`size>0`) · economy/maintenance loops over `countryArmyList` (consistently guard `is_instance_valid`) · law-quadrant and battle-% division (denominators guarded / `max(1,…)`) · `belief_control.gd`, `military_panel_control.gd`, `canvas_layer.gd` toggles (idiomatic) · all `new*`-instance signal connects (one per fresh instance — correct).

---

## Suggested order for the week
1. **P0-1** (army teardown helper + `is_instance_valid` guards) — biggest single win, kills the error spam and three cascade crashes.
2. **P0-2** (movement connect guard) — stops moves multiplying.
3. **P1-1 → P1-4** — the double-fire and stale-UI bugs players will actually notice.
4. **DECISION-A** — decide audio now; if shipping sound, that's its own mini-workstream.
5. **P1-5 + P2 batch** — polish pass.
6. Re-test a full playthrough (win a ranged fight, lose an army, switch co-op players, reselect tiles) with the console open — that exercises every P0/P1 path.

*All findings tagged ✓ were read and confirmed in source during this pass. Findings tagged ◑ were traced by audit and are high-confidence but worth a 30-second in-editor confirmation before you commit the fix.*
