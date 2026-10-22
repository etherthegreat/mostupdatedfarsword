# Ualani

18 events · FIRST PASS 18

[← back to index](00_INDEX.md)

---

### `UALANI_AMBUSH_01` — CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS THE WETLANDS

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** Ambush · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4011`, `Game Scenes and Scripts/world.gd:4020`, `Game Scenes and Scripts/world.gd:4021`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4026`, `Game Scenes and Scripts/world.gd:4042`, `Game Scenes and Scripts/world.gd:4043`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4048`, `Game Scenes and Scripts/world.gd:4055`, `Game Scenes and Scripts/world.gd:4056`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4061`, `Game Scenes and Scripts/world.gd:4071`, `Game Scenes and Scripts/world.gd:4072`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4078`, `Game Scenes and Scripts/world.gd:4089`, `Game Scenes and Scripts/world.gd:4090`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4095`, `Game Scenes and Scripts/world.gd:4107`, `Game Scenes and Scripts/world.gd:4108`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4113`, `Game Scenes and Scripts/world.gd:4120`, `Game Scenes and Scripts/world.gd:4121`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4126`, `Game Scenes and Scripts/world.gd:4145`, `Game Scenes and Scripts/world.gd:4146`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4152`, `Game Scenes and Scripts/world.gd:4161`, `Game Scenes and Scripts/world.gd:4162`

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

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Ambush · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_AMBUSH_01` — scene nav: "intimate" from <sub>(CROWN AMBUSH AVERTED: PRESIDENT CARLISLE HOLDS T)</sub>

**Subhead — first draft**

> Ualani Was Already There. The Crown Did Not Know That.

**Body — first draft**

> The Crown's assessment of [TILE_NAME] as unoccupied had been, in [COMMANDER_NAME]'s words, a navigable error. Ualani asked what made it navigable. [COMMANDER_NAME] said: we were already here. She found this answer professionally satisfying and personally funnier than she expected given that they had just repelled an ambush. The wetlands at dusk have a quality that intelligence reports do not capture — the way the light goes horizontal and turns everything the color of old bronze. They stood at the tree line. The Crown element was gone. The ground had absorbed what the ground absorbs. [COMMANDER_NAME] said something she did not expect — not tactical, not an after-action report. Something personal. Something about what it had been like to watch her hold position when the first contact hit. She did not say: I have held position before. She said what she actually thought, which was quieter and more specific and which she will not have recorded here. [COMMANDER_NAME] did not say anything for a moment. Then [COMMANDER_NAME] said: I know. Which turned out to be exactly the right thing to say. The wetlands continued doing what they do. The light went gold and then gray. What changed between them is not in any field report and is not the Crown's business.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; wetlands dusk scene; bronze light, the right reply

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_DIGNITARY_01_INTIMATE` — STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLISLE A... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Dignitary Reception · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_DIGNITARY_01` — scene nav: "intimate" from <sub>(STATE RECEPTION AT [TILE_NAME]: PRESIDENT CARLIS)</sub>

**Subhead — first draft**

> The Courthouse Has Never Looked This Good.

**Body — first draft**

