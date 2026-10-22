# Loyal Governor

24 events · FULL COMPLETION 14 · FIRST PASS 10

[← back to index](00_INDEX.md)

---

### `GOV_LOYAL_ARC_01` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] PULLS A RECORD CATCH FROM [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Wetlands Fisher · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Fisher Has Done Something Remarkable. The Larder Is Full.

**Body — first draft**

> [COMMANDER_NAME] sent a single-line dispatch from [TILE_NAME]: 'Tide came in right. Came in four times right.' The catch is enough to stock the garrison stores and send surplus up the line. Four turns of [TILE_NAME]'s food output credited to Continental supply.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Catch Report — Four Turns of Food to the Larder | `standard` | tile yield `food` +4 | — |

**Design notes** tile_yield food×4; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_02` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] STRIKES A NEW VEIN AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Appalachian Miner · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Miner Found Something Good in the Mountain.

**Body — first draft**

> [COMMANDER_NAME]'s report from [TILE_NAME]: 'Went deeper than usual. Mountain said yes.' A lateral vein — good quality, accessible this season. Five turns of [TILE_NAME]'s metal output transferred to Continental stores in a single extraction run.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Log the Strike — Five Turns of Metal Delivered | `standard` | tile yield `metal` +5 | — |

**Design notes** tile_yield metal×5; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_03` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] FINDS AN IRREGULARITY IN THE LEDGER AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Ivy League Dropout · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Scholar Found an Inefficiency. It Was Correctable.

**Body — first draft**

> [COMMANDER_NAME] submitted a twelve-page memo identifying a circular grant structure at [TILE_NAME] that had been paying itself since the first year of the war. The correction has been applied. Four turns of [TILE_NAME]'s gold output recovered and credited to the Continental Treasury.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Memo — Four Turns of Gold Recovered | `standard` | tile yield `gold` +4 | — |

**Design notes** tile_yield gold×4; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_04` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] BRINGS IN VOLUNTEERS AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Seminole Fighter · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Fighter's Reputation Has Done the Recruiting.

**Body — first draft**

> [COMMANDER_NAME] sent no report. They sent forty-three people who said they'd been waiting for the right officer to show up at [TILE_NAME]. Three turns of [TILE_NAME]'s manpower output reported to Continental command.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Volunteers — Three Turns of Manpower | `standard` | tile yield `manpower` +3 | — |

**Design notes** tile_yield manpower×3; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_05` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] REPORTS AN EXCEPTIONAL HARVEST AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Green Mountain Farmer · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Farmer Knows What They're Doing. The Fields Agreed.

**Body — first draft**

> [COMMANDER_NAME]'s dispatch from [TILE_NAME] is four words: 'Everything came up right.' The kind of harvest that happens when someone who actually knows the land is managing it. Five turns of [TILE_NAME]'s food output credited to Continental supply.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Record the Harvest — Five Turns of Food | `standard` | tile yield `food` +5 | — |

**Design notes** tile_yield food×5; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_06` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] IDENTIFIES AN UNLOGGED TIMBER STAND AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Chesapeake Shipwright · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Shipwright Found Wood Nobody Else Knew Was There.

**Body — first draft**

> [COMMANDER_NAME] walked the perimeter of [TILE_NAME] on a Tuesday and came back with timber surveys for a stand of white oak that had been right there the entire war. Five turns of [TILE_NAME]'s wood output delivered to Continental stores.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Log the Timber — Five Turns of Wood | `standard` | tile yield `wood` +5 | — |

**Design notes** tile_yield wood×5; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_07` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RECOVERS CROWN ASSETS AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Loyalist Turncoat · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Turncoat Knows Where the Money Was Hidden. They Hid Some of It.

**Body — first draft**

> [COMMANDER_NAME] provided coordinates for a Crown asset cache at [TILE_NAME] buried during a hasty retreat in 1779. The recovery was quiet. Three turns of [TILE_NAME]'s gold output retrieved and credited to Continental accounts. No questions were asked about the coordinates.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Recovery — Three Turns of Gold. No Questions. | `standard` | tile yield `gold` +3 | — |

