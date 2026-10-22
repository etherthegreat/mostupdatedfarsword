# Protector

68 events · FIRST PASS 51 · IDEA 17

[← back to index](00_INDEX.md)

---

### `PROT_01_SUMMON` — MOTHMAN APPROACHES

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Mothman · position Root
**Art** `mothman_approach` (Not Started) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Protector Summon** — protector `PROT_01` · priority 1  <sub>`TRIG_014`</sub>

**Subhead — first draft**

> A Presence in the Dark

**Body — first draft**

> Something enormous and winged has landed near Harper's Ferry. It is looking at you with profound urgency. It has been trying to tell people things for decades. Nobody listened. President Carlisle is looking back. She is not running.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Make Eye Contact | `standard` | fires **PROT_01_TAME** immediately | `PROT_01_TAME` |
| 2 | Hold Your Ground | `standard` | fires **PROT_01_TAME** immediately | `PROT_01_TAME` |

**Leads to**

- "Make Eye Contact" fires `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS
- "Hold Your Ground" fires `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 10+; kinky_lewd gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_01_TAME` — MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Warm
**Chain** Mothman · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_01_SUMMON` — "Make Eye Contact" fires <sub>(MOTHMAN APPROACHES)</sub>
- Chained from `PROT_01_SUMMON` — "Hold Your Ground" fires <sub>(MOTHMAN APPROACHES)</sub>

**Subhead — first draft**

> It Stopped Haunting. It's Still Watching. These Are Different.

**Body — first draft**

> The Department of Mythological Affairs field team has submitted a three-page report on the situation at Harper's Ferry. Summary paragraph: Mothman has ceased indiscriminate haunting. The creature attended the initial contact with what the lead agent describes as 'profound focused attention' and departed to a ridge position that is technically not haunting anything within a twelve-mile radius. The surveillance continues. The disruption does not. The department is calling this success and is actively choosing not to examine the exact nature of the interaction that produced it.

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

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Intimate
**Chain** Mothman · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** true · **Cooldown** 0

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

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Jersey Devil · position Root
**Art** `jersey_devil` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

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

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Jersey Devil · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

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
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

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

### `PROT_03_SUMMON` — BIGFOOT SIDES WITH THE REVOLUTION

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Supernatural
**Chain** Bigfoot · position Root
**Art** `bigfoot` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_03` · priority 1  <sub>`TRIG_019`</sub>

**Subhead — first draft**

> Appalachian Footprint Evidence Officially Classified

**Body — first draft**

> Enormous footprints have been found in eleven separate Appalachian counties, all leading toward Crown fortifications. Intelligence suggests the creature moves with tactical awareness. Reports of Redcoat units filing noise complaints about nighttime woodland disturbances have been confirmed. The Department of Mythological Affairs notes that Bigfoot has expressed solidarity through action rather than statement, which frankly we respect more than the press conferences we have been doing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Approach Without Weapons | `standard` | fires **PROT_03_TAME** immediately | `PROT_03_TAME` |
| 2 | Leave Provisions at the Clearing | `standard` | fires **PROT_03_TAME** immediately | `PROT_03_TAME` |

**Leads to**

- "Approach Without Weapons" fires `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES THE REPUBLIC
- "Leave Provisions at the Clearing" fires `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES THE REPUBLIC

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 20+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_TAME` — APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quiet/Warm
**Chain** Bigfoot · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_SUMMON` — "Approach Without Weapons" fires <sub>(BIGFOOT SIDES WITH THE REVOLUTION)</sub>
- Chained from `PROT_03_SUMMON` — "Leave Provisions at the Clearing" fires <sub>(BIGFOOT SIDES WITH THE REVOLUTION)</sub>

**Subhead — first draft**

> The Mountain Wasn't His Problem. Now It Isn't Our Problem.

**Body — first draft**

> The Appalachian highlands had been experiencing what military dispatches diplomatically call 'unexpected personnel deterrence events' — which is how the Continental Army describes soldiers refusing to pass through mountain corridors because something very large is watching them from the ridgeline. The DMA field team established sustained presence in the affected region, approached without weapons, and left provisions at the clearing the creature regarded as a meeting location. Three visits later, Bigfoot crossed the clearing and stood still for forty seconds. The agents report this as 'communication.' The mountain passes are open.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_03_tame` | `PROT_03_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_03_tame` | `PROT_03_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_03_AGREE` — BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS
- "File the Departmental Report — What Comes Next" → `PROT_03_AGREE` — BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS

**Design notes** Sets prot_03_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_AGREE` — BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Quiet/Triumphant
**Chain** Bigfoot · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_TAME` — "Acknowledge the Deescalation" → <sub>(APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES )</sub>
- Chained from `PROT_03_TAME` — "File the Departmental Report — What Comes Next" → <sub>(APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES )</sub>

**Subhead — first draft**

> He Doesn't Speak. He Moves. That Is Communication.

**Body — first draft**

> President Carlisle went to the Appalachian clearing alone and sat down. After twenty minutes, the clearing was no longer empty. She sat with the creature for an hour in silence. Neither party required words. Continental forces since that meeting report that mountain routes previously described as difficult and hostile are now navigated with a confidence their officers attribute to 'a general sense that the terrain is cooperative.' Three scouting units reported arranged rocks and disturbed paths pointing the correct direction that they followed to significant tactical advantage. Bigfoot has not been seen again. The signs have not stopped appearing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Bigfoot's Guidance Through the Mountains | `standard` | sets flag `prot_03_agreed` | — |
| 2 | The Full Mountain Agreement | `explicit` | sets flag `prot_03_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_03_AGREE_INTIMATE` — BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUG... — BY MORNING

**Design notes** Sets prot_03_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_SUMMON` — THUNDERBIRD ANSWERS THE CALL

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Supernatural
**Chain** Thunderbird · position Root
**Art** `thunderbird` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_04` · priority 1  <sub>`TRIG_020`</sub>

**Subhead — first draft**

> Indigenous Skies Reclaim Their Sovereignty

**Body — first draft**

> The great bird has been seen again. Its wingspan shades hilltops. Its call carries three counties. Several Crown signal fires have been disrupted by what officers recorded as unexplained atmospheric interference — which is the military way of writing a very large bird knocked over our stuff. Indigenous communities across the Northern ranges have acknowledged the sighting without surprise. The Department of Mythological Affairs is catching up.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Request Indigenous Liaison | `standard` | fires **PROT_04_TAME** immediately | `PROT_04_TAME` |
| 2 | Signal a Ceremonial Approach | `standard` | fires **PROT_04_TAME** immediately | `PROT_04_TAME` |