> The baker had not left. This was established late in the evening when the magistrates and the treasury official had all filed out and [COMMANDER_NAME] attempted a headcount and found the number short by one. She was in the courthouse kitchen making something that smelled like cinnamon and refusing to acknowledge that the event had ended. She said — to [COMMANDER_NAME], who was standing in the kitchen doorway in full uniform — that she had brought enough for everyone and did not intend to take it back. [COMMANDER_NAME] looked at the President. The President looked at the baker. The baker was seventy-three years old and had apparently outlasted every civic formality in this county for four decades and was not going to stop now. Ualani sat down. [COMMANDER_NAME] sat down. The baker served them both without ceremony or acknowledgment of rank and then sat down herself and said: you look tired. She said this to both of them and did not pursue the topic. They ate the thing that smelled like cinnamon. The courthouse kitchen at 9 PM has a character that is nothing like the courthouse at 6 PM with the magistrates and the handshakes. [COMMANDER_NAME] said something to the baker about the town that made Ualani look at [COMMANDER_NAME] differently. The baker told them both what the war had cost this specific county in the specific voice of someone keeping count. Ualani set down her fork. She looked at [COMMANDER_NAME]. [COMMANDER_NAME] had already been looking. What changed between them: the distance at which they understand each other had shortened, without moving.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; courthouse kitchen with baker; cinnamon, distance shortens

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_MEMORIAL_01_INTIMATE` — PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENTIAL ... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Memorial Address · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_MEMORIAL_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE VISITS [TILE_NAME]: PRESIDENT)</sub>

**Subhead — first draft**

> The Ground Has History. The President Has Remarks.

**Body — first draft**

> She stayed after. The public record covered the address and the address ended. What it did not cover: [COMMANDER_NAME] standing with her on the ground after the photographers and witnesses had been cleared, in the early light that was now being used by no one except them. She had made three soldiers cry. She knew this. She was not processing it publicly. [COMMANDER_NAME] did not ask her to. [COMMANDER_NAME] had read the same casualty reports. [COMMANDER_NAME] knew the same names. They stood at the memorial stones in the light that was going from gold to ordinary and there is a specific thing that happens between two people who know the same names — who have both memorized the lists and both understand that a list is not an abstraction. It is a list. It has specific names on it. One of them said this. The other one said: yes. The memorial ground is heavier than other ground. She carries it differently standing next to someone who also knows how much it weighs. [COMMANDER_NAME] said, after a while: the address will travel. She said: I know. She meant it differently than he or she or they meant it. [COMMANDER_NAME] heard the difference. What changed between them: something she could not have said before the address and which required no saying after it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; memorial ground morning; shared weight of the lists

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_WOUNDED_01_INTIMATE` — PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TILE_NAME] — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Field Hospital · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_WOUNDED_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE VISITS FIELD HOSPITAL AT [TIL)</sub>

**Subhead — first draft**

> She Knew Their Names. That Is Not an Expression.

**Body — first draft**

> It was 6 AM when she came out of the hospital tent. [COMMANDER_NAME] had been standing outside in the particular posture of someone who has been waiting without acknowledging they are waiting. She did not ask how long. [COMMANDER_NAME] did not say. They walked. The field hospital at dawn has a quality the field hospital at midnight does not — the light makes everything that happened in the dark provisional, possible to carry. She had been in there for two hours. She had talked to every person whose name she had memorized. [COMMANDER_NAME] said, after they had been walking for a while: I read the same reports. She said: I know. [COMMANDER_NAME] said: do you do that every time. She said: I try. [COMMANDER_NAME] was quiet for a while. Then [COMMANDER_NAME] said: they'll fight better because you were there. She said: I know that too. That is not why I was there. [COMMANDER_NAME] stopped walking. She stopped. [COMMANDER_NAME] looked at her with the specific quality of attention that means someone is revising something they thought they understood. She let them revise it. They walked back to camp. The light was ordinary by then. What changed: the revision. It was visible on [COMMANDER_NAME]'s face the rest of the day.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; field hospital 6AM; the walk, revision visible on face

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FORGE_01_INTIMATE` — PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION OF F... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Forge Inspection · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_FORGE_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE CONDUCTS SURPRISE INSPECTION )</sub>

**Subhead — first draft**

> Production Numbers Were Good. The President Made Them Better.

**Body — first draft**

> The shift had changed and the day crew had gone and the President was still there. [COMMANDER_NAME] found her in conversation with the forge supervisor about the efficiency gap between the third and fourth production runs, which the supervisor was explaining with the momentum of someone who has wanted to explain this to someone with authority for several years and has finally found that person. The supervisor had brought a clipboard. The clipboard had a diagram. Ualani had the diagram and was asking about specific tolerances in a way that suggested she had read the production manifests and had opinions about them. [COMMANDER_NAME] stood in the forge doorway in the specific warmth that forges produce — heat-heavy, metallic, the kind of heat that has work in it — and watched the President of the Continental Republic get drawn into an increasingly detailed discussion about iron content with the focused ease of someone who is, in some fundamental way, interested. When the supervisor was eventually called away by an actual production issue, she turned and found [COMMANDER_NAME] still in the doorway. She said: what. [COMMANDER_NAME] said nothing, just looked at her. She said: I read the manifests. [COMMANDER_NAME] said: I know. [COMMANDER_NAME] said it the way people say things when they mean: I know, and I now know something else too. They walked out of the forge into the night, which takes a moment to adjust to after the heat. What changed: [COMMANDER_NAME] had the diagram in the morning. She didn't ask how.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; forge night, efficiency diagram; the way she says 'what'

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_CULPER_01_INTIMATE` — CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE ASS... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Culper Ring · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_CULPER_01` — scene nav: "intimate" from <sub>(CULPER RING CONTACT AT [TILE_NAME]: INTELLIGENCE)</sub>

**Subhead — first draft**

> The Message Arrived With No Signature. She Knew Who Sent It.

**Body — first draft**

> The meeting lasted forty minutes and she cannot say what was in it. What she can say: [TILE_NAME] at night with a standing army and a Culper contact and [COMMANDER_NAME] at her side has a specific atmospheric quality that is not fear, exactly, but is not not-fear either — the particular alertness of people operating in the gap between what is known and what is about to be known. The contact left through the usual method. The intelligence was logged through the usual channels. [COMMANDER_NAME] had held position at the meeting's perimeter without being asked and without appearing to need acknowledgment. She said, after the contact was gone: you read the brief. [COMMANDER_NAME] said: I read the brief. She said: and. [COMMANDER_NAME] said what the brief implied — not the intelligence, the other thing it implied, the thing about the adjacent territory that neither of them had said directly and that the brief made impossible to not say. She looked at [COMMANDER_NAME] for a moment. She said: yes. [COMMANDER_NAME] said: how long have you known. She said: since [TILE_NAME]. [COMMANDER_NAME] was quiet. Then [COMMANDER_NAME] said: that was three months ago. She said: I know. What changed: the silence between them is now a shared silence, which is a different thing than two separate silences occurring at the same time.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; intelligence meeting aftermath; shared silence

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_ALLIANCE_01_INTIMATE` — PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] AT [T... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Alliance Council · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_ALLIANCE_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE MEETS WITH [COMMANDER_NAME] A)</sub>

