# HANDOFF — Liberation economy rework (commander armies, Minutemen contracts, Workshops)

Written 2026-11-09 at the end of the War Room / Agent 355 session. Design agreed with Ether in that
session; nothing in this document is built yet except where marked DONE.

Goal: make "liberating the country" the single spine of the game. Liberating land gives you
commanders with armies, hiring grounds for militia, and construction sites. The DODK-style
sandbox (buy any unit, customise it, a civilian on every tile) goes away for Pax Americana.

Target: Steam Next Fest submission, mid-to-late January 2027. Build in the order below so the
game stays playable after every step.

---

## 1. Agreed design

### 1.1 Commander armies
- 25 fixed **home tiles**, one per existing commander archetype (ARC_01..ARC_25 in
  `WarRoomPanel.gd`). The tile and its archetype are always the same; the commander's name and
  face are random each run.
- Liberating a home tile grants that commander **and their army**. Armies are no longer bought.
- A commander army is two units. Show only: where it is, strength, manpower, its two units,
  who leads it.
- If Britain retakes the home tile the army is **displaced**: no refills and a slow bleed, not
  deleted. Retaking the tile restores it. (This is the brake on snowballing.)
- Starting roster (4 commander armies):
  - South: 1, at Nashville or Birmingham (Tennessee / Alabama).
  - Mid-Atlantic: 2, at **Valley Forge** and **Baltimore**.
  - North: 1, at **Schenectady** (tile 73; it has no commander today, so one moves there).

### 1.2 Minutemen contracts (the old "Buy Units", repurposed)
- Hired from a tile, cost manpower, **leaderless**, expire after 5 turns. Modifiers can extend
  the length later.
- A tile's 2nd hire costs +50%, its 3rd costs double, and a tile can be hired from at most
  3 times per run. A tile cannot be hired from while its current company is still active.
- Show a countdown on the militia badge and a notice one turn before expiry.
- Starting militia (12): South 2, Mid-Atlantic 6, North 4, with **staggered expiry between
  turns 4 and 8** so the timer is taught gradually.

### 1.3 Tile capacity
- A tile holds at most **one commander army, one militia, one civilian**.
- A militia sharing a tile with a commander army **takes on the commander's buffs** (it acts
  as a temporary third unit for punching through a Redcoat line).

### 1.4 Workshops, workers and free building purchases (FBP)
- Some tiles are predetermined **Construction Sites** (they have a Workshop building).
- Liberating one unlocks a **worker** civilian tied to that tile. One worker per Workshop.
- Workshop level = FBPs granted to its worker: level 1 grants 1, level 3 grants 3. Upgrading
  a Workshop grants its worker +1 FBP. Upgrading a Workshop is expensive.
- A worker can:
  - **upgrade** any building for dollars (always costs money), or
  - **add a new building** to a tile by spending an FBP.
- An FBP is the **only** way to add a building to a tile, other than a scripted event.
  An FBP cannot be used to build a Workshop.
- FBPs belong to the worker, so events can hand a worker more later.
- Fully liberating a state gives every worker stationed in that state **+1 FBP**.
- A raised worker can be **captured** by Britain. It is held in that tile until the tile is
  liberated, not killed.
- The civilian panel is reorganised to list the predetermined construction sites, showing
  which are liberated and which are not.

### 1.5 Panels
- **Drop** unit customisation and the Buy Units flow (Buy Units becomes the contract screen).
- **Keep** the card that opens when you click an army on the map. Only change: when a
  commander army shares a tile with a militia, show the militia's stats on it too.
- The **War Room Commanders tab** shows each commander's attached army on their card
  (`war_room_card.gd`, `build_commander`).

### 1.6 Resources
- Dollars are the **only** upgrade cost. Wood, metal and food are dropped.
  CONFIRM SCOPE with Ether before removing them from code: they are still used by army upkeep
  (`country.gd` `payUnitMaintenance`) and by protector objectives (Old Ironsides needs food).
- One resource per verb: dollars = upgrades, manpower = contracts and refilling regulars,
  Culture tokens = Icons / Social Contracts, Mandate = laws.

---

## 2. Agreed numbers

