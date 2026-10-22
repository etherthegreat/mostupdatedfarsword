# CA Protector

32 events · FIRST PASS 32

[← back to index](00_INDEX.md)

---

### `CA_PROT_01_SUMMON` — LE WENDIGO WAKES IN THE LAURENTIAN FOREST

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Tense/Supernatural
**Chain** Le Wendigo · position Root
**Art** `wendigo_approach` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The hunger of the woods is stirring near Saint-Georges.

**Body — first draft**

> Something ancient has awakened in the deep woods between Saint-Georges and the Quebec highland. The Algonquin communities nearest the disturbance stopped hunting that corridor three seasons ago. They knew before the soldiers did. It does not eat armies — it consumes the idea of plenty itself. The winters near Saint-Georges are now longer than they should be. The harvests are thinner. The hunting parties that went in before the season closed came back smaller. Jessica Commanda Odjick has sent word to Washington: she knows where it lives. She knows what it is. She is asking whether the Republic is prepared to acknowledge what that means before she makes the approach.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Authorize Clear-Water's Entry — Formally Acknowledge the Wendigo | `standard` | fires **CA_PROT_01_TAME** immediately | `CA_PROT_01_TAME` |
| 2 | Request DMA Field Team Deployment — Observe from Perimeter | `standard` | fires **CA_PROT_01_TAME** immediately | `CA_PROT_01_TAME` |

**Leads to**

- "Authorize Clear-Water's Entry — Formally Acknowledge the Wendigo" fires `CA_PROT_01_TAME` — THE WENDIGO RECEDES FROM THE HARVEST CORRIDOR
- "Request DMA Field Team Deployment — Observe from Perimeter" fires `CA_PROT_01_TAME` — THE WENDIGO RECEDES FROM THE HARVEST CORRIDOR

**Design notes** Wild: +1 corruption/turn (25% chance) to CA tiles; fires turn 8+; Saint-Georges tile 99

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_01_TAME` — THE WENDIGO RECEDES FROM THE HARVEST CORRIDOR

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Quiet/Warm
**Chain** Le Wendigo · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_01_SUMMON` — "Authorize Clear-Water's Entry — Formally Acknowledge the Wendigo" fires <sub>(LE WENDIGO WAKES IN THE LAURENTIAN FOREST)</sub>
- Chained from `CA_PROT_01_SUMMON` — "Request DMA Field Team Deployment — Observe from Perimeter" fires <sub>(LE WENDIGO WAKES IN THE LAURENTIAN FOREST)</sub>

**Subhead — first draft**

> It Was Never the Creature That Was the Problem. It Was the Condition.

**Body — first draft**

> Jessica Commanda Odjick led the approach without weapons or soldiers. The creature — which is not a creature but a condition, a spiritual state that takes a form — had been walking the boundary between forest and farmland for three seasons. Clear-Water brought tobacco and cedar and something she has declined to describe in writing. She stood in the woods at the edge of its range for two days. On the third morning the border moved. The harvest corridor opened. The weather in the county improved by two degrees. The DMA agent who accompanied her from a respectful distance describes the resolution as 'a negotiation conducted entirely in silence that I was not invited to be part of but am certain resolved something older than the colony itself.' Saint-Georges is accessible again. The supply lines are restored.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the DMA Accord — Corridor Is Open | `standard` | sets flag `ca_prot_01_tame` | `CA_PROT_01_AGREE` |
| 2 | Formally Accept Clear-Water's Dispatch — What the Forest Said | `standard` | sets flag `ca_prot_01_tame` | `CA_PROT_01_AGREE` |

**Leads to**

- "File the DMA Accord — Corridor Is Open" → `CA_PROT_01_AGREE` — LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACCORD
- "Formally Accept Clear-Water's Dispatch — What the Forest Said" → `CA_PROT_01_AGREE` — LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACCORD

**Design notes** Sets ca_prot_01_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_01_AGREE` — LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACCORD

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Tense/Warm
**Chain** Le Wendigo · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_01_TAME` — "File the DMA Accord — Corridor Is Open" → <sub>(THE WENDIGO RECEDES FROM THE HARVEST CORRIDOR)</sub>
- Chained from `CA_PROT_01_TAME` — "Formally Accept Clear-Water's Dispatch — What the Forest Said" → <sub>(THE WENDIGO RECEDES FROM THE HARVEST CORRIDOR)</sub>

**Subhead — first draft**

> The Accord Has No Name in Any Language the DMA Recognizes. It Holds Anyway.

**Body — first draft**

> The accord does not have a name. Clear-Water declined to sign a document, noting that the entity predates paperwork and would not be improved by it. What exists is this: the hunger has moved away from the Quebec agricultural corridor. Continental supply lines through Saint-Georges — which had been suffering attrition the logistics department was attributing to 'unexplained winter conditions' for two months — are restored. CA army units operating in the Saint-Georges woods report improved morale and no further food spoilage events. The Wendigo has not agreed to anything on paper. It has decided not to be here. Clear-Water says that is enough. The DMA's lead analyst has filed a four-page report on whether 'decided not to be here' constitutes a formal alliance posture and concluded, reluctantly, that it does.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Enter the Accord in the Joint Ledger — The Corridor Holds | `standard` | sets flag `ca_prot_01_agreed` | — |
| 2 | The Full Meeting with Jessica Afterward — What She Wasn't Putting in Dispatches | `explicit` | sets flag `ca_prot_01_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_01_AGREE_INTIMATE` — LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACCORD — BY MORNING