**Leads to**

- "Request Indigenous Liaison" fires `PROT_04_TAME` — THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS TO PREDICTABLE PATTERNS
- "Signal a Ceremonial Approach" fires `PROT_04_TAME` — THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS TO PREDICTABLE PATTERNS

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 25+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_TAME` — THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS TO PREDICTABLE PATTERNS

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Thunderbird · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_SUMMON` — "Request Indigenous Liaison" fires <sub>(THUNDERBIRD ANSWERS THE CALL)</sub>
- Chained from `PROT_04_SUMMON` — "Signal a Ceremonial Approach" fires <sub>(THUNDERBIRD ANSWERS THE CALL)</sub>

**Subhead — first draft**

> The Sky Has Calmed. The Bird Is Still Up There.

**Body — first draft**

> The Thunderbird had been disrupting Continental signal fires, weather patterns, and field communications across the Hudson Valley simultaneously — with no apparent concern for whose operations it was disrupting. The DMA's ceremonial approach, conducted through Indigenous liaisons who had been suggesting this methodology for two weeks before the DMA listened, produced immediate results. The ceremony involved offerings, a specific protocol, and what the lead agent describes as 'a complete revision of my understanding of what is negotiable with extremely large birds.' The Thunderbird circles. It is no longer descending. This is meaningfully different.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_04_tame` | `PROT_04_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_04_tame` | `PROT_04_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_04_AGREE` — THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_04_AGREE` — THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_04_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_AGREE` — THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Epic/Rousing
**Chain** Thunderbird · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_TAME` — "Acknowledge the Deescalation" → <sub>(THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS )</sub>
- Chained from `PROT_04_TAME` — "File the Departmental Report — What Comes Next" → <sub>(THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS )</sub>

**Subhead — first draft**

> The Sky Has Taken a Side. This Is Historically Unusual.

**Body — first draft**

> The formal agreement with Thunderbird was reached through the Indigenous liaison network. President Carlisle attended the ceremony without her staff, without her security detail, and without — notably — her shoes, a gesture the lead cultural liaison describes as 'exactly correct in a way that suggests someone has been paying attention.' The ceremony is not described in the official record at the liaison's request. The agreement stands. Thunderbird has since been observed disrupting Crown signal fires along the northern border with precision that the DMA's meteorological analysts attribute to 'deliberate and intentional atmospheric intervention by an entity that understands the operational significance of what it is doing.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Thunderbird's Alignment | `standard` | sets flag `prot_04_agreed` | — |
| 2 | The Full Ceremonial Alliance | `explicit` | sets flag `prot_04_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_04_AGREE_INTIMATE` — THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REP... — BY MORNING

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

### `PROT_06_SUMMON` — CHESSIE RISES FROM THE BAY

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Tense/Quirky
**Chain** Chessie · position Root
**Art** `chessie` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_06` · priority 1  <sub>`TRIG_022`</sub>

**Subhead — first draft**

> Chesapeake Sea Serpent Has Opinions About the Royal Navy

**Body — first draft**

> Fishermen along the Chesapeake have been reporting something enormous moving beneath the water since the Crown fleet arrived. Naval officers describe wake disturbances inconsistent with known wildlife and a sound that makes men uncomfortable in a primal way. Chessie — known to locals, disputed by scientists, beloved by everyone with a boat — has apparently had enough. Three Royal Navy frigates have filed for unspecified weather damage. The Department of Mythological Affairs filed a counter-report labeling it: sea serpent, friendly.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Signal from the Shore | `standard` | fires **PROT_06_TAME** immediately | `PROT_06_TAME` |
| 2 | Consult the Bay Fishermen | `standard` | fires **PROT_06_TAME** immediately | `PROT_06_TAME` |

**Leads to**

- "Signal from the Shore" fires `PROT_06_TAME` — CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAKE FISHING RESTORED
- "Consult the Bay Fishermen" fires `PROT_06_TAME` — CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAKE FISHING RESTORED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 35+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_TAME` — CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAKE FISHING RESTORED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Chessie · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_06_SUMMON` — "Signal from the Shore" fires <sub>(CHESSIE RISES FROM THE BAY)</sub>
- Chained from `PROT_06_SUMMON` — "Consult the Bay Fishermen" fires <sub>(CHESSIE RISES FROM THE BAY)</sub>

**Subhead — first draft**

> The Fishing Boats Are Fine Now. The Crown Frigates Are Less Fine.

**Body — first draft**

> Chesapeake Bay's resident sea creature had been operating with what marine officers described as 'enthusiasm in excess of operational necessity' — meaning it was disrupting commercial fishing alongside Royal Navy operations with identical conviction. The DMA field team coordinated with Chesapeake Bay fishing communities who had, it emerges, been leaving offerings on a specific sandbar for approximately forty years. The offerings were presented. Chessie surfaced, considered the matter for eleven minutes, and returned to the bay. Commercial fishing resumed the following morning. Crown frigates report increased wake disturbances.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_06_tame` | `PROT_06_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_06_tame` | `PROT_06_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_06_AGREE` — CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY
- "File the Departmental Report — What Comes Next" → `PROT_06_AGREE` — CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY

**Design notes** Sets prot_06_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_AGREE` — CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Chessie · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_06_TAME` — "Acknowledge the Deescalation" → <sub>(CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAK)</sub>
- Chained from `PROT_06_TAME` — "File the Departmental Report — What Comes Next" → <sub>(CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAK)</sub>

**Subhead — first draft**

> The Chesapeake Has Chosen. The Bay Knows Whose Side It Is On.

**Body — first draft**

