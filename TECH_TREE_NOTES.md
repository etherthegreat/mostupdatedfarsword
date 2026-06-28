# Tech Tree — Overnight Notes

Hey — here's everything I touched while you slept. Three commits, all on `claude/farsword-recent-push-JL6OS`, all reviewable as diffs.

## What's committed

1. **`636f8fc` — Gameplay stability** (the crashes you confirmed fixed):
   - P0-1 dead-army teardown (per-frame error spam)
   - APF visibility (armies stay visible when parked on hidden path points)
   - `countryArmyList` supply crash (freed army left in the roster)
   - Tech-tree crash + science-investment now persists across turns
2. **`2cce85a` — Tech tree trim + layout** (tonight's main task)

## Tech tree — what changed

- **Five categories now**, renamed from the old labels: **SABRE, RIFLE, CANNON, UNIFORM, DEVELOPMENT**.
- **Generic civ techs hidden**: Language, Writing, Alphabet, Mathematics, Administration, Printing Press, Steam Power.
- **Layout fixed**: the GridContainer was set to `columns = 4` but each row needs 5 cells (label + 4 techs), so every row wrapped a quarter-tech early — that was the scattered mess. Now `columns = 5`, so each category sits on its own clean row.
- **Reward fix**: "Explosive Charges" (CANNON, tier 3) now actually grants the Mortar — its reward was orphaned under an unused "Mortar Tactics" id.

### Category → techs
| Category | Tier 1 → Tier 4 |
|---|---|
| SABRE | Swordsmanship · Cavalry Drills · Officer Training · Marine Discipline |
| RIFLE | Musket Drilling · Volley Tactics · Percussion Ignition · Repeating Mechanisms |
| CANNON | Field Gunnery · Siege Works · Explosive Charges · Rocket Artillery |
| UNIFORM | Organization · Logistics · Tactics · Authority |
| DEVELOPMENT | Agrarian Reform · Trade Networks · Industrialization · Infrastructure |

## ⚠️ Decisions I left for YOU (didn't want to guess)

1. **Hidden techs granted real bonuses.** Language / Writing / Administration / Alphabet have effect code in `country.gd` (~lines 882, 943, 1006, 1014): Palace max-level +3, Infantry/Ranged stat boosts, and starting kits/tools/buildings. Hiding those techs makes those bonuses **unreachable**. If you want them, we should move them onto a kept tech or the starting state — your call.
2. **Hidden, not deleted.** I hid the two generic containers in code (safe + reversible) instead of deleting nodes from `tech_tree.tscn` blind. When you're in the editor you can fully delete `TechPanel/InsititutionContainer` and `TechPanel/UnlockedContainer` (plus the unused hardcoded GridContainer buttons — Agriculture, Calendar, etc.) for a clean scene.
3. **"UNIFORM" is the old DEFENSE techs** (Organization/Logistics/Tactics/Authority → barracks/unit upgrades). If you want true uniform-themed techs with their own names + rewards (e.g. Militia → Line Infantry → Grenadiers → Guards), that's a content pass we should do together — I didn't invent new reward types without you.
4. **Spacing is a guess.** I set `columns=5`, `h_separation=40`, `v_separation=30`. I couldn't see the result, so if it's too tight or too wide it's a one-number tweak in `_build_grid()`.
5. **Row order** is SABRE, RIFLE, CANNON, DEVELOPMENT, UNIFORM — reorder freely in the `TECH_ROWS` array.

## To check this morning
- Open the tech tree: five clean rows, no Language/Writing/etc.
- Invest in a pricier tech across a few turns — it should climb steadily and complete (no reset, no crash).

## Next on the DEBUGLIST
**P0-2** — the army-move duplicate signal connect (moves multiplying each turn). Ready when you are.
