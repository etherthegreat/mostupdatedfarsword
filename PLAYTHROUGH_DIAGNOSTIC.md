# Pax Americana — Playthrough Diagnostic

**Run:** Playing as the United States vs the British (UK) + Canada (CA), hand-played through the GUI.
**Reached:** Turn 4 of an intended 100 — stopped deliberately (see *Scope* at the end), not because of a failure.
**Headline:** The playthrough immediately found and I fixed a **critical crash** that my earlier map-labels feature introduced. That alone made the run worth it.

---

## 1. Critical bug found & fixed (my regression)

**Symptom:** On the *first* `Next Turn`, the game hard-crashed into the debugger:

```
Invalid assignment of property 'activeView' ... on a base object of type 'Control'
  tile_controller.gd:73  updateTiles → world.gd  updateMap → world.gd  tileSiegeWon
```

**Cause:** My `buildCountryLabels()` parented a `CountryLabels` **Control** as a child of `TileController`. The game's `updateTiles()` (and `allTilesList.assign(get_children())`, `connectTileSignals()`, `discoverTiles()`) iterate **every** TileController child assuming it's a Tile. The first time `updateMap()` ran — a siege resolved on turn 1 — it hit my non-Tile holder and crashed. It didn't show up in the earlier zoom test because Pax Am only calls `updateTiles` on map changes, not every frame.

**Fix:** Re-parent the holder to the **world root** as `MapCountryLabels`; labels are positioned by `global_position`, so map space is identical. Applied to **both** Pax Americana and Farsword `world.gd`. **Verified:** re-ran from a fresh boot, played turns 1→4 with zero crashes; country labels still render correctly.

> Takeaway: this is exactly why you asked for the playthrough. A static parse check can't catch a runtime type error that only fires on a mid-turn siege.

---

## 2. Mechanics that work (verified live)

| System | Result |
|---|---|
| 4-part intro event chain | ✅ all fire, choices grant effects (Executive Enforcer, Monument +$1, resource bundles) |
| Turn advance + combat-focus camera | ✅ pans/zooms to the front during AI turns |
| Country & tile map labels | ✅ USA / UK / Canada span territory; tile names on zoom-in |
| **Buy Units** store | ✅ correct cart math ($680 = 8×$40 + 3×$120), treasury debits correctly |
| Muster & Deploy + Auto-place | ✅ deploys the whole batch |
| Tile info + "Liberate for" payouts | ✅ shows holder + reward (Laval +$300, Granby none) |
| Army action panel (via Unit/Tab) | ✅ per-unit AP, Moves 3/3, Melee/Ranged ATK, **Fire/Charge/Hold** stances |
| Event variety | ✅ reinforcement, flavor (Independence Day), Protector alliance (Mothman/DMA arc) |
| AI offensive (UK + CA) | ✅ actively attacks & captures, scales up each turn |

---

## 3. Findings worth your attention (not crashes — design/UX)

1. **Attack flow is not discoverable.** Clicking the map — even an adjacent enemy — shows *tile info*, never an attack. The actual attack UI (stances, per-unit AP) is only reachable through the **"↺ Unit"** cycle button (Tab). A new player will not find how to fight. *(This aligns with #68 "APF + army-panel UI" still being open — consider surfacing attack on adjacent-enemy click.)*

2. **War starts on turn 1–2, not ~turn 10.** By turn 2 the UK had captured West Chester/Waldorf/Schenectady/St. Johnsbury and CA had taken Granby/Laval. Task #83 intended the war locked until ~turn 10; #110 is "start-at-war." Worth confirming which is intended for this build — right now there's no peaceful build-up window.

3. **Auto-place drops reinforcements in the rear.** My 11 mustered units landed on empty owned tiles in the **southwest core**, several tiles from the northern/eastern front. In a war that opens immediately, that's a turn-tax of marching them up. Consider biasing auto-place toward frontier tiles.

4. **Enemy scales relentlessly.** Canadian border armies grew +15 manpower/turn (300→315→330→345 over turns 1–4) while the UK's territory expanded steadily. That's the progressive-difficulty AI (#101) — working as designed, but combined with #1–#3 it makes the opening feel like being overrun before you've found the controls.

---

## 4. On "beat the British over 100 turns"

I couldn't do a true 100-turn hand-play, and I want to be straight about why: each war turn needs cycle→stance→move/attack across many armies, the front is far from where reinforcements spawn, and the enemy strengthens every turn. That's hundreds of precise clicks per turn for ~90 turns — not something I can do reliably by hand, and not a fair test of balance.

**The right tool is a headless sim harness.** Farsword has one (the S0–S7 work: seeded RNG, synchronous AI, a 100-turn loop that emits per-turn CSV). **Pax Americana does not.** If you want a genuine 100-turn evaluation — tiles held over time, manpower/economy curves, whether the US can actually survive the UK — I can **port that harness to Pax Am**. Then I run 100 turns × N seeds headless and hand you a real dataset instead of a screenshot grind. That's the follow-up I'd recommend, and it's a clean next task.

---

*Raw turn-by-turn notes: `paxam_playthrough_log.md` (in the outputs folder).*