> President Carlisle stood at the water's edge of the Chesapeake at low tide at the specific sandbar the fishing community identified as meaningful. She waded out in the dark. After thirteen minutes, something very large surfaced nearby. The agreement was brief. Her security detail, watching from shore, observed a 'sustained period of proximity' and the President emerging from the water looking 'focused in a way that suggested something specific had been communicated.' Crown frigates in the Chesapeake since report what the Admiralty describes as 'inexplicable structural damage to hulls at depth.' Continental fishing boats report excellent conditions.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Chessie's Patrol Commitment | `standard` | sets flag `prot_06_agreed` | — |
| 2 | The Full Chesapeake Accord | `explicit` | sets flag `prot_06_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_06_AGREE_INTIMATE` — CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY — BY MORNING

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
**Art** `bell_witch` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_07` · priority 1  <sub>`TRIG_023`</sub>

**Subhead — first draft**

> Crown Forces in the Southern Theater Reporting Morale Issues

**Body — first draft**

> Soldiers stationed in the Tennessee highlands are filing complaints. The complaints describe: voices in empty rooms, unexplained bruising, complete inability to sleep, and food that tastes wrong in a way we cannot explain. The Bell Witch is not the Department's most cooperative asset. She operates independently, the Secretary noted. We have a working relationship based on mutual respect and her willingness to terrify our enemies specifically.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Contact Local Spiritual Practitioners | `standard` | fires **PROT_07_TAME** immediately | `PROT_07_TAME` |
| 2 | Announce Your Purpose Plainly | `standard` | fires **PROT_07_TAME** immediately | `PROT_07_TAME` |

**Leads to**

- "Contact Local Spiritual Practitioners" fires `PROT_07_TAME` — BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROWN-OCCUPIED TERRITORY
- "Announce Your Purpose Plainly" fires `PROT_07_TAME` — BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROWN-OCCUPIED TERRITORY

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 40+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_TAME` — BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROWN-OCCUPIED TERRITORY

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Tense/Wry
**Chain** Bell Witch · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_07_SUMMON` — "Contact Local Spiritual Practitioners" fires <sub>(THE BELL WITCH MANIFESTS IN TENNESSEE)</sub>
- Chained from `PROT_07_SUMMON` — "Announce Your Purpose Plainly" fires <sub>(THE BELL WITCH MANIFESTS IN TENNESSEE)</sub>

**Subhead — first draft**

> The Soldiers in Tennessee Can Sleep Now. The Crown Ones Cannot.

**Body — first draft**

> The Bell Witch of Tennessee had been an equal-opportunity haunter for the duration of the present conflict — afflicting Continental and Crown soldiers with identical supernatural disruption and zero concern for military allegiance. The DMA's approach involved a spiritual practitioner from the local community who had not been consulted by the department despite being available and having opinions about this for months. The three-hour negotiation produced results. Crown-occupied territory in Tennessee reports a significant increase in unexplained disturbances. Continental territory does not.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_07_tame` | `PROT_07_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_07_tame` | `PROT_07_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_07_AGREE` — THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL CAUSE
- "File the Departmental Report — What Comes Next" → `PROT_07_AGREE` — THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL CAUSE

**Design notes** Sets prot_07_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_AGREE` — THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL CAUSE

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Tense/Rousing
**Chain** Bell Witch · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_07_TAME` — "Acknowledge the Deescalation" → <sub>(BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROW)</sub>
- Chained from `PROT_07_TAME` — "File the Departmental Report — What Comes Next" → <sub>(BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROW)</sub>

**Subhead — first draft**

> She Didn't Need to Be Convinced. She Needed to Be Asked.

**Body — first draft**

> President Carlisle asked the spiritual practitioner who had negotiated the earlier arrangement to set up a second meeting — just Carlisle and the intermediary, no DMA personnel. The meeting in the Tennessee highlands lasted ninety minutes. The Bell Witch, the practitioner reports, 'had a great deal to say about how this should have been approached in the first place, and the President listened to all of it without interrupting.' The agreement was reached in the final twenty minutes. Crown-occupied Tennessee now experiences supernatural disruption at a level their garrison commanders describe as 'incompatible with maintained occupancy.' Three Crown units have requested redeployment to locations described as 'anywhere that isn't this.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Bell Witch's Commitment | `standard` | sets flag `prot_07_agreed` | — |
| 2 | The Full Tennessee Alliance | `explicit` | sets flag `prot_07_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_07_AGREE_INTIMATE` — THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL C... — BY MORNING

**Design notes** Sets prot_07_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_SUMMON` — OLD IRONSIDES RETURNS TO SERVICE

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Epic/Supernatural
**Chain** Old Ironsides · position Root
**Art** `old_ironsides` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_08` · priority 1  <sub>`TRIG_024`</sub>

**Subhead — first draft**

> The USS Constitution Has Opinions About King George

**Body — first draft**

> Something moved in Boston Harbor. Something that should not be moving. The hull of the USS Constitution — battered, ancient, unsinkable — has been observed taking position without a crew aboard. Royal Navy vessels report a ship with no sailors that nonetheless fires with perfect accuracy and appears immune to cannon. The Department of Mythological Affairs is calling it motivated. Old Ironsides has always been impossible to sink. It is apparently also impossible to retire.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hail Using Original Flag Codes | `standard` | fires **PROT_08_TAME** immediately | `PROT_08_TAME` |
| 2 | Send a Port Authority Team | `standard` | fires **PROT_08_TAME** immediately | `PROT_08_TAME` |

**Leads to**

- "Hail Using Original Flag Codes" fires `PROT_08_TAME` — OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND — BOSTON HARBOR STABLE
- "Send a Port Authority Team" fires `PROT_08_TAME` — OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND — BOSTON HARBOR STABLE

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 45+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_TAME` — OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND — BOSTON HARBOR STABLE

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Epic/Dry
**Chain** Old Ironsides · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_08_SUMMON` — "Hail Using Original Flag Codes" fires <sub>(OLD IRONSIDES RETURNS TO SERVICE)</sub>
- Chained from `PROT_08_SUMMON` — "Send a Port Authority Team" fires <sub>(OLD IRONSIDES RETURNS TO SERVICE)</sub>

**Subhead — first draft**

> The Ship Has Docked. It Is Waiting. This Is Not Normal Behavior for a Ship.

**Body — first draft**