**Subhead — first draft**

> An Alliance Was Discussed. The Discussion Went Well.

**Body — first draft**

> After the formal conversation — the candid one, the one involving territory and the Continental cause and the math that is not complicated — they walked. This was not in the meeting notes because the meeting had formally concluded. [COMMANDER_NAME] said: I want to be clear about what I'm asking for. She said: you've been clear. [COMMANDER_NAME] said: I want to be clear about why. She let [COMMANDER_NAME] be clear about why. It took a while. The why was not the version that appears in the meeting notes — the strategic version, the territory-and-alliance version. The why [COMMANDER_NAME] explained on the walk was the version underneath that, which had to do with what [COMMANDER_NAME] is actually protecting and who [COMMANDER_NAME] is actually protecting it for and what it costs to lead people toward something you cannot guarantee. She listened to the whole thing without interrupting. She said, when [COMMANDER_NAME] finished: I asked myself the same question six months into this war and I still don't have a clean answer. [COMMANDER_NAME] said: what do you have. She said: an incomplete answer I'm still fighting for. [COMMANDER_NAME] looked at her. Then [COMMANDER_NAME] said: that's enough. She said: I know. What changed: [COMMANDER_NAME] had asked for a military alliance. That is what [COMMANDER_NAME] received. What [COMMANDER_NAME] also received did not appear in the notes, was less formal, and is more permanent.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; post-meeting walk; the why underneath the strategy

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FRONTIER_01_INTIMATE` — PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE AT ... — BY MORNING

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Frontier · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `UALANI_FRONTIER_01` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE ESTABLISHES FRONTIER PRESENCE)</sub>

**Subhead — first draft**

> The Northern Edge of the Republic. She Walked It.

**Body — first draft**

> The proclamation had been delivered and the observers had received their information and the army was standing down and Ualani was at the frontier line with [COMMANDER_NAME] at the literal edge of what the Republic claims. The marker is easy to miss — a surveyor's post, weathered, half-embedded in the ground, indicating where one jurisdiction ends. She looked at it for a long time. [COMMANDER_NAME] said: it's a post. She said: it's a post we put here. [COMMANDER_NAME] said: we put a lot of posts here. She said: I know. But this one is ours. [COMMANDER_NAME] looked at her and then looked at the post. [COMMANDER_NAME] said: it doesn't look like much. She said: no. It never does, from the inside. From the outside it looks like a line. The frontier at evening has a quality the frontier at noon does not — the shadows go long and everything looks like it has already been decided, even the things that are still being decided. She said: why did you want this posting specifically. [COMMANDER_NAME] gave the official answer first, which she acknowledged, and then the real answer, which she also acknowledged. The real answer had to do with something [COMMANDER_NAME] was moving toward rather than away from, which is not a strategic calculation and which she found, standing at the edge of what the Republic currently claims, privately accurate. She did not say what she thought about it. She stood at the frontier line and thought it anyway. What changed: she knows why [COMMANDER_NAME] is here. It changes the way she looks at the post.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Ualani — authored; frontier post at dusk; why COMMANDER_NAME is here

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
