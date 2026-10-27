# Handoff — Pax Americana, next session: combat rework

Read CLAUDE.md first, then this. Branch: `pax_gui_pass` (main is OLD). Deleting files is off in the connected folder: give Ether git commands to run himself, never leave large files behind.

## Built in the GUI pass (Oct 25–26, 2026) — all committed
- **Score screen** at turn 100 / any ending: `run_score.gd` (maths, tuning constants at top), `score_screen.gd` (UI). NAME REBUILT % = largest connected US territory ÷ 150 claimed tiles. Grades S–F, loss capped at B. Secret **L** grade ("Loyal Subject of the Crown") when a run is lost holding 0 US tiles; plays PNG frames from `art assets/finishedAssets/score/L_jest/`. Best runs saved in `user://pax_run_records.cfg`. Debug: F9 = forced loss, Shift+F9 = forced win.
- **Army badges** (`army_badge.gd`, owned by `army_path_follow.gd`): STR number, ▲/=/▼ verdict vs your selected army (`path_control.gd` `_verdict`, uses `compute_battle_against(..., require_ap=false, as_threat)`), one pip per unit (table `PIP_STYLES`), COVERED/EXPOSED border, one manpower+shield bar. Overlapping badges collapse to compact chips.
- **Tile-name declutter** in `world.gd` (`_declutterTileLabels`).
- **Army card** (`army_card.gd`, opened by `world._show_army_info`): full-body commander portrait, STR breakdown per unit, per-unit orders (Fire/Charge/Hold/Flank; Fortify + one spare slot locked), mil mods grouped by source. Enemy armies open read-only.
- **Fixed:** `unit.calculateMilMods()` used to stack onto itself on every surveySelf (stats crept up every hover/attack/turn). Now rebuilds gross values first.

## Ether's action design (per-unit, agreed)
Each unit has its own actions; moving the army costs every unit 1. Units can split roles: one fires/charges while the other Holds (loaded, fires first if attacked) or Fortifies (melee defence). Reloading both, or spending everything with nobody braced, leaves the army EXPOSED. Cavalry 3 moves, others 2. Keep spare slots for future actions (logistics…).

## Known combat bugs (see `design_docs/milmod_audit.csv`, 246 rows)
1. `army.gd`: `armyBlock` / `armyDefence` are `int` — armor block (0.15…) rounds to 0, and a single +15 buff hits the 90% cap. Make them float and re-tune.
2. `compute_battle_against` (the real fight for player, AI and preview) ignores `armyPunch`, `armyLaunch`, `armyShield` → commander morale, protector attack buffs, Spirit of the General etc. do nothing.
3. Hold does not fire first — no defender counter exists. Only +0.1 block per holding unit.
4. `battle.gd` melee path is dead → SaberCharge, Iron Bayonet, Vanguard, Minuteman's Pride, Naval Supremacy dead.
5. Belief mods vanish each turn (`updateArmyUI` clears; removal targets the wrong copy because `addMilMod` instantiates copies).
6. Many commander mods "handled elsewhere" but nowhere (Quick Reload, Rallying Voice, Marine, Fortified Position, Patrick Henry's…). Most weapon tags empty.
7. `int()` rounding in Secord's Alert / Student Body Commander wipes melee block. Burning/Diseased damage types unhandled.

## Suggested order
1. Floats + make real fights use the card's stats (fix 1–2). 2. Hold fires first + Fortify (fix 3) — badge pips and card buttons already exist. 3. Wire the USA-reachable dead mods from the CSV. 4. Headless 100-turn AI-vs-AI soak to see the war move and the score screen fire.

## Testing setup that worked
- Godot 4.4.1 in Claude's cloud workspace (download from GitHub releases). Headless for logic; `xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-driver opengl3 --resolution 1920x1080 --scene res://zz_test/x.tscn` for screenshots.
- Full game runs in the cloud: tar the project on Ether's machine excluding `.godot`, `.git`, `*.bundle*`, backups (~234 MB), stage it, `--import` (~4 min), then boot like the menu does: instantiate `world.tscn`, add to root, set `current_scene`, `newGameBuild("USA","eng",false)`. Ether must delete the tar afterwards — or reuse the cloud copy and only sync changed `.gd` files.
- Never run Godot in his real folder. Move files back with device_commit_files and confirm matching md5 on both sides. Back up edited files to `_gui_pass_backup_20261025/` first.

---
## Session 2026-10-26 (evening) — steps 1–2 DONE, not yet git-committed
Files changed: army.gd, unit.gd, path_control.gd, country.gd, army_card.gd, army_badge.gd, world.gd (army info lines only). Originals in `_gui_pass_backup_20261025/pre_combat/`. Tests: `zz_test/combat_test.tscn` (PASS) and `zz_test/soak_test.tscn` (SOAK_TURNS env var).
- **Fix 1:** armyPunch/Block/Launch/Defence are floats. Army-level "+N block" = N percentage points of the army average (`_blk`); unit-level "+N defence" mods = N points flat (`unit._pts`, no level scaling). BLOCK_CAP 0.75 (was 0.9). Secord's / Student Body int() wipe fixed.
- **Fix 2:** fights now read army-level effects through `melee_mult()` / `ranged_mult()` (armyPunch ÷ raw unit melee, capped ×2.5). Commander morale now also boosts volleys. Army-level shield (+30 statuses) is a per-turn **ward** (`armyWard`) that soaks damage before unit shields. Badge STR + card breakdown use the same mults.
- **Fix 3:** Hold fires first — loaded holders volley at ×0.75 (braced sabers meet a charge ×1.0) before the attacker strikes; attacker's blow scales by survivors; holders then reload (`consume_hold_volley`, called in player + AI fights). Fortify unlocked: whole-turn order (army must not have moved, unit must have full AP; refunded if switched same turn), +0.30 melee block per fortified unit averaged; marching breaks it. EXPOSED (nobody braced) = block halved. Hold/Fortify now **persist through the enemy turn** (onTurnEnd used to reset them before the AI moved — that's why Hold never worked). Old per-holder +0.1 block removed. Preview shows "Their line fires first" + EXPOSED.
- Soak (idle player, 25 turns): no script errors. Idle USA wiped turn ~12 (original code: turn ~9). With the rework the game ENDED at 13; original code didn't trigger the end at 0 MP — check which loss condition fires.
- NEXT: step 3 (wire USA-reachable dead mods from milmod_audit.csv), then a real played soak. Tuning knobs are constants at the top of the HOLD / FORTIFY block in army.gd.

