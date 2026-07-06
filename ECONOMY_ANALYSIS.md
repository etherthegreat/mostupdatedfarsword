# Uprisings — Economy Simplification Analysis

## The situation
The player carries **12 resources**: Dollars, Manpower, Weapons, Food, Wood, Metal,
Science, Culture (incl. old Faith), Magic, Mandate, Happiness, Influence.

Each has its own income and its own spend, and the player is expected to keep all twelve
meters healthy. That's the "mana management" weight — twelve dials, most of which don't
offer an interesting *choice*; they just have to not run dry. It's inherited from DODK,
where it'll be explored properly.

## The core question
An economy **earns its keep when it gates interesting choices** —
*"I can afford an army OR a tech this turn, not both."*
It becomes a **chore when it demands balancing** —
*"keep Food, Happiness, and Mandate all positive or something bad happens,"* with no fun
decision attached.

Uprisings currently has both. The goal: keep the **gating** (you still unlock things and
can't have everything at once) and drop the **balancing** (the twelve-dial upkeep).

## Sorting the 12 by what they actually earn

**A. Spend-to-unlock — the fun part, KEEP + SHOW**
- **Dollars** — general currency (armies, buildings)
- **Manpower** — mans your units
- **Weapons** — arms your units
- **Science** — buys tech
- **Culture** — buys religion (gods/doctrines)

Each is tied to a real decision: *what do I build/unlock this turn?*

**B. Upkeep / stability — the chore, HIDE + DECLAW**
- **Food** — feeds population/armies
- **Happiness** — contentment
- **Mandate** — political capital
- **Influence** — diplomacy

These are "don't let it go negative" meters. They add worry, not decisions.

**C. Optional / niche**
- **Wood, Metal** — a *second* construction currency layered on top of Dollars
- **Magic** — a whole parallel spell economy

## Three ways to cut it down

### Option 1 — Hide & auto-flow  *(lightest; ~an afternoon; fully reversible)*
Keep all 12 in the data (DODK stays compatible, nothing breaks), but:
- Show the player only **bucket A** (the 5 spend-to-unlock resources).
- Make bucket B/C income auto-apply and **never punish** — they still tick for flavor but
  can't go negative or hurt you.
- Buildings keep producing everything; the player just stops babysitting it.

The player unlocks armies/tech/religion from 5 clear resources; the other 7 leave their
attention. One flag flips it back.

### Option 2 — Collapse to a core five  *(moderate; ~1–2 days)*
Merge the 12 down to what the player touches:
- **Treasury** (Dollars, absorbing Wood + Metal — construction just costs money)
- **Manpower**
- **Weapons**
- **Science** (tech)
- **Culture / Faith** (religion)

Fold Food / Happiness / Mandate / Influence / Magic into flat passive modifiers or drop
them. Buildings produce the core five. This is the cleanest *long-term* shape.

### Option 3 — Buildings-as-flavor, one currency  *(heaviest)*
Buildings produce nothing you manage — cosmetic + small passive perks. A single abstract
**Progress** accrues each turn and is the ONLY thing you spend (armies/tech/religion).
Combat is the only live system. Simplest to play, biggest departure, most rebalancing.

## Recommendation
- **For the July-4 demo → Option 1.** Least risky, reversible, and it removes the
  twelve-dial worry *without touching the systems you'll keep exploring in DODK*. The player
  still builds, unlocks, and grows — they just stop watching Food and Happiness.
- **For the full game later → drift toward Option 2.** A core five is a genuinely good
  economy shape for a war game, and it lets you re-add depth *deliberately* instead of
  inheriting DODK's whole stack.

## Concretely — "keep vs cut" for the demo (Option 1)
| Resource | Demo treatment |
|---|---|
| Dollars, Manpower, Weapons, Science, Culture | **Keep + show** (the 5 you spend) |
| Food, Happiness, Mandate, Influence | **Keep, hide, declaw** (informational, never punishing) |
| Wood, Metal | **Fold into buildings** — don't gate construction on them |
| Magic | Keep if spells are demo-worthy; else hide the orb too |
| **All buildings** | **Stay, keep producing** — the player just reads 5 meters, not 12 |

If Option 1 sounds right, the work is: point the top resource bar at the 5, and set the
upkeep meters to "never go below zero / no penalty." Roughly an afternoon.