**Design notes** Sets ca_prot_01_agreed; BTN2 explicit — private dispatch from Jessica

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_02_SUMMON` — LE LOUP-GAROU RUNS THE RIVER ROAD — RIVIÈRE-DU-LOUP QUARANTINED

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Tense/Supernatural
**Chain** Le Loup-Garou · position Root
**Art** `loup_garou` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The river's name has been accurate for three hundred years. Tonight it's accurate again.

**Body — first draft**

> Rivière-du-Loup has always had the name and the locals have always had the stories and the Crown garrison posted there three months ago stopped having the garrison this week. What remains is a patrol route that nobody will walk and a set of Crown dispatches found shredded on the river road in a pattern the DMA's cryptographic analyst — who looked at it before anyone told her what she was looking at — describes as 'not random.' Jessica Commanda Odjick knows this creature. She grew up with the stories. 'The wolf runs where it has permission to run,' she told the envoy. 'It has been running this river since before the French named it. The question is whose permission it will accept next.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Dispatch DMA Liaison — Walk the River Road with Clear-Water | `standard` | fires **CA_PROT_02_TAME** immediately | `CA_PROT_02_TAME` |
| 2 | Acknowledge the Sentinel — Issue Formal DMA Notice | `standard` | fires **CA_PROT_02_TAME** immediately | `CA_PROT_02_TAME` |

**Leads to**

- "Dispatch DMA Liaison — Walk the River Road with Clear-Water" fires `CA_PROT_02_TAME` — LE LOUP-GAROU ALLOWS PASSAGE — THE RIVER ROAD REOPENS
- "Acknowledge the Sentinel — Issue Formal DMA Notice" fires `CA_PROT_02_TAME` — LE LOUP-GAROU ALLOWS PASSAGE — THE RIVER ROAD REOPENS

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 13+; Rivière-du-Loup tile 105

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_02_TAME` — LE LOUP-GAROU ALLOWS PASSAGE — THE RIVER ROAD REOPENS

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Quiet/Warm
**Chain** Le Loup-Garou · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_02_SUMMON` — "Dispatch DMA Liaison — Walk the River Road with Clear-Water" fires <sub>(LE LOUP-GAROU RUNS THE RIVER ROAD — RIVIÈRE-DU-L)</sub>
- Chained from `CA_PROT_02_SUMMON` — "Acknowledge the Sentinel — Issue Formal DMA Notice" fires <sub>(LE LOUP-GAROU RUNS THE RIVER ROAD — RIVIÈRE-DU-L)</sub>

**Subhead — first draft**

> Jessica Walked It Alone for Four Hours. That Was the Whole Plan.

**Body — first draft**

> The approach was made at night, which was the only way, and without weapons, which was the only survival option. Jessica Commanda Odjick walked the river road alone for four hours while the Continental liaison team watched from a distance that felt insufficient. Nothing happened — which was, according to Clear-Water, the entire point. 'The wolf knows the difference between someone who belongs on this road and someone who doesn't,' she reported. 'I belong on this road. The Crown soldiers didn't. Now neither will any soldier who doesn't come with acknowledgment of whose road it is.' The river road is open. Continental supply runners report no further incidents. They also report a strong feeling of being watched, which Clear-Water says is normal and reassuring and does not need to be in the official record.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Road Accord — The Wolf Knows Whose Road It Is | `standard` | sets flag `ca_prot_02_tame` | `CA_PROT_02_AGREE` |
| 2 | Formally Accept Clear-Water's Debrief — What Happened on the Road | `standard` | sets flag `ca_prot_02_tame` | `CA_PROT_02_AGREE` |

**Leads to**

- "File the Road Accord — The Wolf Knows Whose Road It Is" → `CA_PROT_02_AGREE` — LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNOWLEDGED BY THE REPUBLIC
- "Formally Accept Clear-Water's Debrief — What Happened on the Road" → `CA_PROT_02_AGREE` — LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNOWLEDGED BY THE REPUBLIC

**Design notes** Sets ca_prot_02_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_02_AGREE` — LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNOWLEDGED BY THE REPUBLIC

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Tense/Triumphant
**Chain** Le Loup-Garou · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_02_TAME` — "File the Road Accord — The Wolf Knows Whose Road It Is" → <sub>(LE LOUP-GAROU ALLOWS PASSAGE — THE RIVER ROAD RE)</sub>
- Chained from `CA_PROT_02_TAME` — "Formally Accept Clear-Water's Debrief — What Happened on the Road" → <sub>(LE LOUP-GAROU ALLOWS PASSAGE — THE RIVER ROAD RE)</sub>

**Subhead — first draft**

> The Republic Has Not Technically Issued a Letter of Understanding to a Werewolf. It Has Now.

**Body — first draft**

> The DMA document is addressed to 'the sentinel of the Rivière-du-Loup corridor' and uses language that could describe either a mythological entity or a very vigilant border patrol depending on which sentence you read first. Jessica Commanda Odjick signed the countersignature and described the process as 'a formality the wolf will ignore but that will matter to the historians.' Crown forces have not regained the river road. They have reportedly stopped trying. Continental militia units operating the corridor report that travel time has been cut by a third and that nobody has asked why because they are not asking that question on this road.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Issue DMA Acknowledgment to the Sentinel — File in Joint Ledger | `standard` | sets flag `ca_prot_02_agreed` | — |
| 2 | The Night the Wolf Stopped Running — What Clear-Water Told You Privately | `explicit` | sets flag `ca_prot_02_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_02_AGREE_INTIMATE` — LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNOWLED... — BY MORNING

**Design notes** Sets ca_prot_02_agreed; BTN2 explicit — the wolf stops running

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_03_SUMMON` — LES FEUX FOLLETS RISE OVER THE SAINT JOHN MARSHES — NAVIGATION DISRUPTED

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Eerie/Supernatural
**Chain** Les Feux Follets · position Root
**Art** `feux_follets` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The marsh lights are back. Four Crown barges didn't come back with them.

**Body — first draft**

> The wetlands at the mouth of the Saint John River have been lit up at night for three weeks in a way Crown navigators attributed first to signal fires, then to atmospheric phenomena, then stopped attributing to anything after the fourth barge ran aground in a corridor their charts showed as clear. The Acadian communities along the shore know what the lights are. Les feux follets — the restless dead of the marshes, souls of the unbaptized, wanderers who died without names — are old presences on this shoreline. Jessica Commanda Odjick reached out to the Maliseet council who steward the marsh territories. 'They're not hostile,' she reported. 'They're doing what they have always done. The Crown stopped listening to the water and started listening to their charts.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Request Maliseet Council Navigation Protocols — Acknowledge the Lights | `standard` | fires **CA_PROT_03_TAME** immediately | `CA_PROT_03_TAME` |
| 2 | Dispatch Continental Naval Liaison to Saint John — Observe Marsh Approaches | `standard` | fires **CA_PROT_03_TAME** immediately | `CA_PROT_03_TAME` |

**Leads to**

- "Request Maliseet Council Navigation Protocols — Acknowledge the Lights" fires `CA_PROT_03_TAME` — LES FEUX FOLLETS QUIET — MALISEET PROTOCOLS ESTABLISHED
- "Dispatch Continental Naval Liaison to Saint John — Observe Marsh Approaches" fires `CA_PROT_03_TAME` — LES FEUX FOLLETS QUIET — MALISEET PROTOCOLS ESTABLISHED

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 18+; Saint John tile 194

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_03_TAME` — LES FEUX FOLLETS QUIET — MALISEET PROTOCOLS ESTABLISHED

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Eerie/Warm
**Chain** Les Feux Follets · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_03_SUMMON` — "Request Maliseet Council Navigation Protocols — Acknowledge the Lights" fires <sub>(LES FEUX FOLLETS RISE OVER THE SAINT JOHN MARSHE)</sub>
- Chained from `CA_PROT_03_SUMMON` — "Dispatch Continental Naval Liaison to Saint John — Observe Marsh Approaches" fires <sub>(LES FEUX FOLLETS RISE OVER THE SAINT JOHN MARSHE)</sub>

**Subhead — first draft**

> The Protocols Are Not Written. They Exist in the Knowledge of Who to Ask.

**Body — first draft**

> The protocols are not written anywhere. They exist in the knowledge of who to ask, what to bring, how to walk the shore path at low tide, and what to look at directly versus what to look at sideways. The Maliseet council shared them with the Continental DMA liaison after three days of sustained presence and zero requests for a report format. Continental navigators using the protocols have run no boats aground since. Crown navigators, who have not been offered the protocols and have not asked for them, continue to have problems. The marsh is the same marsh. The lights are doing what they always did. The difference is who knows how to read them.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Distribute Navigation Protocols to Continental Fleet — File the Accord | `standard` | sets flag `ca_prot_03_tame` | `CA_PROT_03_AGREE` |
| 2 | Issue DMA Field Commendation — The Marsh Did Its Job | `standard` | sets flag `ca_prot_03_tame` | `CA_PROT_03_AGREE` |