| Thing | Today | Agreed |
|---|---|---|
| Flat dollar base (`DEMO_BASE_DOLLARS`, `country.gd`) | 370 | 120; the rest earned from Markets and held tiles |
| Dollar income target | ~310 flat | ~200 at start, ~700 with the map liberated |
| Building upgrade | development points from civilians | 100 x the level being upgraded to (L2 = 200, L3 = 300) |
| Workshop upgrade | n/a | 600 to L2, 1,200 to L3; each grants 1 FBP |
| Minutemen contract | 200 manpower, permanent | 500 manpower for 5 turns; 750 second hire, 1,000 third |
| Commander army upkeep | 20 a turn | 10 a turn flat |
| Worker upkeep | 4 a turn | 4 a turn |
| Construction sites | 0 on the map | 12: 4 held at the start, 8 behind British lines |

Not yet decided: which 12 tiles are construction sites, which 25 tiles are commander homes,
which two units each commander army has, how fast a displaced army bleeds, and the exact
per-Market / per-tile dollar yields that reach the income targets.

---

## 3. What the code does today (measured 2026-11-09, ten idle turns, USA)

- Start: 46 owned tiles (PA 12, NY 13, VT 6, MD 5, VA 3, AL 3, WV 1, GA 1, TN 1, DC 1).
- Dollars: about +310 a turn, nearly all from the flat base. Losing 32 tiles did not lower it.
- Wood, metal, food: pinned at 9,999.
- Manpower: about +880 a turn at 46 tiles, about +250 at 15 tiles; 2,887 on turn 2.
- 91 player buildings, 68 of them level 1. No Workshop exists on any tile.
- 14 commanders sit on 14 muster tiles (Valley Forge, Gettysburg, Baltimore, Annapolis,
  Alexandria, Bethesda, Bennington, Ticonderoga, Montpelier, Buffalo, Marietta, Nashville,
  Birmingham, Tuscaloosa), plus Ualani in Washington. Only one army exists at the start
  (Secret Service Detail, Washington).
- With that one army the player loses about three tiles a turn. Re-test once the new
  starting roster exists.
- One `Civilian` card is created per owned tile (46) by `civilian_control.gd`
  `loadCivilians`; tools and kits are DODK leftovers. Development runs through
  `tile.gd` `devChange` (points until a building levels up).
- Muster / Buy Units lives in `world.gd` (`_open_muster_panel`, `_muster_confirm`,
  `_free_muster_tiles`, `MUSTER_DEFAULT_MEN`).

---

## 4. Build order

1. DONE — civilian freeze. `PathControl.onTurnEnd()` (resets civilian moves) was never
   called; it now runs each turn from `world.gd`, and a civilian with no moves says so.
2. DONE (see section 7) - Commander armies: fixed home tiles, army granted on liberation, starting roster,
   displaced state, army line on the War Room commander card.
3. DONE (see section 9; stacking built as attaching) - Minutemen contracts: repurpose Buy Units, expiry, per-tile hire count and pricing,
   starting militia, tile capacity, commander buffs shared with a co-located militia.
4. DONE (see section 10) - Workshops: place 12 sites, worker per site, FBPs, dollar upgrades, capture and rescue,
   state-liberation bonus, civilian panel rebuilt around sites.
5. DONE (see section 11) - Economy: cut the flat base, add land-based dollar income, tune against the targets.
6. Remove unit customisation; confirm scope and drop wood / metal / food.

---

## 5. Working notes for the next session

- **Branch:** work is on `pax_gui_pass` (pushed, commit 05c6dbf "Huge Update"). `CLAUDE.md`
  still names `claude/farsword-recent-push-JL6OS`; ask Ether which is right before pushing.
- **Uncommitted right now:** the civilian fix (`world.gd`, `path_control.gd`) and this file.
- **Follow the project rules in `CLAUDE.md`:** flavordoc rule, ethertask close rule,
  governor token rule.
- **Backups:** copy any file you are about to change into a dated `_..._backup_YYYYMMDD`
  folder first and put a `.gdignore` in it (scripts with `class_name` collide otherwise).
- **Testing:** the project runs headless in Godot 4.4.1. Boot `world.tscn`, call
  `newGameBuild("USA", "eng", false)`, set `_skip_ai_playback = true`, and
  `await _on_next_turn_pressed()` to step turns; `zz_test/depth_boot.gd` is a working
  example. Its turn-2 check expects the old Agent 355 reel and will now fail by design.
- **Flags changed last session (`world.gd`):** `DEBUG_AGENT355_TEST` is false and
  `TRAILER_MONSTER_PARADE` is false, so spirit scenes arrive through War Room files.
