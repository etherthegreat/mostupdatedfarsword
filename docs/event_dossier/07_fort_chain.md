# Fort Chain

5 events · FIRST PASS 4 · IDEA 1

[← back to index](00_INDEX.md)

---

### `FORT_001` — FORT [TILE_NAME]: STRUCTURAL CONCERNS AND A PAMPHLET PROBLEM

**Status** FIRST PASS · **Type** `fort_disrepair` · **Country** `USA` · **Tone** Tense/Satirical
**Chain** Fort Disrepair · position Root
**Art** `fort_pamphlets` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Annual date** — every year in month `2` · priority 3  <sub>`TRIG_034`</sub>
- **Annual date** — every year in month `3` · priority 3  <sub>`TRIG_035`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Has Gone to the Press. All of the Press.

**Body — first draft**

> The fort at [TILE_NAME] has been deteriorating since approximately the second year of human civilization, but [COMMANDER_NAME] has taken the matter public in the most colonial way available: pamphlets. Pamphlets describing the state of the powder stores. Pamphlets describing the structural integrity of the eastern parapet. Pamphlets, somehow, describing the exact sequence of procurement failures that led to seventeen barrels of what was supposed to be gunpowder turning out to be sawdust. They are being distributed in taverns from here to Philadelphia. Three have been read aloud in church. President Carlisle's advisors have used a word she did not ask to have explained. The garrison is restless. The commander is defiant. The fort is unquestionably falling apart. Choose your approach — then station an army at [TILE_NAME] to carry it out.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Make an Example of Him — Confront Publicly | `standard` | sets mission flag `FORT_003` | — |
| 2 | Handle It Quietly — Visit Privately | `standard` | sets mission flag `FORT_004` | — |

**Design notes** Fires at Fortress tiles; requires governor + no fortDisrepair; army station required

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORT_003` — PRESIDENT CARLISLE FIRES [COMMANDER_NAME] IN FRONT OF GOD AND THE GARRISON

**Status** FIRST PASS · **Type** `fort_confrontation` · **Country** `USA` · **Tone** Tense/Rousing
**Chain** Fort Disrepair · position Branch
**Art** `fort_confrontation` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Commander Removed. Effective Immediately. Effectively Loudly.

**Body — first draft**

> President Carlisle's arrival at [TILE_NAME] was not quiet. Her army was with her. She walked through the gate, past the crumbling parapet that featured in pamphlet four, and found [COMMANDER_NAME] in the command tent surrounded by what appeared to be additional draft pamphlets. The conversation lasted four minutes. 'You are relieved,' the President said. This is the complete transcript. [COMMANDER_NAME] opened his mouth. The President's army was outside. He closed it. The command tent was vacated. A replacement commander has been identified, briefed, and installed before sunset. Their first act was to burn the remaining pamphlets. The President sent a letter. The letter said: good start.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Remove the Commander | `standard` | removes the governor | — |

**Design notes** Public confrontation path; removes governor; generates replacement

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORT_004` — FORT [TILE_NAME] REPAIR ORDER SIGNED — GRIEVANCES RESOLVED

**Status** FIRST PASS · **Type** `fort_private` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Fort Disrepair · position Branch
**Art** `fort_handshake` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Gated on flag `FORT_005` — set by _nothing sets this_

**Subhead — first draft**

> Presidential Visit Yields Infrastructure Agreement and Renewed Morale

**Body — first draft**

> President Carlisle did not arrive with banners. She arrived quietly, with her army, and asked to speak with [COMMANDER_NAME] privately. What happened in that meeting room is not officially recorded. What is recorded is what happened after: repair orders signed by both parties before midnight. The commander's public statements retracted the following morning. [COMMANDER_NAME] described the conversation as 'remarkably productive' and 'a significant improvement on the pamphlet approach.' The fort's structural repairs began at dawn. Supply shipments confirmed. The garrison's morale has been upgraded from 'exhausted and skeptical' to 'cautiously optimistic.' The commander filed a formal statement of loyalty. He filed it twice, which several aides described as thorough. The President has cleared the remainder of the evening. For strategic purposes.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Resolution | `standard` | repairs the fort | — |

**Design notes** Private resolution path; repair_fort outcome; chains to FORT_005

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORT_005` — CLASSIFIED DIPLOMATIC PROCEEDINGS AT [TILE_NAME]

**Status** FIRST PASS · **Type** `fort_reward` · **Country** `USA` · **Tone** Quirky/Warm
**Chain** Fort Disrepair · position Followup
**Art** `fort_diplomatic` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** explicit · **Cooldown** false

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Details Unavailable. Several Structural Matters Comprehensively Resolved.

**Body — first draft**

> What follows is classified under the President's personal authority and will not appear in the Continental Congressional Record. What can be confirmed: the proceedings at [TILE_NAME] were thorough. Comprehensive. Extended across several hours and more than one room. [COMMANDER_NAME], who had spent three months producing pamphlets about executive negligence, spent this evening doing something considerably more constructive with his energy. The President employed every diplomatic tool at her disposal. The commander reported in the morning that he had never experienced a more persuasive argument for federal governance. His exact words: 'The President is extremely convincing in private. The Republic is fortunate.' A formal apology has been submitted to the Continental Congress. A personal note — contents sealed — has been received by the President's office and described as 'patriotic.' The fort is repaired. The garrison is loyal. The pamphlets are ash. The President looks, somehow, better rested than she has been in months.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The Full Classified Briefing | `explicit` | morale +30 | — |
| 2 | Keep It Professional | `standard` | morale +10 | — |

**Leads to**

- scene nav: "intimate" → `FORT_005_INTIMATE` — CLASSIFIED DIPLOMATIC PROCEEDINGS AT [TILE_NAME] — BY MORNING

**Design notes** Explicit reward event; BTN1 explicit morale+30 / BTN2 standard morale+10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `FORT_005_INTIMATE` — CLASSIFIED DIPLOMATIC PROCEEDINGS AT [TILE_NAME] — BY MORNING

**Status** IDEA · **Type** `fort_reward` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Fort Disrepair · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `FORT_005` — scene nav: "intimate" from <sub>(CLASSIFIED DIPLOMATIC PROCEEDINGS AT [TILE_NAME])</sub>

**Subhead — first draft**

> Details Unavailable. Several Structural Matters Comprehensively Resolved.

**Body — first draft**

> [INTIMATE STUB — FORT_005] Field event intimate version: CLASSIFIED DIPLOMATIC PROCEEDINGS AT [TILE_NAME]. Write the quieter version: what the relationship looks like away from headquarters, in the field, with something at stake. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of FORT_005. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