## Session 2026-10-27 — step 3 batch 1 (wired dead mil mods), not yet git-committed
Originals in `_gui_pass_backup_20261025/pre_mods/`. Test: `zz_test/mod_test.tscn` (PASS, 8 checks).
- "First engagement" now real: `army._engagedFromTile` (set in `on_attack_resolved`) → `unit.inFirstEngagement`. Works for AI too (AI moves by setting inTile, never sets movedThisTurn). Live for: Iron Bayonet +2/lvl, Vanguard +1/lvl, QuickDraw +3 ranged/lvl, Combahee River Raid +5/lvl (was +3 always; now as its card says).
- `army.on_attack_resolved(defender, def_loss, conquered)` called from player (path_control) + AI (country._resolve_ai_battle): Field Research (science = 20% of damage), Liberator's Will (+15% manpower, commander +2 loyalty on conquest).
- SaberCharge (every saber): ×2 melee vs a target with a reloading gun, ×3 with Tempuring. Big — it's the counter to firing without anyone on Hold.
- Double Shot (artillery ×1.5), Double Cannonade ((v + 3×lvl) ×2) in `_artillery_volley`.
- Quick Reload −1 reload (start_reload). Fortified Position +3% block in Barracks/Fortress tiles; Coastal Watch +2% melee/ranged block coastal; HardeeDisc +3% block with a friendly army adjacent; Flanking Drill +3/lvl on Flank order; Visionary +3/lvl, Champion of the Sun +1/lvl (melee, per house convention); Healer +10 reinforce; The Long March +2 MP; Night Raider: no Exhausted for move-then-attack; Corrupted Ground −1 corruption/turn on its tile.
- Burning / Diseased / Quarantined now actually cost men (were an unknown damage type). Inspired (×1.15 attack) and Fortified (+20% melee, +15% ranged block) event statuses now do something — values are my pick.
- Removed duplicate early `pass` stubs for Fortified Position / Coastal Watch in unit.gd.
- DEFERRED (need systems): Marine, Naval Supremacy (no naval melee), Ghost March (no ZOC), Rallying Voice / Undaunted / Terror (no morale/rout loop), Siege Line, Cleaner (no moral decay), Sharpshooter armour-pierce, CannonBlast damage multipliers (legacy, would break balance).
- NEEDS DESIGN (no description): VolleyFire, RapidFire, AreaDamage, Siege, HeavyCharge, CavalryMorale, Bayonet, DrillFormation, MinutemanSpirit, Minutemen; ores Wood/Iron describe +attack but are legacy.
- Soak: 2 "Node not found" errors per turn exist in the ORIGINAL code too (PathPointsControl/6 and /94) — pre-existing.
