# Farsword Combat Model — 2-Unit Army Spec

Status: **keystones locked**, a few `[CONFIRM]` items flagged. This is the map we build from.

## 1. Core idea
Every army is exactly **2 units** — a fireteam, not a blob. Each turn an army has **three independent budgets**:

1. **Army Movement** — moves the whole 2-unit army tile-to-tile (existing path system).
2. **Unit Action ×2** — each unit independently spends ONE action: Attack / Hold / Reload / Charge. Independent of the move *and* of the other unit.
3. **Weapon State (per unit)** — Loaded/Unloaded + reload timer. Independent slots: a reloading cannon never freezes the sabre beside it.

Result: combined arms is a real decision, and there are no "dead" reload turns.

## 2. Data model (most of this already exists)
**Unit (`unit.gd`) — already present:** `unitCurrentManpower` / `unitMaxManpower`, `unitShield` / `unitMaxShield`, `unitWeapon` (weaponType / weaponClass), reload state (`is_reloading()` / `tick_reload()`).
- ADD: per-unit action state for the turn — `actedThisTurn: bool`, `stance` ("none"/"hold"/"charge").

**Army (`army.gd`) — already present:** `manpowerInArmy` / `maxManpower` (POOLED = sum of the 2 units — **keep these**), `armyShield` / `armyMaxShield` (pooled — keep), `unitsList` (2), `armyStatusEffects`, `movedThisTurn`, `isGuarding` (end-turn skip — NOT combat Hold), `inRetreat` (uncontrollable retreat — NOT the Retreat modifier).
- ADD: `isHolding: bool` (combat Hold, distinct from isGuarding), and per-turn tracking of "moved" + "a unit attacked" to drive Exhausted/Retreat.

## 3. Death & dormancy
- A unit at **0 manpower / 0 shield = DOWNED, not deleted.** It stays a slot, can't act, and can be reinforced back to life.
- An army **only dies when pooled `manpowerInArmy` = 0** (both units down). Then both units + the APF are removed (existing `deleteMode` path).
- Why: a battered unit is an asset worth saving, not free XP for the enemy.

## 4. The four unit actions (weapon-gated buttons, per unit)
| Action | What it does | Requires |
|---|---|---|
| **Attack** | Strike an adjacent enemy in the weapon's native mode (ranged fires, melee strikes). Spends the unit's action; ranged → Unloaded. | Adjacent enemy; ranged needs Loaded |
| **Hold** | Defensive stance. Sets `isHolding`. **Latency:** the defense bonus arms now but activates at the next-turn tick — no instant reactive defense. `[CONFIRM exact timing]` | Always |
| **Reload** | Refill a spent weapon; spends the action; Loaded again after the reload timer. | Weapon is reloadable + Unloaded |
| **Charge** | Melee shock: bonus attack damage, but **exposed after** (no defense bonus this turn). | Weapon supports charge (cavalry / bayonet) |

## 5. Modifiers (carried in `armyStatusEffects`)
- **Exhausted** (1 turn) — applied when the army **moved, then a unit attacked** the same turn. Effect: **−10% attack**. Also **clears `isHolding`**.
- **Retreat** (1 turn) — applied when a unit **attacked, then the army moved**. Effect: **whole army cannot attack next turn**. (Stored as a status string distinct from the existing `inRetreat` bool.)
- **Holding** — defensive bonus; arms on declare, active from the next-turn tick; cleared by move+attack (Exhausted).

## 6. Move / fight economy
Pure move or pure fight = no penalty. The two mixed orderings each have a cost:

| Sequence | Allowed? | Cost |
|---|---|---|
| Move → then Attack | Yes | `Exhausted` (−10% atk), lose `isHolding` |
| Attack → then Move | Yes | `Retreat` (no attack next turn) |

## 7. Reload model
- Firing a ranged weapon → Unloaded. Reload (action or auto-tick) reloads over N turns, **per unit**.
- Default lengths: musket / repeater **1 turn**, cannon **2 turns**, melee n/a. `[default — adjustable]`
- Independent slots: one unit reloading never blocks the other.

## 8. Combat resolution
- Attacker picks which unit(s) attack (one or both).
- Defender answers with **both units** (confirmed). Defense weighted by stance: **Hold = big bonus**, already-acted (attacked/charged) = **exposed** (reduced), idle/loaded = base.
- Damage applies **per unit** (shield first, then `unitCurrentManpower`); pooled `manpowerInArmy` = the running sum.
- Army dies when pooled = 0.

## 9. Starter weapon -> ability map
| Weapon | Attack | Hold | Reload | Charge |
|---|---|---|---|---|
| Cannon (Mortar/Howitzer) | Ranged | yes | yes, slow (2t) | - |
| Musket (Bess/Flintlock) | Ranged | yes | yes (1t) | yes (bayonet) |
| Repeater (Lever) | Ranged | yes | yes, fast | - |
| Sabre / Cavalry | Melee | yes | - | yes |
| Club / Axe / melee | Melee | yes | - | maybe |

## 10. APF UI implications
- **On-map token:** keep the compact pooled bars (just built). `[CONFIRM: also show per-unit bars on the token, or keep pooled on the token and per-unit detail in the selected panel?]`
- **Weapon icons:** the 2 units' weapons above-left of the token; they double as the per-unit action anchors. Yellow highlight + size-bump on select.
- **Per-unit action buttons:** Attack / Hold / Reload / Charge, enabled/disabled by weapon + state, shown on select.
- **Battle UX:** drop the melee/ranged auto-spam; hover an enemy APF shows the estimate, click attacks. Each attacking unit uses its weapon's native mode.
- **Out-of-turns background:** colorful while the army still has any move or unit action; grey + disabled once fully spent.

## 11. Open / `[CONFIRM]`
1. Hold timing — exact tick the defense bonus activates.
2. Per-unit bars on the map token vs pooled-on-token + per-unit-on-select.
3. Charge — does it move the unit into the tile, or just bonus damage in place?
4. Reload — manual Reload action, auto-reload over N turns, or both (manual to speed up)?

## 12. Build order
- **Phase 1 — rules/data (no UI):** per-unit damage in combat resolution; unit dormancy (no delete at 0); army death on pooled 0; the Exhausted / Retreat / Holding statuses + move-fight economy.
- **Phase 2 — unit actions:** Attack / Hold / Reload / Charge per unit, weapon-gated; retire the old melee/ranged battle buttons.
- **Phase 3 — APF UI:** per-unit action buttons + weapon icons + per-unit stats; hover-preview + click-attack; out-of-turns background.
