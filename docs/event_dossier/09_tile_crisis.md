# Tile Crisis

26 events · FIRST PASS 24 · IDEA 2

[← back to index](00_INDEX.md)

---

### `HARVEST_001` — THE ARMY ATE THE SEED CORN

**Status** FIRST PASS · **Type** `harvest_crisis` · **Country** `USA` · **Tone** Tense/Satirical
**Chain** Harvest Crisis · position Root
**Art** `harvest_crisis` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:2970`, `Game Scenes and Scripts/world.gd:2983`, `Game Scenes and Scripts/world.gd:2984`, `Game Scenes and Scripts/world.gd:2985`

**Subhead — first draft**

> Continental Supply Office Files Report Describing Situation as 'Technically Above Zero'

**Body — first draft**

> The quarterly food assessment has arrived with unusual candor. Reserves have reached a number the quartermaster described as 'technically above zero, which remains the official threshold for catastrophe.' The seed corn designated for spring planting has been consumed. Entirely. By the army. The spring planting is now subject to philosophical revision. This is an agricultural emergency. The President is aware. The fields at [TILE_NAME] are the closest operational farmland. Station the army there to salvage the harvest before the season closes.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Dispatch Ualani to the Farmlands — Station Army at [TILE_NAME] | `standard` | sets mission flag `HARVEST_VISIT_01` | — |
| 2 | Accept the Shortage — Hold Position | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when food < 50; Farm tile required; set_mission_flag BTN1

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `HARVEST_VISIT_01` — PRESIDENT CARLISLE SAVES THE HARVEST

**Status** FIRST PASS · **Type** `harvest_resolution` · **Country** `USA` · **Tone** Warm/Triumphant
**Chain** Harvest Crisis · position Followup
**Art** `harvest_complete` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Farmers Report She Was 'Unexpectedly Effective in a Corn Emergency'

**Body — first draft**

> The President arrived at [TILE_NAME] before the roosters did. She did not explain herself. She assessed the fields, spoke with the senior farmhand in a tone the farmhand later described as 'extremely motivating and slightly terrifying,' and proceeded to personally oversee the emergency harvest with the focused energy of someone who has read every briefing and is not going to let corn defeat the Republic. The harvest is back on track. The army has been fed. The farmhand filed a formal statement of gratitude and requested the President not come back because the workers couldn't concentrate. This has been logged as a successful operation.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Process the Harvest Report | `standard` | food +60 | — |
| 2 | Presidential Persuasion — Full Agricultural Engagement | `explicit` | food +80 | — |

**Leads to**

- scene nav: "intimate" → `HARVEST_VISIT_01_INTIMATE` — PRESIDENT CARLISLE SAVES THE HARVEST — BY MORNING

**Design notes** BTN2 explicit 'Presidential Persuasion' +food 80 vs BTN1 standard +food 60

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `HARBOR_001` — CROWN VESSELS SPOTTED IN TERRITORIAL WATERS: DOCK AT [TILE_NAME] AT RISK

**Status** FIRST PASS · **Type** `harbor_threat` · **Country** `USA` · **Tone** Tense/Satirical
**Chain** Harbor Threat · position Root
**Art** `harbor_threat` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:2990`, `Game Scenes and Scripts/world.gd:3003`, `Game Scenes and Scripts/world.gd:3004`, `Game Scenes and Scripts/world.gd:3005`

**Subhead — first draft**

> Royal Navy Calls It 'Routine Navigation.' The Harbor Master Calls It Something Else.

**Body — first draft**

> Three Crown frigates have been conducting what their signals officer described as 'standard maritime operations' within eyeshot of [TILE_NAME]. The harbor master's report uses different language — specifically, the words 'deliberate,' 'provocative,' and 'they keep sailing past the same dock at the same time every morning like they're measuring it.' The dock at [TILE_NAME] represents a critical supply and naval access point. The Crown knows this. They are also measuring it. Choose a response — then station your army at [TILE_NAME] to execute it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Station a Naval Garrison — Secure the Dock | `standard` | sets mission flag `HARBOR_ESCORT_01` | — |
| 2 | Deny Access by Force — Destroy the Dock | `standard` | sets mission flag `HARBOR_BURN_01` | — |