> The USS Constitution's autonomous operations had been creating navigational hazards for Continental and Crown vessels alike — its targeting was based on criteria no one in naval command could identify. Port authority at Boston, following extended attempts to communicate with an unmanned vessel, established a signal protocol using flag codes dated to the ship's original commissioning. The ship responded to flag signals. This is not something ships do. The port authority has chosen to process this pragmatically. Old Ironsides is docked and waiting. Its guns are loaded.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_08_tame` | `PROT_08_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_08_tame` | `PROT_08_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_08_AGREE` — OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY
- "File the Departmental Report — What Comes Next" → `PROT_08_AGREE` — OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY

**Design notes** Sets prot_08_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_AGREE` — OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Epic/Triumphant
**Chain** Old Ironsides · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_08_TAME` — "Acknowledge the Deescalation" → <sub>(OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND )</sub>
- Chained from `PROT_08_TAME` — "File the Departmental Report — What Comes Next" → <sub>(OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND )</sub>

**Subhead — first draft**

> The Ship Has Its Orders. It Seems to Understand Them.

**Body — first draft**

> The recommissioning ceremony for Old Ironsides was held at Boston Harbor with full naval honors and what the port authority describes as 'an unusually attentive vessel.' President Carlisle addressed the ship directly — her staff noted this without comment and has continued not commenting — and read the commission aloud. When she finished, the ship's bell rang once. The port authority logged this as 'acknowledgment of commission.' Old Ironsides has since operated as the most effective element of the Continental Navy, engaging Crown vessels with targeting precision that no living crew could match. Nobody is asking follow-up questions.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Commission Old Ironsides | `standard` | sets flag `prot_08_agreed` | — |
| 2 | The Full Naval Recommissioning | `explicit` | sets flag `prot_08_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_08_AGREE_INTIMATE` — OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY — BY MORNING

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

- scene nav: "intimate" → `PROT_09_AGREE_INTIMATE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENT... — BY MORNING

**Design notes** Sets prot_09_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_SUMMON` — THE SNALLYGASTER DESCENDS ON MARYLAND

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Quirky/Tense
**Chain** Snallygaster · position Root
**Art** `snallygaster` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_10` · priority 1  <sub>`TRIG_026`</sub>

**Subhead — first draft**

> Half-Reptile Half-Bird Entity Entirely Against the Crown

**Body — first draft**

> Farmers in the Maryland foothills have been locking their doors. The Snallygaster — which German immigrants brought stories of, and which the mountains apparently confirmed — has returned. It has destroyed two Crown supply depots and one strategic bridge, which it appeared to resent personally. The Department of Mythological Affairs notes: Aggressive, territorial, extremely effective. Not trainable in the conventional sense. We are communicating through what we believe is mutual anti-Crown sentiment.

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

- Chained from `PROT_10_SUMMON` — "Establish a Feeding Station" fires <sub>(THE SNALLYGASTER DESCENDS ON MARYLAND)</sub>
- Chained from `PROT_10_SUMMON` — "Approach from the Supply Route" fires <sub>(THE SNALLYGASTER DESCENDS ON MARYLAND)</sub>

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

> The arrangement reached its formal stage when President Carlisle visited the feeding station in Maryland and waited. The creature arrived twenty minutes later, ate approximately four hundred pounds of provisions with efficiency, and then sat down near the President, which the field agent present describes as 'not something I had a protocol for.' The conversation — described by Carlisle as 'nonverbal but extremely clear' — produced a working relationship. Continental supply routes in the Maryland corridor now have zero unexplained losses. Crown supply operations in the same corridor report what their dispatches call 'persistent heavy losses from an unknown source.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Snallygaster's Protection | `standard` | sets flag `prot_10_agreed` | — |
| 2 | The Full Maryland Agreement | `explicit` | sets flag `prot_10_agreed` | — |

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

### `PROT_11_SUMMON` — PAUL REVERE RIDES AGAIN

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Rousing/Supernatural
**Chain** Paul Revere · position Root
**Art** `paul_revere` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_11` · priority 1  <sub>`TRIG_027`</sub>

**Subhead — first draft**

> Midnight Rider Returns for Additional Midnight

**Body — first draft**

> The horse was heard before the rider was seen. Then both were seen: a figure in colonial dress moving at speeds inconsistent with mortality, shouting something at Redcoat outposts. The outposts are gone now. The message, best the Department could reconstruct, was essentially the same as last time. They are here. Wake up. Several Crown officers filed reports describing extreme panic caused by patriotic specter. The Department of Mythological Affairs has awarded Paul Revere the position of Honorary Speed Asset.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Prepare an Updated Map | `standard` | fires **PROT_11_TAME** immediately | `PROT_11_TAME` |
| 2 | Intercept the Route — Gently | `standard` | fires **PROT_11_TAME** immediately | `PROT_11_TAME` |

**Leads to**

- "Prepare an Updated Map" fires `PROT_11_TAME` — PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND — MIDNIGHT RIDES COORDINATED
- "Intercept the Route — Gently" fires `PROT_11_TAME` — PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND — MIDNIGHT RIDES COORDINATED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 60+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_TAME` — PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND — MIDNIGHT RIDES COORDINATED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Warm/Earnest
**Chain** Paul Revere · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_SUMMON` — "Prepare an Updated Map" fires <sub>(PAUL REVERE RIDES AGAIN)</sub>
- Chained from `PROT_11_SUMMON` — "Intercept the Route — Gently" fires <sub>(PAUL REVERE RIDES AGAIN)</sub>

**Subhead — first draft**

> He Was Always Trying to Help. He Needed a Schedule.

**Body — first draft**

> Paul Revere's midnight rides were entirely sincere. The problem was coordination: his warnings went to Continental counterintelligence positions as readily as to Crown ones, routes were not mapped to current fortifications, and his schedule bore no relationship to actual Crown movements. The DMA's integration protocol involved what the lead agent describes as 'a very patient map session.' Revere listened, reviewed the updated intelligence, asked one question through his established communication method, and his subsequent rides have aligned precisely with Crown courier movements. No Continental positions have been alarmed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_11_tame` | `PROT_11_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_11_tame` | `PROT_11_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_11_AGREE` — PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INTELLIGENCE
- "File the Departmental Report — What Comes Next" → `PROT_11_AGREE` — PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INTELLIGENCE

**Design notes** Sets prot_11_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_AGREE` — PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INTELLIGENCE

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Rousing
**Chain** Paul Revere · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_TAME` — "Acknowledge the Deescalation" → <sub>(PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND )</sub>
- Chained from `PROT_11_TAME` — "File the Departmental Report — What Comes Next" → <sub>(PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND )</sub>

**Subhead — first draft**

> He Has Always Been Ready. Now He Knows Where to Go.

**Body — first draft**

> The formal integration of Paul Revere was, remarkably, the simplest alliance in DMA operational history. He arrived at the designated location, sat down with the intelligence brief, reviewed it completely, and looked at the lead agent with what the agent describes as 'the specific expression of someone who has been doing this alone for too long and is relieved to have a map.' He left immediately. The following week included three Crown courier interceptions, two supply depot locations identified in advance, and one alarm raised with thirty minutes for the Continental garrison to prepare. Revere has asked for a better map. A better map has been provided.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Integrate Paul Revere | `standard` | sets flag `prot_11_agreed` | — |
| 2 | The Full Intelligence Alliance | `explicit` | sets flag `prot_11_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_11_AGREE_INTIMATE` — PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INT... — BY MORNING

