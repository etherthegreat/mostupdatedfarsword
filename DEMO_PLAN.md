# Uprisings — July 4 Limited Demo: Gating Plan

## Core principle
**Gate, don't strip.** One master switch (`DEMO_MODE`), flip features OFF, keep the code.
Smallest possible diff from the working build; fully reversible after the demo.

---

## What's IN the demo (keep — do not touch)
- Tiles + the combat system (instant capture, AI march/fight replay, stances, reload)
- War timing: quiet peace (turns 1–9) → turn-9 mobilization (National Guard / Citizens) → turn-10 invasion
- Economy / building / barracks (needed to raise armies during peace)
- Governors / commanders (used by combat + mobilization)
- The 4-part intro chain (`INTRO_01` → `INTRO_04`)
- Protector arcs (`PROT_` / `CA_PROT_` summons + follow-ups)

---

## The one switch
Add `const DEMO_MODE := true` in `world.gd` (near `_ARCS_DISABLED`). Everything below keys off it.

---

## 1. Events — the single most important gate  *(the 95% win)*
Every event funnels through `createNewEvent()`. Replace the current `_ARCS_DISABLED` block
(world.gd ~line 2595) with a **demo whitelist**:

> In demo mode, only fire event IDs starting with `INTRO_`, `PROT_`, or `CA_PROT_`.
> Everything else returns immediately.

- Automatically KILLS: commander arcs (`CMD_`/`ARC_`), VP events, Chalchiuhtlicue arcs,
  White House secrets, Ualani arcs, Beat 2/3 events, faction/governor events,
  state secession/rebel events, tile-fall/liberation (already off), and every date event past the intro.
- Automatically KEEPS: the intro chain + the protector arcs (this also *re-enables* protectors,
  which `_ARCS_DISABLED` is currently muting).
- The turn-9 "British Amassing" warning + mobilization is fired by **direct instantiation**,
  not `createNewEvent`, so it fires regardless — good, it's part of the demo.

One reversible change gates almost all non-demo content in a single spot.

---

## 2. Per-turn dispatch — belt & suspenders
`evaluateDateEvents()` runs a stack of `_check_*` / `_tick_*` calls each turn (VP, Chalch,
White House, commander turns, arc objectives…). The whitelist already stops their popups, but
wrap the non-demo ones in `if not DEMO_MODE:` so they don't burn cycles or nudge state.
KEEP the protector ones: `_check_protector_summons`, `_tick_wild_protectors`,
`_check_prot08_dma_summon`, `_check_prot17_dma_summon`.

---

## 3. Save / Load
`Continue` doesn't reliably restore yet (task #65). For a short demo: **hide/disable the
Continue button** on the main menu in demo mode — New Game only. Avoids a broken-restore
support headache on day one.

---

## 4. Systems — decisions for you *(my recommendation in bold)*
- Tech tree — **KEEP.** Works; gives the peace turns something to do.
- Religion / beliefs — **KEEP** (works), or gate for minimalism. Your call.
- Presidential Library (Gallery / Records / Journal) — **KEEP.** Nice depth, self-contained, low risk.
- Anything half-finished not listed — the whitelist gates it automatically.

---

## 5. The demo end-cap  *(the one net-new thing to build — small)*
The game currently never ends on purpose. Add: in demo mode, when
`currentWorldTurn >= DEMO_END_TURN` (suggest ~15, giving ~5 war turns) OR on the first
decisive win/loss → show a simple **"Demo Complete — thanks for playing / wishlist us"** screen.

---

## 6. Hardening  *(the real risk — not game design)*
- Verify `world.tscn` is complete: it must end on the `RightClickDetector` connection line.
  This is the truncation gremlin — a hard won't-load crash. It's bitten us twice.
- Lock the build: verify the scene, then **don't re-save it in the editor** before packaging.
- Optional: a tiny startup self-check that logs if the scene loaded fully.

---

## 7. Test before ship
- **2–3 cold playthroughs:** fresh New Game → survive to turn 10 → several war turns → hit the end-cap.
- Watch for: any crash; mobilization spawns correctly; invasion arrives at turn 10; combat replays
  cleanly; **no stray event popups** during combat.

---

## Suggested order of operations
1. Add `DEMO_MODE` + the `createNewEvent` whitelist (kills events, turns protectors back on).
2. Gate the per-turn `_check_*` calls.
3. Disable Continue on the menu.
4. Build the end-cap.
5. Harden + verify `world.tscn`.
6. Two clean playthroughs.
7. Package.

Items 1–4 are roughly an afternoon. Items 5–7 are where the care goes.