**Leads to**

- "Distribute Navigation Protocols to Continental Fleet — File the Accord" → `CA_PROT_03_AGREE` — LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAINT JOHN MARSH ACCORD
- "Issue DMA Field Commendation — The Marsh Did Its Job" → `CA_PROT_03_AGREE` — LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAINT JOHN MARSH ACCORD

**Design notes** Sets ca_prot_03_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_03_AGREE` — LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAINT JOHN MARSH ACCORD

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Eerie/Triumphant
**Chain** Les Feux Follets · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_03_TAME` — "Distribute Navigation Protocols to Continental Fleet — File the Accord" → <sub>(LES FEUX FOLLETS QUIET — MALISEET PROTOCOLS ESTA)</sub>
- Chained from `CA_PROT_03_TAME` — "Issue DMA Field Commendation — The Marsh Did Its Job" → <sub>(LES FEUX FOLLETS QUIET — MALISEET PROTOCOLS ESTA)</sub>

**Subhead — first draft**

> The Admiralty Couldn't Figure Out How to File a Commendation to a Shoreline Tradition. They Figured It Out.

**Body — first draft**

> The marsh lights have not stopped. They will not stop. The accord does not ask them to — it formalizes which vessels they guide and which ones they run aground, a distinction decided by the protocols and not the admiralty charts. Continental naval command filed an official commendation for the Maliseet liaison's contribution and then stared at the form for a while because it was unclear how to file a commendation to a shoreline tradition. They figured it out. The Crown has not figured it out. The barges are still running aground. CA navy units operating from Saint John report clear passage through all southern approaches and something they describe as 'reliable guidance from unexpected sources' that the DMA has asked them not to elaborate on in official dispatches.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Enter the Navigation Accord in the Maritime Ledger — Lights Are Ours | `standard` | sets flag `ca_prot_03_agreed` | — |
| 2 | The Night Jessica Walked You Through the Marsh Herself to Show You What the Lights Mean | `sensual` | sets flag `ca_prot_03_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_03_AGREE_INTIMATE` — LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAINT JO... — BY MORNING

**Design notes** Sets ca_prot_03_agreed; BTN2 sensual — Jessica walks you through the marsh

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_04_SUMMON` — MISHEPESHU STIRS BENEATH LAKE SIMCOE — CROSSINGS CONTESTED

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Serious/Supernatural
**Chain** Mishepeshu · position Root
**Art** `mishepeshu` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Great Lynx is awake. The lake crossing at Barrie is no longer safe.

**Body — first draft**

> Lake Simcoe has been unusable for Continental river crossings since last month when three ferry platforms were destroyed in conditions that Crown engineers described as 'unexpected hydraulic variance' and that the Anishinaabe communities on the western shore described as 'Mishepeshu is annoyed.' The Great Lynx — Underwater Panther, Water Dragon, the spirit that controls every freshwater crossing on this continent — had been relatively dormant since the last ceremony was held on the lake three generations ago. Something disturbed the lake bottom. Jessica Commanda Odjick believes she knows what and believes it is correctable and has asked President Carlisle personally whether the Republic is prepared to say sorry to a lake in a way that means something.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Request Anishinaabe Liaison Council — Arrange the Ceremony | `standard` | fires **CA_PROT_04_TAME** immediately | `CA_PROT_04_TAME` |
| 2 | Dispatch DMA Field Team to Barrie — Observe and Report | `standard` | fires **CA_PROT_04_TAME** immediately | `CA_PROT_04_TAME` |

**Leads to**

- "Request Anishinaabe Liaison Council — Arrange the Ceremony" fires `CA_PROT_04_TAME` — MISHEPESHU WITHDRAWS FROM THE CROSSING LANES — LAKE SIMCOE NAVIGABLE
- "Dispatch DMA Field Team to Barrie — Observe and Report" fires `CA_PROT_04_TAME` — MISHEPESHU WITHDRAWS FROM THE CROSSING LANES — LAKE SIMCOE NAVIGABLE

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 23+; Barrie tile 131

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_04_TAME` — MISHEPESHU WITHDRAWS FROM THE CROSSING LANES — LAKE SIMCOE NAVIGABLE

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Serious/Warm
**Chain** Mishepeshu · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_04_SUMMON` — "Request Anishinaabe Liaison Council — Arrange the Ceremony" fires <sub>(MISHEPESHU STIRS BENEATH LAKE SIMCOE — CROSSINGS)</sub>
- Chained from `CA_PROT_04_SUMMON` — "Dispatch DMA Field Team to Barrie — Observe and Report" fires <sub>(MISHEPESHU STIRS BENEATH LAKE SIMCOE — CROSSINGS)</sub>

**Subhead — first draft**

> The Ceremony Took Place at Sunrise. The DMA Agent Was Asked to Stop Writing.

**Body — first draft**

> The ceremony took place at sunrise on the western shore of Lake Simcoe. Jessica Commanda Odjick attended with the Anishinaabe women's council and offerings of copper and cedar. The DMA agent was asked to remain on the shore at a respectful distance and to please stop writing things in the notebook for thirty minutes. She complied. The crossing lanes opened during the ceremony and have remained open since. The Great Lynx is not gone — it is never gone from its waterways — but it has agreed to allow passage to vessels that approach the lake correctly. Three Crown transport barges subsequently approached the lake incorrectly. This is being logged as a tactical asset by the Ontario command.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Crossing Accord — Lake Simcoe Is Open | `standard` | sets flag `ca_prot_04_tame` | `CA_PROT_04_AGREE` |
| 2 | Formally Accept the Ceremony Report — What Happened in Those 30 Minutes | `standard` | sets flag `ca_prot_04_tame` | `CA_PROT_04_AGREE` |

**Leads to**

- "File the Crossing Accord — Lake Simcoe Is Open" → `CA_PROT_04_AGREE` — MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS THE ONTARIO WATERWAYS
- "Formally Accept the Ceremony Report — What Happened in Those 30 Minutes" → `CA_PROT_04_AGREE` — MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS THE ONTARIO WATERWAYS

**Design notes** Sets ca_prot_04_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_04_AGREE` — MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS THE ONTARIO WATERWAYS

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Serious/Triumphant
**Chain** Mishepeshu · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_04_TAME` — "File the Crossing Accord — Lake Simcoe Is Open" → <sub>(MISHEPESHU WITHDRAWS FROM THE CROSSING LANES — L)</sub>
- Chained from `CA_PROT_04_TAME` — "Formally Accept the Ceremony Report — What Happened in Those 30 Minutes" → <sub>(MISHEPESHU WITHDRAWS FROM THE CROSSING LANES — L)</sub>

**Subhead — first draft**

> The Anishinaabe Council Has Been Doing This Work for Three Centuries. They Now Receive Pay.

**Body — first draft**

> The pact is not a document. The pact is the ongoing maintenance of the relationship, which requires quarterly ceremony and the continued employment of the Anishinaabe liaison council at Continental DMA rate of pay. They accepted with the observation that they had been doing this work for three centuries without pay and would continue regardless, but the pay was appreciated. Lake Simcoe is open. The Georgian Bay approaches are open. Crown forces attempting the lake corridor for supply operations are experiencing what Ontario command classifies as 'consistent and inexplicable adverse maritime conditions' and CA army units crossing from Barrie report smooth water and what one sergeant described as 'the strong impression that the lake is paying attention to us, in a way that is not threatening, but is extremely aware.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Employ the Anishinaabe Liaison Council at DMA Pay Rates — File the Full Accord | `standard` | sets flag `ca_prot_04_agreed` | — |
| 2 | What Jessica Said Afterward About Why This One Required the Republic to Apologize First | `explicit` | sets flag `ca_prot_04_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_04_AGREE_INTIMATE` — MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS THE... — BY MORNING

**Design notes** Sets ca_prot_04_agreed; BTN2 explicit — why the Republic had to apologize first

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_05_SUMMON` — LA CORRIVEAU IS FREE — THE IRON CAGE HAS BEEN SWINGING IN TROIS-PISTOLES

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Serious/Defiant
**Chain** La Corriveau · position Root
**Art** `la_corriveau` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> She was buried three times and tried twice. She has opinions about the British legal system.