**Design notes** Sets prot_11_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_SUMMON` — THE LIBERTY BELL RINGS

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Triumphant/Supernatural
**Chain** Liberty Bell · position Root
**Art** `liberty_bell_ring` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_12` · priority 1  <sub>`TRIG_028`</sub>

**Subhead — first draft**

> Philadelphia Hears What It Needed to Hear

**Body — first draft**

> It rang. Nobody touched it. The crack is still there — has always been there, will always be there — and still the sound came. Clear and enormous and somehow carrying to every corner of liberated territory simultaneously. Crown forces in earshot reported what they described as an unwillingness to continue. President Carlisle heard it from Washington. She put down her briefing, walked outside, and stood in the cold for a moment. That, she said finally. That is the point.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Address the Bell Directly | `standard` | fires **PROT_12_TAME** immediately | `PROT_12_TAME` |
| 2 | Establish a Bell Protocol | `standard` | fires **PROT_12_TAME** immediately | `PROT_12_TAME` |

**Leads to**

- "Address the Bell Directly" fires `PROT_12_TAME` — LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC CEASES
- "Establish a Bell Protocol" fires `PROT_12_TAME` — LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC CEASES

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 65+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_TAME` — LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC CEASES

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Liberty Bell · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_SUMMON` — "Address the Bell Directly" fires <sub>(THE LIBERTY BELL RINGS)</sub>
- Chained from `PROT_12_SUMMON` — "Establish a Bell Protocol" fires <sub>(THE LIBERTY BELL RINGS)</sub>

**Subhead — first draft**

> It's Not Ringing at 3 A.M. Anymore. This Is an Improvement.

**Body — first draft**

> Philadelphia had been experiencing what the city's emergency operations office describes as 'irregular patriotic events' — which is how the city officially logs the Liberty Bell ringing without warning at two and three in the morning, producing civilian evacuations and one canal boat running aground during what the captain described as 'a moment of patriotic confusion.' The DMA conducted what the senior member calls 'a direct and surprisingly productive conversation with a bell.' The Bell listened. It has since rung at dawn. It also rang at 6:47 p.m. on a Tuesday, which the DMA categorizes as within acceptable operational parameters.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_12_tame` | `PROT_12_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_12_tame` | `PROT_12_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_12_AGREE` — THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_12_AGREE` — THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC

**Design notes** Sets prot_12_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_AGREE` — THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Triumphant/Intimate
**Chain** Liberty Bell · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_TAME` — "Acknowledge the Deescalation" → <sub>(LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC )</sub>
- Chained from `PROT_12_TAME` — "File the Departmental Report — What Comes Next" → <sub>(LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC )</sub>

**Subhead — first draft**

> It Has Always Been Ringing for the Republic. Now It Knows When to Ring.

**Body — first draft**

> The Liberty Bell does not negotiate in the conventional sense. What it does is respond. President Carlisle went to Independence Hall and stood with the Bell for an hour without talking points. She stood in silence and thought about what she was asking it to do. The Bell rang once at the beginning and once at the end of the hour. The DMA's spiritual analyst believes this constitutes formal agreement. The Bell has since rung exactly when the President needed it to ring — once during a Continental morale crisis, once at the liberation of a key city, and once on a night when Carlisle was reading casualty reports at four in the morning. That last one was just for her. She is grateful for it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Liberty Bell's Commitment | `standard` | sets flag `prot_12_agreed` | — |
| 2 | The Full Independence Hall Accord | `explicit` | sets flag `prot_12_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_12_AGREE_INTIMATE` — THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC — BY MORNING

**Design notes** Sets prot_12_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_SUMMON` — THE GREEN MOUNTAIN GHOST RIDES

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Supernatural/Regional
**Chain** Green Mountain Ghost · position Root
**Art** `green_mountain_ghost` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_13` · priority 1  <sub>`TRIG_029`</sub>

**Subhead — first draft**

> Vermont's Impossible Defender Returns

**Body — first draft**

> The Green Mountain Boys are long dead. Ethan Allen is long dead. The mountain, apparently, is not done with them. Something rides the ridgelines of Vermont at night that leaves no tracks and crosses no roads and is sighted by exactly as many people as believe in it. The Crown detachments in Vermont have been filing retreat requests without specifying the cause. The Department of Mythological Affairs classified the cause as Vermont. This was considered sufficiently explanatory.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Consult Vermont Communities | `standard` | fires **PROT_13_TAME** immediately | `PROT_13_TAME` |
| 2 | Walk the Ridgeline at Dusk | `standard` | fires **PROT_13_TAME** immediately | `PROT_13_TAME` |

**Leads to**

- "Consult Vermont Communities" fires `PROT_13_TAME` — GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA AS NON-HOSTILE
- "Walk the Ridgeline at Dusk" fires `PROT_13_TAME` — GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA AS NON-HOSTILE

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 70+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_TAME` — GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA AS NON-HOSTILE

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Quirky/Regional
**Chain** Green Mountain Ghost · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_SUMMON` — "Consult Vermont Communities" fires <sub>(THE GREEN MOUNTAIN GHOST RIDES)</sub>
- Chained from `PROT_13_SUMMON` — "Walk the Ridgeline at Dusk" fires <sub>(THE GREEN MOUNTAIN GHOST RIDES)</sub>

**Subhead — first draft**

> The Ghost Updated Its Friend/Foe Protocol. This Was Necessary.

**Body — first draft**

> Vermont's spectral irregular force had been engaging Vermont militia units with the same tactical aggression applied to Crown forces. The Vermont militia had been filing incident reports. The DMA field team consulted with Vermont communities who described the situation as 'the Ghost doesn't know who you are yet.' The introduction was arranged through local channels. The Ghost, having received context, withdrew from two contested positions and was subsequently observed operating exclusively in Crown-adjacent territory. Vermont has updated its incident reports accordingly.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_13_tame` | `PROT_13_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_13_tame` | `PROT_13_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_13_AGREE` — GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR THE REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_13_AGREE` — GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR THE REPUBLIC

**Design notes** Sets prot_13_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_AGREE` — GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR THE REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Supernatural/Regional
**Chain** Green Mountain Ghost · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_TAME` — "Acknowledge the Deescalation" → <sub>(GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA )</sub>
- Chained from `PROT_13_TAME` — "File the Departmental Report — What Comes Next" → <sub>(GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA )</sub>