**Design notes** Dock tile required + UK neighbor; army station required

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `HARBOR_ESCORT_01` — HARBOR SECURED: CROWN FRIGATE RETREATS FROM [TILE_NAME]

**Status** FIRST PASS · **Type** `harbor_secured` · **Country** `USA` · **Tone** Rousing/Satirical
**Chain** Harbor Threat · position Branch
**Art** `harbor_secure` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Continental Garrison Establishes Presence. Royal Navy Files Strongly-Worded Complaint.

**Body — first draft**

> The Continental garrison at [TILE_NAME] has made its position clear to the Royal Navy: this harbor is not available for measurement, assessment, or casual intimidation. The lead Crown frigate sent a signal requesting clarification of territorial intent. The garrison commander sent back a cannon salute — which is technically a diplomatic communication format, and nobody in the harbor disagreed with the message. The frigate has retreated to open water. The harbor is operational and supply lines are confirmed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Process the Harbor Master's Report | `standard` | food +30 | — |

**Design notes** +food 30; garrison path

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `HARBOR_BURN_01` — DOCK FACILITIES AT [TILE_NAME] DESTROYED: ACCESS DENIED TO ALL PARTIES

**Status** FIRST PASS · **Type** `harbor_burned` · **Country** `USA` · **Tone** Tense/Wry
**Chain** Harbor Threat · position Branch
**Art** `harbor_burned` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Strategic Denial Operation Comprehensively Denies Everything Including Our Own Access.

**Body — first draft**

> The dock at [TILE_NAME] has been destroyed. This was intentional. The Crown will not be using it. We will also not be using it, which the supply office has noted with measured frustration in a report labeled 'collateral strategic sacrifice.' The fire was efficient and the Crown frigate that had been watching from the harbor mouth has withdrawn — presumably to locate a different dock to measure. The operation is logged as a tactical success. The quartermaster logs it as 'a situation.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Operations Report | `standard` | disables building `Dock` | — |

**Design notes** disable_building Dock 8 turns; destruction path

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORGE_001` — INTELLIGENCE ALERT: CROWN FORCES HAVE LOCATED THE FORGE AT [TILE_NAME]

**Status** FIRST PASS · **Type** `forge_threat` · **Country** `USA` · **Tone** Tense/Urgent
**Chain** Forge Threat · position Root
**Art** `forge_threat` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3010`, `Game Scenes and Scripts/world.gd:3023`, `Game Scenes and Scripts/world.gd:3024`, `Game Scenes and Scripts/world.gd:3025`

**Subhead — first draft**

> Crown Agents Observed Sketching Schematics. The Sketches Were Detailed. Too Detailed.

**Body — first draft**

> Continental intelligence reports that Crown agents have been conducting reconnaissance near the forge at [TILE_NAME] for the past week. The intelligence is considered reliable. The agents were seen sketching what appears to be the forge layout, the approach roads, and the shift schedule of the workers. This is not casual interest. The forge at [TILE_NAME] produces a meaningful portion of Continental weapons output. The Crown knows this. They are planning something. Station your army at [TILE_NAME] and choose how to respond before they act.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Reinforce the Forge — Station Army at [TILE_NAME] | `standard` | sets mission flag `FORGE_REINFORCE_01` | — |
| 2 | Emergency Evacuation — Extract the Weapons Cache | `standard` | sets mission flag `FORGE_EVACUATE_01` | — |