**Body — first draft**

> The iron gibbet cage that held Marie-Josephte Corriveau has been swinging in Trois-Pistoles since before anyone alive can remember. The British tried her, hanged her, displayed her body in the cage as a warning. The warning did not take. The Québécois kept telling the story. The story became something else — bigger than the trial, bigger than the execution, bigger than the British legal system that produced both. Now the cage is moving again and the candles in Trois-Pistoles keep going out at midnight and three Crown officers assigned to the garrison there submitted transfer requests in the same week. Jessica Commanda Odjick's dispatch reads: 'She has been waiting for someone to acknowledge the injustice formally. I believe that someone might be the Republic.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Authorize the Acknowledgment Document — Read It in Trois-Pistoles | `standard` | fires **CA_PROT_05_TAME** immediately | `CA_PROT_05_TAME` |
| 2 | Dispatch DMA Special Envoy to Quebec — Engage the Local Record | `standard` | fires **CA_PROT_05_TAME** immediately | `CA_PROT_05_TAME` |

**Leads to**

- "Authorize the Acknowledgment Document — Read It in Trois-Pistoles" fires `CA_PROT_05_TAME` — LA CORRIVEAU QUIETS — THE REPUBLIC ACKNOWLEDGES THE VERDICT WAS WRONG
- "Dispatch DMA Special Envoy to Quebec — Engage the Local Record" fires `CA_PROT_05_TAME` — LA CORRIVEAU QUIETS — THE REPUBLIC ACKNOWLEDGES THE VERDICT WAS WRONG

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 28+; Trois-Pistoles tile 106

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_05_TAME` — LA CORRIVEAU QUIETS — THE REPUBLIC ACKNOWLEDGES THE VERDICT WAS WRONG

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Serious/Warm
**Chain** La Corriveau · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_05_SUMMON` — "Authorize the Acknowledgment Document — Read It in Trois-Pistoles" fires <sub>(LA CORRIVEAU IS FREE — THE IRON CAGE HAS BEEN SW)</sub>
- Chained from `CA_PROT_05_SUMMON` — "Dispatch DMA Special Envoy to Quebec — Engage the Local Record" fires <sub>(LA CORRIVEAU IS FREE — THE IRON CAGE HAS BEEN SW)</sub>

**Subhead — first draft**

> A Continental Document Was Read in the Village Square. That Was Enough.

**Body — first draft**

> The acknowledgment was delivered to Trois-Pistoles as a Continental document stating in plain language that the British legal process which condemned Marie-Josephte Corriveau had been a miscarriage of justice conducted under colonial authority the Republic does not recognize. The document was read aloud in the village square by the DMA liaison, which was not standard procedure and was absolutely correct. The cage stopped swinging the same evening. The candles stopped going out. Three Crown officers who had been sleeping badly are sleeping worse, now that they understand what they were sharing a garrison with and that it has taken a particular interest in the Republic's formal position on colonial courts.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Historical Acknowledgment — The Cage Has Stopped Swinging | `standard` | sets flag `ca_prot_05_tame` | `CA_PROT_05_AGREE` |
| 2 | Review the DMA Operational Report — Three Crown Officers Sleeping Worse | `standard` | sets flag `ca_prot_05_tame` | `CA_PROT_05_AGREE` |

**Leads to**

- "File the Historical Acknowledgment — The Cage Has Stopped Swinging" → `CA_PROT_05_AGREE` — LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC — THREE GARRISONS EVACUATED THIS WEEK
- "Review the DMA Operational Report — Three Crown Officers Sleeping Worse" → `CA_PROT_05_AGREE` — LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC — THREE GARRISONS EVACUATED THIS WEEK

**Design notes** Sets ca_prot_05_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_05_AGREE` — LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC — THREE GARRISONS EVACUATED THIS WEEK

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Serious/Triumphant
**Chain** La Corriveau · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_05_TAME` — "File the Historical Acknowledgment — The Cage Has Stopped Swinging" → <sub>(LA CORRIVEAU QUIETS — THE REPUBLIC ACKNOWLEDGES )</sub>
- Chained from `CA_PROT_05_TAME` — "Review the DMA Operational Report — Three Crown Officers Sleeping Worse" → <sub>(LA CORRIVEAU QUIETS — THE REPUBLIC ACKNOWLEDGES )</sub>

**Subhead — first draft**

> The Agreement Was Between the Republic and a Woman Executed in 1763. The DMA's Legal Team Has Opinions.

**Body — first draft**

> The DMA's legal team submitted a three-page memo on whether this agreement was enforceable. The memo was tabled indefinitely when three Crown garrisons most resistant to Continental advance in the Trois-Pistoles corridor were abandoned without engagement. Commanding officers' dispatches cited 'deteriorating supernatural conditions incompatible with sustained military operations.' La Corriveau did not need a letter of alliance. She needed someone to say the verdict was wrong. The Republic said it. She heard. CA units operating through the Trois-Pistoles corridor now report that Crown fortifications in the region appear to suffer from what one field commander's dispatch describes as 'an acute awareness of their own illegitimacy' followed by rapid abandonment.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Enter the Accord in the Joint Ledger — Three Garrisons Abandoned | `standard` | sets flag `ca_prot_05_agreed` | — |
| 2 | What Jessica Told You About What Corriveau Actually Wanted to Say — The Thing Not in the Dispatches | `explicit` | sets flag `ca_prot_05_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_05_AGREE_INTIMATE` — LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC — THR... — BY MORNING

