# Protector

64 events · FIRST PASS 53 · FULL COMPLETION 11

[← back to index](00_INDEX.md)

---

### `PROT_01_SUMMON` — MOTHMAN APPROACHES — THESE WOODS‚ THESE HILLS

**Status** FULL COMPLETION · **Type** `protector_summon` · **Country** `USA` · **Tone** Tender/Supernatural
**Chain** Mothman · position Root
**Art** `mothman_approach` (Integrated) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Protector Summon** — protector `PROT_01` · priority 1  <sub>`TRIG_014`</sub>

**Subhead — first draft**

> He Was Here Before Any of This. He Will Outlast All of It.

**Body — first draft**

> West Virginia. These woods. These hills. They have been wrong for a long time — wrong since before the revolution‚ wrong since the last president stripped the life from the country for personal gain and left the grief to settle into the soil. The Mothman felt all of it. He was here before them. He will outlast them. Anger grew in him from seeds spread by loss. He stopped being a warning and became the wound itself. Until Ualani arrived. She was different — not a Democrat‚ not a Republican‚ not someone promising something intangible. She came to the foothills and she listened. For hours‚ she listened to the Mothman. The lonely creature from the hills — finally‚ someone to hear him. She spent an evening in his cave learning the philosophies of a citizen-monster. She left before he woke. He slept in for the first time in centuries.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Make Eye Contact | `standard` | fires **PROT_01_TAME** immediately | `PROT_01_TAME` |
| 2 | Hold Your Ground | `standard` | fires **PROT_01_TAME** immediately | `PROT_01_TAME` |

**Leads to**

- "Make Eye Contact" fires `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS
- "Hold Your Ground" fires `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 10+; kinky_lewd gated. Ualani listens for hours in the foothills; leaves before dawn.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS

**Status** FULL COMPLETION · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Warm
**Chain** Mothman · position Branch
**Art** `prot_01_tame_scene` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_01_SUMMON` — "Make Eye Contact" fires <sub>(MOTHMAN APPROACHES — THESE WOODS‚ THESE HILLS)</sub>
- Chained from `PROT_01_SUMMON` — "Hold Your Ground" fires <sub>(MOTHMAN APPROACHES — THESE WOODS‚ THESE HILLS)</sub>

**Subhead — first draft**

> It Stopped Haunting. It Is Still Watching. These Are Different Things.

**Body — first draft**

> The Department of Mythological Affairs field team submitted a three-page report on the situation at Harper's Ferry. The summary paragraph reads as follows: Mothman has ceased indiscriminate haunting. The creature attended the initial contact with what the lead agent describes as profound focused attention and departed to a ridge position that is technically not haunting anything within a twelve-mile radius. The surveillance continues. The disruption does not. President Carlisle left before dawn. The Mothman slept until noon. The DMA agent on site noted this was‚ by all available evidence‚ the first time the creature had slept past sunrise in at least two hundred years. The department is calling this success and is actively choosing not to examine the exact nature of the interaction that produced it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_01_tame` | `PROT_01_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_01_tame` | `PROT_01_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_01_AGREE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_01_AGREE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_01_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_01_AGREE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Status** FULL COMPLETION · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Intimate
**Chain** Mothman · position Followup
**Art** `prot_01_agree` (Integrated) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_01_TAME` — "Acknowledge the Deescalation" → <sub>(MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS)</sub>
- Chained from `PROT_01_TAME` — "File the Departmental Report — What Comes Next" → <sub>(MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS)</sub>

**Subhead — first draft**

> The Agreement Required No Words. The Words Came Anyway.

**Body — first draft**

> President Carlisle went to Harper's Ferry alone. Her security detail was told to stay and did not listen and was subsequently convinced to stay by a look from both the President and the creature that the senior agent described as 'a rethinking of my entire professional situation.' The meeting on the ridge was not recorded. What is recorded is what followed: Mothman, which had been causing generalized supernatural disruption across the eastern highland corridor, has realigned entirely to Continental interests. The Department of Mythological Affairs has filed the paperwork. The paperwork required a new category.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Alliance | `standard` | sets flag `prot_01_agreed` | — |
| 2 | The Complete Accord at Harper's Ferry | `kinky_lewd` | sets flag `prot_01_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_01_AGREE_INTIMATE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Design notes** Sets prot_01_agreed; BTN2 kinky_lewd gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_02_SUMMON` — JERSEY DEVIL EMERGES FROM THE PINE BARRENS

**Status** FULL COMPLETION · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Jersey Devil · position Root
**Art** `jersey_devil` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_02` · priority 1  <sub>`TRIG_018`</sub>

**Subhead — first draft**

> Something Deeply Unusual Has Endorsed the Revolution

**Body — first draft**

> A creature — hooves, wings, a screech that rattles teeth — has been conducting what witnesses describe as aggressive reconnaissance along Crown supply lines in New Jersey. The Department of Mythological Affairs filed a report. The report said: confirmed. The Governor of New Jersey was asked to comment. He said only 'yeah.' New Jersey knows. New Jersey has always known.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hold Your Position | `standard` | fires **PROT_02_TAME** immediately | `PROT_02_TAME` |
| 2 | Observe and Document | `standard` | fires **PROT_02_TAME** immediately | `PROT_02_TAME` |

**Leads to**

- "Hold Your Position" fires `PROT_02_TAME` — JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — PINE BARRENS ACCORD
- "Observe and Document" fires `PROT_02_TAME` — JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — PINE BARRENS ACCORD

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 15+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_02_TAME` — JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — PINE BARRENS ACCORD

**Status** FULL COMPLETION · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Jersey Devil · position Branch
**Art** `prot_02_tame` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_02_SUMMON` — "Hold Your Position" fires <sub>(JERSEY DEVIL EMERGES FROM THE PINE BARRENS)</sub>
- Chained from `PROT_02_SUMMON` — "Observe and Document" fires <sub>(JERSEY DEVIL EMERGES FROM THE PINE BARRENS)</sub>

**Subhead — first draft**

> The Wagons Are Getting Through. The Devil Is Still There. It's Fine.

**Body — first draft**

> New Jersey's most reliable supernatural problem had been operating with comprehensive indifference to the political sympathies of the wagons it destroyed. The DMA field team, through a combination of persistence and what their report calls 'non-hostile presence in the creature's territory over multiple consecutive nights,' has achieved a working arrangement. The Jersey Devil has agreed — through a process that did not involve written documents and which the lead agent has declined to describe in detail — to restrict operations to Crown-affiliated convoys. The Continental seal on the wagon matters, the agent reports. The seal is working.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_02_tame` | `PROT_02_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_02_tame` | `PROT_02_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_02_AGREE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE
- "File the Departmental Report — What Comes Next" → `PROT_02_AGREE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE

**Design notes** Sets prot_02_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_02_AGREE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Quirky/Triumphant
**Chain** Jersey Devil · position Followup
**Art** `prot_02_agree` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_02_TAME` — "Acknowledge the Deescalation" → <sub>(JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — P)</sub>
- Chained from `PROT_02_TAME` — "File the Departmental Report — What Comes Next" → <sub>(JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — P)</sub>

**Subhead — first draft**

> New Jersey's Most Complicated Asset Has Chosen a Side.

**Body — first draft**

> President Carlisle drove to the Pine Barrens edge after dark without her security detail, which her chief of staff has noted in his personal log as 'the second time this week she's done something I wasn't told about.' She returned several hours later. What she said to the Jersey Devil, and what it communicated back, has not been included in the official record. What IS in the record: Crown supply convoys in New Jersey now experience what their logistics office describes as 'selective and targeted interference' with a consistency that suggests coordination rather than random destruction. No Continental convoy has been disrupted since the meeting.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept New Jersey's Commitment | `standard` | sets flag `prot_02_agreed` | — |
| 2 | The Full Pine Barrens Meeting | `explicit` | sets flag `prot_02_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_02_AGREE_INTIMATE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE — BY MORNING

**Design notes** Sets prot_02_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_SUMMON` — WOOD BOOGER SIDES WITH THE REVOLUTION

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Bigfoot · position Root
**Art** `bigfoot` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_03` · priority 1  <sub>`TRIG_019`</sub>

**Subhead — first draft**

> He Does Not Give Press Conferences. He Does Not Need To.

**Body — first draft**

> Enormous footprints have been documented across eleven Appalachian counties, each trail running directly to Crown fortifications and ending there — no egress, no camp evidence, no tracks out. Continental intelligence has confirmed tactical purpose: supply line disruptions, overnight material losses, and what field reports are calling 'methodical harassment of Redcoat encampments with extreme prejudice' across the Blue Ridge corridor. Four Crown companies submitted formal noise complaints about nighttime woodland disturbances. The forms were processed. Nothing was dispatched. The Department of Mythological Affairs has reached its assessment: Wood Booger has chosen a side. Direct communication is not advised and is almost certainly not possible. The creature's operational methods are not fully legible to Continental command, which the DMA classifies as both an asset and a complication. Its motives are unknown. Its terms are unclear. It may not have terms. The Republic is grateful regardless.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Approach Without Weapons | `standard` | fires **PROT_03_TAME** immediately | `PROT_03_TAME` |
| 2 | Leave Provisions at the Clearing | `standard` | fires **PROT_03_TAME** immediately | `PROT_03_TAME` |

**Leads to**

- "Approach Without Weapons" fires `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: WOOD BOOGER ACKNOWLEDGES THE REPUBLIC
- "Leave Provisions at the Clearing" fires `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: WOOD BOOGER ACKNOWLEDGES THE REPUBLIC

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 20+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: WOOD BOOGER ACKNOWLEDGES THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quiet/Warm
**Chain** Bigfoot · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_SUMMON` — "Approach Without Weapons" fires <sub>(WOOD BOOGER SIDES WITH THE REVOLUTION)</sub>
- Chained from `PROT_03_SUMMON` — "Leave Provisions at the Clearing" fires <sub>(WOOD BOOGER SIDES WITH THE REVOLUTION)</sub>

**Subhead — first draft**

> The Mountain Wasn't His Problem. Now It Isn't Our Problem.

**Body — first draft**

> The Appalachian highlands had been experiencing what military dispatches diplomatically call 'unexpected personnel deterrence events' — which is how the Continental Army describes soldiers refusing to pass through mountain corridors because something very large is watching them from the ridgeline. The DMA field team established sustained presence in the affected region, approached without weapons, and left provisions at the clearing the creature regarded as a meeting location. Three visits later, Wood Booger crossed the clearing and stood still for forty seconds. The agents report this as 'communication.' The mountain passes are open.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_03_tame` | `PROT_03_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_03_tame` | `PROT_03_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_03_AGREE` — WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS
- "File the Departmental Report — What Comes Next" → `PROT_03_AGREE` — WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS

**Design notes** Sets prot_03_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_AGREE` — WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Quiet/Triumphant
**Chain** Bigfoot · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_TAME` — "Acknowledge the Deescalation" → <sub>(APPALACHIAN PASSES REOPEN: WOOD BOOGER ACKNOWLED)</sub>
- Chained from `PROT_03_TAME` — "File the Departmental Report — What Comes Next" → <sub>(APPALACHIAN PASSES REOPEN: WOOD BOOGER ACKNOWLED)</sub>

**Subhead — first draft**

> He Doesn't Speak. He Moves. That Is Communication.

**Body — first draft**

> President Carlisle went to the Appalachian clearing alone and sat down. After twenty minutes, the clearing was no longer empty. She sat with the creature for an hour in silence. Neither party required words. Continental forces since that meeting report that mountain routes previously described as difficult and hostile are now navigated with a confidence their officers attribute to 'a general sense that the terrain is cooperative.' Three scouting units reported arranged rocks and disturbed paths pointing the correct direction that they followed to significant tactical advantage. Wood Booger has not been seen again. The signs have not stopped appearing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Wood Booger's Guidance Through the Mountains | `standard` | sets flag `prot_03_agreed` | — |
| 2 | The Full Mountain Agreement | `explicit` | sets flag `prot_03_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_03_AGREE_INTIMATE` — WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE WOODS — BY MORNING

**Design notes** Sets prot_03_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_SUMMON` — PAMOLA STIRS ABOVE KATAHDIN

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Thunderbird · position Root
**Art** `pamola` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_04` · priority 1  <sub>`TRIG_020`</sub>

**Subhead — first draft**

> The Storm Spirit of the Abenaki Has Not Been Forgotten

**Body — first draft**

> Something moves above Mount Katahdin. The Penobscot communities near Millinocket have been saying for weeks that the mountain is restless — that Pamola, the storm spirit, is awake and circling. Two Crown signal outposts along the Acadia coast were destroyed in what the meteorological report classifies as 'localized storm events of unusual character.' The Department of Mythological Affairs has a more specific classification. The classification is: extremely large winged entity with the head of a moose and opinions about Crown presence in Maine.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Request Indigenous Liaison | `standard` | fires **PROT_04_TAME** immediately | `PROT_04_TAME` |
| 2 | Signal a Ceremonial Approach | `standard` | fires **PROT_04_TAME** immediately | `PROT_04_TAME` |

**Leads to**

- "Request Indigenous Liaison" fires `PROT_04_TAME` — PAMOLA WITHDRAWS — STORM ACTIVITY OVER ACADIA NORMALIZES
- "Signal a Ceremonial Approach" fires `PROT_04_TAME` — PAMOLA WITHDRAWS — STORM ACTIVITY OVER ACADIA NORMALIZES

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 25+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_TAME` — PAMOLA WITHDRAWS — STORM ACTIVITY OVER ACADIA NORMALIZES

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Thunderbird · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_SUMMON` — "Request Indigenous Liaison" fires <sub>(PAMOLA STIRS ABOVE KATAHDIN)</sub>
- Chained from `PROT_04_SUMMON` — "Signal a Ceremonial Approach" fires <sub>(PAMOLA STIRS ABOVE KATAHDIN)</sub>

**Subhead — first draft**

> The Mountain Has Calmed. The Spirit Has Not Left It.

**Body — first draft**

> Pamola had been disrupting both Continental and Crown operations along the Maine coast with equal indifference — its storms don't distinguish between flags. The DMA's ceremonial approach, coordinated with Penobscot Nation liaisons who had been offering this methodology since the beginning, produced immediate results. What was required was acknowledgment: Pamola controls these skies and has always controlled them, and the ceremony said so correctly. The storms along the Acadia corridor have subsided. Pamola still circles Katahdin. It is simply circling with what the meteorological team describes as 'directional intent.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_04_tame` | `PROT_04_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_04_tame` | `PROT_04_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_04_AGREE` — PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_04_AGREE` — PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_04_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_AGREE` — PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Epic/Rousing
**Chain** Thunderbird · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_TAME` — "Acknowledge the Deescalation" → <sub>(PAMOLA WITHDRAWS — STORM ACTIVITY OVER ACADIA NO)</sub>
- Chained from `PROT_04_TAME` — "File the Departmental Report — What Comes Next" → <sub>(PAMOLA WITHDRAWS — STORM ACTIVITY OVER ACADIA NO)</sub>

**Subhead — first draft**

> The Mountain Has Made a Decision. Crown Forces Along the Maine Coast Will Not Enjoy It.

**Body — first draft**

> The formal agreement with Pamola was reached through the Penobscot Nation liaison council at a ceremony on the shore of Millinocket Lake, with Katahdin visible in the northern sky. President Carlisle attended without her staff, at the council's request. She was asked to look at the mountain and state what she understood about it. She looked for a long time. What she said was not recorded. The council confirmed it was sufficient. Pamola has since directed its storms exclusively toward Crown signal positions along the Maine coast and the Acadia approaches. The meteorological data shows a pattern that the Crown weather office describes as 'inexplicable.' The Penobscot Nation describes it as expected.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Pamola's Alignment | `standard` | sets flag `prot_04_agreed` | — |
| 2 | The Full Ceremonial Alliance | `explicit` | sets flag `prot_04_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_04_AGREE_INTIMATE` — PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Design notes** Sets prot_04_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_05_SUMMON` — THE HORSEMAN RIDES AGAIN

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Headless Horseman · position Root
**Art** `headless_horseman` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_05` · priority 1  <sub>`TRIG_021`</sub>

**Subhead — first draft**

> Sleepy Hollow Reports Extremely On-Brand Development

**Body — first draft**

> A rider with no head — which is notably inconvenient from a military intelligence standpoint but apparently no impediment to aggressive cavalry engagement — has been conducting raids against Crown couriers in the Hudson Valley. The locals are not alarmed. She comes around every generation, said a woman in Tarrytown handing the field reporter a cup of cider. Doesn't like British people. Classic. The Department of Mythological Affairs is filing this one under R for Refreshingly Familiar.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Present Continental Credentials | `standard` | fires **PROT_05_TAME** immediately | `PROT_05_TAME` |
| 2 | Stand in the Road | `standard` | fires **PROT_05_TAME** immediately | `PROT_05_TAME` |

**Leads to**

- "Present Continental Credentials" fires `PROT_05_TAME` — THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — CONTINENTAL COURIERS SAFE
- "Stand in the Road" fires `PROT_05_TAME` — THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — CONTINENTAL COURIERS SAFE

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 30+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_05_TAME` — THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — CONTINENTAL COURIERS SAFE

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Dry
**Chain** Headless Horseman · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_05_SUMMON` — "Present Continental Credentials" fires <sub>(THE HORSEMAN RIDES AGAIN)</sub>
- Chained from `PROT_05_SUMMON` — "Stand in the Road" fires <sub>(THE HORSEMAN RIDES AGAIN)</sub>

**Subhead — first draft**

> The Head Was Not the Problem. The Targeting Was the Problem.

**Body — first draft**

> Continental couriers in the Hudson Valley had been experiencing the same disruption as Crown couriers, which was technically impressive but logistically catastrophic. The DMA's approach involved a protocol the lead agent describes as 'we showed him a list and he seemed to understand lists.' The list contained Crown courier identification markers. The Horseman reviewed it. Three Crown couriers that week confirmed that the following week featured significantly higher levels of inexplicable mounting accidents than the previous one. No Continental couriers were involved. The protocol is working.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_05_tame` | `PROT_05_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_05_tame` | `PROT_05_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_05_AGREE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY
- "File the Departmental Report — What Comes Next" → `PROT_05_AGREE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY

**Design notes** Sets prot_05_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_05_AGREE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Headless Horseman · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_05_TAME` — "Acknowledge the Deescalation" → <sub>(THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — )</sub>
- Chained from `PROT_05_TAME` — "File the Departmental Report — What Comes Next" → <sub>(THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — )</sub>

**Subhead — first draft**

> He Was Always Going to Choose a Side. She Just Had to Ask.

**Body — first draft**

> President Carlisle found the Headless Horseman in the Hudson Valley before midnight on a night when neither was expected to be there. She stood in the road and he stopped. The exchange was brief — her words, his silence, and a single gesture that her aide (who was there despite explicit instructions) describes as 'the kind of nod that means something specific and permanent.' The Horseman has since operated with perfect Crown courier interdiction. Not a single Continental messenger in the Hudson Valley has been impeded. The Crown's courier casualty rate in the corridor has reached what their dispatches call 'an unsustainable operational situation.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Horseman's Declaration | `standard` | sets flag `prot_05_agreed` | — |
| 2 | The Full Hudson Valley Accord | `explicit` | sets flag `prot_05_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_05_AGREE_INTIMATE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY — BY MORNING

**Design notes** Sets prot_05_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_SUMMON` — NO BILLY GOAT I'VE SEEN

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Ominous
**Chain** Chessie · position Root
**Art** `goatman_summon` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_06` · priority 1  <sub>`TRIG_022`</sub>

**Subhead — first draft**

> A Maryland Legend Has Been Active. The DMA Sent Two Agents to Investigate. They Are Now Missing.

**Body — first draft**