**Design notes** Forge tile required + UK neighbor; army station required

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORGE_REINFORCE_01` — FORGE SECURED: CROWN ASSAULT PLAN ABANDONED

**Status** FIRST PASS · **Type** `forge_reinforced` · **Country** `USA` · **Tone** Rousing/Satisfying
**Chain** Forge Threat · position Branch
**Art** `forge_secure` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Continental Garrison Arrives. Crown Intelligence Reports Update to 'Heavily Fortified. Do Not.'

**Body — first draft**

> The Continental garrison has reached [TILE_NAME] and established a perimeter around the forge with the particular energy of people who know exactly what the Crown was planning and are choosing not to allow it. The lead Crown agent, according to intercept intelligence, filed a revised assessment: 'Position is no longer viable for extraction or destruction. Recommend withdrawal.' The recommendation has been accepted. The forge is operational. Production continues. The sketches are burned.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Increase Production — Forge Secured | `standard` | weapons +30 | — |

**Design notes** +weapons 30; defense path

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORGE_EVACUATE_01` — EMERGENCY EXTRACTION: WEAPONS CACHE SECURED — FORGE TEMPORARILY OUT OF SERVICE

**Status** FIRST PASS · **Type** `forge_evacuated` · **Country** `USA` · **Tone** Tense/Wry
**Chain** Forge Threat · position Branch
**Art** `forge_evac` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Weapons Made It Out. The Forge Did Not Have Time to Pack.

**Body — first draft**

> Speed was the priority. The garrison reached [TILE_NAME] and immediately began extraction of the weapons cache before Crown forces could move on the position. The extraction was fast. The forge itself sustained damage in the process — not from enemy action but from the particular violence of moving heavy manufacturing equipment at a pace it was not designed for. The weapons are secured. The forge will need time to recover. The Crown found an empty building and one very confused foreman who had not received the memo.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Extraction Report | `standard` | weapons +25 | — |

**Design notes** +weapons 25; Forge temporarily offline

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CORRUPT_001` — MAGISTRATE [COMMANDER_NAME] UNDER INVESTIGATION FOR REMARKABLE CONDUCT

**Status** FIRST PASS · **Type** `corruption_crisis` · **Country** `USA` · **Tone** Tense/Satirical
**Chain** Corruption Crisis · position Root
**Art** `corruption_crisis` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3030`, `Game Scenes and Scripts/world.gd:3043`, `Game Scenes and Scripts/world.gd:3044`

**Subhead — first draft**

> The Courthouse at [TILE_NAME] Has Been Running a Parallel Economy

**Body — first draft**

> The Office of Continental Accountability has filed a report on the magistrate at [TILE_NAME]. The report is seventy pages. The summary is two words: comprehensive fraud. The specifics include redirected tax receipts, creative reinterpretation of sentencing guidelines in exchange for what the ledger calls 'administrative appreciation,' and a livestock arrangement that involves seventeen cows that legally belong to the courthouse but are living at the magistrate's home in what the investigating officer described as 'suspicious contentment.' The courthouse is technically functioning. It is functioning for [COMMANDER_NAME]. Station your army at [TILE_NAME] to deal with this — then choose your method.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Public Trial — Remove and Make an Example | `standard` | sets mission flag `CORRUPT_TRIAL_01` | — |
| 2 | Private Deal — Negotiate a Resolution | `standard` | sets mission flag `CORRUPT_DEAL_01` | — |
| 3 | Investigate Further — No Action Yet | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when tileMoralDecay >= 50 on Courthouse tile; army station required

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CORRUPT_TRIAL_01` — MAGISTRATE REMOVED IN DISGRACE — [TILE_NAME] COURTHOUSE CLEANED

**Status** FIRST PASS · **Type** `corrupt_trial` · **Country** `USA` · **Tone** Serious/Triumphant
**Chain** Corruption Crisis · position Branch
**Art** `corrupt_trial` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Trial Lasted Four Hours. Verdict Required Three Minutes. The Cows Have Been Returned.

**Body — first draft**

> The public trial of [COMMANDER_NAME] proceeded with the particular efficiency of cases where the evidence arrives in its own wheelbarrow. The magistrate's defense was creative, occasionally coherent, and ultimately not credible to any of the seven witnesses, four ledgers, and seventeen cows that were present. Sentence has been passed. [COMMANDER_NAME] is removed from office, effective immediately. The courthouse at [TILE_NAME] has been purged of the relevant paperwork, the secondary ledger system, and whatever was happening with the back room that nobody was allowed to enter. The community has been informed. The community had already figured it out.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Verdict — Remove the Magistrate | `standard` | removes the governor | `CORRUPT_REFORM_01` |

**Leads to**

- "Accept the Verdict — Remove the Magistrate" → `CORRUPT_REFORM_01` — COURTHOUSE REFORMS UNDERWAY AT [TILE_NAME]

**Design notes** remove_governor; chains to CORRUPT_REFORM_01

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CORRUPT_REFORM_01` — COURTHOUSE REFORMS UNDERWAY AT [TILE_NAME]