**Subhead — first draft**

> The Mountains Have Always Been His. Now They Are Also Ours.

**Body — first draft**

> President Carlisle drove to the ridge above Brattleboro and stood at the tree line at dusk. The Ghost arrived — not dramatically, just the particular quality of attention the local communities recognize as presence. They stood together. Carlisle asked one question. The Ghost's response, described by the interpreter she brought, was 'the mountains themselves agreeing.' Crown forces in Vermont have begun what their dispatches call 'strategic repositioning' out of terrain they could not operate in. The terrain has not changed. The Ghost has.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Ghost's Protection of Vermont | `standard` | sets flag `prot_13_agreed` | — |
| 2 | The Full Green Mountain Ceremony | `explicit` | sets flag `prot_13_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_13_AGREE_INTIMATE` — GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR T... — BY MORNING

**Design notes** Sets prot_13_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_14_SUMMON` — MOUNT RUSHMORE AWAKENS

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Epic/Satirical
**Chain** Mount Rushmore · position Root
**Art** `rushmore_awakens` (Not Started) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Protector Summon** — protector `PROT_14` · priority 1  <sub>`TRIG_015`</sub>

**Subhead — first draft**

> All Four Have Arrived and They Are Already Arguing

**Body — first draft**

> The granite has cracked. Four enormous presidents have arrived in the emergency situation room. Washington is attempting to chair the meeting. Roosevelt keeps interrupting. Jefferson has raised a philosophical objection that everyone is ignoring. Lincoln is watching Ualani. 'She's better at this than any of us were,' he says. Nobody disagrees.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Let Them Finish | `standard` | fires **PROT_14_TAME** immediately | `PROT_14_TAME` |
| 2 | Gentlemen — One Agenda Item | `standard` | fires **PROT_14_TAME** immediately | `PROT_14_TAME` |

**Leads to**

- "Let Them Finish" fires `PROT_14_TAME` — MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSUS — DEBATES FORMALIZED
- "Gentlemen — One Agenda Item" fires `PROT_14_TAME` — MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSUS — DEBATES FORMALIZED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 75+; kinky_lewd gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_14_TAME` — MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSUS — DEBATES FORMALIZED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Epic/Satirical
**Chain** Mount Rushmore · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_14_SUMMON` — "Let Them Finish" fires <sub>(MOUNT RUSHMORE AWAKENS)</sub>
- Chained from `PROT_14_SUMMON` — "Gentlemen — One Agenda Item" fires <sub>(MOUNT RUSHMORE AWAKENS)</sub>

**Subhead — first draft**

> They Have Agreed to Disagree Quietly. This Is Progress.

**Body — first draft**

> The four stone presidents had been engaged in what the DMA's report describes as 'a continuous and very loud policy discussion that does not account for the acoustic impact on the surrounding region.' Washington attempted to chair. Roosevelt continued interrupting. Jefferson raised structural objections. Lincoln sat quietly and looked troubled. The civilian disruption from four very large men arguing about constitutional theory at unreasonable volume had reached the level of a formal noise ordinance complaint filed with no one in particular. The DMA intervention imposed one agenda item and a strict time limit. The debates are now held in session. The volume has decreased. The topics have not.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_14_tame` | `PROT_14_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_14_tame` | `PROT_14_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_14_AGREE` — THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CARLISLE
- "File the Departmental Report — What Comes Next" → `PROT_14_AGREE` — THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CARLISLE

**Design notes** Sets prot_14_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_14_AGREE` — THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CARLISLE

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Epic/Satirical
**Chain** Mount Rushmore · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `kinky` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_14_TAME` — "Acknowledge the Deescalation" → <sub>(MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSU)</sub>
- Chained from `PROT_14_TAME` — "File the Departmental Report — What Comes Next" → <sub>(MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSU)</sub>

**Subhead — first draft**

> They Came to a Vote. The Vote Was Unanimous. Lincoln Broke the Tie.

**Body — first draft**

> The four stone presidents convened for a final session on the matter of President Ualani Carlisle's administration. Washington presented the case. Roosevelt called it excellent and interrupted three times. Jefferson raised a procedural objection that was noted, recorded, and overruled. Lincoln, who had been quiet throughout, spoke last. His remarks were brief — the DMA transcript records approximately fourteen words — and produced immediate consensus. The formal endorsement was made in the manner available to entities made of granite: each looked at her for a sustained moment and she looked back. Lincoln's sustained moment was the longest. The endorsement stands.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Rushmore Endorsement | `standard` | sets flag `prot_14_agreed` | — |
| 2 | The Complete Presidential Council | `kinky_lewd` | sets flag `prot_14_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_14_AGREE_INTIMATE` — THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CAR... — BY MORNING

**Design notes** Sets prot_14_agreed; BTN2 kinky_lewd gated

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

### `PROT_16_SUMMON` — THE MINUTEMAN IS READY

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Rousing/Supernatural
**Chain** Minuteman · position Root
**Art** `eternal_minuteman` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_16` · priority 1  <sub>`TRIG_031`</sub>

**Subhead — first draft**

> Lexington Calls Once More

**Body — first draft**

> They said it took a minute's notice. This one took less. The figure appeared on Lexington Green at dawn — musket ready, coat grey with something that might be dust or might be years — and looked east toward the Crown lines, and then looked back at President Carlisle's representatives, and seemed to be asking a question whose answer was already known. Ready. Always ready. The shot that started this the first time still echoes here. The Department of Mythological Affairs is calling this one home.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Approach on Foot — No Weapons Visible | `standard` | fires **PROT_16_TAME** immediately | `PROT_16_TAME` |
| 2 | Present Your Continental Commission | `standard` | fires **PROT_16_TAME** immediately | `PROT_16_TAME` |

**Leads to**

- "Approach on Foot — No Weapons Visible" fires `PROT_16_TAME` — THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — LEXINGTON GREEN ACCESS RESTORED
- "Present Your Continental Commission" fires `PROT_16_TAME` — THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — LEXINGTON GREEN ACCESS RESTORED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 85+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_TAME` — THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — LEXINGTON GREEN ACCESS RESTORED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Rousing
**Chain** Minuteman · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_16_SUMMON` — "Approach on Foot — No Weapons Visible" fires <sub>(THE MINUTEMAN IS READY)</sub>
- Chained from `PROT_16_SUMMON` — "Present Your Continental Commission" fires <sub>(THE MINUTEMAN IS READY)</sub>

**Subhead — first draft**

> He Wasn't Going to Stand Down for Anyone. He Did Anyway.

**Body — first draft**

> The eternal Minuteman at Lexington had been challenging every military unit approaching the Green — Continental, Crown, civilian militia — with what witnesses describe as 'extremely focused attention and an expression that suggests the concept of surrender has not entered his operational framework.' Three Continental units had been turned back. The DMA's recommendation was that a senior officer approach on foot alone, without visible weapons, in formal Continental uniform. The officer who performed this approach filed a report consisting primarily of: 'He looked at me for a long time and then stepped aside.' Access to Lexington Green has been restored.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_16_tame` | `PROT_16_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_16_tame` | `PROT_16_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_16_AGREE` — THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL REPUBLIC
- "File the Departmental Report — What Comes Next" → `PROT_16_AGREE` — THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL REPUBLIC