**Design notes** tile_yield gold×3; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_08` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] CALLS IN A FAVOR AT [TILE_NAME] — WAGONS ARRIVE FULL

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Tobacco Belt Drifter · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Drifter Knows Everyone on This Road. Everyone Owed Them One.

**Body — first draft**

> [COMMANDER_NAME] sent a letter to someone they knew from somewhere they don't specify, and a convoy arrived at [TILE_NAME] two days later. No paperwork. No explanation beyond 'I know people.' Four turns of [TILE_NAME]'s food output delivered.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Convoy — Four Turns of Food. No Paperwork. | `standard` | tile yield `food` +4 | — |

**Design notes** tile_yield food×4; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_09` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] ORGANIZES A MEMORIAL AT [TILE_NAME] — THE COMMUNITY RESPONDS

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** War Widow · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The War Widow Knows How to Hold a Town Together When the War Takes Too Much.

**Body — first draft**

> [COMMANDER_NAME] organized a public memorial at [TILE_NAME] — no ceremony, no speeches, just names read aloud in the town square and a fire kept burning overnight. The community turned out in full. Four turns of [TILE_NAME]'s culture output credited to the Continental record.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Record the Memorial — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** tile_yield culture×4; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_10` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RETURNS FROM THE TREE LINE WITH COMPANY AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Indigenous Scout · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Scout Knows Who Else Is Watching the Forest. Some of Them Said Yes.

**Body — first draft**

> [COMMANDER_NAME] disappeared into the woods outside [TILE_NAME] for six days and came back with thirty-one people who knew the trails, the crossing points, and which Crown supply routes were actually staffed. Three turns of [TILE_NAME]'s manpower output reported to Continental command.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Scouts — Three Turns of Manpower | `standard` | tile yield `manpower` +3 | — |

**Design notes** tile_yield manpower×3; 3%/turn at loyalty≥8; once per governor; text-only

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_18` — MESSAGE IN A BOTTLE FROM THE DEEP SWAMPS OF [TILE_NAME] — THE NOTE READS: SEEK POWER? OR SEEK KNOWLEDGE?

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Eerie/Wry
**Chain** Swamp Witch · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> One Commander. One Question. No Signature.

**Body — first draft**

> A bottle arrived at the Capitol from [TILE_NAME] — no courier, no seal, no explanation of how it crossed six hundred miles of contested territory. Inside: a single strip of paper in [COMMANDER_NAME]'s handwriting. 'Seek Power? Or Seek Knowledge?' Nothing else. The Secretary's office has been staring at it for four hours. You may answer.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Seek Power — 10x Tile Magic Output Immediately | `standard` | tile yield `magic` +10 | — |
| 2 | Seek Knowledge — +10 Spell Points to All Schools | `standard` | `level_all_spell_schools` +10 | — |

**Design notes** BTN1: tile_yield magic×10; BTN2: level_all_spell_schools ×10; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_19` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] CLOSES AN UNDISCLOSED DEAL; GOLD ARRIVES WITHOUT EXPLANATION

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Wry
**Chain** Caribbean Privateer · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Privateer Brokered Something. The Terms Were Favorable. Nobody Is Asking.

**Body — first draft**

> [COMMANDER_NAME] sent no report. A courier arrived the following morning with a sealed chest and a note reading 'see below,' with nothing below it. The gold checks out — equivalent to four turns of [TILE_NAME]'s full output. The Secretary's office has filed this one under 'privateer operations: do not investigate, do not follow up, do not think about it too hard.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Chest — Four Turns of Gold. Terms Undisclosed. | `standard` | tile yield `gold` +4 | — |

**Design notes** BTN1: tile_yield gold×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_11` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] DELIVERS A SPEECH THAT DOES NOT DISPERSE

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Loud/Electric
**Chain** Boston Rabble-Rouser · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Rabble-Rouser Said Something True in Public. It Landed.

**Body — first draft**

> [COMMANDER_NAME]'s speech at [TILE_NAME] was not scheduled, not announced, and drew four hundred people by the third paragraph. The transcript is already circulating in six settlements. The Crown has formally complained. Four turns of [TILE_NAME]'s culture output credited to the Continental record.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Distribute the Transcript — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** BTN1: tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_12` — THE AMPUTEE'S HANDBOOK — [COMMANDER_NAME] SUBMITS A REPORT ON BATTLEFIELD MEDICINE

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Clinical/Tense
**Chain** Continental Surgeon · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Surgeon Has Written Something Remarkable. The Cabinet Does Not Know What to Do With It.

**Body — first draft**

> [COMMANDER_NAME] has produced a comprehensive field manual on wartime medicine — triage, amputation, infection prevention, nutrition for recovery. The cabinet convenes. The knowledge is undeniably valuable. The question is how to deploy it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Send it to the frontline — all units receive 25% manpower back | `standard` | `all_armies_manpower_heal` +25 | — |
| 2 | Our scholars will be very pleased — all buildings in [TILE_NAME] produce +1 science | `standard` | `set_governor_perk` `medical_science` +0 | — |

