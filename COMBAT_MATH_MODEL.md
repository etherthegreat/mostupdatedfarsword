# Farsword Combat Math — Findings & Suggestions
*(analysis only — no code touched; apply when you're sharp)*

## 1. Your current number system (measured from combat-work)

| Thing | Formula | Range |
|---|---|---|
| Unit HP (manpower) | `100 × unitLevel` | 100 → 400 |
| Army HP | 2 units pooled | 200 → 800 |
| Melee attack (per unit) | `level × weaponMelee × meleePenalty × mpEffect` | ~4 → ~280 |
| Ranged attack (per unit) | `level × weaponRanged × mpEffect` | ~35 → ~360 |
| Block (melee/ranged) | armor decimal, summed ÷ units, clamp 0..0.9 | ~0.15–0.35 |
| Shield | `level × oreMaxShield` (separate HP buffer) | varies |
| Weapon melee values | Saber 25–70, Musket bayonet 8–15 (×0.5) | 4–70 |
| Weapon ranged values | Musket 35–80, Artillery 70–120 | 35–120 |

## 2. What's actually wrong — three specific problems

**P1 — Combat is one-shot, and gets worse as the game goes.**
Attack scales on TWO axes (weapon tier climbs 35→120, *and* ×unitLevel), but HP scales on ONE (×level only). So the attack/HP ratio widens over the game:
- Early (L1 musket duel): a volley = ~56 dmg on 200 HP → **28% per exchange** (≈ 4-turn fight — healthy!).
- Late (L4 repeater duel): a volley = ~512 dmg on 800 HP → **64% per exchange** (≈ 2-turn fight — near one-shot).
Civ/Vic3 keep every hit at ~15–30% of HP forever. Yours drifts to 60%+.

**P2 — The Hold bonus is on the wrong scale (this is the big one).**
`unitDefensiveScore` is a **decimal 0.0–1.0** (armor block). But `hold_defense_bonus()` adds **+20** per holding unit into that same sum, then clamps to 0.9. Result: a *single* Hold unit makes the block `clamp((0.4 + 20)/2, 0, 0.9) = 0.90` → **90% damage reduction from one holder.** Holders are effectively invincible. The bonus should be ~**+0.20**, not +20.

**P3 — Melee ≪ ranged, so Charge is suicide.**
Melee weapon values (8–70) sit far below ranged (35–120), muskets eat a ×0.5 melee penalty, and the counter fires *everyone* back at full ranged (holders at 1.5×). So a charge brings a ~50 melee poke into a ~300 ranged counter → your real "Deal 52 / Take 340." Melee has zero compensating advantage — nothing says "closing the distance blunts their volley."

## 3. How your reference games avoid all three

- **Civ VI:** `damage = 30 × e^(strengthDiff/25) × rand(0.75–1.25)` on 100 HP. Only the *strength difference* matters, never the magnitude — so an even fight is always ~30/hit (3–4 turns) whether it's Warriors or tanks. No era one-shots.
- **Victoria 3:** manpower + **morale**. Each hit is a small %, damage scales by the shooter's remaining manpower (you already do this via `mpEffect` — nice), and a battle ends at ~**50% casualties** when morale breaks. Units *rout*, they don't fight to zero.

## 4. Recommended model: Civ-flavored, because you have 2-unit tactical fireteams

Keep manpower as the readable HP bar. Target: **a full army exchange costs ~20–30% of the enemy's HP**, so every fight is a legible 3–5 turn trade. Add a rout breakpoint so armies shatter near ~50% losses instead of grinding to 0 (huge feel upgrade, optional).

## 5. Concrete suggestions — two tiers

### Tier 1 — three one-liners, ~80% of the feel tonight-easy
1. **Fix the Hold bonus:** `hold_defense_bonus` → return **0.20 per holder** (decimal), not 20. Holders become "sturdy," not immortal.
2. **Tame the one-shot:** add `const COMBAT_DAMAGE_SCALE := 0.5` and multiply `def_loss`/`atk_loss` by it in `compute_battle_against`. Instantly ~doubles fight length. Tune 0.4–0.6 by feel.
3. **Make Charge viable:** when the attacker is charging, multiply the defender's **ranged** counter by 0.5 (you closed the distance; the volley is rushed). Now charge is a "range-closer" that neutralizes gun lines instead of feeding them.

### Tier 2 — the real fix (when you want combat consistent across the whole game)
Convert raw attack into a tight **Combat Strength** band (~20–90, Civ-style) and derive damage from the *ratio*, not raw subtraction:
```
strengthRatio = attackerStrength / max(1, defenderStrength)
damage = BASE_DMG(≈25) × strengthRatio × (1 - block)   # on a ~150 HP unit bar
```
Because it keys off the ratio, an even fight is always ~25 on 150 (≈6 turns) whether it's L1 cutlasses or L4 howitzers — the late-game one-shot drift (P1) disappears permanently. I can hand you the full strength-conversion table (each weapon → a 20–90 strength value) whenever you want to go here.

## 6. Rout/morale breakpoint (optional, big feel win)
Add an army "morale" that drops as manpower falls; at ~50% losses the army auto-retreats (your Retreat status already exists). Turns every battle into a push-until-they-break instead of a fight-to-the-last-man, exactly like Vic3.

---
*Sources: Civ VI combat formula (CivFanatics / Civ Wiki), Victoria 3 land-warfare (Paradox wiki).*
