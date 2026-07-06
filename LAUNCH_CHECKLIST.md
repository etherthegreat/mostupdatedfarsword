# Uprisings — Launch Checklist

Organized from tonight's priorities + open goals. Grouped by dependency so we can parallelize:
**I build code while you gather art.**

## TIER 1 — Launch-critical (your top priorities)

### I can build now (no art needed)
- [ ] **Remove focus feature from main-menu buttons** (in `main_menu.tscn` — set button `focus_mode = none`).
- [ ] **Remove the Buildings tab** — hide `BuildingInfoPanel` + its trigger. Map info about where to find
      tokens comes from simpler indicators instead. (Buildings deferred to Farsword.)
- [ ] **Commander arcs — DONE.** `_ARCS_DISABLED` already mutes CMD_/ARC_/PROT_/CA_PROT_ events; I'll
      confirm it's permanent for launch.
- [ ] **Religion tab pass** — make every idol/doctrine actually do something.
- [ ] **Presidential Library rewrite** — turn it into the how-to-play reference: reclamation loop, tokens
      (tech/culture/spell), the buy store + tiers, artillery action economy, stances incl. Flank, caches.
      This is the tutorial, so it's big and important.
- [ ] **Event-image *wiring*** — the mechanism so each event loads its *own* image (not the shared one).

### Needs your art / files / input
- [ ] **Sister Spacedesk's latest art** — drop-in once you hand me the files.
- [ ] **Event images** — the wiring is mine; the image→event *mapping* + the images are yours.
- [ ] **Studio intro splash** — "A game by Ether & Sister Spacedesk" before the main menu. I build the
      scene; you supply the new logos.

## TIER 2 — Narrative reframe (merges with leader armies)
- [ ] **Rewrite Ualani's intimate scene** — replace the human minuteman with **her partner from the
      Pacific**: an Aboriginal man who fled the Pacific collapse, met Ualani, fell in love → the **First
      Gentleman**. (I'll draft; you approve.)
- [ ] **Leader armies + morale stakes** — spawn **Ualani's army at DC**; **Marc Benoit (VP)** placed by a
      front-choice event (S/N/Mid-Atlantic); the **First Gentleman** is a sendable leader army too.
      **Devastating morale loss if the First Gentleman or Marc dies.**
- [ ] **Adult content policy** — keep it to **mythic beasts + Ualani & her partner** only.

## TIER 3 — Reclamation follow-ups (decide pre- vs post-launch)
- [ ] Courthouse **spell tokens → Spellbook** (one spell per protector; remove magic-school panel).
- [ ] **Culture tokens → belief spending** (same token-spend as the tech tree; pairs with the religion pass).
- [ ] **Emergency-alliance arc at ~turn 2** (Canada on the backfoot).
- [ ] **Marc Benoit → VP** reference cleanup (Quebec-leader → US Vice President).
- [ ] **Cross-border deployment** (US units placeable on CA tiles while allied).
- [ ] **Remove the demo turn cap** (full 100-turn game).

## TIER 4 — Deferred to last / post-launch
- [ ] **Spirit of Baseball** art + protector (you de-prioritized to the very end).
- [ ] **Pinned status** (Explosive Charges tech) — nice-to-have.

## Suggested order for tonight
1. **I start the pure-code TIER 1 items** — remove focus, remove Buildings tab, religion pass, event-image
   wiring — quick wins that don't wait on art.
2. **In parallel, you gather:** Sister Spacedesk's art, the studio logos, and the event-image mapping.
3. **I write the Presidential Library** tutorial (big, self-contained).
4. **Leader armies + First Gentleman + morale** (TIER 2) — I build the mechanic; I draft the scene rewrite.
5. **Integrate art as it arrives** — studio intro, event images, art drop-in.
6. TIER 3 follow-ups as time allows; TIER 4 last.
