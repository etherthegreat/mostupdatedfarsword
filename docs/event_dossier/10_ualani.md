# Ualani

18 events · FIRST PASS 10 · IDEA 8

[← back to index](00_INDEX.md)

---

### `UALANI_AMBUSH_01` — CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS THE WETLANDS

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Ambush · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:52`, `Game Scenes and Scripts/world.gd:3142`, `Game Scenes and Scripts/world.gd:3151`, `Game Scenes and Scripts/world.gd:3152`

**Subhead — first draft**

> Ualani Was Already There. The Crown Did Not Know That.

**Body — first draft**

> Crown scouts selected [TILE_NAME] for an ambush with what intelligence reports describe as 'reasonable confidence the area was unoccupied.' This confidence was incorrect. President Carlisle's army was already in position. The scouts learned this in sequence: first the outriders, then the main unit, then the entire Crown element, each arriving at the same conclusion approximately seven minutes after the one before them. The President did not appear to find the encounter surprising. She appeared, witnesses report, to have been waiting for it. The wetlands absorbed the skirmish with the particular neutrality of terrain that has seen worse. The Crown force has withdrawn to file a report that will require significant creative editing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Fortify the Perimeter | `standard` | weapons +25 | — |
| 2 | Rally the Defense | `standard` | morale +25 | — |
| 3 | The Full Counteroffensive Briefing | `explicit` | weapons +40 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_AMBUSH_01_INTIMATE` — CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS THE W... — BY MORNING

**Design notes** Ualani in Wetlands + UK neighbor; BTN3 explicit +weapons 40

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_DIGNITARY_01` — STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLISLE ATTENDS IN FULL CAPACITY

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Formal/Warm
**Chain** Dignitary Reception · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 18 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:59`, `Game Scenes and Scripts/world.gd:3157`, `Game Scenes and Scripts/world.gd:3173`, `Game Scenes and Scripts/world.gd:3174`

**Subhead — first draft**

> The Courthouse Has Never Looked This Good.

**Body — first draft**

> The civic officials of [TILE_NAME] have organized a reception at the courthouse with the particular energy of people who have access to the President and intend to use it. The guest list includes three magistrates, the head of the local chamber of commerce, a representative from the Continental treasury office, and — by what appears to be an administrative scheduling error — the woman who runs the town's most successful bakery, who is not backing down. President Carlisle arrived in full presidential capacity. The courthouse has been cleaned. There are flowers. [COMMANDER_NAME] is attempting to look like this was planned.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the State Commendation | `standard` | claim → `` +2 | — |
| 2 | Deliver Brief Remarks | `standard` | claim → `` +1 | — |
| 3 | The Full Presidential Reception | `explicit` | tile moral decay -20 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_DIGNITARY_01_INTIMATE` — STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLISLE A... — BY MORNING

**Design notes** Ualani in Metro/Suburbs + Courthouse + tileMoralDecay < 30; BTN3 explicit -20 moralDecay

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_MEMORIAL_01` — PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENTIAL ADDRESS AT THE MEMORIAL

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Rousing/Serious
**Chain** Memorial Address · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 20 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:66`, `Game Scenes and Scripts/world.gd:3179`, `Game Scenes and Scripts/world.gd:3186`, `Game Scenes and Scripts/world.gd:3187`

**Subhead — first draft**

> The Ground Has History. The President Has Remarks.

**Body — first draft**

> [TILE_NAME] has been on the presidential itinerary since the Republic's founding — a site that the nation considers important enough to protect twice and apparently to argue about between protections. President Carlisle walked the ground before anyone knew she was there. The early morning light caught the memorial stones in a way the official photographer noted as 'extremely usable.' She stood with [COMMANDER_NAME] for what witnesses describe as a long moment of mutual silence that communicated considerably more than most official statements. When she spoke it was brief, historically accurate, and made three soldiers cry. The address will be distributed across liberated territory.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Deliver the Presidential Address | `standard` | morale +40 | — |
| 2 | Stand in Witness | `standard` | claim → `` +1 | — |
| 3 | The Full Memorial Ceremony | `explicit` | morale +50 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_MEMORIAL_01_INTIMATE` — PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENTIAL ... — BY MORNING

**Design notes** Ualani at tile with tileSpecialFeatures; BTN3 explicit +morale 50

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_WOUNDED_01` — PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Serious
**Chain** Field Hospital · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 12 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:73`, `Game Scenes and Scripts/world.gd:3192`, `Game Scenes and Scripts/world.gd:3202`, `Game Scenes and Scripts/world.gd:3203`