**Design notes** Sets ca_prot_05_agreed; BTN2 explicit — what Corriveau actually wanted to say

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_06_SUMMON` — LE CARCAJOU MOVES THROUGH THE MONCTON FOREST — NOTHING STOPS IT

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Tense/Ominous
**Chain** Le Carcajou · position Root
**Art** `carcajou` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Wolverine spirit. Demon. The one thing in these woods the British cannot route around.

**Body — first draft**

> The Mi'kmaq communities near Moncton have two categories of forest danger: things you can reason with and things you cannot. Le Carcajou is in the second category and has been for as long as the stories exist. It is not a wolverine, though it has a wolverine's indifference to obstacles and a wolverine's habit of destroying things simply because they exist wrong in its territory. It has been moving through Crown supply lines in the Moncton corridor in a pattern their logistics department is calling 'organized sabotage by unknown parties' and that Mi'kmaq elders are calling 'the Carcajou is annoyed that the British built a road there.' Jessica Commanda Odjick's assessment: 'You cannot make the Carcajou stop. You can only make sure you're not what it's walking toward.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Request Mi'kmaq Elder Council — Establish the Ceremony | `standard` | fires **CA_PROT_06_TAME** immediately | `CA_PROT_06_TAME` |
| 2 | Dispatch DMA Field Team to Moncton — Document What Exists Wrong | `standard` | fires **CA_PROT_06_TAME** immediately | `CA_PROT_06_TAME` |

**Leads to**

- "Request Mi'kmaq Elder Council — Establish the Ceremony" fires `CA_PROT_06_TAME` — LE CARCAJOU REDIRECTS — CONTINENTAL LINES EXEMPTED FROM DESTRUCTION
- "Dispatch DMA Field Team to Moncton — Document What Exists Wrong" fires `CA_PROT_06_TAME` — LE CARCAJOU REDIRECTS — CONTINENTAL LINES EXEMPTED FROM DESTRUCTION

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 33+; Moncton tile 193

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_06_TAME` — LE CARCAJOU REDIRECTS — CONTINENTAL LINES EXEMPTED FROM DESTRUCTION

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Tense/Warm
**Chain** Le Carcajou · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_06_SUMMON` — "Request Mi'kmaq Elder Council — Establish the Ceremony" fires <sub>(LE CARCAJOU MOVES THROUGH THE MONCTON FOREST — N)</sub>
- Chained from `CA_PROT_06_SUMMON` — "Dispatch DMA Field Team to Moncton — Document What Exists Wrong" fires <sub>(LE CARCAJOU MOVES THROUGH THE MONCTON FOREST — N)</sub>

**Subhead — first draft**

> The Mi'kmaq Elders Performed a Ceremony. The DMA Agent Was Asked to Stop Calling It a Natural Force.

**Body — first draft**

> The Mi'kmaq elders performed a ceremony establishing the distinction between what the Carcajou moves toward and what it moves away from. Continental supply lines and allied forces are now in the second category. Crown supply lines, roads, fortifications, and soldiers in the forest at night remain in the first. The DMA agent present for the ceremony described it as 'one of the most efficient uses of existing natural forces I have witnessed in this conflict' and was asked by the lead elder to please not call the Carcajou a natural force in the official report. The report has been edited. The Carcajou has not noticed and would not care if it had.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Corridor Distinction — Continental Lines in Second Category | `standard` | sets flag `ca_prot_06_tame` | `CA_PROT_06_AGREE` |
| 2 | Formally Acknowledge the Mi'kmaq Council — Stop Calling It a Natural Force | `standard` | sets flag `ca_prot_06_tame` | `CA_PROT_06_AGREE` |

**Leads to**

- "File the Corridor Distinction — Continental Lines in Second Category" → `CA_PROT_06_AGREE` — LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON CORRIDOR ACCORD
- "Formally Acknowledge the Mi'kmaq Council — Stop Calling It a Natural Force" → `CA_PROT_06_AGREE` — LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON CORRIDOR ACCORD

**Design notes** Sets ca_prot_06_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_06_AGREE` — LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON CORRIDOR ACCORD

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Tense/Triumphant
**Chain** Le Carcajou · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_06_TAME` — "File the Corridor Distinction — Continental Lines in Second Category" → <sub>(LE CARCAJOU REDIRECTS — CONTINENTAL LINES EXEMPT)</sub>
- Chained from `CA_PROT_06_TAME` — "Formally Acknowledge the Mi'kmaq Council — Stop Calling It a Natural Force" → <sub>(LE CARCAJOU REDIRECTS — CONTINENTAL LINES EXEMPT)</sub>

**Subhead — first draft**

> The Republic Has Not Tamed a Wolverine Demon. It Has Established a Working Relationship with the People Who Talk to One.

**Body — first draft**

> The Republic has not tamed a wolverine demon. It has established a working relationship with the Mi'kmaq elder council that resulted in the wolverine demon developing a consistent preference for destroying Crown infrastructure over Continental infrastructure. The distinction is operational and the DMA is choosing not to examine it too closely. Crown fortification attempts in the Moncton corridor have a failure rate of approximately eighty percent that their engineers attribute to 'unexplained structural compromise.' CA army units operating through Moncton have reported zero supply incidents since the accord was signed. The Carcajou moves where it wants. At the moment it wants to move through Crown supply lines. Everyone is treating this as a stable arrangement.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formalize the Mi'kmaq Council Accord — Working Relationship Established | `standard` | sets flag `ca_prot_06_agreed` | — |
| 2 | The Private Briefing — What Clear-Water Told You About Why the Carcajou Actually Accepted the Accord | `explicit` | sets flag `ca_prot_06_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_06_AGREE_INTIMATE` — LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON CORRIDO... — BY MORNING

**Design notes** Sets ca_prot_06_agreed; BTN2 explicit — why the Carcajou accepted the accord

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_07_SUMMON` — THE FLYING CANOE RUNS THE OTTAWA RIVER — THREE SIGHTINGS TWO MISSING PATROLS

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Eerie/Supernatural
**Chain** La Chasse-Galerie · position Root
**Art** `chasse_galerie` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The voyageurs made their deal with the devil in 1760. The canoe is still honoring it.

**Body — first draft**

> La Chasse-Galerie — the flying canoe, the devil's bargain, the old story every habitant knows and every Crown officer dismisses until the night they don't — has been visible over the Ottawa River corridor for the past week. The tradition holds that it carries voyageurs who struck a deal: the devil flies their canoe home in exchange for their souls if they utter God's name before landing. Two Crown patrol boats have not returned from the river. Their dispatches, when recovered, mention 'airborne vessel' and stop mid-sentence. Jessica Commanda Odjick's message to Washington: 'The canoe runs where it has always run. The question is whether you want to be on the river when it passes or whether you want to know how to ask it to carry something for you.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Contact the Habitant Network — Request an Introduction | `standard` | fires **CA_PROT_07_TAME** immediately | `CA_PROT_07_TAME` |
| 2 | Dispatch DMA Liaison to Deep River — Find Marc Penoit | `standard` | fires **CA_PROT_07_TAME** immediately | `CA_PROT_07_TAME` |

**Leads to**