> Long have Maryland's young lovers and night-wandering citizens been keenly aware of one standing danger: the Goatman. The creature has stalked the state's suburban parkways and forest corridors for as long as records exist — and several records that no longer exist, which is also suspicious. Its attacks have increased since the start of the war, with considerably less discretion applied to target selection. The DMA dispatched two field agents to investigate, agents long rumored within the department to harbor feelings for each other. They set up a stakeout near a known Goatman corridor in Prince George's County. Only their binoculars were recovered. They were still warm. All signs point to a deeply territorial spirit operating at an intensity that will make diplomatic contact extraordinarily difficult. Develop Maryland's libraries and barracks to demonstrate the Republic's civilizational commitment — perhaps something beyond brute force can reach it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Send DMA Field Team — Investigate the Parkway Reports | `standard` | sets flag `prot_06_summoned` | — |
| 2 | Classify the Incident — No Comment from This Office | `standard` | sets flag `prot_06_summoned` | — |

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 35+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_TAME` — GOATMAN: CONSEQUENCES

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Chessie · position Branch
**Art** `goatman_tame` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Missing College Students. Missing Agents. Missing People. Not Anymore.

**Body — first draft**

> Missing college students. Missing DMA agents. Missing people in general, which the state of Maryland had absorbed with diminishing patience for a generation. 'A monster is a monster' was the official DMA operating principle before Ualani arrived. The cost of coexisting with the Republic's mythic creatures had always been measured in citizens and quietly closed case files. That policy has been formally retired. Ualani set the trap herself: two volunteer DMA agents positioned at a known Goatman approach, operating under heavy surveillance, performing their role with what the field observers logged as 'considerable commitment to the mission.' The Goatman arrived. It found something it did not expect. Ualani and twelve armed DMA agents emerged from the treeline. The Goatman was surrounded before it had time to reconsider. Terms were discussed. Promises were made. Peace in Maryland is now a condition of the creature's continued operation. Develop Maryland's total building output to demonstrate the Republic's industrial seriousness.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Peace Agreement | `standard` | sets flag `prot_06_tame` | — |
| 2 | Acknowledge Terms — Peace in Maryland | `standard` | sets flag `prot_06_tame` | — |

**Design notes** Sets prot_06_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_AGREE` — MIDNIGHT MEETING — THE TERMS OF THE DEAL

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Warm
**Chain** Chessie · position Followup
**Art** `goatman` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> It Was the Old Overlook. Everyone in Prince George's County Knows That Spot.

**Body — first draft**

> Ualani was driven to a highway overlook at 2:14 in the morning by her most trusted protective service agent. No duty log was filed. No security detail followed. The site — a well-worn makeout point for several generations of Prince George's County residents — was chosen entirely for its privacy. She exited the vehicle without a weapon. The Goatman appeared within three minutes, which suggests it had been waiting. The two stood in the dark beneath a crescent moon and reaffirmed the terms of the arrangement. The Goatman is territorial. Peace in Maryland costs the Republic nothing but acknowledgment, and the acknowledgment had now been given in person. [CMD_POSSESSIVE] protective service agent remained in the vehicle. Some agreements require witnesses. Some do not. Both of them understood which kind this was.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | A monster turned ally. Continue. | `standard` | sets flag `prot_06_agreed` | — |
| 2 | Perform the duties of peace. | `explicit` | fires **PROT_06_AGREE_INTIMATE** immediately | `PROT_06_AGREE_INTIMATE` |

**Leads to**

- "Perform the duties of peace." fires `PROT_06_AGREE_INTIMATE` — VOYEUR‚ NOT MONSTER
- scene nav: "intimate" → `PROT_06_AGREE_INTIMATE` — VOYEUR‚ NOT MONSTER

**Design notes** Sets prot_06_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_SUMMON` — THE BELL WITCH MANIFESTS IN TENNESSEE

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Bell Witch · position Root
**Art** `bell_witch_summon` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_07` · priority 1  <sub>`TRIG_023`</sub>

**Subhead — first draft**

> Crown Forces in the Southern Theater Reporting Morale Issues

**Body — first draft**

> Soldiers stationed in the Tennessee highlands are filing complaints. The complaints describe: voices in empty rooms, unexplained bruising, complete inability to sleep, and food that tastes wrong in a way we cannot explain. The Bell Witch is not cooperative, the Secretary noted. She operates independently, with opinions about what kind of civilization deserves her protection. Develop Tennessee's farms, libraries, theaters, and cultural institutions — reach a combined cultural and agricultural score of 25 and she will notice. She already has opinions. Give her something worth protecting and she will express them to the correct people.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Contact Local Spiritual Practitioners | `standard` | sets flag `prot_07_summoned` | — |
| 2 | Announce Your Purpose Plainly | `standard` | sets flag `prot_07_summoned` | — |

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 40+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_TAME` — THE HAUNTING OF BELL HOUSE

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Bell Witch · position Branch
**Art** `bell_witch_tame` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Adams Farmhouse Lights Were On All Night. Crown Positions Were Not That Lucky.

**Body — first draft**

> Tennessee's farms are producing. The theaters are full. The libraries have books in them and people reading the books, which the Bell Witch considers the minimum requirement for a civilization worth haunting on behalf of. The Adams farmhouse — the original site of her operations, the one she considers home in whatever sense a witch considers anything home — lit up at midnight. Every candle in every window. By morning, three Crown encampments in the Tennessee highlands reported complete operational disruption. Continental encampments did not. The DMA has classified this as voluntary redirection of supernatural assets. She did not ask for a meeting. She simply decided Tennessee had earned it. The next objective is forty: double down on what you've built and she'll make the commitment official.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_07_tame` | — |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_07_tame` | — |

**Design notes** Sets prot_07_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_AGREE` — JINGLE BELLS‚ KING GEORGE SMELLS

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Rousing
**Chain** Bell Witch · position Followup
**Art** `bell_witch` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> She Didn't Have a Lot of Notes. She Had One Note. She Played It Loudly.

**Body — first draft**

> Tennessee's cultural and agricultural development has reached a threshold the Bell Witch considers personally significant. Her official position statement‚ delivered at 3 in the morning via unexplained singing audible throughout Adams township‚ reduced — after the DMA transcriptionist removed the verses deemed unsuitable for official correspondence — to the following: King George smells. The war is ours. She requested one thing in exchange for full commitment: someone willing to drive to Adams and listen to everything she had to say about how this should have been handled‚ from the beginning‚ without interrupting. Ualani drove there herself. The Bell Witch talked for four hours. The President listened. The agreement was reached in the final twenty minutes. The Witch then produced a gift from a velvet case that smelled of Tennessee cedar. The DMA field report‚ filed by an agent stationed outside‚ describes it only as 'a significant supernatural asset of non-standard configuration.' The spell Bell Witch's Gift has been added to the Presidential Registry.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The meeting is enough | `standard` | sets flag `prot_07_agreed` | — |
| 2 | Lead the way | `explicit` | fires **PROT_07_AGREE_INTIMATE** immediately | `PROT_07_AGREE_INTIMATE` |

**Leads to**

- "Lead the way" fires `PROT_07_AGREE_INTIMATE` — BELL AND THE BEAST
- scene nav: "intimate" → `PROT_07_AGREE_INTIMATE` — BELL AND THE BEAST

**Design notes** Sets prot_07_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_SUMMON` — Old Ironsides Spotted Roving the Coastal Waters

**Status** FULL COMPLETION · **Type** `protector_summon` · **Country** `USA` · **Tone** Epic/Supernatural
**Chain** Old Ironsides · position Root
**Art** `old_ironsides` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_08` · priority 1  <sub>`TRIG_024`</sub>

**Subhead — first draft**

> Our Agents Are Asking For Presidential Permission to Treat It as a Protector

**Body — first draft**

> Our DMA Agents in the field report the USS Constitution, a two hundred year old navy ship from George Washington’s day, has been spotted sailing the New England coast. While these sightings explain where the ship ended up after disappearing decades ago, they don’t explain how the vessel appears to be sailing itself. Thermal scans reveal no crew, passengers, or captain. Our agents are certain the ship is an American Protector lashing out over a major grievance and are asking for the President’s permission to treat the warship as such.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hail Using Original Flag Codes | `standard` | fires **PROT_08_TAME** immediately | `PROT_08_TAME` |
| 2 | Send a Port Authority Team | `standard` | fires **PROT_08_TAME** immediately | `PROT_08_TAME` |

**Leads to**

- "Hail Using Original Flag Codes" fires `PROT_08_TAME` — President Ualani Meets With Old Ironsides
- "Send a Port Authority Team" fires `PROT_08_TAME` — President Ualani Meets With Old Ironsides

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 45+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_TAME` — President Ualani Meets With Old Ironsides

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Epic/Dry
**Chain** Old Ironsides · position Branch
**Art** `prot_08_tame` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- **Protector Tame** — protector `PROT_08` · priority 1  <sub>`TRIG_085`</sub>
- Chained from `PROT_08_SUMMON` — "Hail Using Original Flag Codes" fires <sub>(Old Ironsides Spotted Roving the Coastal Waters)</sub>
- Chained from `PROT_08_SUMMON` — "Send a Port Authority Team" fires <sub>(Old Ironsides Spotted Roving the Coastal Waters)</sub>

**Subhead — first draft**

> The Meeting Between the Nation’s Leader and Its Oldest Warship Lasted Around Two Hours

**Body — first draft**

> Immediately after DMA agents performed a sweep of the USS Constitution, President Carlisle boated up to the ship in a dinghy paddled by her own strength. The meeting between the nation’s leader and its oldest warship lasted around two hours. While DMA agents on shore were able to maintain visual contact throughout, a powerful fog appeared from nowhere and consumed both the President and Old Ironsides for just over a minute. When agents regained line of sight, the President was paddling back to shore. Agents noted she smelled of perfume and lotions and when asked where the fragrances came from, she claimed the vessel had treated her well. Agents are still trying to decipher the meaning of that.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_08_tame` | `PROT_08_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_08_tame` | `PROT_08_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_08_AGREE` — President Ualani Sets Sail
- "File the Departmental Report — What Comes Next" → `PROT_08_AGREE` — President Ualani Sets Sail

