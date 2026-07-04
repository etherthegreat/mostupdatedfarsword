# Uprisings — Reclamation Rework Build Plan

## The Pivot
From **"defend the revolution"** to **"reclaim the homeland."** The player begins on the
brink of collapse — a few scattered pockets — and claws territory back from Britain. The
tension comes from the *map*, not from nerfing the player. The player is powerful and always
on the attack; the fun is the comeback.

Why it's better: defensive games force you to weaken the player to manufacture tension. A
reclamation game lets the player stay strong and aggressive while the *starting position*
supplies the pressure. You attack, attack, attack — liberating as you go.

## Starting Position — Four Pockets
The USA begins holding only four disconnected pockets (each = anchor tile + immediate
neighbors, pulled from the tile adjacency graph):

- **Valley Forge pocket** (PA) — tile 1, `Fortress` terrain, "Birthplace of America." A
  natural chokepoint and the strongest opening pocket.
- **Washington DC pocket** — tile 188, "National Mall | Pentagon | US Capitol."
- **Southern arm** — Birmingham (168, AL) + Nashville (165, TN). Both at corruption 70 — a
  contested, occupied South that reads as barely-held.
- **Northern arm** — Montpelier (80, VT), Green Mountains, home of the Green Mountain Ghost
  protector.

Canada is pushed back to **Ottawa** (tile 201) + immediate neighbors. Britain owns everything
else. Both nations are one bad turn from annihilation.

## The Token Economy — Everything Comes From Liberating
Replace the passive point/resource systems with liberation payouts. Every building you take
pays out:

| Liberate a tile with… | Payout |
|---|---|
| Ivy / school (18 tiles) | **1 Tech token** — instantly unlock any technology |
| Monument | **1 Culture token** — unlock a belief / doctrine |
| Courthouse | **3 Spell tokens** — cast protector spells (once DMA-unlocked) |
| Market | Large **cash** influx |
| Forge | Large **weapons** influx |
| Barracks | Large **manpower** influx |

### Resource simplification
- **Drop Science** — technologies are token-only now.
- **Drop Culture** — beliefs are token-only now.
- Keep **Dollars, Manpower, Weapons** (the three the buy store spends).
- HUD becomes 3 resources + three token counters (Tech / Culture / Spell).

## The 18 Tech Tiles (one per unlockable tech)
6 techs are seeded free (first row of each category); **18 remain unlockable**, so 18 tech
tiles = 18 possible unlocks. Tokens are **generic** (spend on any tech) so the player pushes
toward whatever unlock they want.

**Existing 9 (Northeast):** Philadelphia (Penn), New York City (Columbia), Princeton, West
Point, New Haven (Yale), Providence (Brown), Harvard, Boston (MIT), Raleigh (Research Triangle).

**New 9 (spread South / Mid-Atlantic / Florida / Canada):**
1. Baltimore, MD — Johns Hopkins
2. Norfolk, VA — naval research
3. Atlanta, GA — Georgia Tech
4. Orlando, FL — Space Coast / NASA
5. Charleston, SC — military academies (The Citadel)
6. Knoxville, TN — Oak Ridge labs
7. Toronto, ON — University of Toronto
8. Montreal, QC — McGill
9. Portland, ME *(or Quebec City)* — upper-Northeast / eastern-Canada gap-filler

## Keep the Buy Store + Huge Starting Cash
The mobilization / purchase system stays exactly as is — it's the "run it your way" freedom:
fortify a pocket, or abandon one to concentrate force. Give the player a large starting
treasury to build out defensive lines immediately. Income grows as territory is reclaimed, so
the aggressive loop self-reinforces (liberate → more income → more armies → liberate more).

## Systems to Delete / Simplify
- The peace phase (turns 1-9), turn-9 border warning, National Guard / Citizens mobilization,
  and turn-10 UK invasion — all removed. You start at war.
- Science-point tech buying — replaced by tech tokens.
- Culture resource output — replaced by culture tokens.

## Systems to Add
- Token counters + "spend token" UI (tech tree, belief panel, spell UI).
- British garrisons pre-placed across UK tiles at start.
- Cache payouts on tile capture (hook the existing capture / liberation flow).
- Win / loss: win = liberate a bounded goal region (demo: e.g. retake Pennsylvania + New
  Jersey); loss = lose your last pocket.

## Build Sequence
1. **Data flip** — CSV ownership (pockets → USA, Ottawa → CA, rest → UK) + tag the 9 new tech tiles.
2. **Delete** the peace / invasion / mobilization machinery.
3. **Garrisons** — pre-place UK armies on their tiles.
4. **Token system** — counters, payouts on capture, spend-UI; drop Science + Culture resources.
5. **Caches** — cash / weapons / manpower on market / forge / barracks capture.
6. **Win / loss** retune + huge starting cash.
7. **Narrative pass** — reframe intro events to "reclaim the homeland"; bring liberation events back.

## Open Questions / Risks
- **Opening survivability** — pockets can't die on turn 2. Garrisons should mostly *hold*, not
  all-rush a tiny player. Valley Forge's fortress terrain helps.
- **Demo goal** — a bounded liberation objective so there's a real win inside ~20 turns.
- **Pocket sizes** — confirm each pocket's exact tiles once the adjacency graph is pulled.
- **Cache amounts** — "huge" is tunable; set after playtesting.
- **Courthouse spell tokens** depend on the DMA / protector-spell system being wired for the
  player — confirm scope for the demo.

## Session Addendum — Locked Decisions

**Scope / no demo goal.** Ship the **full system** — 100 turns, full liberation of America as
the implicit win. Minimal flavor/events beyond combat; the point is genuine feedback on how the
system plays across the whole board. (Removes the need for a bounded demo win.)

**Spell system (build now — pairs with tonight's protector-arc pass):**
- Add **one spell per protector** (~7 current) to the existing **Spellbook** scene
  (`spellbook.gd` / `spellbook.tscn`), which is already how the player casts spells.
- **Remove the magic-school panel** (`spell_schools_control.gd`, `magic_amount_control`) for now.
- **Courthouse liberation → 3 spell tokens**; spells cast from the Spellbook once unlocked via
  the DMA / protector system.

**Canada / alliance:**
- **Emergency-alliance arc opens the game (~turn 2).** Allied powers are on the backfoot and
  Canada is at real risk of dying, so the alliance session starts immediately
  (`_check_usa_alliance_events`).
- **Marc Benoit → US Vice President.** Repoint all "leader of Quebec" references to the VP role
  and wire the finished VP event chain + art to him. (Name can be freed later for a future
  Quebecois leader; ship the done art now.)
- **Canada-liberates → US benefits.** While allied, a Canadian liberation grants the *US player*
  that tile's token/cache (Canada retakes Quebec → US gets the buff).
- **Cross-border deployment.** The US player may place bought units on Canadian tiles while
  allied, to help push the northern front.

**Dependency order for the build:**
- *Foundation (everything hangs off this):* Phase 1 data flip → tile-capture hook → token
  counters + payouts + caches.
- *Independent track (parallelizable):* Marc Benoit → VP, emergency-alliance timing, the
  Spellbook casting UI + magic-panel removal.
- *Needs foundation:* courthouse spell tokens, Canada-liberation → US tokens, cross-border
  placement.