**Status** FIRST PASS · **Type** `corrupt_reform` · **Country** `USA` · **Tone** Serious/Hopeful
**Chain** Corruption Crisis · position Followup
**Art** `courthouse_reform` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CORRUPT_TRIAL_01` — "Accept the Verdict — Remove the Magistrate" → <sub>(MAGISTRATE REMOVED IN DISGRACE — [TILE_NAME] COU)</sub>

**Subhead — first draft**

> Presidential Reform Committee Dismantles the Parallel Economy.

**Body — first draft**

> The President's reform committee has arrived at [TILE_NAME] and begun the work of institutional repair. The courthouse's secondary ledger system has been dismantled. The administrative protocols that enabled [COMMANDER_NAME]'s operation have been replaced with federal standards and a quarterly audit requirement. The seventeen cows have finally been assigned to their correct legal owner. The community is cautious but the ledgers mean what they say for the first time in years. The moral decay that had settled into [TILE_NAME]'s governance is being addressed methodically. It will take time. It is happening.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Implement the Reforms | `standard` | tile moral decay -50 | — |

**Design notes** tile_moral_decay_change -50

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CORRUPT_DEAL_01` — ARRANGEMENT REACHED AT [TILE_NAME]: COURTHOUSE CONTINUES OPERATING

**Status** FIRST PASS · **Type** `corrupt_deal` · **Country** `USA` · **Tone** Wry/Tense
**Chain** Corruption Crisis · position Branch
**Art** `corrupt_deal` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Details Sealed. Auditors Redirected. The Cows Remain Complicated.

**Body — first draft**

> [COMMANDER_NAME] has accepted a private arrangement with the President's office. The terms are not public. What is public is that the magistrate has agreed to redirect a portion of the administrative receipts to the Continental treasury, signed a loyalty affirmation that is notably more specific than the standard form, and delivered a formal apology that reads as though it was written by someone who understood the consequences of insufficient sincerity. The courthouse continues operations. [COMMANDER_NAME] continues in post, for now, under conditions they have been clearly informed about. The seventeen cows have been placed in administrative limbo pending final determination of ownership.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Seal the Arrangement | `standard` | gold +40 | — |

**Design notes** +gold 40; private deal path; magistrate stays

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `BORDER_001` — CANADIAN BORDER INCIDENT AT [TILE_NAME]: THE LINE IS IN QUESTION

