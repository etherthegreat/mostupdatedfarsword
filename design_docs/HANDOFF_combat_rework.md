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