- "Contact the Habitant Network — Request an Introduction" fires `CA_PROT_07_TAME` — THE FLYING CANOE ACKNOWLEDGES THE REPUBLIC — THE OTTAWA RIVER CORRIDOR SECURED
- "Dispatch DMA Liaison to Deep River — Find Marc Penoit" fires `CA_PROT_07_TAME` — THE FLYING CANOE ACKNOWLEDGES THE REPUBLIC — THE OTTAWA RIVER CORRIDOR SECURED

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 38+; Deep River tile 128

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_07_TAME` — THE FLYING CANOE ACKNOWLEDGES THE REPUBLIC — THE OTTAWA RIVER CORRIDOR SECURED

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Eerie/Warm
**Chain** La Chasse-Galerie · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_07_SUMMON` — "Contact the Habitant Network — Request an Introduction" fires <sub>(THE FLYING CANOE RUNS THE OTTAWA RIVER — THREE S)</sub>
- Chained from `CA_PROT_07_SUMMON` — "Dispatch DMA Liaison to Deep River — Find Marc Penoit" fires <sub>(THE FLYING CANOE RUNS THE OTTAWA RIVER — THREE S)</sub>

**Subhead — first draft**

> The Habitant Network Made the Approach. They Brought Old Brandy and a Document They Knew Would Never Be Read.

**Body — first draft**

> The approach was made through the habitant network — old families in Deep River who have been maintaining the tradition for three generations, who know the songs and know better than to sing them near a Crown officer. The DMA team arrived with a liaison from the French-Canadian community, a bottle of very old brandy, and a formal document the habitant spokesman described as 'something the canoe will never read but that the people sending it should write, to understand what they're agreeing to.' The river corridor has been secured. Continental dispatches are moving through the Ottawa passage at unprecedented speed. Two Crown patrol boats still have not returned.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the River Accord — Continental Dispatches Moving at Speed | `standard` | sets flag `ca_prot_07_tame` | `CA_PROT_07_AGREE` |
| 2 | Review Penoit's Contract Document — Write It So You Understand What You're Agreeing To | `standard` | sets flag `ca_prot_07_tame` | `CA_PROT_07_AGREE` |

**Leads to**

- "File the River Accord — Continental Dispatches Moving at Speed" → `CA_PROT_07_AGREE` — LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBLIC NOW
- "Review Penoit's Contract Document — Write It So You Understand What You're Agreeing To" → `CA_PROT_07_AGREE` — LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBLIC NOW

**Design notes** Sets ca_prot_07_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_07_AGREE` — LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBLIC NOW

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Eerie/Triumphant
**Chain** La Chasse-Galerie · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_07_TAME` — "File the River Accord — Continental Dispatches Moving at Speed" → <sub>(THE FLYING CANOE ACKNOWLEDGES THE REPUBLIC — THE)</sub>
- Chained from `CA_PROT_07_TAME` — "Review Penoit's Contract Document — Write It So You Understand What You're Agreeing To" → <sub>(THE FLYING CANOE ACKNOWLEDGES THE REPUBLIC — THE)</sub>

**Subhead — first draft**

> An Old Bargain Renegotiated. The DMA's Legal Team Has Refused to Document the Process.

**Body — first draft**

> The old bargain has been — through a process the DMA's legal team refuses to document and the habitant liaison describes as 'a renegotiation that the other party accepted because the terms were better for everyone except the party that was originally getting the souls' — extended to include Continental interests. The river moves faster for Continental dispatches than Crown dispatches. The night mail between Deep River and Ottawa runs in half the time. The Chasse-Galerie does not discriminate between political causes. It does, however, know whose canoes are in the water and whether they approached the river correctly. The deal includes knowing that. The DMA has filed this under 'strategic assets: non-traditional' and is leaving it there.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Enter the Renegotiated Bargain in the Joint Ledger — Night Mail Secured | `standard` | sets flag `ca_prot_07_agreed` | — |
| 2 | The Night Marc Penoit Took You on the River and Told You the Full Story of How He Secured the Canoe for the Republic | `sensual` | sets flag `ca_prot_07_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_07_AGREE_INTIMATE` — LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBLIC NOW — BY MORNING

**Design notes** Sets ca_prot_07_agreed; BTN2 sensual — Marc Penoit on the river

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_08_SUMMON` — THE GOUGOU RISES IN THE CHALEUR BAY — CHAMPLAIN'S MONSTER IS REAL

**Status** FIRST PASS · **Type** `ca_protector_summon` · **Country** `CA` · **Tone** Epic/Supernatural
**Chain** Le Gougou · position Root
**Art** `le_gougou` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Samuel de Champlain wrote about it in 1609. He was not exaggerating.

**Body — first draft**

> The Gougou was documented in Champlain's journals as a creature so immense it could carry a ship's crew in the pouch on its chest, so terrible that the Mi'kmaq and Maliseet would not approach the Bay of Chaleur where it lived. The Crown dismissed this for a hundred and sixty years. The Crown supply fleet in Chaleur Bay has revised this assessment. Three vessels are overdue. The shoreline at Bathurst reports sounds at night the garrison commander describes as 'inconsistent with known fauna' and the local Mi'kmaq community describes as 'the Gougou looking for what was taken from it.' Jessica Commanda Odjick's dispatch is one sentence: 'Find out what was taken and return it.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Commission DMA Historical Investigation — Verify Champlain's Account | `standard` | fires **CA_PROT_08_TAME** immediately | `CA_PROT_08_TAME` |
| 2 | Consult Mi'kmaq Council on Sacred Site Status — Begin Investigation | `standard` | fires **CA_PROT_08_TAME** immediately | `CA_PROT_08_TAME` |

**Leads to**

- "Commission DMA Historical Investigation — Verify Champlain's Account" fires `CA_PROT_08_TAME` — THE GOUGOU WITHDRAWS FROM THE BAY LANES — RESTITUTION PROTOCOLS ACTIVE
- "Consult Mi'kmaq Council on Sacred Site Status — Begin Investigation" fires `CA_PROT_08_TAME` — THE GOUGOU WITHDRAWS FROM THE BAY LANES — RESTITUTION PROTOCOLS ACTIVE

**Design notes** Wild: +1 corruption/turn to CA tiles; fires turn 43+; Bathurst tile 109

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_08_TAME` — THE GOUGOU WITHDRAWS FROM THE BAY LANES — RESTITUTION PROTOCOLS ACTIVE