**Status** FIRST PASS · **Type** `border_dispute` · **Country** `USA` · **Tone** Tense/Wry
**Chain** Border Dispute · position Root
**Art** `border_dispute` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3050`, `Game Scenes and Scripts/world.gd:3066`, `Game Scenes and Scripts/world.gd:3067`, `Game Scenes and Scripts/world.gd:3068`

**Subhead — first draft**

> The Map Says One Thing. The Territory Says Another. Canada Has Opinions.

**Body — first draft**

> A delegation from the Canadian colonial administration has filed a formal objection to Continental presence at [TILE_NAME], citing territorial claim documents from 1762 that nobody remembered existed. The Continental cartography office has filed a counter-citation from 1754 that also nobody remembered existed. Both documents appear genuine. Both documents draw the line in different places. There is also a third map, origin unclear, that draws the line somewhere else entirely and appears to have been produced by someone who had strong feelings about the matter but limited access to a compass. The territory at [TILE_NAME] is valuable. Choose your approach.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Assert Federal Authority — Station Army at [TILE_NAME] | `standard` | sets mission flag `BORDER_ASSERT_01` | — |
| 2 | Open a Diplomatic Channel — Accept the Negotiation | `standard` | claim → `` -1 | — |
| 3 | Survey the Territory — Document the Claim | `standard` | sets mission flag `BORDER_SURVEY_01` | — |

**Design notes** Woods/Foothills tile + CA neighbor; BTN2 claim_change -1 (diplomacy)

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `BORDER_ASSERT_01` — FEDERAL BOUNDARY MARKER PLANTED AT [TILE_NAME]: CANADA FILES OBJECTION

**Status** FIRST PASS · **Type** `border_asserted` · **Country** `USA` · **Tone** Rousing/Dry
**Chain** Border Dispute · position Branch
**Art** `border_assert` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Marker Is In. The Objection Is On File. The Marker Remains In.

**Body — first draft**

> The Continental garrison has established a clear federal presence at [TILE_NAME] and planted a boundary marker with the kind of permanence that communicates sovereign intent without requiring further explanation. The Canadian colonial administration has filed a formal diplomatic objection that is thorough, well-cited, and has been received, logged, and placed in the appropriate file. The marker is still there. The territory is established as Continental. The cartography office has updated the map. The previous map has been placed in the 'superseded' archive, where it will remain.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hold the Line — Claim Established | `standard` | claim → `` +2 | — |

**Design notes** +claim 2; garrison asserts sovereignty

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `BORDER_SURVEY_01` — SURVEY COMPLETE AT [TILE_NAME]: THE LAND HAS BEEN MEASURED AND IS OURS

**Status** FIRST PASS · **Type** `border_surveyed` · **Country** `USA` · **Tone** Serious/Dry
**Chain** Border Dispute · position Branch
**Art** `border_survey` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Affidavit Attached. Measurements Verified. Canada Has Read the Affidavit.

**Body — first draft**

> A survey team accompanied the Continental garrison to [TILE_NAME] and spent eight days establishing precise geographic coordinates for every notable feature within the disputed boundary zone. The survey was thorough. The report is comprehensive. The affidavit has been signed by three licensed surveyors and notarized by the Continental Secretary of Records. The territory has been formally and legally documented as Continental. Canada has received a copy of the survey. Their cartography office is reviewing it. This is expected to take some time.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Survey — Territory Documented | `standard` | gold +20 | — |

**Design notes** +gold 20; diplomatic survey path

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GARRISON_001` — FIELD REPORT: [TILE_NAME] GARRISON REPORTING CRITICAL SUPPLY SHORTFALL

**Status** FIRST PASS · **Type** `garrison_starving` · **Country** `USA` · **Tone** Urgent/Tense
**Chain** Garrison Hunger · position Root
**Art** `garrison_starving` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3073`, `Game Scenes and Scripts/world.gd:3081`, `Game Scenes and Scripts/world.gd:3082`

**Subhead — first draft**

> Continental Army There Has Fewer Than Fifty Men and Substantially Fewer Than Fifty Meals.

**Body — first draft**

> The garrison at [TILE_NAME] has filed an emergency supply requisition. The word 'emergency' appears eleven times in the document, which is unusual even by the standards of emergency supply requisitions. The commanding officer notes that current food reserves will sustain operations for approximately four more days before the garrison's combat effectiveness transitions from 'limited' to 'theoretical.' The army is stationed. The army is hungry. The army needs a decision now, not next week.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Emergency Supply Requisition — Spend Gold to Feed the Army | `standard` | gold -30 | — |
| 2 | Ordered Tactical Retreat — Pull Back | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when any USA army < 50 manpower; BTN1 spend -30 gold / BTN2 retreat

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CRISIS_CLAIM_001` — LEGITIMACY CRISIS: THE REPUBLIC'S CLAIM ON ITSELF IS IN QUESTION