**Design notes** Sets prot_08_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_AGREE` — President Ualani Sets Sail

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Epic/Triumphant
**Chain** Old Ironsides · position Followup
**Art** `prot_08_agree` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- **Protector Agree** — protector `PROT_08` · priority 1  <sub>`TRIG_086`</sub>
- Chained from `PROT_08_TAME` — "Acknowledge the Deescalation" → <sub>(President Ualani Meets With Old Ironsides)</sub>
- Chained from `PROT_08_TAME` — "File the Departmental Report — What Comes Next" → <sub>(President Ualani Meets With Old Ironsides)</sub>

**Subhead — first draft**

> Agents Rushed Into the Water When the President Climbed Aboard the Unmanned Warship

**Body — first draft**

> Agents rushed into the water today when President Ualani, while on her dinghy communicating with Old Ironsides, suddenly climbed aboard the warship and was near instantly whisked away. The ship caught air and disappeared with the president for nearly three hours. Agents finally found the president two states over and when asked where she’d been, she just smiled. The Constitution has formally joined the Continental Navy.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Commission Old Ironsides | `standard` | sets flag `prot_08_agreed` | — |
| 2 | The Full Naval Recommissioning | `explicit` | sets flag `prot_08_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_08_AGREE_INTIMATE` — Motion of the Ocean

**Design notes** Sets prot_08_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_09_SUMMON` — THE GUARDIAN OF VALLEY FORGE STIRS

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Serious/Supernatural
**Chain** Valley Forge Guardian · position Followup
**Art** `valley_forge_guardian` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_09` · priority 1  <sub>`TRIG_025`</sub>
- Chained from `CL_001` — "Summon Liberty" fires <sub>(NYC FALLS TO THE REPUBLIC)</sub>

**Subhead — first draft**

> Washington's Winter Ground Remembers

**Body — first draft**

> The ground at Valley Forge is remembering things. The sentries report footsteps in the snow where there are no feet. The cannon fire sounds different near the old encampment — larger, somehow. Like memory has mass. The Department of Mythological Affairs believes this is Washington's army: not the General, not the man, but the army itself — the frozen and the starved and the ones who stayed. They stayed then. They are staying now.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Walk the Perimeter at Dawn | `standard` | fires **PROT_09_TAME** immediately | `PROT_09_TAME` |
| 2 | Station a Garrison — Wait | `standard` | fires **PROT_09_TAME** immediately | `PROT_09_TAME` |

**Leads to**

- "Walk the Perimeter at Dawn" fires `PROT_09_TAME` — VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WELCOMED
- "Station a Garrison — Wait" fires `PROT_09_TAME` — VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WELCOMED

**Design notes** Only fires via NYC liberation button; not staggered-turn triggered

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_09_TAME` — VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WELCOMED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Valley Forge Guardian · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_09_SUMMON` — "Walk the Perimeter at Dawn" fires <sub>(THE GUARDIAN OF VALLEY FORGE STIRS)</sub>
- Chained from `PROT_09_SUMMON` — "Station a Garrison — Wait" fires <sub>(THE GUARDIAN OF VALLEY FORGE STIRS)</sub>

**Subhead — first draft**

> The Ground Recognized Her. It Takes Time.

**Body — first draft**

> The garrison at Valley Forge had been reporting what their commanding officer called 'an atmosphere of judgment' — the sense that the ground itself was evaluating whether the present army was worthy of occupying it. The DMA recommended President Carlisle visit personally. She did, unannounced, at four in the morning in November. She walked the encampment in silence. What the Guardian communicated during those hours is not recorded. What is recorded is that when she left at dawn, every soldier in the garrison reported that the atmosphere had changed. The verdict had been reached.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_09_tame` | `PROT_09_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_09_tame` | `PROT_09_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_09_AGREE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY
- "File the Departmental Report — What Comes Next" → `PROT_09_AGREE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY

**Design notes** Sets prot_09_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_09_AGREE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Rousing
**Chain** Valley Forge Guardian · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_09_TAME` — "Acknowledge the Deescalation" → <sub>(VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WE)</sub>
- Chained from `PROT_09_TAME` — "File the Departmental Report — What Comes Next" → <sub>(VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WE)</sub>

**Subhead — first draft**

> The Ground Accepted Her Army. That Is Not a Small Thing.

**Body — first draft**

> President Carlisle spent a night at the Valley Forge encampment. She woke before dawn and walked the original perimeter of Washington's winter camp — alone, in silence, in November. The Guardian walked with her. Not metaphorically. The DMA's spiritual analyst submitted a report using the phrase 'direct and unambiguous supernatural endorsement' fourteen times. The Continental Army stationed at Valley Forge reports a change in its operational capacity that their commanding officer attributes to 'morale, or something close enough to morale that I am not pursuing the distinction further.' The ground that held Washington's army has accepted Carlisle's.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Guardian's Blessing | `standard` | sets flag `prot_09_agreed` | — |
| 2 | The Full Valley Forge Ceremony | `explicit` | sets flag `prot_09_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_09_AGREE_INTIMATE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY — BY MORNING

**Design notes** Sets prot_09_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_SUMMON` — THE SNALLYGASTER DESCENDS ON VIRGINIA

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Tense
**Chain** Snallygaster · position Root
**Art** `snallygaster` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_10` · priority 1  <sub>`TRIG_026`</sub>

**Subhead — first draft**

> Half-Reptile Half-Bird Entity Entirely Against the Crown

**Body — first draft**

> Farmers in the Virginia foothills have been locking their doors. The Snallygaster — which German immigrants brought stories of to the Shenandoah Valley, and which the mountains apparently confirmed — has returned. It has destroyed two Crown supply depots and one strategic bridge, which it appeared to resent personally. The Department of Mythological Affairs notes: Aggressive, territorial, extremely effective. Not trainable in the conventional sense. We are communicating through what we believe is mutual anti-Crown sentiment.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Establish a Feeding Station | `standard` | fires **PROT_10_TAME** immediately | `PROT_10_TAME` |
| 2 | Approach from the Supply Route | `standard` | fires **PROT_10_TAME** immediately | `PROT_10_TAME` |

**Leads to**

- "Establish a Feeding Station" fires `PROT_10_TAME` — SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUTES NOW CLEAR
- "Approach from the Supply Route" fires `PROT_10_TAME` — SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUTES NOW CLEAR

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 55+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_TAME` — SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUTES NOW CLEAR

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Wry
**Chain** Snallygaster · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_10_SUMMON` — "Establish a Feeding Station" fires <sub>(THE SNALLYGASTER DESCENDS ON VIRGINIA)</sub>
- Chained from `PROT_10_SUMMON` — "Approach from the Supply Route" fires <sub>(THE SNALLYGASTER DESCENDS ON VIRGINIA)</sub>

**Subhead — first draft**

> It Was Never Personal. It Was Just Hungry.

**Body — first draft**

> The Snallygaster's approach to Continental supply depots was, intelligence eventually determined, primarily nutritional rather than ideological — it was eating stored provisions because they were there. The DMA's solution involved establishing a designated feeding station adjacent to supply routes, stocked with provisions marked 'NOT FOR SNALLYGASTER' in Continental standard font. The Snallygaster destroyed the sign immediately and consumed the provisions. This was considered satisfactory. Supply depots since that date have not been disturbed. The feeding station requires restocking every nine days.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_10_tame` | `PROT_10_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_10_tame` | `PROT_10_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_10_AGREE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY NETWORK
- "File the Departmental Report — What Comes Next" → `PROT_10_AGREE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY NETWORK

**Design notes** Sets prot_10_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_AGREE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY NETWORK

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Quirky/Triumphant
**Chain** Snallygaster · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_10_TAME` — "Acknowledge the Deescalation" → <sub>(SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUT)</sub>
- Chained from `PROT_10_TAME` — "File the Departmental Report — What Comes Next" → <sub>(SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUT)</sub>

**Subhead — first draft**

> It Has Stopped Eating Our Supplies. It Has Started Eating Theirs.

**Body — first draft**

> The arrangement reached its formal stage when President Carlisle visited the feeding station in the Shenandoah Valley and waited. The creature arrived twenty minutes later, ate approximately four hundred pounds of provisions with efficiency, and then sat down near the President, which the field agent present describes as 'not something I had a protocol for.' The conversation — described by Carlisle as 'nonverbal but extremely clear' — produced a working relationship. Continental supply routes in the Shenandoah corridor now have zero unexplained losses. Crown supply operations in the same corridor report what their dispatches call 'persistent heavy losses from an unknown source.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Snallygaster's Protection | `standard` | sets flag `prot_10_agreed` | — |
| 2 | The Full Shenandoah Agreement | `explicit` | sets flag `prot_10_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_10_AGREE_INTIMATE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY ... — BY MORNING

**Design notes** Sets prot_10_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_SUMMON` — THE BLACK DOG OF THE HANGING HILLS

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Paul Revere · position Root
**Art** `black_dog` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_11` · priority 1  <sub>`TRIG_027`</sub>

**Subhead — first draft**

> Connecticut's Silent Omen Has Been Seen. Crown Officers Are Counting Their Encounters.

**Body — first draft**

> The Black Dog has been sighted above the Hanging Hills outside Hartford. It is small, completely black, leaves no tracks on stone or mud, and has not been heard to make a sound by any witness in three centuries of documentation. The Crown cavalry unit stationed at the Hartford approach has now encountered it twice. The DMA field agent who interviewed the survivors notes that none of them understood the significance of this until after the second encounter, which is consistently how it works. The Department of Mythological Affairs is watching the situation carefully. So is the dog.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Approach the Hanging Hills at Dawn | `standard` | fires **PROT_11_TAME** immediately | `PROT_11_TAME` |
| 2 | Observe the Sighting — Do Not Approach | `standard` | fires **PROT_11_TAME** immediately | `PROT_11_TAME` |

**Leads to**

- "Approach the Hanging Hills at Dawn" fires `PROT_11_TAME` — BLACK DOG REDIRECTED — CONTINENTAL PATROL ROUTES CLEARED
- "Observe the Sighting — Do Not Approach" fires `PROT_11_TAME` — BLACK DOG REDIRECTED — CONTINENTAL PATROL ROUTES CLEARED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 60+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_TAME` — BLACK DOG REDIRECTED — CONTINENTAL PATROL ROUTES CLEARED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Dry
**Chain** Paul Revere · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_SUMMON` — "Approach the Hanging Hills at Dawn" fires <sub>(THE BLACK DOG OF THE HANGING HILLS)</sub>
- Chained from `PROT_11_SUMMON` — "Observe the Sighting — Do Not Approach" fires <sub>(THE BLACK DOG OF THE HANGING HILLS)</sub>

**Subhead — first draft**

> The Dog Has Been Briefed. It Is No Longer Following Our Scouts.

**Body — first draft**

> Three Continental patrol units had unknowingly acquired the Black Dog's attention, which produces outcomes the DMA describes as 'omen accumulation.' The DMA's solution required neither ceremony nor negotiation. It required, as the field agent puts it, 'simply going to where the dog was and standing still until it had decided something about you.' The agent stood on the Hanging Hills trail at dawn for two hours. The dog appeared, assessed the agent, and departed in the direction of the Crown supply column to the east. Continental patrol sightings have dropped to zero. Crown sightings have increased.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_11_tame` | `PROT_11_AGREE` |
| 2 | File the Omen Report — What Comes Next | `standard` | sets flag `prot_11_tame` | `PROT_11_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_11_AGREE` — BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR THE REPUBLIC
- "File the Omen Report — What Comes Next" → `PROT_11_AGREE` — BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR THE REPUBLIC