**Status** FIRST PASS · **Type** `ca_protector_tame` · **Country** `CA` · **Tone** Epic/Warm
**Chain** Le Gougou · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_08_SUMMON` — "Commission DMA Historical Investigation — Verify Champlain's Account" fires <sub>(THE GOUGOU RISES IN THE CHALEUR BAY — CHAMPLAIN')</sub>
- Chained from `CA_PROT_08_SUMMON` — "Consult Mi'kmaq Council on Sacred Site Status — Begin Investigation" fires <sub>(THE GOUGOU RISES IN THE CHALEUR BAY — CHAMPLAIN')</sub>

**Subhead — first draft**

> The Objects Were in Crown Custody. The Republic Filed Paperwork Demanding Their Return. It Worked.

**Body — first draft**

> The investigation confirmed what the Mi'kmaq council had always known: the colonial settlement at Bathurst had been built on sacred territory and a significant number of ceremonial objects had been removed from a site the Gougou — which is not a monster but a guardian — regarded as its responsibility. The DMA team spent two weeks locating the objects in Crown custody. The Republic filed formal paperwork demanding their return under Continental authority, which was an interesting legal maneuver that should not have worked and did. The objects were returned to the Mi'kmaq council at a shoreline ceremony. The bay sounds stopped that night. The DMA agent present reports this as the fastest resolution of a supernatural custody dispute in the department's short history.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | File the Repatriation Record — Objects Returned. Bay Quiet. | `standard` | sets flag `ca_prot_08_tame` | `CA_PROT_08_AGREE` |
| 2 | Issue Continental Legal Authority Certificate — Crown Custody Contested | `standard` | sets flag `ca_prot_08_tame` | `CA_PROT_08_AGREE` |

**Leads to**

- "File the Repatriation Record — Objects Returned. Bay Quiet." → `CA_PROT_08_AGREE` — THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR THE CONTINENTAL ALLIANCE
- "Issue Continental Legal Authority Certificate — Crown Custody Contested" → `CA_PROT_08_AGREE` — THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR THE CONTINENTAL ALLIANCE

**Design notes** Sets ca_prot_08_tame flag; immediately chains to AGREE

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_08_AGREE` — THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR THE CONTINENTAL ALLIANCE

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Epic/Triumphant
**Chain** Le Gougou · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_08_TAME` — "File the Repatriation Record — Objects Returned. Bay Quiet." → <sub>(THE GOUGOU WITHDRAWS FROM THE BAY LANES — RESTIT)</sub>
- Chained from `CA_PROT_08_TAME` — "Issue Continental Legal Authority Certificate — Crown Custody Contested" → <sub>(THE GOUGOU WITHDRAWS FROM THE BAY LANES — RESTIT)</sub>

**Subhead — first draft**

> Seventeen Vessels Over Four Months. The Crown Has Stopped Sending More.

**Body — first draft**

> The Crown fleet in Chaleur Bay has not recovered. Seventeen vessels over four months is not a loss attributable to weather, navigation error, or known enemy engagement. The DMA classifies the Gougou as an active strategic asset in the maritime theater. It does not discriminate between Continental and Crown vessels — it discriminates between vessels operating with and without permission of the Mi'kmaq council that now maintains formal relations with Continental maritime command. The protocol is simple. The permits are simple. The price for non-compliance is a creature the size of a small hill with a carrying capacity for an entire ship's crew. Nobody has asked for clarification on compliance a second time. The Bay of Chaleur is ours.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Classify the Gougou as Active Strategic Asset — Issue Maritime Permits | `standard` | sets flag `ca_prot_08_agreed` | — |
| 2 | What Jessica Told You About the Gougou's Real Name — and What It Cost Her to Learn It | `explicit` | sets flag `ca_prot_08_agreed` | — |

**Leads to**

- scene nav: "intimate" → `CA_PROT_08_AGREE_INTIMATE` — THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR THE C... — BY MORNING

**Design notes** Sets ca_prot_08_agreed; BTN2 explicit — the Gougou's real name

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_01_AGREE_INTIMATE` — LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACCORD — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Le Wendigo · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_01_AGREE` — scene nav: "intimate" from <sub>(LE WENDIGO STANDS DOWN: SAINT-GEORGES FOREST ACC)</sub>

**Subhead — first draft**

> It Is Not a Creature. It Is a Condition. She Knew This Before She Went In.

**Body — first draft**

> She stood at the edge of its range for two days and did not pretend she was not afraid. Fear was appropriate. The Wendigo is not a monster — it is what happens to a place when the balance breaks‚ when the taking exceeds what the land can give back. It does not hate. It does not want anything. It simply is the consequence of the wound‚ walking. Jessica Commanda Odjick knows this the way she knows the names of the waterways her grandmother taught her before borders were drawn through them. She brought tobacco. She brought cedar. She brought two days of stillness at the edge of something that could have taken her and chose not to. On the third morning‚ the condition shifted. Not because it had been defeated. Because she had acknowledged it correctly — named the wound for what it was‚ offered the right things‚ stood long enough to prove she understood the cost of what she was asking. The woods did not return to normal. They returned to tended. That is not the same thing. Clear-Water walked out on the third morning and filed nothing. Some agreements are older than writing. She knows which ones.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Le Wendigo, three days at forest edge; wound acknowledged

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_02_AGREE_INTIMATE` — LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNOWLED... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Le Loup-Garou · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_02_AGREE` — scene nav: "intimate" from <sub>(LE LOUP-GAROU OF RIVIÈRE-DU-LOUP: FORMALLY ACKNO)</sub>

**Subhead — first draft**

> The Republic Has Not Technically Issued a Letter of Understanding to a Werewolf. It Has Now.

**Body — first draft**

> The full moon over the Saint Lawrence does something to the valley that daylight does not — it makes the water silver and the hills black and the space between them the particular quality of ambiguous dark that has been used for hundreds of years to explain why people in this region do not walk to the river after midnight. Jessica Commanda Odjick walked to the river after midnight. She had brought tobacco and cedar and the specific quality of patience that her grandmother's grandmother would have recognized — not confrontational, not negotiating, just present enough that whatever was watching could make its own decision about her. Le Loup-Garou is not a monster. It is the valley's boundary made manifest — the thing that marks where human certainty ends and where the older agreements begin. It circled. It came close. She did not move. It stopped circling and stood at the water's edge and looked at her across the specific distance that these encounters require. She said: I know what you protect. I am asking you to protect it from the direction of the Crown. It turned its head south — toward the British positions, toward the corridor they had been using through the lower valley. It turned back. Then it was gone. The Crown's southern approach through Rivière-du-Loup has been disrupted since.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Le Loup-Garou, Saint Lawrence full moon; turns south

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_03_AGREE_INTIMATE` — LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAINT JO... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Les Feux Follets · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_03_AGREE` — scene nav: "intimate" from <sub>(LES FEUX FOLLETS FORMALLY ACKNOWLEDGED: THE SAIN)</sub>

**Subhead — first draft**

> The Admiralty Couldn't Figure Out How to File a Commendation to a Shoreline Tradition. They Figured

**Body — first draft**

> The lights of the Saint John River estuary are not the lights of lanterns. Sailors who have been in this water long enough know the difference — the quality of a lamp is steady, the quality of a feux follet is searching, as though it is looking for something it lost or something that was promised and has not yet arrived. Jessica went to the estuary at the edge of night when the tide was going out and the mud flats were visible and the specific fog that belongs to this coast had come in to do its work. She stood in the fog. The lights came. Not hostile, not welcoming — assessing, in the way that things that have been guiding and misleading travelers through this coast for three hundred years assess newcomers. She said, in French first, then in Wolastoqey: I know what you are. I know what you do to ships that come through here wrong. I am asking you to decide what 'wrong' means. The lights moved — not toward her, not away, but in the particular deliberate pattern that means a collective thing has reached a collective decision. The Crown's coastal patrols in the estuary began reporting navigational anomalies the following week. The charts have not been updated. The charts do not cover this.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Les Feux Follets, Saint John estuary fog; lights decide

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_04_AGREE_INTIMATE` — MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS THE... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Mishepeshu · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_04_AGREE` — scene nav: "intimate" from <sub>(MISHEPESHU PACT FORMALIZED: THE GREAT LYNX HOLDS)</sub>

**Subhead — first draft**

> The Anishinaabe Council Has Been Doing This Work for Three Centuries. They Now Receive Pay.

**Body — first draft**

> The deep channel of Lake Superior at night is the same color as space — dark in the way that means depth, not absence. Jessica Commanda Odjick went to the water's edge at Gichi-gami with the Anishinaabe advisors who had been working with the DMA since the beginning of this and who had been saying, since the beginning of this, that the old relationships were available if the Republic would do the work of asking properly. She did the work. She sat with the council at the shoreline and was told what Mishepeshu is: the boundary of the lake's authority, the keeper of the copper, the deep thing that decides whether the water cooperates with what the people on its edge are trying to do. She said what she needed. The council translated, not linguistically but in the way the relationship requires — not petition but acknowledgment, not demand but recognition. The water moved. Not violently but deliberately — the specific quality of very large old water that has decided something. Crown transport through the Lake Superior corridor has become, since that night, unreliable in ways that weather alone does not explain.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Mishepeshu, Gichi-gami with Anishinaabe council

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_05_AGREE_INTIMATE` — LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC — THR... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** La Corriveau · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_05_AGREE` — scene nav: "intimate" from <sub>(LA CORRIVEAU FORMALLY ALLIES WITH THE REPUBLIC —)</sub>

**Subhead — first draft**

> The Agreement Was Between the Republic and a Woman Executed in 1763. The DMA's Legal Team Has Opinio

**Body — first draft**

> La Corriveau was put in a gibbet and hung at Québec City for something she may or may not have done and the Crown put her on display for weeks as a lesson about authority, which is a very specific kind of lesson that teaches people the opposite of what it intends. Jessica Commanda Odjick went to the site of the old gibbet at night and stood where it had been and said nothing for a long time, because the woman in the gibbet does not want to be told things. She wants to be heard. Jessica said what had happened to Marie-Josephte Corriveau was known and was not forgotten and was the kind of record the Republic intends to carry. The presence in the air above the site was old and specific and not gentle — it does not have to be gentle, it was not treated gently — but it listened. After a while it spoke, in a language that is older than French and younger than the land. Jessica understood enough. What was agreed: the Republic acknowledges what the Crown did here. La Corriveau acknowledges what the Republic is trying to do. This is not friendship. This is a working relationship between people who have the same enemy.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; La Corriveau gibbet site; not friendship, same enemy

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_06_AGREE_INTIMATE` — LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON CORRIDO... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Le Carcajou · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_06_AGREE` — scene nav: "intimate" from <sub>(LE CARCAJOU FORMALLY RECOGNIZED: THE MONCTON COR)</sub>

**Subhead — first draft**

> The Republic Has Not Tamed a Wolverine Demon. It Has Established a Working Relationship with the Peo

**Body — first draft**

> Le Carcajou is not tamed. This is the first thing the DMA field liaison said when Jessica asked what approach was recommended, and it is the correct first thing. A wolverine is not tamed. What a wolverine does is decide whether you are worth tolerating, and if the calculation tips right, you find that the wolverine is no longer destroying your supply lines. The Moncton corridor has been the problem since spring — the Crown had been using it for transit and something had been making the Crown uncomfortable in the way that large mustelid spirits make things uncomfortable, which is indiscriminately and without tactical consideration. Jessica went into the Moncton barrens alone and waited. She brought nothing she was not willing to lose. She sat until the quality of the cold changed — not colder, but more specific, the cold of something watching from closer than you thought. She did not negotiate. She stated facts: the Crown is here, the Republic is also here, and the Republic is going to be here longer. The Carcajou made no agreement. It simply began to apply its attention to the Crown positions specifically, which is the closest thing to a contract that a wolverine spirit signs.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Le Carcajou, Moncton barrens; states facts not demands

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_07_AGREE_INTIMATE` — LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBLIC NOW — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** La Chasse-Galerie · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_07_AGREE` — scene nav: "intimate" from <sub>(LA CHASSE-GALERIE: THE RIVER RUNS FOR THE REPUBL)</sub>

**Subhead — first draft**

> An Old Bargain Renegotiated. The DMA's Legal Team Has Refused to Document the Process.

**Body — first draft**

> The old bargain was with the devil and it required not saying the name of God or touching the church steeples and in exchange the canoe would fly from Montreal to wherever the paddlers needed to go for New Year's. The new bargain is with the Republic. Jessica Commanda Odjick is not the devil, but she made the counteroffer in a language that old bargains understand: what do you want in exchange for what I need. What La Chasse-Galerie wants — what the flying canoe of Quebec has always wanted, underneath the folklore and the cautionary tale structure — is to be used. To be useful. To carry people. The Crown has been disrupting the river routes and the supply lines and the whole structure of movement that the Quebec interior depends on, and the canoe is old enough to remember when rivers were the roads and roads were not yet roads. She asked: will you carry Republic couriers. The river is not a river at night when La Chasse-Galerie is on it. It is something faster. The courier time between Quebec City and the southern positions has improved significantly. The field reports note 'improved logistical conditions.' They do not note the canoe.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; La Chasse-Galerie; old bargain renegotiated, river couriers

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PROT_08_AGREE_INTIMATE` — THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR THE C... — BY MORNING