**Status** FIRST PASS · **Type** `legitimacy_crisis` · **Country** `USA` · **Tone** Somber/Tense
**Chain** Legitimacy Crisis · position Root
**Art** `legitimacy_crisis` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3089`, `Game Scenes and Scripts/world.gd:3093`, `Game Scenes and Scripts/world.gd:3094`

**Subhead — first draft**

> Public Confidence in Federal Authority Reaches Level Analysts Describe as 'Are You Sure?'

**Body — first draft**

> The Continental polling operation — which functions mostly through tavern conversations and the content of pamphlets — has produced a finding that the President's advisors are describing as 'a number.' The number represents current public faith in federal governance and it is, to use the technical term, low. The states are restless. The governors are asking questions. The questions are polite but the politeness has the particular texture of politeness that exists in place of something more direct. The Republic's authority depends on its citizens choosing to recognize it. Right now, that choice is under negotiation.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | National Address — Rally the Republic | `standard` | claim → `` +2 | — |
| 2 | Emergency Decree — Assert Authority Directly | `standard` | claim → `` +3 | — |
| 3 | Presidential Tour — Acknowledge the Failures | `standard` | claim → `` +1 | — |

**Design notes** Fires when presidentialClaim <= -5; 3 claim_change response buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `TURNCOAT_001` — INTELLIGENCE REPORT: COMMANDER [COMMANDER_NAME] MAY BE IN CONTACT WITH THE CROWN

**Status** FIRST PASS · **Type** `turncoat_discovered` · **Country** `USA` · **Tone** Tense/Serious
**Chain** Turncoat General · position Root
**Art** `turncoat_report` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3100`, `Game Scenes and Scripts/world.gd:3111`, `Game Scenes and Scripts/world.gd:3112`

**Subhead — first draft**

> Loyalties at [TILE_NAME] Are No Longer Legible From the Outside

**Body — first draft**

> The intelligence that arrived this morning uses careful language. It describes 'communications of uncertain provenance' between [COMMANDER_NAME] and parties that the report declines to name but whose identity is implied by the word 'Crown' appearing seventeen times in the adjacent paragraphs. [COMMANDER_NAME] has not confirmed or denied. They have, however, been seen in conversation with a man who subsequently boarded a Royal Navy courier vessel, which is the kind of thing that tends to narrow interpretive options. The President has read the report. There are several possible responses.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Expose and Remove — Public Discharge | `standard` | removes the governor | — |
| 2 | Turn Them — Feed Bad Intelligence to the Crown | `standard` | sets flag `double_agent_active` | — |
| 3 | Watch and Wait — Gather More Evidence | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when any governor loyalty <= -8; remove / double-agent / watch

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `MEMORIAL_001` — [TILE_NAME] FALLS TO THE CROWN: HISTORICAL SITE UNDER OCCUPATION

**Status** FIRST PASS · **Type** `memorial_lost` · **Country** `USA` · **Tone** Somber/Tense
**Chain** Memorial Lost · position Root
**Art** `memorial_lost` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4860`

**Subhead — first draft**

> The Memorial Has a New Administrator. This Is Not Acceptable.

**Body — first draft**

> [TILE_NAME] has fallen to Crown forces. The historical site — which has stood through two sieges, one philosophical argument about its significance, and the ongoing presence of head docent Patricia Eubanks — is now under Crown administration. Crown officers have reportedly placed a guard at the entrance and issued a notice that the site is closed 'pending review of its historical accuracy.' Patricia Eubanks has described this review process using language that does not appear in the official field report. The site must be recovered. The docents cannot hold it indefinitely.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Plan the Recapture — Retake [TILE_NAME] | `standard` | sets mission flag `MEMORIAL_RESTORE_01` (own country) | — |
| 2 | Denounce the Occupation — Issue a Statement | `standard` | morale +10 | — |

**Design notes** Fires when UK captures tile with tileSpecialFeatures; set_mission_flag_own

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `MEMORIAL_RESTORE_01` — [TILE_NAME] LIBERATED: THE MEMORIAL IS OURS AGAIN

**Status** FIRST PASS · **Type** `memorial_restored` · **Country** `USA` · **Tone** Triumphant/Warm
**Chain** Memorial Lost · position Followup
**Art** `memorial_restored` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Guard Has Come Down. The Docents Have Returned. Patricia Eubanks Has Filed a Report.

**Body — first draft**

> [TILE_NAME] has been retaken. Continental forces arrived at dawn and the Crown's guard detail — which had been conducting what the Crown called 'administrative review' and Patricia Eubanks calls 'an affront to institutional memory' — has withdrawn. The flag has come down. The Continental flag has gone up. The head docent was on-site before the garrison had finished clearing the building. Her report on the state of the memorial during occupation is sixty-three pages and contains seventeen footnotes that are themselves longer than most reports. The site is restored. Morale in the territory has improved considerably.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Honor the Liberation | `standard` | morale +20 | — |

**Design notes** Fires when USA retakes the special-feature tile; +morale 20

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ELECTION_SEASON` — UALANI'S TERM IS ENDING — THE REPUBLIC MUST CHOOSE A SUCCESSOR