- **Spirit ladder:** `WarRoomPanel.gd` drives every spirit through Contact, Trust, Accord;
  hand-written tasks live in `data/protector_stages.csv`. Buttons can carry several outcomes
  with the `multi` outcome type (`world.gd` `executeOutcome`).
- **Known leftovers, not part of this rework:** a legacy starting belief "Tyla-Dyn" and
  legacy laws "Mercantilism" / "Citizen Militia" still appear; `ProtectorArcEntry` and
  `CommanderArcEntry` scenes are no longer used; spirit stockpile targets (20-50) are
  trivial against the current economy; Old Ironsides and Lincoln's Ghost first contact
  (DMA investigation) is untested; a 0-byte `_claude_stage.tar` may still be in the root.

---

## 6. Decisions added 2026-11-09 (evening session)

- **Southern starting commander is at Nashville** (tile 165).
- **Commander homes are always Barracks tiles**, sprinkled across the map. 65 tiles have a
  Barracks today; 25 of them are homes. Ether asked for "randomized balance": see open
  question A below on what is random per run.
- **Workers cannot add a Barracks with an FBP** (same rule as Workshops).
- **Commander army composition follows the commander's abilities**: horse-charge commander =
  two dragoon units; artillery commander = one musket + one mortar; gun commander = two
  musket units. Composition is fixed by archetype, not chosen by the player.
- **Minutemen composition is the player's choice**: pick the left unit and the right unit
  independently from any available type (mix and match). This replaces the fixed
  `BUY_CATALOG` templates in `world.gd`.
- **Construction sites are one per state**, at the capital or a more satisfying city
  (e.g. New York City). **New York has two**: one upstate, one in the city.

Answers from Ether (same evening):

- **A. Random each run:** the 25 homes are drawn from the Barracks tiles, spread evenly by
  region (South 9, Mid-Atlantic 8, North 8) and then by state; archetypes are dealt by
  terrain. Only the four starting homes are fixed. This replaces "tile and archetype are
  always the same" in 1.1.
- **B. Northern starter is Ticonderoga** (tile 78), not Schenectady. Starting homes:
  Nashville 165, Valley Forge 1, Baltimore 37, Ticonderoga 78.
- **C. 12 construction sites**, skipping the smaller states. One per chosen state, two in NY.
- **D. Three unit types only: musket, saber, artillery.** Tech chains advance the weapon of
  each type. When a tech unlocks a better weapon, every unit that can take it shows an
  **Upgrade** button that costs dollars. Artillery commanders start with a Field Cannon and
  upgrade to a Mortar later. (Not built yet; belongs with step 6 / the unit card.)

---

## 7. Step 2 is BUILT (commander homes and armies) - 2026-11-09

Files: `world.gd` (section "COMMANDER HOMES", plus `_spawn_home_commander`), `army.gd`
(`commanderHome`, `displaced`, `_bleed_displaced`), `governor.gd` (`commanderHomeTile`,
`commanderArmy`), `WarRoomPanel.gd` (`setWaitingCommanders`), `war_room_card.gd`
(`_add_army_lines`). Originals are in `_liberation_step2_backup_20261109/`.
Test: `zz_test/home_test.tscn` (passes; `depth_boot` still passes).

How it works:
- `_pick_commander_homes()` runs at game start for a USA player. Homes other than the four
  starters are always on enemy-held Barracks tiles. Washington is never a home.
- `_deal_archetype()` picks an archetype that fits the terrain, avoids repeats, and steers
  toward `ARMY_TYPE_SHARE` (40% musket, 30% saber, 30% artillery).
- `_army_type_for_arch()` reads the army type off the abilities: Saber Drill = saber;
  Powder & Shot, Explosives Expert, Double Shot, Double Cannonade, Siege Line = artillery;
  otherwise musket. The lowest commander level carrying one of those decides.
- Armies use the existing templates Minutemen / Dragoons / Artillery Battery (200 men).
- `tileSiegeWon` calls `_on_commander_home_changed`. Liberating a home grants the commander
  at once; the army musters at the end of that turn on the home tile, or a free friendly
  neighbour. Losing a home sets `displaced`; retaking it clears it, or raises a new army if
  the old one died.
- Displaced: no recruits, minus 5% of full strength a turn, never below 25%. Both numbers
  are placeholders (`DISPLACED_BLEED`, `DISPLACED_FLOOR` in `army.gd`).