**Design notes** Sets prot_11_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_AGREE` — BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Tense
**Chain** Paul Revere · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_TAME` — "Acknowledge the Deescalation" → <sub>(BLACK DOG REDIRECTED — CONTINENTAL PATROL ROUTES)</sub>
- Chained from `PROT_11_TAME` — "File the Omen Report — What Comes Next" → <sub>(BLACK DOG REDIRECTED — CONTINENTAL PATROL ROUTES)</sub>

**Subhead — first draft**

> It Has Always Been Watching. Now It Watches in a Useful Direction.

**Body — first draft**

> The Black Dog does not enter into agreements. It has what the DMA's omen analyst describes as 'stable territorial preferences.' President Carlisle met it at the Hanging Hills trailhead at dawn, which is when sightings historically concentrate. The dog appeared, sat down, and looked at her for an extended period. She looked back. This is the entirety of the record. What followed over the next three weeks: six Crown reconnaissance units encountered the dog in the field. The DMA omen register has recorded their subsequent outcomes in a separate file not cleared for general distribution. Connecticut is quiet. The dog is watching.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Accept the Dog's Watch | `standard` | sets flag `prot_11_agreed` | — |
| 2 | Walk the Hanging Hills — Full Protocol | `explicit` | sets flag `prot_11_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_11_AGREE_INTIMATE` — BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR T... — BY MORNING

**Design notes** Sets prot_11_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_SUMMON` — MERCY BROWN STIRS IN EXETER CHURCHYARD

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Liberty Bell · position Root
**Art** `mercy_brown` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_12` · priority 1  <sub>`TRIG_028`</sub>

**Subhead — first draft**

> Rhode Island's Reluctant Vampire Is Active Again. Crown Forces Are Reporting Unusual Fatigue.

**Body — first draft**

> Chestnut Hill Cemetery in Exeter has been reporting activity. Mercy Brown — who died of tuberculosis in 1892 and whose body was exhumed, heart burned, and ashes given to her sick brother Edwin on the instructions of Exeter neighbors who had a theory — is, evidently, still present. Crown forces stationed near Exeter have been filing medical reports describing unexplained constitutional fatigue. The DMA cross-referenced the fatigue reports against the cemetery's documented activity radius. The correlation is exact. Mercy Brown appears to be directing her attention toward Crown personnel, which the DMA considers operationally promising.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Travel to Exeter — Approach the Churchyard | `standard` | fires **PROT_12_TAME** immediately | `PROT_12_TAME` |
| 2 | Commission a DMA Exhumation Study | `standard` | fires **PROT_12_TAME** immediately | `PROT_12_TAME` |

**Leads to**

- "Travel to Exeter — Approach the Churchyard" fires `PROT_12_TAME` — MERCY BROWN WITHDRAWS FROM CONTINENTAL FORCES — RHODE ISLAND GARRISONS RECOVERING
- "Commission a DMA Exhumation Study" fires `PROT_12_TAME` — MERCY BROWN WITHDRAWS FROM CONTINENTAL FORCES — RHODE ISLAND GARRISONS RECOVERING

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 65+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_TAME` — MERCY BROWN WITHDRAWS FROM CONTINENTAL FORCES — RHODE ISLAND GARRISONS RECOVERING

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Liberty Bell · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_SUMMON` — "Travel to Exeter — Approach the Churchyard" fires <sub>(MERCY BROWN STIRS IN EXETER CHURCHYARD)</sub>
- Chained from `PROT_12_SUMMON` — "Commission a DMA Exhumation Study" fires <sub>(MERCY BROWN STIRS IN EXETER CHURCHYARD)</sub>

**Subhead — first draft**

> She Was Not Targeting Us Specifically. She Has Agreed to Be More Specific.

**Body — first draft**

> Three Continental garrison units stationed within the Exeter activity radius had been experiencing unexplained fatigue — which the DMA's omen analyst describes as Mercy Brown not yet knowing which army to prefer. The resolution involved a late-night visit to Chestnut Hill Cemetery by the DMA's lead Rhode Island specialist, who placed a letter of introduction at the grave and explained the situation. The fatigue reports from Continental units ceased within the week. Crown units in the area have begun filing their own medical reports.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_12_tame` | `PROT_12_AGREE` |
| 2 | File the Vampiric Incident Report — What Comes Next | `standard` | sets flag `prot_12_tame` | `PROT_12_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_12_AGREE` — MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC
- "File the Vampiric Incident Report — What Comes Next" → `PROT_12_AGREE` — MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_12_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_AGREE` — MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Warm
**Chain** Liberty Bell · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_TAME` — "Acknowledge the Deescalation" → <sub>(MERCY BROWN WITHDRAWS FROM CONTINENTAL FORCES — )</sub>
- Chained from `PROT_12_TAME` — "File the Vampiric Incident Report — What Comes Next" → <sub>(MERCY BROWN WITHDRAWS FROM CONTINENTAL FORCES — )</sub>

**Subhead — first draft**

> She Did Not Choose This. She Has Chosen This.

**Body — first draft**

> President Carlisle went to Chestnut Hill Cemetery alone, in the evening, with no briefing document and no protocol sheet. She sat at Mercy Brown's grave for an hour. She did not ask for anything. She spoke — about what was being asked of Mercy Brown, about what it costs to be what Mercy Brown is through no decision of her own, about the Exeter neighbors in 1892 who thought they had solved the problem and had instead created something that could not be solved, only acknowledged. When Carlisle left, she said only: she understood. Crown forces across Rhode Island began reporting the fatigue symptoms within ten days.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formalize Mercy Brown's Compact | `standard` | sets flag `prot_12_agreed` | — |
| 2 | The Full Exeter Accord | `explicit` | sets flag `prot_12_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_12_AGREE_INTIMATE` — MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Design notes** Sets prot_12_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_SUMMON` — CHAMP SURFACES ON LAKE CHAMPLAIN

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Green Mountain Ghost · position Root
**Art** `champ` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_13` · priority 1  <sub>`TRIG_029`</sub>

**Subhead — first draft**

> Vermont's Lake Monster Is Active. Crown Vessels Are Reporting Structural Complications.

**Body — first draft**

> Something very large has been observed in Lake Champlain. This has been reported since 1609, when Samuel de Champlain recorded it with what scholars describe as 'surprising equanimity for a man in a canoe.' The relevant current development is that three Crown supply barges transiting the lake have been damaged in what the Royal Navy classifies as 'unexplained contact with submerged object, nature unknown.' The Department of Mythological Affairs has a more specific classification. The classification involves a lake monster approximately fifteen feet long that appears to have assessed the current military situation on the lake and formed an opinion.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Send a Survey Vessel to Lake Champlain | `standard` | fires **PROT_13_TAME** immediately | `PROT_13_TAME` |
| 2 | Consult Vermont Lake Communities | `standard` | fires **PROT_13_TAME** immediately | `PROT_13_TAME` |

**Leads to**

- "Send a Survey Vessel to Lake Champlain" fires `PROT_13_TAME` — CHAMP DISTINGUISHES CONTINENTAL VESSELS — LAKE CHAMPLAIN CROSSINGS RESTORED
- "Consult Vermont Lake Communities" fires `PROT_13_TAME` — CHAMP DISTINGUISHES CONTINENTAL VESSELS — LAKE CHAMPLAIN CROSSINGS RESTORED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 70+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_TAME` — CHAMP DISTINGUISHES CONTINENTAL VESSELS — LAKE CHAMPLAIN CROSSINGS RESTORED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Green Mountain Ghost · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_SUMMON` — "Send a Survey Vessel to Lake Champlain" fires <sub>(CHAMP SURFACES ON LAKE CHAMPLAIN)</sub>
- Chained from `PROT_13_SUMMON` — "Consult Vermont Lake Communities" fires <sub>(CHAMP SURFACES ON LAKE CHAMPLAIN)</sub>

**Subhead — first draft**

> The Lake Monster Has Updated Its Vessel Recognition Protocol.

**Body — first draft**

> Continental supply vessels on Lake Champlain had been experiencing the same structural complications as Crown vessels, which the DMA attributes to Champ operating without vessel identification context. The solution proposed by Vermont lake communities was straightforward: mark Continental vessels with a white stripe on the bow, a practice the communities noted they had been using informally for two generations with favorable crossing results. The stripe was adopted. Continental crossings on Lake Champlain have been unimpeded since. Crown vessels have not adopted the stripe. Their crossing outcomes have not improved.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_13_tame` | `PROT_13_AGREE` |
| 2 | File the Lake Sovereignty Report — What Comes Next | `standard` | sets flag `prot_13_tame` | `PROT_13_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_13_AGREE` — CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR THE REPUBLIC
- "File the Lake Sovereignty Report — What Comes Next" → `PROT_13_AGREE` — CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR THE REPUBLIC

**Design notes** Sets prot_13_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_AGREE` — CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Triumphant
**Chain** Green Mountain Ghost · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_TAME` — "Acknowledge the Deescalation" → <sub>(CHAMP DISTINGUISHES CONTINENTAL VESSELS — LAKE C)</sub>
- Chained from `PROT_13_TAME` — "File the Lake Sovereignty Report — What Comes Next" → <sub>(CHAMP DISTINGUISHES CONTINENTAL VESSELS — LAKE C)</sub>

**Subhead — first draft**

> The Lake Has Always Had Jurisdiction. It Is Now Using It Selectively.

**Body — first draft**

> President Carlisle chartered a flat-bottomed boat from a Vermont family that had been doing crossings on the lake for three generations and went out to the middle of the lake alone. She waited. Champ surfaced at approximately six in the morning, at a distance the field agent estimated as thirty feet, and remained visible for what Carlisle describes as 'long enough.' What she said to it is not in the official record. The lake closed over Champ's return without disturbance. Crown supply operations on Lake Champlain have been suspended indefinitely. Vermont's transport corridor is open.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Accept Champ's Lake Pact | `standard` | sets flag `prot_13_agreed` | — |
| 2 | The Full Lake Champlain Sovereignty Ceremony | `explicit` | sets flag `prot_13_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_13_AGREE_INTIMATE` — CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR T... — BY MORNING

**Design notes** Sets prot_13_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_15_SUMMON` — THE SKUNK APE EMERGES FROM FLORIDA

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Skunk Ape · position Root
**Art** `skunk_ape` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_15` · priority 1  <sub>`TRIG_030`</sub>

**Subhead — first draft**

> Floridian Swamp Cryptid Rejects Crown Authority

**Body — first draft**