**Design notes** Sets prot_16_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_AGREE` — THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL REPUBLIC

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Rousing/Serious
**Chain** Minuteman · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_16_TAME` — "Acknowledge the Deescalation" → <sub>(THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — )</sub>
- Chained from `PROT_16_TAME` — "File the Departmental Report — What Comes Next" → <sub>(THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — )</sub>

**Subhead — first draft**

> He Said One Thing. It Was Enough.

**Body — first draft**

> The formal declaration came at Lexington Green at dawn. President Carlisle arrived early and stood on the Green and waited. He came at first light from the direction of the old battle position, musket ready, in the posture witnesses describe as 'someone who has never once been unprepared for anything.' She did not speak first. He did. The DMA transcript records three sentences. Two were about the Republic. One was about her specifically. Her aide, present against instructions, describes it as 'the most direct presidential endorsement I have ever heard.' The Minuteman has formally declared the Continental Army as his army and President Carlisle as his President.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Minuteman's Declaration | `standard` | sets flag `prot_16_agreed` | — |
| 2 | The Full Lexington Green Ceremony | `explicit` | sets flag `prot_16_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_16_AGREE_INTIMATE` — THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL ... — BY MORNING

**Design notes** Sets prot_16_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_SUMMON` — LINCOLN'S GHOST APPEARS IN WASHINGTON

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Serious/Supernatural
**Chain** Lincoln's Ghost · position Root
**Art** `lincolns_ghost` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- **Protector Summon** — protector `PROT_17` · priority 1  <sub>`TRIG_032`</sub>

**Subhead — first draft**

> The President Has an Appointment

**Body — first draft**

> He has been here since 1865. The building knows. The rooms remember. Lincoln does not haunt Washington the way stories say haunting works — he sits in the hard chairs and reads the difficult briefings and sometimes appears at Ualani Carlisle's office door at two in the morning to say something useful about losing things that matter. The arc of history, he said last Tuesday, looking out at the occupation. Bends toward justice. Pause. This is the bending part. He does not seem worried. This helps.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Clear Your Thursday Evening | `standard` | fires **PROT_17_TAME** immediately | `PROT_17_TAME` |
| 2 | Leave the Light On in the Executive Quarters | `standard` | fires **PROT_17_TAME** immediately | `PROT_17_TAME` |

**Leads to**

- "Clear Your Thursday Evening" fires `PROT_17_TAME` — LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESIDENTIAL SCHEDULE RESTORED
- "Leave the Light On in the Executive Quarters" fires `PROT_17_TAME` — LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESIDENTIAL SCHEDULE RESTORED

**Design notes** Wild: +1 corruption/turn 25% chance; fires turn 90+

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_TAME` — LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESIDENTIAL SCHEDULE RESTORED