**Status** FIRST PASS · **Type** `ca_protector_agree` · **Country** `CA` · **Tone** Warm/Tender
**Chain** Le Gougou · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CA_PROT_08_AGREE` — scene nav: "intimate" from <sub>(THE GOUGOU FORMALLY GUARDS THE CHALEUR BAY FOR T)</sub>

**Subhead — first draft**

> Seventeen Vessels Over Four Months. The Crown Has Stopped Sending More.

**Body — first draft**

> The Chaleur Bay has always had something in it that the Mi'kmaq have known about since before the colony and that the French colonists noted in their records as something that makes a sound like a woman screaming, which is how they described the presence because they did not have a better word for the quality of wrongness that the bay has when the thing in it is paying attention. Jessica went to the bay at Bathurst in a small boat with the Mi'kmaq advisor who had been asking the Republic to take the Gougou seriously for six months. She said, to the water: I know what you are and I know what the Mi'kmaq have always known about you, and I am here because the Crown does not know. The water moved. The bay's surface does things at night that it does not do in daylight — it reflects wrong, it sounds wrong, there is a quality to the dark water that is not weather and not current. The thing in it moved closer than Crown sailors would have survived. It was not hostile. It was assessing. She said: I need the approach from the outer bay watched. The bay has been watched since. The Crown knows its ships are not arriving, and it does not know why, and the why has seventeen tentacles and has been here longer than the map that names the bay.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** CA Protector — authored; Le Gougou, Chaleur Bay; Mi'kmaq advisor, bay watching since

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