**Status** FIRST PASS · **Type** `election_season` · **Country** `USA` · **Tone** Serious/Satirical
**Chain** Election Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Gated on flag `!vp_declined_candidacy` — set by `VP_PRE_ELECTION`

**Subhead — first draft**

> The Vice Presidency Was Always a Campaign. The Campaign Starts Now.

**Body — first draft**

> The Continental Congress has confirmed what everyone already knew: President Carlisle's term ends at the close of this year, and the Republic needs to know who comes next. The situation is more complicated than usual, which for this Republic means: considerably more complicated than any reasonable person would plan for. King George III — who has now lost America three times but is apparently prepared to go for four — is personally funding what his advisors are calling a 'Bre-entrance referendum': a ballot initiative to rejoin the British Crown on the grounds that things have gotten quite out of hand over here and perhaps a firm royal hand would help. The proposal is polling better than it has any right to. The Liberty Coalition has until Election Day to make the case for the Republic. That case begins with a name. Whose name is it?

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Endorse the Vice President — Champion Your Running Mate | `standard` | sets flag `endorsed_vp` | — |
| 2 | Endorse the Patriot Coalition Candidate — Sons of Liberty | `standard` | sets flag `endorsed_patriot` | — |
| 3 | Endorse the Moderate Coalition Candidate — Continental Congress | `standard` | sets flag `endorsed_moderate` | — |
| 4 | Endorse the Populist Coalition Candidate — Common Cause | `standard` | sets flag `endorsed_populist` | — |
| 5 | Endorse the Radical Coalition Candidate — Free Workers Union | `standard` | sets flag `endorsed_radical` | — |

**Design notes** Fires once turns 93-95; presents 5 faction endorsement buttons; ELECTION_BTN1 gated by !vp_declined_candidacy

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `STUMP_SPEECH_01` — PRESIDENT CARLISLE TAKES THE FLOOR AT [TILE_NAME] — THE CAMPAIGN IS HERE

**Status** FIRST PASS · **Type** `stump_speech` · **Country** `USA` · **Tone** Rousing/Satirical
**Chain** Election Arc · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3949`, `Game Scenes and Scripts/world.gd:3961`, `Game Scenes and Scripts/world.gd:3962`

**Subhead — first draft**

> George III Has Pamphlets. The President Has a Voice.

**Body — first draft**

> President Carlisle did not schedule this stop. She added it three days ago, told the advance team at six in the morning, and arrived with her army and no prepared remarks, which is how the locals knew this was not a standard presidential visit. The [TILE_NAME] courthouse has hosted a great number of important events. None of them have been quite like this. Outside, George III's Bre-entrance literature is papering every available surface. Inside, the President has the floor. The question is whether she uses it to give a speech or something considerably more persuasive.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Give the Stump Speech | `standard` | election pressure +15 | — |
| 2 | The Full Presidential Address | `explicit` | election pressure +25 | — |

**Leads to**

- scene nav: "intimate" → `STUMP_SPEECH_01_INTIMATE` — PRESIDENT CARLISLE TAKES THE FLOOR AT [TILE_NAME] — ... — BY MORNING

**Design notes** Ualani at Courthouse turns 90-100; BTN1 +15 pressure / BTN2 explicit +25 pressure

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ELECTION_NIGHT_WIN` — THE REPUBLIC ENDURES: UALANI'S COALITION CARRIES THE ELECTION

