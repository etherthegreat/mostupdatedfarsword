# Loyal Governor

25 events · FIRST PASS 25

[← back to index](00_INDEX.md)

---

### `GOV_LOYAL_ARC_01` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] PULLS A RECORD CATCH FROM [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Wetlands Fisher · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield food×4; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield metal×5; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield gold×4; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield manpower×3; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield food×5; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield wood×5; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield gold×3; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield food×4; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

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
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Design notes** tile_yield manpower×3; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_11` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] DELIVERS A SPEECH AT [TILE_NAME] THAT DOES NOT DISPERSE

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Boston Rabble-Rouser · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Rabble-Rouser Said Something True in Public. It Landed.

**Body — first draft**

> [COMMANDER_NAME]'s speech at [TILE_NAME] was not scheduled, not announced, and drew four hundred people by the third paragraph. The transcript is being circulated in six settlements. The Crown has formally complained about it. Four turns of [TILE_NAME]'s culture output credited to the Continental record.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Distribute the Transcript — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_12` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] APPLIES MEDICAL PRECISION TO THE SUPPLY CHAIN AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Continental Surgeon · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Surgeon Found Four Points of Waste. All Four Were Fixable.

**Body — first draft**

> [COMMANDER_NAME] conducted a review of [TILE_NAME]'s supply logistics and identified four points of waste significant enough to correct in a single week. 'Soldiers don't eat like patients, but they could stand to eat like people who intend to survive,' they wrote. Four turns of [TILE_NAME]'s food output recovered.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Implement the Protocol — Four Turns of Food Recovered | `standard` | tile yield `food` +4 | — |

**Design notes** tile_yield food×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_13` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] REFLOATS A DECOMMISSIONED HULL AT [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Nantucket Sailor · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Sailor Found Something Useful in the Harbor Mud.

**Body — first draft**

> [COMMANDER_NAME] pointed at something in the shallows at [TILE_NAME] that everyone else had written off as a navigation hazard and turned it into operational naval capacity in nine days. The repair was unconventional. The result is seaworthy. Three turns of [TILE_NAME]'s boat output credited to Continental maritime command.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Commission the Hull — Three Turns of Boats | `standard` | tile yield `boats` +3 | — |

**Design notes** tile_yield boats×3; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_14` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RIDES THE CIRCUIT AT [TILE_NAME] — FOUR SETTLEMENTS RESPOND

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Frontier Preacher · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Preacher Got on a Horse and Did What They Do.

**Body — first draft**

> [COMMANDER_NAME] rode through four outlying settlements around [TILE_NAME] over eleven days, held services, delivered Continental correspondence, and came back with signed pledges of community support from all four. 'They just needed someone to show up,' they wrote. Four turns of [TILE_NAME]'s culture output credited.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Enter the Pledges — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_15` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] AUDITS [TILE_NAME] AND FINDS THREE YEARS OF ACCOUNTING ERROR

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** DC Bureaucrat · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Bureaucrat Found a Mistake. The Mistake Favored the Republic.

**Body — first draft**

> [COMMANDER_NAME] submitted a routine quarterly review of [TILE_NAME]'s expenditure ledger and found a procurement line miscategorized since the first year of the war. The correction transfers four turns of [TILE_NAME]'s gold output into active Continental accounts. [COMMANDER_NAME] has been asked to audit everything else.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Apply the Correction — Four Turns of Gold | `standard` | tile yield `gold` +4 | — |

**Design notes** tile_yield gold×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_16` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RETASKS THE FOUNDRY AT [TILE_NAME] FOR ONE EXCEPTIONAL WEEK

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Rust Belt Steelworker · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Steelworker Called in Every Colleague They Had. They All Showed Up.

**Body — first draft**

> [COMMANDER_NAME] sent one message through the industrial network and every former colleague within riding distance arrived at [TILE_NAME] the following Monday. The foundry ran around the clock for six days. Five turns of [TILE_NAME]'s metal output delivered to Continental arms production in one surge.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Log the Surge — Five Turns of Metal | `standard` | tile yield `metal` +5 | — |

**Design notes** tile_yield metal×5; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_17` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] RETURNS TO [TILE_NAME] WITH RECRUITS WHO WERE WAITING

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Plantation Deserter · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Deserter Knows Who Else Wants Out. They Asked.

**Body — first draft**

> [COMMANDER_NAME] knows which roads the Crown doesn't watch and which workers are waiting for an offer. They returned to [TILE_NAME] and made that offer. Four turns of [TILE_NAME]'s manpower output reported to Continental command — people who were waiting for someone to come back for them.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Register the Recruits — Four Turns of Manpower | `standard` | tile yield `manpower` +4 | — |