**Subhead — first draft**

> She Knew Their Names. That Is Not an Expression.

**Body — first draft**

> The field hospital at [TILE_NAME] was not on the official schedule. President Carlisle arrived between two meetings that were on the official schedule, which her press secretary is describing as 'a logistical interlude' and the soldiers are describing as 'the President walked in at four in the morning and sat down and talked to us for two hours.' She knew their names. This is not a metaphor or an embellishment for the historical record — she had read the casualty reports, she remembered the names, and she used them. [COMMANDER_NAME] reports that the army's morale has changed in a way that does not show up in any metric the Continental Army has developed but that everyone in the tent understood immediately.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Walk the Wards — Address the Wounded | `standard` | morale +35 | — |
| 2 | Full Field Hospital Authorization | `explicit` | manpower +40 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_WOUNDED_01_INTIMATE` — PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TILE_NAME] — BY MORNING

**Design notes** Ualani army < 80% manpower; BTN2 explicit +manpower 40

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_WINTER_01` — PRESIDENT CARLISLE MARCHES THROUGH [TILE_NAME] IN THE DEAD OF WINTER

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Rousing/Somber
**Chain** Winter March · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `sensual` · **Repeatable** 20 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:80`, `Game Scenes and Scripts/world.gd:3209`, `Game Scenes and Scripts/world.gd:3220`, `Game Scenes and Scripts/world.gd:3221`

**Subhead — first draft**

> Washington Did It Once. The Precedent Is Established.

**Body — first draft**

> The winter at [TILE_NAME] has been described by the quartermaster as 'technically survivable, in the sense that we have not stopped surviving it.' The terrain is frozen. The army's boots are insufficient for the terrain and their morale is insufficient for the temperature and both of these things were true before President Carlisle arrived. She arrived at dawn with no announcement, wearing what appeared to be the same coat she wore to the State of the Republic address. She walked the perimeter. She addressed the troops by the fire. Her remarks were not uplifting in the conventional sense — they were true, which the troops have later described as considerably more useful than uplifting. By the time the sun was fully up the army had decided to stay.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The Winter Address — Hold the Line | `standard` | claim → `` +2 | — |
| 2 | Station Fires and Distribute Rations | `standard` | morale +20 | — |

**Design notes** Ualani in Foothills/Woods; winter months [11,12,1,2]; winterScore > 0; no explicit

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FORGE_01` — PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION OF FORGE AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Energetic
**Chain** Forge Inspection · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:87`, `Game Scenes and Scripts/world.gd:3226`, `Game Scenes and Scripts/world.gd:3238`, `Game Scenes and Scripts/world.gd:3239`

**Subhead — first draft**

> Production Numbers Were Good. The President Made Them Better.

**Body — first draft**

> The forge at [TILE_NAME] runs on coal, iron, and the particular institutional stubbornness of people who have been doing this for twenty years. President Carlisle's arrival was not announced. She appeared in the facility with [COMMANDER_NAME] at the hour the day shift begins and proceeded to ask the sort of questions that indicate she has read every supply ledger, production manifest, and complaint filed in the past six months. The workers found this alarming and then gradually not alarming at all. She understood what they were building. She understood why it mattered. She stayed through the full shift change. Production output, the forge supervisor filed in a report the following morning, had increased by what he called 'an amount attributable to presidential interest in the process.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Full Production Authorization | `standard` | weapons +40 | — |
| 2 | Civilian Oversight Committee | `standard` | tile moral decay -15 | — |
| 3 | The Full Forge Inspection | `explicit` | weapons +60 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_FORGE_01_INTIMATE` — PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION OF F... — BY MORNING

**Design notes** Ualani at tile with enabled Forge; BTN3 explicit +weapons 60

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_CULPER_01` — CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE ASSET REQUESTS MEETING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Tense/Serious
**Chain** Culper Ring · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 18 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:94`, `Game Scenes and Scripts/world.gd:3244`, `Game Scenes and Scripts/world.gd:3251`, `Game Scenes and Scripts/world.gd:3252`

**Subhead — first draft**

> The Message Arrived With No Signature. She Knew Who Sent It.

**Body — first draft**