- The 10 other Barracks tiles the player owns at the start no longer get a commander.
- War Room Commanders tab: each card shows the army (units, men, attack, location, displaced
  warning) and the tab lists the commanders still behind enemy lines.

Measured over three runs: army mix lands at 15-17 musket, 5-7 saber, 3-5 artillery, because
few archetypes carry saber or artillery abilities on most terrains.

## 8. Step 2 follow-up (same evening, Ether's answers)

- **Re-muster:** a commander army destroyed in the field returns after 10 turns of holding
  its home tile (`COMMANDER_REMUSTER_TURNS`, `_tick_commander_remuster` in `world.gd`).
  Turns the enemy holds the home do not count. `_commander_remuster_bonus` is the hook for a
  future unlockable that shortens the wait by 1, 2, 3 turns. The War Room card shows the
  countdown.
- **Commander armies are twice a Minutemen company:** new templates Commander Muskets /
  Commander Sabers / Commander Battery in `army_templates.csv` (level 2 units, 400 men).
  Measured: musket 175 attack vs 78, saber 65 vs 25, battery 254 vs 109; shield 104 vs 52.
- **Minutemen are the small units:** used for spacing, defence and final blows. In step 3
  draw their map token visibly smaller, with the turns-left number ticking on it.
- **Four new commander traits** (`mil_mod.gd`, `unit.gd`, `RecordsDatabase.gd`, flavordoc
  and preslib builders, all FIRST DRAFT text): Light Horse and Thunder Charge (saber),
  Gun Captain and Canister Shot (artillery). They only lift the matching weapon.
- **Archetypes moved off musket** (`_apply_archetype_mods`):
  saber: Florida Cracker Cowman, Hudson Valley Patroon, Tidewater Gentlewoman, Boston Irish
  Dockworker, Frontier Preacher, Tobacco Belt Drifter, Carnival Barker (Border Mercenary
  also gains Thunder Charge);
  artillery: Nantucket Sailor, Bahamian Free Sailor, Ivy League Dropout, Appalachian
  Moonshiner, Green Mountain Farmer, Loyalist Turncoat, DC Bureaucrat.
  Pool is now 30 musket, 15 saber, 11 artillery of 56. Measured mix per run: 10-13 musket,
  5-7 saber, 7-8 artillery.
- `scripts/build_army_masterdoc.py` has its own archetype / trait table that was already out
  of step with the code before this change; it was not updated.

## 9. Step 3 is BUILT (Minutemen contracts, attaching, movement) - 2026-11-09

Built (files: `world.gd` section "MINUTEMEN CONTRACTS", `army.gd`, `country.gd`,
`army_badge.gd`, `army_path_follow.gd`; originals in `_liberation_step3_backup_20261109/`;
test `zz_test/contract_test.tscn`, screenshots via `zz_test/contract_shot.tscn`):
- The old Buy Units button is now "Minutemen" and opens the contract screen
  (`_open_contract_panel`): pick the left unit and the right unit (musket / saber /
  artillery), then Hire from a hiring ground.
- Hiring grounds are the owned muster points: barracks, forts, cities and the capital.
- Cost 500 / 750 / 1,000 Manpower for a ground's 1st / 2nd / 3rd hire; three hires a run;
  no new hire while that ground's last company is still serving.
- A company serves 5 turns (`CONTRACT_TURNS`; `_contract_length_bonus` is the hook for
  modifiers), has no commander, takes no recruits, and pays no dollar upkeep.
- `_tick_contracts` runs once a round; a notice lists companies on their last turn and the
  ones that went home.
- Map: company tokens are drawn at 72% size and the badge carries a round chip with the
  turns left; the chip fills orange on the last turn.
- 12 starting companies (`STARTING_MILITIA`): South 2, Mid-Atlantic 6, North 4, serving
  through turns 4 to 8, placed on free front-line tiles. They do not count against any
  ground's three hires.
- The mobilisation events and the Farmer Volunteers now hand out one-contract companies.
- Interim rule: a new company carries the best weapon of each type the player has
  researched (`CONTRACT_WEAPON_CHAIN`), because the per-unit Upgrade button is not built.

Attaching (Ether chose this over true two-armies-on-a-tile stacking), BUILT:
- A company that moves onto a commander army's tile joins it: its two units become units
  3 and 4 of that army, carry the commander's traits, and show on the same card under an
  "ATTACHED" line with the turns left and a Detach button. A commander army that marches
  onto a company's tile picks it up the same way. One company per commander army.