> The Florida wetlands have produced something large, fragrant, and extremely motivated. Crown forces in the southern theater have been retreating from territory they held securely two days ago for reasons they will not fully specify in official documents. Unofficial documents say something in the trees. Locals say oh that is just him. Him has been walking through their swamps for generations. He does not like strangers. Crown forces are strangers. The Department of Mythological Affairs notes this with satisfaction.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Contact Florida Homesteaders | `standard` | fires **PROT_15_TAME** immediately | `PROT_15_TAME` |
| 2 | Observe from the Swamp Edge | `standard` | fires **PROT_15_TAME** immediately | `PROT_15_TAME` |

**Leads to**

- "Contact Florida Homesteaders" fires `PROT_15_TAME` — SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES — SOUTHERN OPERATIONS STABLE
- "Observe from the Swamp Edge" fires `PROT_15_TAME` — SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES — SOUTHERN OPERATIONS STABLE

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 80+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_15_TAME` — SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES — SOUTHERN OPERATIONS STABLE

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Skunk Ape · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_15_SUMMON` — "Contact Florida Homesteaders" fires <sub>(THE SKUNK APE EMERGES FROM FLORIDA)</sub>
- Chained from `PROT_15_SUMMON` — "Observe from the Swamp Edge" fires <sub>(THE SKUNK APE EMERGES FROM FLORIDA)</sub>

**Subhead — first draft**

> It Smells Worse Than Before. But It's Staying in the Swamp.

**Body — first draft**

> The Skunk Ape's excursions from the Florida wetlands into Continental operating territory had been causing what southern field command describes as 'substantial logistical and morale complications.' The DMA's approach relied entirely on local Florida homesteaders who had been coexisting with the creature for generations. Their method involved a specific frequency of sound produced by a specific instrument at a specific distance from the creature's patrol area. The Skunk Ape listened. It returned to the swamp. The frequency and instrument have been added to the field manual as Protocol 7.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_15_tame` | `PROT_15_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_15_tame` | `PROT_15_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_15_AGREE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENTAL REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_15_AGREE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_15_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_15_AGREE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENTAL REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Quirky/Triumphant
**Chain** Skunk Ape · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_15_TAME` — "Acknowledge the Deescalation" → <sub>(SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES)</sub>
- Chained from `PROT_15_TAME` — "File the Departmental Report — What Comes Next" → <sub>(SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES)</sub>

**Subhead — first draft**

> The Swamp Is His. The Republic Is Grateful.

**Body — first draft**

> The formal commitment was negotiated entirely through the Florida homesteader network with zero DMA involvement, which the homesteaders view as improvement and the DMA views as a departmental lesson. President Carlisle visited the edge of the Skunk Ape's territory — the boundary where it decides whether strangers are threats. She stood there. The Skunk Ape came to the boundary. They spent forty minutes in proximity, neither advancing, both aware of exactly what was being negotiated. Crown forces in the Florida theater have since begun what their dispatches describe as 'unexpected and persistent difficulty with swamp terrain' they had managed fine in previous months.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Skunk Ape's Patrol Commitment | `standard` | sets flag `prot_15_agreed` | — |
| 2 | The Full Everglades Accord | `explicit` | sets flag `prot_15_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_15_AGREE_INTIMATE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENT... — BY MORNING

**Design notes** Sets prot_15_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_SUMMON` — A SEEMINGLY INCONSEQUENTIAL CLOTHESLINE

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Mysterious/Supernatural
**Chain** Minuteman · position Root
**Art** `agent_355` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_16` · priority 1  <sub>`TRIG_031`</sub>

**Subhead — first draft**

> The Department of Mythological Affairs Knows What It Means

**Body — first draft**

> A seemingly inconsequential string of clothing has been spotted on a clothesline in the New York theater. Only the most eagle-eyed agents of the Department of Mythological Affairs spotted it — but the message was clear. Agent 355: ready. To survey the British once again, awaiting further instructions. The Culper Ring, Washington's legendary covert operation, appears to have maintained at least one active cell across the centuries. The DMA has delivered its assessment without fanfare, which is itself unusual, and which the DMA notes is a professional courtesy extended to no other entity in their files.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Send a DMA Field Agent to Investigate | `standard` | sets flag `prot_16_summoned` | — |
| 2 | Leave the Message Where It Hangs | `standard` | sets flag `prot_16_summoned` | — |

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 85+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_TAME` — COVERT AGENT ACTIVE — CELL LOYAL

**Status** FULL COMPLETION · **Type** `protector_tame` · **Country** `USA` · **Tone** is once again hard at work for the President of the United States
**Chain** Minuteman · position Branch
**Art** `George Washington's famous spy system` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** — · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Culper Ring Is Operational Again

**Body — first draft**

> ”Agent 355 has been hard at work — harnessing the powers of local surveillance and community networks that the Crown cannot see and cannot understand. The Culper Ring

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Ring's Renewed Operations | `standard` | sets flag `prot_16_tame` | — |
| 2 | File the Intelligence Report | `standard` | sets flag `prot_16_tame` | — |

**Design notes** Sets prot_16_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_AGREE` — A LETTER OF PERSONAL LOYALTY

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Minuteman · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> It Was On the Pillow

**Body — first draft**

> Ualani never receives letters in the nighttime hours unless they are absolute emergencies. A letter sitting on her pillow, with every indication of studied nonchalance, is a different category of thing entirely. The President recognizes the handwriting immediately. Her personal loyal agent. The mystery woman known only as Three Fifty-Five. She opens the letter and reads: a spirited and enthusiastic proclamation of loyalty from the Culper Ring's head — intelligence summary, operational report, personal affirmation, all in the same hand. The letter ends with a postscript. Simply asking if the President wishes to meet in person. Ualani sets the letter down. She is suddenly aware that the bedroom is not empty in the way she had assumed it was empty. She ponders her response.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Thank and dismiss the agent. | `standard` | sets flag `prot_16_agreed` | — |
| 2 | Please come in — the candlelight awaits my dear friend. | `explicit` | fires **PROT_16_AGREE_INTIMATE** immediately | `PROT_16_AGREE_INTIMATE` |

**Leads to**

- "Please come in — the candlelight awaits my dear friend." fires `PROT_16_AGREE_INTIMATE` — TOUCHING 355 — AGENT INCÓGNITA
- scene nav: "intimate" → `PROT_16_AGREE_INTIMATE` — TOUCHING 355 — AGENT INCÓGNITA

**Design notes** Sets prot_16_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_SUMMON` — A QUIET CREAK IN THE WHITE HOUSE. AN ANGRY RANT IN THE NIGHT.

**Status** FULL COMPLETION · **Type** `protector_summon` · **Country** `USA` · **Tone** Serious/Supernatural
**Chain** Lincoln's Ghost · position Root
**Art** `lincolns_ghost` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_17` · priority 1  <sub>`TRIG_032`</sub>

**Subhead — first draft**

> The DMA Recommends We Let Him Speak.

**Body — first draft**

> Not since the Second World War has the White House held this many people. The population of the executive residence has increased substantially — staff, DMA liaisons, military personnel, civilian advisors who moved their operations closer to the President after the occupation began and never moved back. The building is crowded. It is also, according to the past three weeks of incident reports, occupied by something that does not appear in the staff directory. Personnel have described a presence. The word 'watching' appears in eleven separate incident reports. A cold spot in the Lincoln Bedroom has caused three staff reassignments. The Department of Mythological Affairs conducted a sweep at the President's request and has delivered their findings. The sweep found Lincoln. He has been here for one hundred and sixty years. He appears to have opinions about the current situation. He expressed several of them to a DMA field agent who did not have time to take notes but remembers the general shape of the argument. He has been trying to say something for a very long time. The DMA recommends we let him.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Tall and Dark Spooky | `standard` | sets flag `prot_17_summoned` | — |

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 90+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_TAME` — LINCOLN'S GHOST — ROOFTOP ACCORDS

**Status** FULL COMPLETION · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Intimate
**Chain** Lincoln's Ghost · position Branch
**Art** `prot_17_tame` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- **Protector Tame** — protector `PROT_17` · priority 1  <sub>`TRIG_087`</sub>

**Subhead — first draft**

> She Climbed the Stairs. He Was Already There.

**Body — first draft**

> No one else could see the blue flames from the roof. This was established early. Security reported nothing unusual from their station at the north gate, which is consistent with the general pattern: the White House grounds are fine. The roof is not fine. The flames, which burn a specific shade of cold blue, do not appear on any fire department record President Carlisle has ever filed. She took the stairs at a pace that lost the security detail on the third landing. They caught up with her at the roof access ten minutes later. She was already talking to him. He was everything the DMA field reports had suggested: tall, worn, carrying the weight of everything that ended in April of 1865, in a coat he had apparently not changed since. There was a hole in his hat where something had gone through it. She noticed. She did not say anything about the hole in his hat. He noticed her not saying anything and appeared to appreciate it. They stood on the roof for forty minutes while the security team waited at the door. She told her chief of staff afterward that he had known this moment was coming — this administration specifically, this moment. He had been waiting. He said he was in. She said good. That was the accord. The rest is paperwork.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_17_tame` | — |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_17_tame` | — |

**Design notes** Sets prot_17_tame flag; AGREE gated by level-8 Monument in DC

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_AGREE` — LINCOLN'S GHOST TOURS THE MALL

**Status** FULL COMPLETION · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Lincoln's Ghost · position Followup
**Art** `prot_17_agree` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Protector Agree** — protector `PROT_17` · priority 1  <sub>`TRIG_088`</sub>

**Subhead — first draft**

> With the National Mall Restored, a Tour Was in Order.

**Body — first draft**

> With the renovations complete across the damaged National Mall, and Lincoln's ghost on what anyone would charitably call friendly terms with the administration, President Carlisle extended an invitation that no one had thought to extend before: a day trip. Lincoln was hesitant. The White House is his. The rest of the city is a question he has been avoiding for a hundred and sixty years. But he trusted Ualani, which is a sentence no one expected to write in a briefing. They spent the afternoon among the statues of great presidents and civic leaders. With each monument visited, something returned to the man. The Jefferson Memorial gave him form — his eyes took shape from the gaunt fog that had been his face. The MLK monument solidified the image, his transparency shifting into something a bystander might mistake for flesh. But it was not until his own monument that Abraham Lincoln finally returned in full. His voice. The statue gave the president back his voice. He sat upon his own lap and looked out across the reflecting pond at Washington's great tower, which he had never seen completed. 'Too bad for that rebellion,' he said. 'The General's obelisk is discolored.' 'I could have it painted if you'd like,' Ualani replied. 'It's a war scar. You'll have your own to deal with. Don't try and fix mine.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Come on Abe, we've still got half the Mall to explore! | `standard` | sets flag `prot_17_agreed` | — |
| 2 | Invite the President to Dinner this evening | `explicit` | fires **PROT_17_AGREE_INTIMATE** immediately | `PROT_17_AGREE_INTIMATE` |

**Leads to**

- "Invite the President to Dinner this evening" fires `PROT_17_AGREE_INTIMATE` — THE MOST EXCLUSIVE CLUB ON EARTH
- scene nav: "intimate" → `PROT_17_AGREE_INTIMATE` — THE MOST EXCLUSIVE CLUB ON EARTH

**Design notes** Sets prot_17_agreed; BTN2 triggers intimate; unlocks Lincoln governor + doubles Red Badge

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_01_AGREE_INTIMATE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Mothman · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_01_AGREE` — scene nav: "intimate" from <sub>(MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REP)</sub>