> A contact associated with the Culper Ring — the Continental intelligence network that operates through couriers, civilians, and what the Department of Intelligence calls 'a remarkable willingness of ordinary people to notice things' — has requested a meeting at [TILE_NAME]. The request was delivered via a method the intelligence office describes as 'the usual one' and declines to specify further. The contact has information on Crown activities in the adjacent territory. The asset is aware that [TILE_NAME] borders compromised ground. President Carlisle is in position. This is not a coincidence.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Full Intelligence Brief | `standard` | reveals tiles | `UALANI_CULPER_BRIEF_01` |
| 2 | Compensate the Asset | `standard` | gold +15 | — |
| 3 | The Full Culper Meeting | `explicit` | gold +40 | `UALANI_CULPER_BRIEF_01` |

**Leads to**

- "Accept the Full Intelligence Brief" → `UALANI_CULPER_BRIEF_01` — CULPER RING INTELLIGENCE RECEIVED: CROWN PLANS CONFIRMED
- "The Full Culper Meeting" → `UALANI_CULPER_BRIEF_01` — CULPER RING INTELLIGENCE RECEIVED: CROWN PLANS CONFIRMED
- scene nav: "intimate" → `UALANI_CULPER_01_INTIMATE` — CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE ASS... — BY MORNING

**Design notes** Ualani neighbors tile with espionageActive; BTN3 explicit +gold 40 then brief

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_CULPER_BRIEF_01` — CULPER RING INTELLIGENCE RECEIVED: CROWN PLANS CONFIRMED

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Serious/Tense
**Chain** Culper Ring · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `sensual` · **Repeatable** 0 · **Cooldown** 0

**Fires when**

- Chained from `UALANI_CULPER_01` — "Accept the Full Intelligence Brief" → <sub>(CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE)</sub>
- Chained from `UALANI_CULPER_01` — "The Full Culper Meeting" → <sub>(CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE)</sub>

**Subhead — first draft**

> The Asset Delivered. The Map Is Different Now.

**Body — first draft**

> The Culper contact's information has been verified against three independent sources and confirmed. Crown operations in the adjacent territory are larger than the initial assessment suggested — and their timeline is shorter. The intelligence map has been updated. The President's strategic options have been updated accordingly. The Culper Ring asset has been extracted to a safe house. Their name is not in this report. Their name is not in any report. That is why they are still alive.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Activate the Culper Ring | `standard` | sets flag `culper_active` | — |

**Design notes** Sets culper_active flag; single button; no explicit

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_ALLIANCE_01` — PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Alliance Council · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 18 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:108`, `Game Scenes and Scripts/world.gd:3257`, `Game Scenes and Scripts/world.gd:3276`, `Game Scenes and Scripts/world.gd:3277`

**Subhead — first draft**

> An Alliance Was Discussed. The Discussion Went Well.

**Body — first draft**

> [COMMANDER_NAME] requested the meeting. This in itself was significant — the independent governors of the eastern territories do not typically ask for presidential audiences, and certainly not on short notice, and certainly not with the particular tone of the message that arrived, which the President's chief of staff described as 'urgent, respectful, and aware that it is urgent and respectful for a reason.' President Carlisle met with [COMMANDER_NAME] at [TILE_NAME] with her army standing at a professionally measured distance. The conversation was by all accounts candid. The Continental cause needs allies who govern territory. [COMMANDER_NAME] governs territory. The math is not complicated.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Alliance | `standard` | governor loyalty `` +6 | — |
| 2 | Acknowledge the Offer | `standard` | claim → `` +1 | — |
| 3 | The Full Alliance Council | `explicit` | governor loyalty `` +12 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_ALLIANCE_01_INTIMATE` — PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] AT [T... — BY MORNING

**Design notes** Fires at NEIGHBOR tile (named hist. governor); BTN3 explicit governor_loyalty +12

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FRONTIER_01` — PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Rousing/Dry
**Chain** Frontier · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 20 · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:115`, `Game Scenes and Scripts/world.gd:3283`, `Game Scenes and Scripts/world.gd:3292`, `Game Scenes and Scripts/world.gd:3293`

**Subhead — first draft**

> The Northern Edge of the Republic. She Walked It.

**Body — first draft**

> [TILE_NAME] sits at the boundary where Continental sovereignty makes a statement and Canadian colonial administration files a diplomatic objection. President Carlisle walked the frontier line with her army in a gesture that was simultaneously ceremonial and tactically meaningful — Crown and Canadian observers have been informed that the territory has a presidential presence, and that the presence arrived with an army, and that the army appears comfortable in the terrain. The proclamation was brief. It cited the Republic's founding documents, the history of the territory, and the particular American tradition of showing up at a frontier and describing it as already yours.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Frontier Proclamation — Assert Continental Sovereignty | `standard` | claim → `` +3 | — |
| 2 | Survey the Frontier | `standard` | reveals tiles | — |
| 3 | The Full Frontier Address | `explicit` | morale +30 | — |

**Leads to**

- scene nav: "intimate" → `UALANI_FRONTIER_01_INTIMATE` — PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE AT ... — BY MORNING

**Design notes** Ualani in Woods/Foothills bordering CA - * tile; BTN3 explicit +morale 30

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_AMBUSH_01_INTIMATE` — CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS THE W... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Ambush · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_AMBUSH_01` — scene nav: "intimate" from <sub>(CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS T)</sub>

**Subhead — first draft**

> Ualani Was Already There. The Crown Did Not Know That.

**Body — first draft**

> [INTIMATE STUB — UALANI_AMBUSH_01] Ualani personal arc — intimate version of: CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS THE WETLANDS. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_AMBUSH_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_DIGNITARY_01_INTIMATE` — STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLISLE A... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Dignitary Reception · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_DIGNITARY_01` — scene nav: "intimate" from <sub>(STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLIS)</sub>

**Subhead — first draft**

> The Courthouse Has Never Looked This Good.

**Body — first draft**

> [INTIMATE STUB — UALANI_DIGNITARY_01] Ualani personal arc — intimate version of: STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLISLE ATTENDS IN FULL CAPACITY. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_DIGNITARY_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_MEMORIAL_01_INTIMATE` — PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENTIAL ... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Memorial Address · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_MEMORIAL_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENT)</sub>

**Subhead — first draft**

> The Ground Has History. The President Has Remarks.

**Body — first draft**

> [INTIMATE STUB — UALANI_MEMORIAL_01] Ualani personal arc — intimate version of: PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENTIAL ADDRESS AT THE MEMORIAL. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_MEMORIAL_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_WOUNDED_01_INTIMATE` — PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TILE_NAME] — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Field Hospital · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_WOUNDED_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TIL)</sub>