**Design notes** BTN1: all_armies_manpower_heal 25%; BTN2: set_governor_perk medical_science (+1 science all buildings); 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_13` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] REFLOATS A HULL THAT WAS LISTED ON THE CHARTS AS A NAVIGATION HAZARD

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Dry/Maritime
**Chain** Nantucket Sailor · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Sailor Found Something Useful in the Harbor Mud. Everyone Else Had Written It Off.

**Body — first draft**

> [COMMANDER_NAME] pointed at something in the shallows at [TILE_NAME] that the harbor authority had marked as a hazard to be avoided and told the crew it was a ship to be sailed. Nine days later it was seaworthy. The repair method is not documented anywhere in Continental naval manuals, which [COMMANDER_NAME] notes is probably for the best. Three turns of boat output credited to Continental maritime command.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Commission the Port — Three Turns of Food | `standard` | tile yield `food` +3 | — |

**Design notes** BTN1: tile_yield boats×3; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_14` — FRONTIER PREACHER INSPIRES THOUSANDS

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Earnest
**Chain** Frontier Preacher · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Governor [COMMANDER_NAME] Has Been Hard at Work Inspiring the Citizenry of [TILE_NAME].

**Body — first draft**

> [COMMANDER_NAME] has been riding the frontier settlements of [TILE_NAME] and the crowds have not stopped coming. Word traveled faster than the horse. People arrived from three days out — farmers, trappers, families who had not yet decided whose side they were on. They have decided now. The question is what to do with all of this energy. Where shall we direct the flock?

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Community Inspiration Builds True Beauty — 5x Culture Gift | `standard` | tile yield `culture` +5 | — |
| 2 | Direct the Flock to Heroism — 1000 Manpower to National Stockpile | `standard` | manpower +1000 | — |

**Design notes** BTN1: tile_yield culture×5; BTN2: resource_change manpower 1000; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_25` — FOR ONE NIGHT ONLY!

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Theatrical
**Chain** Carnival Barker · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Governor [COMMANDER_NAME] Has Traded Elephants and Acrobats for Something More Useful.

**Body — first draft**

> [COMMANDER_NAME] has been running the circuit out of [TILE_NAME] for three seasons — the tumbling act, the strongman, the fire-eater who is probably on the Continental wanted list for other reasons. Last Tuesday, for one night only, [COMMANDER_NAME] replaced the whole program with a speech about President Carlisle and the revolution she is personally winning. The crowd was enormous. They were not expecting a political rally. They did not leave. The question is what to do with the momentum.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Excellent Work — Use This Momentum to Sell War Bonds | `standard` | tile yield `gold` +5 | — |
| 2 | His Oration Inspires the Audience to Public Service | `standard` | `tile_building_mandate_surge` +5 | — |

**Design notes** BTN1: tile_yield gold×5; BTN2: tile_building_mandate_surge×5 turns; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_24` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] ORGANIZED SOMETHING NOBODY OFFICIALLY SANCTIONED AND EVERYONE SHOWED UP

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Defiant
**Chain** LGBTQ+ Organizer · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Organizer Built Something in the Town Square. It Held. The Crown Added It to Their List.

**Body — first draft**

> [COMMANDER_NAME] organized a public gathering at [TILE_NAME] — not a rally, not a ceremony, not a church service — so people who avoided all three showed up anyway. The event had no official name. It had music. It had a bonfire. People brought their families. Four turns of culture credited to the Continental record. The Crown has since added it to the formal list of things they would like stopped, which [COMMANDER_NAME] has framed and hung in the garrison.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Record the Gathering — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** BTN1: tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_15` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] AUDITS [TILE_NAME] AND FINDS THREE YEARS OF ACCOUNTING ERROR

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** DC Bureaucrat · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Bureaucrat Found a Mistake. The Mistake Favored the Republic.

**Body — first draft**

> [COMMANDER_NAME] submitted a routine quarterly review of [TILE_NAME]'s expenditure ledger and found a procurement line miscategorized since the first year of the war. The correction transfers four turns of [TILE_NAME]'s gold output into active Continental accounts. [COMMANDER_NAME] has been asked to audit everything else.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Commend [COMMANDER_NAME] for Their Diligent Oversight and Eagle-Like Eyes | `standard` | tile yield `gold` +4 | — |
| 2 | Someone This Good at Finances Must Have Even More Useful Skills… | `standard` | `corrupt_windfall` `gold` +10 | — |

**Design notes** BTN1: tile_yield gold×4; BTN2: corrupt_windfall gold×10 +20 corruption; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_16` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] HAS A PROPOSAL FOR THE FOUNDRY

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Industrial/Serious
**Chain** Rust Belt Steelworker · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Steelworker Is Calling in Favors. The Question Is How to Use Them.