**Subhead — first draft**

> He Has Been Angry for a Long Time. He Is Not Angry Anymore.

**Body — first draft**

> By morning the ridge was quiet. Ualani had already gone — she does not do goodbyes to things she intends to come back to. What remained was the agreement‚ which had no document and needed none. He had been a warning for so long. A portent. The thing that appears before the disaster to tell you the disaster is coming‚ which is the loneliest possible function. Nobody wants to see the Mothman. Nobody wants to hear what the Mothman knows. She had wanted to hear. She had sat in the dark of the Appalachian hills and listened to everything he knew about this country — the grief of it‚ the promise of it‚ the long patience of watching people fail the land and fail each other and occasionally‚ rarely‚ not. He had told her all of it. She had not run. He had decided‚ sometime in the early hours before dawn‚ that the Republic she was building was worth watching over instead of warning about. That is not a small decision for something that old. He slept until the sun was high. When he woke‚ he was already facing east.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Mothman, Appalachian ridge at dawn; from warning to watching over

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_02_AGREE_INTIMATE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE — BY MORNING

**Status** FULL COMPLETION · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Jersey Devil · position Chain
**Art** `prot_02_agree_intimate` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_02_AGREE` — scene nav: "intimate" from <sub>(JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL C)</sub>

**Subhead — first draft**

> New Jersey's Most Complicated Asset Has Chosen a Side.

**Body — first draft**

> The Pine Barrens are not quiet — they are never quiet — but they are different now. The Jersey Devil does not make agreements. It makes decisions‚ and the decision it made was not communicated in language but in the sudden‚ specific quality of the silence around the southern New Jersey perimeter. The Crown scouts who had been using the Barrens as a corridor stopped using it. They did not explain why in their reports. They did not have the vocabulary. What Carlisle had done — standing in the dark at the treeline and simply waiting‚ not demanding‚ not negotiating‚ just being present long enough that the thing that lived there could decide whether she was the kind of problem it wanted — was not diplomacy. It was recognition. The Jersey Devil does not care about republics. It cares about whether the people running them understand what they are in. She stayed until she was sure it knew she did.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** New Jersey's most complicated asset. By morning: recognition without negotiation.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_AGREE_INTIMATE` — WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE WOODS — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Bigfoot · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_AGREE` — scene nav: "intimate" from <sub>(WOOD BOOGER FORMALLY GUIDES THE CONTINENTAL CAUS)</sub>

**Subhead — first draft**

> He Doesn't Speak. He Moves. That Is Communication.

**Body — first draft**

> He did not agree to anything. He began to walk in front of her. That is the same thing. Carlisle followed him through the northern woods for two hours without speaking‚ because there was nothing to say that he had not already heard from the trees and the undergrowth and the particular quality of the ground that registers footfall differently depending on whether the person walking knows what they are walking through. He stopped at the ridge. She stopped behind him. He looked north — toward the Crown positions‚ toward the border‚ toward the places where the Continental Army was thin. Then he walked away into the dark and she came back alone and told the security detail the woods were fine. The woods‚ in fact‚ have been fine since. The patrol reports note fewer Crown scouts in the highland corridors. They attribute it to strategy. She has not corrected them.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Bigfoot leads walk through northern woods; Crown scouts leave

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_AGREE_INTIMATE` — PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Thunderbird · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_AGREE` — scene nav: "intimate" from <sub>(PAMOLA FORMALLY ALIGNS WITH THE CONTINENTAL REPU)</sub>

**Subhead — first draft**

> The Mountain Has Made a Decision. Crown Forces Along the Maine Coast Will Not Enjoy It.

**Body — first draft**

> Katahdin at midnight is a different thing than Katahdin in daylight. She went up the approach trail to treeline alone‚ which the Penobscot liaison had said was the correct protocol‚ and stood where the stone plateau begins and the world becomes sky. Pamola does not descend to meet you. You ascend to where Pamola is. The storm that had been building over the summit came down in the way storms on Katahdin come down — sudden‚ total‚ with the specific quality of being personal rather than meteorological. She stood in it. She did not flinch‚ which the Penobscot council had said was the whole of it. The storm went through her‚ the way things with real authority do when they are deciding whether you deserve to be in their presence. Then it pulled back to the summit and stayed there‚ and the air above the plateau was clear and cold. She went down in the dark. Continental Army units operating along the Maine coast reported‚ in the weeks that followed‚ weather that the Crown forces could not move through. Pamola had decided. The mountain does not announce these things.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Thunderbird rain-as-decision; NY highlands weather

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_05_AGREE_INTIMATE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Headless Horseman · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_05_AGREE` — scene nav: "intimate" from <sub>(THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY)</sub>

**Subhead — first draft**

> He Was Always Going to Choose a Side. She Just Had to Ask.

**Body — first draft**

> He had been riding the same roads since before the revolution and would ride them after‚ regardless of what she said. That was not the point. The point was that she came to Sleepy Hollow and stood in the road at midnight and waited — without a torch‚ without a weapon‚ without the security detail she had technically agreed to bring — and when the sound of hooves came she did not move. He stopped. They regarded each other in the dark‚ the President of the Continental Republic and the thing that has haunted these roads since the war before this war. She said: I know you're going to ride. I'm asking you to ride in a direction. That was all she said. He turned north — toward the Crown positions‚ toward the approaches they had been using through Westchester. He did not come back that night. The Crown's northern courier routes stopped functioning shortly after.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Headless Horseman Sleepy Hollow midnight; turns north

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_AGREE_INTIMATE` — VOYEUR‚ NOT MONSTER

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Chessie · position Chain
**Art** `goatman_intimate` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_06_AGREE` — "Perform the duties of peace." fires <sub>(MIDNIGHT MEETING — THE TERMS OF THE DEAL)</sub>
- Chained from `PROT_06_AGREE` — scene nav: "intimate" from <sub>(MIDNIGHT MEETING — THE TERMS OF THE DEAL)</sub>

**Subhead — first draft**

> The Terms Required a Witness. The Goatman Had That in Common with Notaries.

**Body — first draft**

> It takes a particular kind of leader to hold empathy for something that murders people on parkways. Ualani has always been that kind of leader. The Goatman had never received anything but containment orders and dead DMA agents — she gave it terms instead‚ and a dignity it had never been offered. The final clause of the arrangement required a witness. Ualani returned to the protective service vehicle and explained the terms to her agent‚ who received this information with what would appear in no official document as 'enthusiasm.' The two of them lit a joint and hotboxed the car while the radio played something quiet. The Goatman‚ per the agreement‚ maintained a respectful distance from the vehicle until morning. It watched. A deal is a deal‚ and this one was specific. Ualani would not sleep that night. She did not appear to mind. By the time her agent drove her back to the capital in the early grey hours‚ the Goatman was gone from the overlook. Maryland was quieter than it had been in years.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | sets flag `prot_06_agreed` | — |

**Design notes** Protector — authored; Chessie, Annapolis dock, cold bay water; shape in the deep

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_AGREE_INTIMATE` — BELL AND THE BEAST

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Bell Witch · position Chain
**Art** `bell_witch_intimate` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_07_AGREE` — "Lead the way" fires <sub>(JINGLE BELLS‚ KING GEORGE SMELLS)</sub>
- Chained from `PROT_07_AGREE` — scene nav: "intimate" from <sub>(JINGLE BELLS‚ KING GEORGE SMELLS)</sub>

**Subhead — first draft**

> The Velvet Case. The Cedar Smell. The Thing Inside It.

**Body — first draft**

> The Bell Witch's gift arrived in a velvet case that smelled of Tennessee cedar and something older and considerably more assertive. The DMA field agent stationed outside the Adams farmhouse — it was his job‚ he filed it under professional obligation — describes the contents as 'a supernatural military asset of considerable dimension‚ notable hue‚ and operational complexity.' The President accepted it without comment. She has deployed it. The army reports plus three Attack across all units‚ an improvement the Secretary of War describes as remarkable and declines to attribute to any specific cause. The Bell Witch was heard laughing from three counties over. No inquiry has been opened into the precise nature of the gift. Some things are operational and need not be explained. The agent's field report closes with the note: 'I am going to need a moment.' He took several.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | sets flag `prot_07_agreed` | — |

**Design notes** Protector — authored; Bell Witch Adams TN; candle facing south

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_AGREE_INTIMATE` — Motion of the Ocean

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Old Ironsides · position Chain
**Art** `prot_08_agree_intimate` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_08_AGREE` — scene nav: "intimate" from <sub>(President Ualani Sets Sail)</sub>

**Subhead — first draft**

> The Captain’s Log Notes Favorable Winds

**Body — first draft**