**Status** FIRST PASS · **Type** `protector_tame` · **Country** `USA` · **Tone** Serious/Intimate
**Chain** Lincoln's Ghost · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_17_SUMMON` — "Clear Your Thursday Evening" fires <sub>(LINCOLN'S GHOST APPEARS IN WASHINGTON)</sub>
- Chained from `PROT_17_SUMMON` — "Leave the Light On in the Executive Quarters" fires <sub>(LINCOLN'S GHOST APPEARS IN WASHINGTON)</sub>

**Subhead — first draft**

> He's Still Here. He Now Knocks.

**Body — first draft**

> Abraham Lincoln's ghost had been appearing in the White House executive quarters at two and three in the morning regardless of scheduling, affecting President Carlisle's operational capacity in a way the press secretary categorized as 'a situation we are not equipped to communicate publicly.' The DMA's solution was endorsed by the President personally: she sat down with Lincoln for two hours, listened without interruption, and asked two questions. Lincoln, the President told her senior staff, 'had been trying to say something for a long time and needed someone to actually listen.' He now appears at scheduled intervals. He knocks. The President has cleared Thursday evenings.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Deescalation | `standard` | sets flag `prot_17_tame` | `PROT_17_AGREE` |
| 2 | File the Departmental Report — What Comes Next | `standard` | sets flag `prot_17_tame` | `PROT_17_AGREE` |

**Leads to**

- "Acknowledge the Deescalation" → `PROT_17_AGREE` — LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMINISTRATION
- "File the Departmental Report — What Comes Next" → `PROT_17_AGREE` — LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMINISTRATION

**Design notes** Sets prot_17_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_AGREE` — LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMINISTRATION

**Status** FIRST PASS · **Type** `protector_agree` · **Country** `USA` · **Tone** Serious/Triumphant
**Chain** Lincoln's Ghost · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `PROT_17_TAME` — "Acknowledge the Deescalation" → <sub>(LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESI)</sub>
- Chained from `PROT_17_TAME` — "File the Departmental Report — What Comes Next" → <sub>(LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESI)</sub>

**Subhead — first draft**

> He Has Been Waiting to Say This Since 1865.

**Body — first draft**

> The formal endorsement meeting took place on a Thursday evening, as scheduled. Lincoln arrived on time. He sat across from Carlisle at the long table in the executive quarters and told her, for the first time without interruption or qualification, what he had been trying to tell every president who passed through these rooms since his own presidency ended. What he said is in her personal record, not the public record, because it was meant for her. What she has shared: he told her the arc bends toward justice. He said this is the bending. He said she is exactly who the Republic needs for this specific moment. He said he has not been this certain about something since the Emancipation Proclamation.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Lincoln's Endorsement | `standard` | sets flag `prot_17_agreed` | — |
| 2 | The Full Presidential Consultation | `explicit` | sets flag `prot_17_agreed` | — |

**Leads to**

- scene nav: "intimate" → `PROT_17_AGREE_INTIMATE` — LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMIN... — BY MORNING

**Design notes** Sets prot_17_agreed; BTN2 explicit gated

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_01_AGREE_INTIMATE` — MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Mothman · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_01_AGREE` — scene nav: "intimate" from <sub>(MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REP)</sub>

**Subhead — first draft**

> The Agreement Required No Words. The Words Came Anyway.

**Body — first draft**

> [INTIMATE STUB — PROT_01_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_01_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_02_AGREE_INTIMATE` — JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Jersey Devil · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_02_AGREE` — scene nav: "intimate" from <sub>(JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL C)</sub>

**Subhead — first draft**

> New Jersey's Most Complicated Asset Has Chosen a Side.

**Body — first draft**

> [INTIMATE STUB — PROT_02_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_02_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_03_AGREE_INTIMATE` — BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUG... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Bigfoot · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_03_AGREE` — scene nav: "intimate" from <sub>(BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE TH)</sub>

**Subhead — first draft**

> He Doesn't Speak. He Moves. That Is Communication.

**Body — first draft**

> [INTIMATE STUB — PROT_03_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_03_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_04_AGREE_INTIMATE` — THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REP... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Thunderbird · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_04_AGREE` — scene nav: "intimate" from <sub>(THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL)</sub>

**Subhead — first draft**

> The Sky Has Taken a Side. This Is Historically Unusual.

**Body — first draft**

> [INTIMATE STUB — PROT_04_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_04_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_05_AGREE_INTIMATE` — THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Headless Horseman · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_05_AGREE` — scene nav: "intimate" from <sub>(THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY)</sub>

**Subhead — first draft**

> He Was Always Going to Choose a Side. She Just Had to Ask.

**Body — first draft**

> [INTIMATE STUB — PROT_05_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_05_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_06_AGREE_INTIMATE` — CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Chessie · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_06_AGREE` — scene nav: "intimate" from <sub>(CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAV)</sub>

**Subhead — first draft**

> The Chesapeake Has Chosen. The Bay Knows Whose Side It Is On.

**Body — first draft**

> [INTIMATE STUB — PROT_06_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_06_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_07_AGREE_INTIMATE` — THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL C... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Bell Witch · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_07_AGREE` — scene nav: "intimate" from <sub>(THE BELL WITCH FORMALLY COMMITS TO THE CONTINENT)</sub>

**Subhead — first draft**

> She Didn't Need to Be Convinced. She Needed to Be Asked.

**Body — first draft**

> [INTIMATE STUB — PROT_07_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_07_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_08_AGREE_INTIMATE` — OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Old Ironsides · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_08_AGREE` — scene nav: "intimate" from <sub>(OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAV)</sub>

**Subhead — first draft**

> The Ship Has Its Orders. It Seems to Understand Them.

**Body — first draft**

> [INTIMATE STUB — PROT_08_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_08_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_09_AGREE_INTIMATE` — VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENT... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Valley Forge Guardian · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_09_AGREE` — scene nav: "intimate" from <sub>(VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTI)</sub>

**Subhead — first draft**

> The Ground Accepted Her Army. That Is Not a Small Thing.

**Body — first draft**

> [INTIMATE STUB — PROT_09_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_09_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_10_AGREE_INTIMATE` — SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY ... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Snallygaster · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_10_AGREE` — scene nav: "intimate" from <sub>(SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUP)</sub>

**Subhead — first draft**

> It Has Stopped Eating Our Supplies. It Has Started Eating Theirs.

**Body — first draft**

> [INTIMATE STUB — PROT_10_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_10_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_11_AGREE_INTIMATE` — PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INT... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Paul Revere · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_11_AGREE` — scene nav: "intimate" from <sub>(PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL)</sub>

**Subhead — first draft**

> He Has Always Been Ready. Now He Knows Where to Go.

**Body — first draft**

> [INTIMATE STUB — PROT_11_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_11_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_12_AGREE_INTIMATE` — THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Liberty Bell · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_12_AGREE` — scene nav: "intimate" from <sub>(THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC)</sub>

**Subhead — first draft**

> It Has Always Been Ringing for the Republic. Now It Knows When to Ring.

**Body — first draft**

> [INTIMATE STUB — PROT_12_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_12_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_13_AGREE_INTIMATE` — GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR T... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Green Mountain Ghost · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_13_AGREE` — scene nav: "intimate" from <sub>(GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT F)</sub>

**Subhead — first draft**

> The Mountains Have Always Been His. Now They Are Also Ours.

**Body — first draft**

> [INTIMATE STUB — PROT_13_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_13_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_14_AGREE_INTIMATE` — THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CAR... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Mount Rushmore · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_14_AGREE` — scene nav: "intimate" from <sub>(THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT)</sub>

**Subhead — first draft**

> They Came to a Vote. The Vote Was Unanimous. Lincoln Broke the Tie.

**Body — first draft**

> [INTIMATE STUB — PROT_14_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_14_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_15_AGREE_INTIMATE` — SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENT... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Skunk Ape · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_15_AGREE` — scene nav: "intimate" from <sub>(SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTI)</sub>

**Subhead — first draft**

> The Swamp Is His. The Republic Is Grateful.

**Body — first draft**

> [INTIMATE STUB — PROT_15_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_15_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_16_AGREE_INTIMATE` — THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL ... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Minuteman · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_16_AGREE` — scene nav: "intimate" from <sub>(THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINEN)</sub>

**Subhead — first draft**

> He Said One Thing. It Was Enough.

**Body — first draft**

> [INTIMATE STUB — PROT_16_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_16_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PROT_17_AGREE_INTIMATE` — LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMIN... — BY MORNING

**Status** IDEA · **Type** `protector_agree` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Lincoln's Ghost · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PROT_17_AGREE` — scene nav: "intimate" from <sub>(LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S A)</sub>

**Subhead — first draft**

> He Has Been Waiting to Say This Since 1865.

**Body — first draft**

> [INTIMATE STUB — PROT_17_AGREE] The protector agreement, quieter. Write the 'By morning' version: the moment of accord without the explicit scene. The weight of what was agreed to. What it feels like when something that old decides to trust something this new. Emotional arc present. No explicit imagery. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PROT_17_AGREE. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