**Subhead — first draft**

> She Knew Their Names. That Is Not an Expression.

**Body — first draft**

> [INTIMATE STUB — UALANI_WOUNDED_01] Ualani personal arc — intimate version of: PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TILE_NAME]. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_WOUNDED_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FORGE_01_INTIMATE` — PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION OF F... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Forge Inspection · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_FORGE_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION )</sub>

**Subhead — first draft**

> Production Numbers Were Good. The President Made Them Better.

**Body — first draft**

> [INTIMATE STUB — UALANI_FORGE_01] Ualani personal arc — intimate version of: PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION OF FORGE AT [TILE_NAME]. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_FORGE_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_CULPER_01_INTIMATE` — CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE ASS... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Culper Ring · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_CULPER_01` — scene nav: "intimate" from <sub>(CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE)</sub>

**Subhead — first draft**

> The Message Arrived With No Signature. She Knew Who Sent It.

**Body — first draft**

> [INTIMATE STUB — UALANI_CULPER_01] Ualani personal arc — intimate version of: CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE ASSET REQUESTS MEETING. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_CULPER_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_ALLIANCE_01_INTIMATE` — PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] AT [T... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Alliance Council · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_ALLIANCE_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] A)</sub>

**Subhead — first draft**

> An Alliance Was Discussed. The Discussion Went Well.

**Body — first draft**

> [INTIMATE STUB — UALANI_ALLIANCE_01] Ualani personal arc — intimate version of: PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] AT [TILE_NAME]. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_ALLIANCE_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FRONTIER_01_INTIMATE` — PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE AT ... — BY MORNING

**Status** IDEA · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Frontier · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_FRONTIER_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE)</sub>

**Subhead — first draft**

> The Northern Edge of the Republic. She Walked It.

**Body — first draft**

> [INTIMATE STUB — UALANI_FRONTIER_01] Ualani personal arc — intimate version of: PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE AT [TILE_NAME]. Write the version where the relationship advances through presence and conversation rather than explicit action. What she says. What she doesn't say. What changes. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of UALANI_FRONTIER_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