> Ualani’s clothes came off more or less accidentally. The ship took her to a patch of ocean so still and so blue and so lonely. She hadn’t been alone like this since becoming president, hell since running for president. This water was like the water from home. Not exactly. But the closest thing she’d found to it outside Hawaii. And the ship wasn’t moving until she took a dip. The sun and the water. What a lovely medicine, health shot directly to the soul. How could she have forgotten? Was the war so brutal she’d lost her cherubic wonder at the world? She had come so close, the memory of her happy life before this hell took it all almost fully gone — if not for the creaking wooden boat she now swam beside. She climbed aboard. The ship didn’t move. She still needed time. She made her way to the crow’s nest to watch the sunset. Without a single wave, the boat swayed gently, rhythmically. Ualani swayed along, feeling her gravity shift in pleasurably dizzying loops. The vessel’s quiet rocking smoothly accelerated pace, triggering Ualani’s heart to flutter slightly. Already naked, she didn’t need any more justification to rock the boat further. When the Constitution finally began making its way to port, the president let out a rare whine.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored (Old Ironsides); explicit content; already Integrated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_09_AGREE_INTIMATE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Valley Forge Guardian · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_09_AGREE` — scene nav: "intimate" from <sub>(VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTI)</sub>

**Subhead — first draft**

> The Ground Accepted Her Army. That Is Not a Small Thing.

**Body — first draft**

> Valley Forge remembers everything. The winter of 1777. The men who died there. The ones who left and came back. The ones who stayed because there was nowhere else to go and built something out of nothing and cold and the specific kind of stubbornness that does not have a better name than faith. Carlisle went to the field at dawn‚ alone‚ in winter‚ and stood on the ground where the encampment had been‚ and she did not say anything because there was nothing to say to ground that already knew. She stood until the cold became unremarkable‚ the way you stand in cold that you are asking something of. The Guardian is not a creature. It is a commitment made by people who are no longer alive‚ living in the soil they made something in. When she left‚ the ground behind her was slightly warmer than it should have been. The armies that camped there after reported better rest than the conditions should have allowed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Valley Forge Guardian, winter dawn, warmer ground

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_AGREE_INTIMATE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY ... — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Snallygaster · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_10_AGREE` — scene nav: "intimate" from <sub>(SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUP)</sub>

**Subhead — first draft**

> It Has Stopped Eating Our Supplies. It Has Started Eating Theirs.

**Body — first draft**

> The supply depot at a mountain gap in the Shenandoah had been running low since November. Not because of the Crown — because something in the mountains had been helping itself to the transit caches at a rate the quartermaster described as 'operationally unsustainable but taxonomically unprecedented.' Carlisle went to the Valley alone at night and waited at the ridge gap with one of the undamaged crates set out in the open. She waited four hours. What arrived was large and old and wrong-shaped and hungry in the specific way that things that have been living alone in mountains for centuries are hungry — not for food, but for acknowledgment. She acknowledged it. She said: I know you're here. I know you've been here longer than this road. I am not asking you to stop doing what you do. I am asking you to do it to them instead of us. The next morning the crate was gone, which was expected. The Crown supply route through the Valley was disrupted for three weeks by what the field reports describe as 'unknown interference of a zoological character,' which is the documentation that exists for what the Snallygaster decided to do with the winter.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Snallygaster, Cumberland Pass midnight; crate gone, Crown route disrupted

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_AGREE_INTIMATE` — BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR T... — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Paul Revere · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_AGREE` — scene nav: "intimate" from <sub>(BLACK DOG FORMALLY WATCHES THE HANGING HILLS FOR)</sub>

**Subhead — first draft**

> It Has Always Been Watching. Now It Watches in a Useful Direction.

**Body — first draft**

> The dog was there when she arrived at the trailhead‚ which she had been told would happen and which still required some adjustment. It is small. That is the first thing — the folklore suggests something vast and she had calibrated her expectation accordingly‚ but it is the size of a medium dog‚ completely black‚ and entirely silent. It sat. She sat also‚ on a stone at the trail's edge‚ and they stayed that way for forty minutes. She did not try to speak to it. She did not try to touch it. She thought about Connecticut‚ which is a state she has mostly thought of in passing and which she was now thinking of as a place that has been watched‚ quietly and without fanfare‚ by something that has no interest in recognition. The dog stood up eventually. It walked to the eastern edge of the ridge and looked down the slope toward where the Crown supply routes ran through the valley. It looked back at her once. Then it went down the hill‚ in the direction of the Crown. She did not follow. You do not follow the Black Dog. It is the omen. You are simply the occasion.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Paul Revere Lexington midnight; turns north without orders

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_AGREE_INTIMATE` — MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Liberty Bell · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_AGREE` — scene nav: "intimate" from <sub>(MERCY BROWN FORMALLY ALLIES WITH THE CONTINENTAL)</sub>

**Subhead — first draft**

> She Did Not Choose This. She Has Chosen This.

**Body — first draft**

> The cemetery in Exeter is quiet in the way that places with unresolved business are quiet — a quiet that has content to it. She went in the late evening‚ when the light was going‚ and walked to the grave at the back of the churchyard near the stone wall. There is no monument. There is a simple stone and a name and a date and what happened after. She sat on the ground. She thought about what it means to be turned into a symbol by the people who were afraid of you — to have your death become a story about what you were‚ rather than who you were. Mercy Brown was nineteen. She died of tuberculosis. Her neighbors dug her up three months later and burned her heart. The ash was given to her brother to eat. It didn't work. He died six weeks later anyway. She said: I know what was done to you. I am not asking you to forgive it. I am asking you to let what you are‚ now‚ be useful. The graves of Crown soldiers in the Rhode Island corridor‚ in the following months‚ received visitors at odd hours. The DMA has not been asked to explain it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Liberty Bell Philadelphia dawn; crack unchanged, ringing anyway

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_AGREE_INTIMATE` — CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR T... — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Green Mountain Ghost · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_AGREE` — scene nav: "intimate" from <sub>(CHAMP FORMALLY GUARDS LAKE CHAMPLAIN FOR THE REP)</sub>

**Subhead — first draft**

> The Lake Has Always Had Jurisdiction. It Is Now Using It Selectively.

**Body — first draft**

> Lake Champlain at the middle of the night is the color of everything that goes deep. She borrowed a boat from the Vermont family — they had offered‚ which meant they had known she would ask‚ which she understood was a Vermont thing — and rowed out to the center of the lake in the dark. No one came with her. The family had said this was the correct approach and she believed them. She sat in the boat for a long time. The kind of water that has been here since the ice receded and carries the passage of everything that has tried to cross it. Champ came up beside the boat quietly‚ without the disturbance you would expect from something that size‚ and stayed there. In the dark it was less visible and more present — the specific presence of very old large things that have existed in one place long enough to be the place. She put her hand over the side. The water was cold. She said: I know you're older than this war. I know this lake is yours. I am asking you to let the people who have built things on your shores use what you allow. The water moved‚ and then was still‚ and then Champ was gone without her seeing it go. Crown patrol vessels sent to establish jurisdiction over the lake encountered conditions the admiralty classified as implausible.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Green Mountain Ghost, Vermont October; weather not in meteorological record

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_15_AGREE_INTIMATE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENT... — BY MORNING

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Skunk Ape · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_15_AGREE` — scene nav: "intimate" from <sub>(SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTI)</sub>

**Subhead — first draft**

> The Swamp Is His. The Republic Is Grateful.

**Body — first draft**

> The Everglades at night smell like something older than the Republic, older than the colony, older than anyone's claim to what grows in this water. She went in alone — the security detail stopped at the road because the security detail cannot meaningfully secure anything that is happening in a swamp at midnight with a creature that is eight feet tall and profoundly unbothered by hierarchy. She found the place where the water stopped and the ground started and stood there until the smell changed and the quality of the air changed and she knew she was no longer alone in the way she had been alone. The Skunk Ape does not negotiate. It evaluates. What it evaluated, standing in the dark of the Florida interior looking at the President of the Continental Republic who had come into the swamp without a weapon and without a retinue and without appearing to be afraid: she was not afraid. She was respectful. These are different things and the Skunk Ape understands the difference. Crown supply routes through central Florida began experiencing delays shortly after. The Florida field reports cite 'hostile terrain conditions' and 'unidentified interference.' The terrain has been making its own decisions since before the European maps.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Protector — authored; Skunk Ape, Everglades midnight; respectful not afraid

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_AGREE_INTIMATE` — TOUCHING 355 — AGENT INCÓGNITA

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Minuteman · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_16_AGREE` — "Please come in — the candlelight awaits my dear friend." fires <sub>(A LETTER OF PERSONAL LOYALTY)</sub>
- Chained from `PROT_16_AGREE` — scene nav: "intimate" from <sub>(A LETTER OF PERSONAL LOYALTY)</sub>

**Subhead — first draft**

> Close Your Eyes Madame President

**Body — first draft**

> The spy comes forward but holds the President's head. 'Close your eyes, Madame President. My identity must remain a secret even from you — else I may have to kill you.' She had been threatened many times. None of them had landed quite like that. She closed her eyes. She felt her spy's hands find her — sure, unhurried, professional in a manner that had nothing to do with efficiency and everything to do with experience. The clothes came aside. The candle burned lower. Agent 355 knew her job. The President need not micromanage.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | sets flag `prot_16_agreed` | — |

**Design notes** Protector — authored; Minuteman, Lexington Green; one nod, response time improves

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_AGREE_INTIMATE` — THE MOST EXCLUSIVE CLUB ON EARTH

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Explicit
**Chain** Lincoln's Ghost · position Chain
**Art** `prot_17_agree_intimate` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_17_AGREE` — "Invite the President to Dinner this evening" fires <sub>(LINCOLN'S GHOST TOURS THE MALL)</sub>
- Chained from `PROT_17_AGREE` — scene nav: "intimate" from <sub>(LINCOLN'S GHOST TOURS THE MALL)</sub>

**Subhead — first draft**

> Dinner Was a Failure. The Evening Was Not.

**Body — first draft**

> Dinner was a failure. This was not anticipated. DMA field agents on site recorded that phantasms cannot consume meat or vegetables, which is a finding that raises more questions than the brief was prepared to address. The President and the former president salvaged the evening by strolling the rose garden instead. They had more in common than perhaps any two presidents before them — they both led a massive war of survival from this building, with an existential threat always looming. Lincoln fought and destroyed a slaver empire carved from a republic he was sworn to uphold. Ualani has spent years defending her people from a tyrannical resurrected British tyrant whose robot redcoats march across the world. They are, in several meaningful ways, the same person. The conversation deepened. The wandering became less coordinated. They found themselves, at some point, standing in the Lincoln Bedroom, unsure exactly why. A brush of chill plasmic mist against warm living skin. Buttons popped. Clothes found the floor. Then — a pause. 'Madam President,' the ghost said, his voice oddly cautious. 'I cannot tell a lie. I know you cannot see them, but the other presidents are here. They are here to watch.' She looked around the room. 'All the presidents? Which ones?' 'Everyone but Buchanan. Us presidents can only fuck other presidents, and we have been desperate for a woman to finally win.' 'Well then.' She looked back at him. 'Get to work down there, Mr. Lincoln. We have got a lot of ground to cover.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | sets flag `prot_17_agreed` | — |

**Design notes** Protector — authored (Lincoln); explicit content with presidential council; already Integrated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