- Hiring on a ground where a commander army stands hires the company straight into it.
- Attached units add no movement, take no recruits and cost no upkeep. The contract keeps
  counting down; at zero the units leave the army. The host's badge shows the chip.
- Detach puts the company on a free friendly tile beside the army with no movement left
  that turn.
- Code: `army.gd` (`attachedUnits`, `attach_company`, `detach_units`, `can_host_company`),
  `world.gd` (`attach_company`, `detach_company`, `_contract_host_on`), `path_control.gd`
  (`_attach_partner`), `army_card.gd` (`_build_attached_header`). Test:
  `zz_test/attach_test.tscn`. Originals in `_liberation_attach_backup_20261109/`.
- With more than two units the army card drops the per-unit strength sum to a hover so it
  fits a 1080 screen.

Movement (Ether, same evening), BUILT:
- A player army's movement is the sum of its own units, rounded down: saber 1.5, musket 1,
  artillery 0.5 (`base_movement_points` in `army.gd`). Two sabers 3, saber + musket 2,
  two muskets 2, musket + artillery 1, two cannons 1. Commander and belief movement bonuses
  still add on top. AI armies keep their flat 3.
- Multi-tile march: a selected army lights up every tile it can reach with the movement
  it has left, and a right-click sends it there in one order (`reachable_from`, `route_to`
  in `path_control.gd`). It may only pass THROUGH friendly, empty tiles that no Redcoat
  army covers; the last step can be anything a single step could do before.
- A cannon army spends one crew action per march order, not per tile.

Other notes:
- The old Buy Units code (`_open_muster_panel`, `BUY_CATALOG`, `_raise_archetype_army`,
  `try_buy_and_raise`) is no longer reachable from the UI but is still used by
  `depth_boot`, `strat_bot` and `stance_matrix`. Remove it with step 6.
- `contract_test` prints one "Parent node is busy setting up children" error as the test
  quits; not traced. It does not appear during play in the test.
- Every player march prints "Can't add child 'Army' ... already has a parent
  'ArmyContainer'" from `armyArrivedFunc`. It was there before this work and is harmless
  (the army stays in its barracks button), but it should be cleaned up.
- Idle for ten turns, Manpower climbs to about 8,400 and dollars to about 3,000, so
  contracts are cheap until step 5 retunes income.

## 10. Step 4 is BUILT (Workshops and workers) + AI movement - 2026-11-09

Files: `world.gd` section "WORKSHOPS AND WORKERS", `Civilian.gd` (`isWorker`, `fbp`,
`workshopTile`, `captured`), `civilian_control.gd`, `path_control.gd`,
`data/tiles_final.csv`. Originals in `_liberation_step4_backup_20261109/`.
Test `zz_test/workers_test.tscn`; screenshots via `zz_test/workers_shot.tscn`.