**Design notes** tile_yield manpower×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_18` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] REPORTS A WORKING COMPLETED AT [TILE_NAME] — THE RESULTS ARE SUBSTANTIAL

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Swamp Witch · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Witch Did Something in the Swamp Last Night. The Results Are Beneficial.

**Body — first draft**

> [COMMANDER_NAME]'s report from [TILE_NAME] is two sentences: 'The working is complete. Do not go into the east marsh until Tuesday.' The DMA has classified the results as Category 2 Beneficial. Four turns of [TILE_NAME]'s magic output transferred to Continental arcane reserves.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Working — Four Turns of Magic. Do Not Ask. | `standard` | tile yield `magic` +4 | — |

**Design notes** tile_yield magic×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_19` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] CLOSES A DEAL AT [TILE_NAME] — GOLD ARRIVES WITHOUT EXPLANATION

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Caribbean Privateer · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Privateer Brokered Something. The Terms Were Favorable.

**Body — first draft**

> [COMMANDER_NAME] sent no report. A courier arrived the following morning with a sealed chest and a note that read 'see below' with nothing below it. The amount checks out against four turns of [TILE_NAME]'s gold output. The DMA has filed this under 'privateer operations: do not investigate.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Chest — Four Turns of Gold. Terms Undisclosed. | `standard` | tile yield `gold` +4 | — |

**Design notes** tile_yield gold×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_20` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] INTRODUCES NEW METHODS AT [TILE_NAME] — YIELDS CLIMB IMMEDIATELY

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Hawaiian Refugee · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Refugee Looked at the Land and Saw It Differently.

**Body — first draft**

> [COMMANDER_NAME] spent a week at [TILE_NAME]'s food production operations and introduced cultivation methods obvious to someone from the Pacific and entirely unobvious to everyone else. The improvement was immediate. Three turns of [TILE_NAME]'s food output credited to Continental supply.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Document the Method — Three Turns of Food | `standard` | tile yield `food` +3 | — |

**Design notes** tile_yield food×3; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_21` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] CONSOLIDATES SCATTERED ARMS CACHES NEAR [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Border Mercenary · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Mercenary Knows Where Everyone Hides Things.

**Body — first draft**

> [COMMANDER_NAME] spent three days conducting what they called 'a professional survey of the surrounding territory' and returned with four wagons of weapons and ammunition from informal caches around [TILE_NAME]. 'Inefficient placement,' they wrote. Four turns of [TILE_NAME]'s weapons output delivered.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Consolidate the Caches — Four Turns of Weapons | `standard` | tile yield `weapons` +4 | — |

**Design notes** tile_yield weapons×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_22` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] MAPS AND MILLS A TIMBER ROUTE FROM [TILE_NAME]

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Acadian Forest Ranger · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Ranger Has Been Walking These Woods Since Before the War.

**Body — first draft**

> [COMMANDER_NAME] filed a timber survey of every accessible stand within two days' travel of [TILE_NAME] and negotiated cutting rights with the local trappers in the same week. The mill ran five days straight. Five turns of [TILE_NAME]'s wood output delivered to Continental construction.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Receive the Timber — Five Turns of Wood | `standard` | tile yield `wood` +5 | — |

**Design notes** tile_yield wood×5; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_23` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] POSTS A MUSTER AT [TILE_NAME] — PEOPLE SHOW UP

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Gettysburg Descendant · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Soldier's Name Alone Is Enough.

**Body — first draft**

> [COMMANDER_NAME] posted a muster notice at [TILE_NAME] with their name on it. That was the entire recruitment campaign. Four turns of [TILE_NAME]'s manpower output reported to Continental command by end of week. Some of the recruits are the grandchildren of people who fought alongside their family before.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Muster — Four Turns of Manpower | `standard` | tile yield `manpower` +4 | — |

**Design notes** tile_yield manpower×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_24` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] HOSTS A GATHERING AT [TILE_NAME] — EVERYONE COMES

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** LGBTQ+ Organizer · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Organizer Built Something in the Town Square. It Held.

**Body — first draft**

> [COMMANDER_NAME] organized a public gathering at [TILE_NAME] — not a rally, not a ceremony, not a church service — so people who avoided all three showed up anyway. Four turns of [TILE_NAME]'s culture output credited to the Continental record. The Crown has added it to the list of things they want stopped.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Record the Gathering — Four Turns of Culture | `standard` | tile yield `culture` +4 | — |

**Design notes** tile_yield culture×4; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LOYAL_ARC_25` — DISPATCH FROM [TILE_NAME] — [COMMANDER_NAME] STAGES AN EXHIBITION AT [TILE_NAME] — THE TILL IS FULL

**Status** FIRST PASS · **Type** `loyal_governor` · **Country** `GEN` · **Tone** Warm/Brief
**Chain** Carnival Barker · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Barker Pitched Something. People Paid to See It.

**Body — first draft**

> [COMMANDER_NAME] organized what the official report calls 'a traveling exhibition of Continental military achievements' at [TILE_NAME] — which was a carnival with a patriotic framing and a substantial admission fee. Three turns of [TILE_NAME]'s gold output credited to Continental accounts. Attendance was remarkable.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Gate — Three Turns of Gold | `standard` | tile yield `gold` +3 | — |

**Design notes** tile_yield gold×3; 3%/turn at loyalty≥8; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
