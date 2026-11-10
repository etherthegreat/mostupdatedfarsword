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
2. Commander armies: fixed home tiles, army granted on liberation, starting roster,
   displaced state, army line on the War Room commander card.
3. Minutemen contracts: repurpose Buy Units, expiry, per-tile hire count and pricing,
   starting militia, tile capacity, commander buffs shared with a co-located militia.
4. Workshops: place 12 sites, worker per site, FBPs, dollar upgrades, capture and rescue,
   state-liberation bonus, civilian panel rebuilt around sites.
5. Economy: cut the flat base, add land-based dollar income, tune against the targets.
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