- **The 12 Construction Sites** are the tiles with `workshop:1` in `tiles_final.csv`
  (Claude's pick, Ether to confirm; change the CSV to move one):
  held at the start: Harrisburg PA, Buffalo NY (upstate), Annapolis MD, Nashville TN;
  behind British lines: New York City, Boston MA, Augusta ME, Richmond VA, Raleigh NC,
  Charleston SC, Atlanta GA, Miami FL. Skipped: NJ, CT, DE, RI, NH, VT, WV, AL, DC.
- Holding a site gives one worker, placed on the map at the Workshop. Liberating a site
  frees its worker (`_grant_site_worker`). No more one-civilian-per-tile for a US player.
- A worker has free building purchases (`fbp`): one per Workshop level at the start, +1
  each time its Workshop is upgraded, +1 when the state it is STANDING in becomes fully
  liberated (once per state per run).
- Clicking a worker opens the worker panel: upgrade any building on its tile for
  100 x the new level (cap L4), upgrade a Workshop for 600 / 1,200 (cap L3), or add a
  building for one FBP. Addable: Farm, Granary, Mine, Camp, Market, Forge, Library,
  Courthouse, Monument, Resort, Fortress. Never Workshop or Barracks. Dock is left out
  because tiles do not record which are coastal.
- Workers only move on liberated ground, one worker to a tile, and no longer block armies.
- If Britain takes the tile a worker stands on, the worker is captured (cannot move or
  build) until the tile is retaken.
- The civilian button opens the Construction Sites list (all 12, who holds them, where
  each worker is, FBPs left, "Go to").
- Worker upkeep: `activeCivilianCount` is now set each round, so the 4 dollars a turn per
  worker is actually charged (it was never set before, so civilians were free).
- The old building screen's Upgrade / Add buttons are hidden for a US player.
- The worker panel has a "Report the strange sightings here" button on tiles flagged
  `hasMysteriousShipRaids`; it sets `dmaInvestigationPending`, which the DMA Badge tool
  used to do. Spy civilians (Codebook tool) have no way in any more.
- `tile.addBuilding` and `building.upgradeBuilding` do not touch the `tile.buildings`
  dictionary; the worker functions update both. Anything else that adds or upgrades a
  building at run time should do the same, or the tile card will not show it.

AI movement (Ether): every army, British and Canadian included, now gets movement from
its units (saber 1.5, musket 1, artillery 0.5, rounded down). The British AI takes one
step per movement point and stops when it attacks (`_uk_calculate_turn`). The standard
Redcoat + Howitzer army comes out at 1, which is what it did before; Canadian
musket + saber militia come out at 2 but the Canadian AI does not march.

## 11. Step 5 is BUILT (dollar economy) + panel pass - 2026-11-09

Economy (`country.gd`, `building.gd`; originals in `_liberation_step5_backup_20261109/`;
measure with `zz_test/econ_probe.tscn`):
- Flat base `DEMO_BASE_DOLLARS` 370 -> 120. `DOLLARS_PER_HELD_TILE` = 1.
  `MARKET_DOLLARS_PER_LEVEL` = 14 (was 1), before corruption.
- Commander army upkeep is a flat `COMMANDER_ARMY_UPKEEP` = 10; contract companies cost no
  dollars at all (the old per-army gold cost is skipped for both).
- Measured income before upkeep: about 215 a turn at the start (46 tiles, 10 Market
  levels), about 700 with all 150 US tiles (46 Market levels). After upkeep and workers:
  about 136 at the start, about 377 with the map liberated.
- Manpower reserve can no longer go below zero.
- Manpower flattened (Ether): a governor's manpower bonus counts for a tenth
  (`GOVERNOR_MANPOWER_SHARE`), and a Barracks gives 25 per level, up from 15
  (`BARRACKS_MANPOWER_PER_LEVEL`). Measured: 495-505 a turn at the start in every run,
  about 1,900 with the map liberated. Idle to turn 10 the reserve reaches about 3,400.
- The turn-1 trailer boost is off (`TRAILER_LAUNCH_BOOST` in `world.gd`). A run starts
  with 100 dollars and 1,000 manpower. The Secret Service Detail army still spawns.

Panels (`canvas_layer.gd`, `world.gd`, `pause_menu.gd`; test `zz_test/ui_test.tscn`, which
must run with a real window: xvfb + `--rendering-driver vulkan`, not `--headless`):
- First attempt (invisible mouse-swallowing shields under each panel) was WRONG and is
  gone: belief and law buttons and the resource bar are Area2Ds, so a Control that eats
  the mouse eats them too, and the idle event-popup holder claimed the middle of the map.
- What is there now: `canvas_layer.gd` only MEASURES what each open panel shows
  (`_panel_rects`, `blocks_map_at(pos)`; solid things only, never bare containers; over
  55% of the screen counts as all of it). The map asks before it reacts:
  `tile.gd` `_under_open_panel()`, the right-click march in `world.gd`, and
  `path_control.gd` `_tick_token_mouse()`, which makes army / worker tokens under a panel
  ignore the mouse so the click reaches the panel's own Area2D buttons.
- Move-marker buttons are hidden unless a civilian is selected. They used to stay lit
  around the last unit raised and each one ate the click on the middle of its tile.
- One panel at a time: `closeAllPanels()` now also calls `world._close_code_panels()`
  (army card, tile card, contracts, worker, sites, old muster, commander picker, run
  progress). A code panel opens through `world._close_all_panels("name")`. Closing a
  unit's card by opening something else also deselects the unit.
- The pause menu closes everything and moves itself above the HUD.

Still open for step 2:
- The Secret Service Detail in Washington is still a permanent, led army outside the
  commander system.
- Event-driven ownership changes that call `record_conquest` directly (secession,
  reintegration, collapse) do not pass through `tileSiegeWon`, so they do not grant or
  displace commanders.
- No map marker for commander homes yet; the War Room list is the only place they show.
- Commander upkeep (10 a turn) is step 5.