**Body — first draft**

> [COMMANDER_NAME] has spent months building a network of former colleagues across the state — mill workers, smelters, forge hands who know what the revolution actually runs on. They are ready to act. The question is what you ask them to do: burn bright once and flood Continental arms production with a single unstoppable surge — or restructure the foundry floor quietly and permanently, so that every mine and market in [TILE_NAME] produces more metal every turn from this point forward.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Strength of Steel — Pull All Shifts | `standard` | `state_building_level_yield` `metal` +10 | — |
| 2 | Community Steel — Restructure the Foundry Floor | `standard` | `set_governor_perk` `community_steel` +0 | — |

**Design notes** BTN1: state_building_level_yield metal×10; BTN2: set_governor_perk community_steel; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_17` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RETURNS TO [TILE_NAME] WITH RECRUITS WHO WERE WAITING

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Plantation Deserter · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Deserter Knows Who Else Wants Out. They Asked.

**Body — first draft**

> [COMMANDER_NAME] knows which roads the Crown doesn't watch and which workers are waiting for an offer. They returned to [TILE_NAME] and made that offer. Four turns of [TILE_NAME]'s manpower output reported to Continental command — people who were waiting for someone to come back for them.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Refill the Ranks — Send Them Back to Their Fort | `standard` | `tile_army_manpower_refill` +0 | — |
| 2 | Release Them — Send Anarchists Into Crown Territory | `standard` | `spawn_anarchist` +0 | — |

**Design notes** BTN1: tile_army_manpower_refill; BTN2: spawn_anarchist; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_23` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] POSTS ONE MUSTER NOTICE; THE LINE FORMS BEFORE DAWN

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Serious
**Chain** Gettysburg Descendant · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Name Alone. That Was the Whole Campaign.

**Body — first draft**

> [COMMANDER_NAME] posted a single muster notice at [TILE_NAME]. Their name at the bottom. No speech, no broadside, no promises. By the following morning the line stretched past the mill. The Secretary's office asked what rhetoric they used. The reply was four words: 'My grandfather was there.' Four turns of [TILE_NAME]'s manpower reported to Continental command. Some recruits brought their grandparents' uniforms.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Muster — Four Turns of Manpower | `standard` | tile yield `manpower` +4 | — |

**Design notes** BTN1: tile_yield manpower×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_22` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] HAS MAPPED EVERY TIMBER STAND WITHIN TWO DAYS' TRAVEL

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Dry
**Chain** Acadian Forest Ranger · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Ranger Has Been Walking These Woods Since Before Anyone Drew a Border Through Them.

**Body — first draft**

> [COMMANDER_NAME] did not wait for orders. They filed a complete timber survey of every accessible stand within two days' travel of [TILE_NAME], negotiated cutting rights with the trappers in the same afternoon, and had the mill running by dawn. 'The trees were already there,' the dispatch reads. 'I just introduced them to the war.' Five turns of wood output delivered to Continental construction.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Receive the Timber — Five Turns of Wood | `standard` | tile yield `wood` +5 | — |

**Design notes** BTN1: tile_yield wood×5; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_21` — MERCENARY COMMANDER'S PATRIOTIC DISPLAY

**Status** FULL COMPLETION · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Serious/Surprising
**Chain** Border Mercenary · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Stunning Every Military Expert in the Capitol

**Body — first draft**

> Stunning every military expert in the Capitol, our foreign mercenary company led by [COMMANDER_NAME] has been reported singing our national anthem and saluting the flag at dawn. While we never believed them hostile to our cause, coin was always assumed to be their primary motivator — not patriotism. With this new information, should we change how we treat these soldiers going forward?

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Loyalty to Coin Is Better Than No Loyalty at All — 50 Gold + Attack Surge | `standard` | `gold_and_army_buff` `Mercenary Zeal` +10 | — |
| 2 | These Soldiers Will Be Disciplined Like Any Other Troops — Permanent +1 Defense | `standard` | army buff `Iron Discipline` +9999 | — |

**Design notes** BTN1: gold_and_army_buff Mercenary Zeal×10 turns + 50 gold; BTN2: army_buff Iron Discipline permanent; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