**Status** FIRST PASS · **Type** `election_night_win` · **Country** `USA` · **Tone** Triumphant/Warm
**Chain** Election Arc · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3992`

**Subhead — first draft**

> America Voted. America Got It Right. Ualani Is Cautiously Pleased.

**Body — first draft**

> The returns came in over several hours that the President spent in the situation room eating a bowl of cereal and reading intelligence reports because she was constitutionally incapable of just watching. When the final numbers cleared, her press secretary knocked on the door and read the tally. The Liberty Coalition has won. The Republic continues. George III's Bre-entrance referendum has been defeated — decisively, in some districts, embarrassingly in others. The King's reaction was not made public but was described by a Crown correspondent as 'the fourth time he has made this particular face.' Ualani Carlisle's chosen successor is the next President of the Continental Republic. The transition of power will be orderly. The Republic is, against considerable odds and sustained effort, still here.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The Republic Stands | `standard` | morale +50 | — |

**Design notes** End-game WIN; fires when sum(electionPressure) > 0 at turn 100

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ELECTION_NIGHT_LOSE` — WELL. THIS IS SOMETHING: KING GEORGE III WINS THE AMERICAN POPULAR VOTE

**Status** FIRST PASS · **Type** `election_night_lose` · **Country** `USA` · **Tone** Somber/Satirical
**Chain** Election Arc · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3995`

**Subhead — first draft**

> Long Live King George III Again? This Is All So Confusing.

**Body — first draft**

> The returns were clear by midnight. The Bre-entrance referendum has passed. George III's campaign — which ran on the platform of 'you tried it without us and look how that went' — has carried enough of the electoral map to claim a mandate. The Continental Congress is in emergency session. The Liberty Coalition is filing seventeen separate procedural challenges. Ualani Carlisle is in the situation room staring at a cereal bowl she forgot to eat and a stack of intelligence reports that are now, technically, addressed to the wrong government. Her press secretary knocked on the door, read her the numbers, and then waited. The President's exact words have been classified under executive privilege. What can be confirmed: she said them very quietly and they were extremely accurate.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Well. Okay Then. | `standard` | _no mechanical effect_ | — |

**Design notes** End-game LOSE; fires when sum(electionPressure) ≤ 0 at turn 100

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `HARVEST_VISIT_01_INTIMATE` — PRESIDENT CARLISLE SAVES THE HARVEST — BY MORNING

**Status** IDEA · **Type** `harvest_resolution` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Harvest Crisis · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `HARVEST_VISIT_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE SAVES THE HARVEST)</sub>

**Subhead — first draft**

> Farmers Report She Was 'Unexpectedly Effective in a Corn Emergency'

**Body — first draft**

> [INTIMATE STUB — HARVEST_VISIT_01] Field event intimate version: PRESIDENT CARLISLE SAVES THE HARVEST. Write the quieter version: what the relationship looks like away from headquarters, in the field, with something at stake. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of HARVEST_VISIT_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `STUMP_SPEECH_01_INTIMATE` — PRESIDENT CARLISLE TAKES THE FLOOR AT [TILE_NAME] — ... — BY MORNING

**Status** IDEA · **Type** `stump_speech` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Election Arc · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `STUMP_SPEECH_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE TAKES THE FLOOR AT [TILE_NAME)</sub>

**Subhead — first draft**

> George III Has Pamphlets. The President Has a Voice.

**Body — first draft**

> [INTIMATE STUB — STUMP_SPEECH_01] Campaign trail intimate scene, 'By morning' version. Write: what happens after the rally, in the quiet. The exhaustion and the adrenaline and the specific intimacy of people who share a cause. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of STUMP_SPEECH_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
