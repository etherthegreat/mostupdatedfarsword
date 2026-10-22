# Commander

57 events · FIRST PASS 43 · FULL COMPLETION 14

[← back to index](00_INDEX.md)

---

### `CMD_MERIT` — FIELD PROMOTION: [COMMANDER_NAME] DISTINGUISHED IN EARLY OPERATIONS

**Status** FULL COMPLETION · **Type** `commander_merit` · **Country** `USA` · **Tone** Determined
**Chain** Commander Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> [COMMANDER_NAME] Has Earned the First Step.

**Body — first draft**

> [COMMANDER_NAME] arrived at [TILE_NAME] without a title worth repeating. They leave this phase of the war with one. The record shows: five engagements, two under circumstances that nobody who wasn't there should have survived, and one decision that will be taught in whatever military academies the Republic eventually builds. The paperwork moved faster than paperwork usually moves. Three officers co-signed without being asked. President Carlisle does not promote lightly — but she promotes quickly when the name is right. The citation is brief. The garrison already knew.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Issue the Promotion | `standard` | promotes the commander | — |
| 2 | Add a Personal Note | `standard` | morale +15 | — |

**Design notes** DROPPED — arc redesigned to XP system; entry begins at CMD_RECOGNITION (50 XP)

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CMD_RECOGNITION` — CITATION FOR EXCEPTIONAL SERVICE: [COMMANDER_NAME] AT [TILE_NAME]

**Status** FULL COMPLETION · **Type** `commander_recognition` · **Country** `USA` · **Tone** Proud/Formal
**Chain** Commander Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:5171`, `Game Scenes and Scripts/world.gd:5175`, `Game Scenes and Scripts/world.gd:5188`, `Game Scenes and Scripts/world.gd:5189`, `Game Scenes and Scripts/world.gd:5190`

**Subhead — first draft**

> [COMMANDER_NAME] Warranted a Second Look. And a Second Promotion.

**Body — first draft**

> The formal recognition came with a document, a seal, and a room full of officers who had heard the name before and now understood why. [COMMANDER_NAME]'s service at [TILE_NAME] has moved from notable to undeniable. Three separate unit commanders cited [CMD_OBJECT] in field reports. One cited [CMD_OBJECT] twice, which is unusual and meaningful. President Carlisle signed the citation personally and added a marginal note that the official record omits but the recipient will not forget.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Present the Citation Formally | `standard` | promotes the commander | — |
| 2 | Address the Garrison in Their Honor | `standard` | claim → `` +1 | — |

**Design notes** Fires at governorLevel==2 (50 XP from combat); promote_commander BTN1 (+20 morale commendation); claim_change BTN2

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CMD_THANKS` — PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [COMMANDER_NAME] AT [TILE_NAME]

**Status** FULL COMPLETION · **Type** `commander_thanks` · **Country** `USA` · **Tone** Intimate/Warm
**Chain** Commander Arc · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `explicit` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:2814`, `Game Scenes and Scripts/world.gd:2815`, `Game Scenes and Scripts/world.gd:5195`, `Game Scenes and Scripts/world.gd:5209`, `Game Scenes and Scripts/world.gd:5210`

**Subhead — first draft**

> The President Doesn't Visit Everyone. She Visited [CMD_OBJECT].

**Body — first draft**

> [COMMANDER_NAME] did not expect the President to arrive in person. Nobody who gets this visit expects it — it is, by design, not on the official schedule. President Carlisle came to [TILE_NAME] without the briefing staff and without the press detail and with exactly the intention she communicated at the door: to thank a specific person, in a specific place, for what [CMD_SUBJECT] specifically did. What was said in that room is not in the official record. What is in the official record: [COMMANDER_NAME] returned to duty with a bearing that several junior officers described as 'changed.' One said 'galvanized.' The word the President used, privately, was 'deserved.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | A President's Personal Thanks | `standard` | morale +25 | — |
| 2 | The Full Presidential Visit | `explicit` | fires **CMD_THANKS_INTIMATE** immediately | `CMD_THANKS_INTIMATE` |

**Leads to**

- "The Full Presidential Visit" fires `CMD_THANKS_INTIMATE` — PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [COMM... — BY MORNING
- scene nav: "intimate" → `CMD_THANKS_INTIMATE` — PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [COMM... — BY MORNING

**Design notes** Fires at governorLevel==3 after 50 turns stationed; BTN2 explicit morale_boost +40; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_03_HONORARY` — HONORARY DEGREE GRANTED — [TILE_NAME] UNIVERSITY RECOGNIZES [COMMANDER_NAME]'S SERVICE

**Status** FULL COMPLETION · **Type** `general` · **Country** `USA` · **Tone** Wry/Warm
**Chain** Ivy League Dropout · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:5487`

**Subhead — first draft**

> The College Gave Back What the War Took. Or So They Said.

**Body — first draft**

> [COMMANDER_NAME] left a full scholarship to enlist in the Continental Army. Their university — moved by the reports from the field — has voted to grant an honorary degree in absentia. At the graduation ceremony, [COMMANDER_NAME] accepted the scroll and dedicated the award to:

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Dedicated to the War Effort — +1000 Manpower | `standard` | manpower +1000 | — |
| 2 | Dedicated to the Sciences — +100 Science | `standard` | science +100 | — |

**Design notes** BTN1: resource_change manpower+1000; BTN2: resource_change science+100; 3%/turn at loyalty≥6; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_11_MONARCHISTS` — ORAL PERFORMANCE SWAYS MONARCHISTS — A MOB IN [TILE_NAME] IS LISTENING

**Status** FULL COMPLETION · **Type** `general` · **Country** `USA` · **Tone** Tense/Relief
**Chain** Boston Rabble-Rouser · position Root
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:5507`

**Subhead — first draft**

> Two Dispatches. One Morning. Things Could Have Gone Worse.

**Body — first draft**

> 07:00 — British loyalists attempting to form a mob at [TILE_NAME]. [COMMANDER_NAME] has been dispatched to calm the rioters. Awaiting further direction.13:30 — Loyalist mob calmed and listening to [COMMANDER_NAME]'s address. The crowd has not dispersed. They are waiting to be told what to do next. Cabinet to decide.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | These men will make fine soldiers — convince them to join our cause | `standard` | manpower +1000 | — |
| 2 | Use the loyalists against the King — extract their secrets | `standard` | `reveal_british_tiles` +1 | — |

**Design notes** BTN1: resource_change manpower+1000; BTN2: reveal_british_tiles (fog reveal 1 turn); 3%/turn at loyalty≥5; once per governor

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_01_FIRST` — [COMMANDER_NAME] REPORTS IN FROM THE WETLANDS — FIRST GROUND HELD

**Status** FULL COMPLETION · **Type** `commander_objective` · **Country** `USA` · **Tone** Terse/Determined
**Chain** Wetlands Fisher · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4942`

**Subhead — first draft**

> The Marsh Has Been Cleared. [COMMANDER_NAME] Sends Word.

**Body — first draft**

> The dispatch arrived wet. [COMMANDER_NAME] does not write long field reports — the note says: we have the wetlands, the Crown does not, and the herons seem fine. A Wetlands Fisher does not require validation from headquarters but headquarters is providing it anyway.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Promote [COMMANDER_NAME] to Second Rank | `standard` | promotes the commander | — |

**Design notes** Fires when ARC_01 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_01_DONE` — [COMMANDER_NAME] HAS EARNED THE SWAMP — THE WETLANDS ARE OURS

**Status** FULL COMPLETION · **Type** `commander_complete` · **Country** `USA` · **Tone** Quiet/Triumphant
**Chain** Wetlands Fisher · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4952`

**Subhead — first draft**

> The Fisher Has Proven Their Arc. The Wetlands Remember.

**Body — first draft**

> Three objectives. Achieved without drama — which is the Wetlands Fisher's particular talent. [COMMANDER_NAME] sent a final dispatch from the water's edge: the ground holds. The fish are good. The Redcoats did not understand wetlands. We do.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Invite the General to Washington | `standard` | promotes the commander | — |

**Design notes** Fires when ARC_01 completes all 3 objectives; BTN1: morale+20, BTN2: food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_02_FIRST` — [COMMANDER_NAME] SENDS WORD FROM THE MINE — SHAFT OPENED AND GROUND HELD

**Status** FULL COMPLETION · **Type** `commander_objective` · **Country** `USA` · **Tone** Gruff/Determined
**Chain** Appalachian Miner · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_02`, objective #1 · priority 2  <sub>`TRIG_036`</sub>

**Subhead — first draft**

> The Mountain Cooperated. [COMMANDER_NAME] Dug Deep Enough.

**Body — first draft**

> [COMMANDER_NAME] held [TILE_NAME] and drove the mine down to second level while five hundred troops kept the ridge clear. The field report was a single line: 'Went deeper. Shaft's good. Nobody bothered us.' That is exactly what this command needed to hear.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Promote [COMMANDER_NAME] to Second Rank | `standard` | promotes the commander | — |

**Design notes** Fires when ARC_02 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_02_DONE` — [COMMANDER_NAME] HAS EARNED THE RIDGE — THE APPALACHIAN ARC IS COMPLETE

**Status** FULL COMPLETION · **Type** `commander_complete` · **Country** `USA` · **Tone** Terse/Satisfied
**Chain** Appalachian Miner · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_02`, objective #3 · priority 2  <sub>`TRIG_037`</sub>

**Subhead — first draft**

> The Mine Is Deep. The Tile Is Ours. Eight Hundred Stood With Them.

**Body — first draft**

> An Appalachian Miner does not celebrate. [COMMANDER_NAME]'s final dispatch from [TILE_NAME]: shaft is at fourth level, eight hundred under arms, tile is Continental territory by name and by fact. The mountain said yes. We listened.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Appalachian Miner's Work Deserves Its Reward | `standard` | metal +20 | — |

**Design notes** Fires when ARC_02 completes all 3 objectives; BTN1: morale+20, BTN2: metal

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_03_FIRST` — [COMMANDER_NAME] DISPATCHES FROM THE CITY — FIRST URBAN GROUND SECURED

**Status** FULL COMPLETION · **Type** `commander_objective` · **Country** `USA` · **Tone** Verbose/Self-Aware
**Chain** Ivy League Dropout · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_03`, objective #1 · priority 2  <sub>`TRIG_038`</sub>

**Subhead — first draft**

> The Dispatch Was Three Pages. Page One Was Good.

**Body — first draft**

> [COMMANDER_NAME] has liberated a Metro tile and submitted a fifteen-hundred-word report explaining exactly why this outcome was historically inevitable and what it means for the continental strategic picture. President Carlisle read page one. Headquarters is providing validation that was not requested but appears to have been anticipated.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Promote [COMMANDER_NAME] to Second Rank | `standard` | promotes the commander | — |

**Design notes** Fires when ARC_03 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_03_DONE` — [COMMANDER_NAME]'S URBAN ARC COMPLETE — THE SCHOLAR CLOSES THE BOOK

**Status** FULL COMPLETION · **Type** `commander_complete` · **Country** `USA` · **Tone** Wry/Satisfied
**Chain** Ivy League Dropout · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_03`, objective #3 · priority 2  <sub>`TRIG_039`</sub>

**Subhead — first draft**

> Library Maxed. Army Intact. The Curriculum Is Complete.

**Body — first draft**

> The final dispatch was characteristically long and characteristically correct. [COMMANDER_NAME] has built the finest library on the continent, kept a thousand soldiers in the field, and proven that an Ivy League dropout with a usable theory and the sense to adapt it is worth twice a graduate who cannot. The arc is closed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | An Ivy League Dropout's Work Deserves Its Reward | `standard` | gold +25 | — |

**Design notes** Fires when ARC_03 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_04_FIRST` — [COMMANDER_NAME] HOLDS THE WETLANDS — THE FIGHTER HAS FOUND THEIR GROUND

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Terse/Martial
**Chain** Seminole Fighter · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_04`, objective #1 · priority 2  <sub>`TRIG_040`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Did Not Send a Long Report. The Ground Speaks for Itself.

**Body — first draft**

> The Seminole Fighter does not explain what they do — they do it. A wetlands tile was liberated. [COMMANDER_NAME] is stationed there. The Crown has not retaken it. The eight-turn hold is in progress.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_04 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_04_DONE` — [COMMANDER_NAME] HAS HELD THE SWAMP — THE SEMINOLE FIGHTER'S ARC IS COMPLETE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Spare/Triumphant
**Chain** Seminole Fighter · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_04`, objective #3 · priority 2  <sub>`TRIG_041`</sub>

**Subhead — first draft**

> Eight Turns. The Wetlands Still Ours.

**Body — first draft**

> Three objectives met without ceremony. [COMMANDER_NAME] filed a single field note at the completion of the third: done. The Wetlands are ours. I am staying. The Republic does not need to tell the Seminole Fighter how to hold ground. They already knew.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Seminole Fighter's Work Deserves Its Reward | `standard` | manpower +15 | — |

**Design notes** Fires when ARC_04 completes all 3 objectives; BTN1: morale+20, BTN2: manpower

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_05_FIRST` — [COMMANDER_NAME] SECURES THE FARMLANDS — THE FARMER FINDS THEIR FIELD

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Warm/Grounded
**Chain** Green Mountain Farmer · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_05`, objective #1 · priority 2  <sub>`TRIG_042`</sub>

**Subhead — first draft**

> Good Ground Taken. [COMMANDER_NAME] Puts Down Roots.

**Body — first draft**

> A farmlands tile is secured and [COMMANDER_NAME] has already started thinking about what grows there. The Green Mountain Farmer does not clearly distinguish between liberation and cultivation — both require patience, good soil, and the willingness to be there in the morning. The dispatch was brief: we have it. The land is good.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_05 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_05_DONE` — [COMMANDER_NAME]'S HARVEST IS COMPLETE — THE GREEN MOUNTAIN ARC CLOSES

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Warm/Triumphant
**Chain** Green Mountain Farmer · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_05`, objective #3 · priority 2  <sub>`TRIG_043`</sub>

**Subhead — first draft**

> Farm Built. Food Stockpiled. The Land Knows Who It Belongs To.

**Body — first draft**

> Three objectives in the order a farmer would have listed them. [COMMANDER_NAME]'s final note said: the farm is built, the stores are full, and Vermont knows which side of this war feeds people. The arc is complete. The harvest is in.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Green Mountain Farmer's Work Deserves Its Reward | `standard` | food +30 | — |

**Design notes** Fires when ARC_05 completes all 3 objectives; BTN1: morale+20, BTN2: food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_06_FIRST` — [COMMANDER_NAME] SECURES A PORT — THE SHIPWRIGHT FINDS THEIR HARBOR

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Methodical/Precise
**Chain** Chesapeake Shipwright · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_06`, objective #1 · priority 2  <sub>`TRIG_044`</sub>

**Subhead — first draft**

> Dock Taken. [COMMANDER_NAME] Reports the Water Is Deep Enough.

**Body — first draft**

> A dock tile is secured and [COMMANDER_NAME] immediately sent measurements. A Chesapeake Shipwright does not simply liberate a port — they assess it. Draft depth: adequate. Berth capacity: expandable. Strategic value: obvious. Construction begins on schedule.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_06 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_06_DONE` — [COMMANDER_NAME]'S SHIPYARD ARC IS COMPLETE — THE HARBOR IS OURS

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Satisfied/Methodical
**Chain** Chesapeake Shipwright · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_06`, objective #3 · priority 2  <sub>`TRIG_045`</sub>

**Subhead — first draft**

> Dock Held. Home Tile Built. Coastal Position Confirmed.

**Body — first draft**

> Three objectives met with the systematic precision of someone who builds ships and therefore understands that every component must be right in sequence. [COMMANDER_NAME]'s final dispatch included a draft budget for expanded dock facilities that was not requested. It was also excellent.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Chesapeake Shipwright's Work Deserves Its Reward | `standard` | wood +20 | — |

**Design notes** Fires when ARC_06 completes all 3 objectives; BTN1: morale+20, BTN2: wood

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_07_FIRST` — [COMMANDER_NAME] PROVES LOYALTY — FIVE TURNS SURVIVED, DOUBTS QUIETED

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Cautious/Earnest
**Chain** Loyalist Turncoat · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_07`, objective #1 · priority 2  <sub>`TRIG_046`</sub>

**Subhead — first draft**

> They Stayed. That Is the First Evidence.

**Body — first draft**

> Five turns is not long. Five turns as a former Loyalist serving the Continental Army while the Army debates whether to trust you is a different matter. [COMMANDER_NAME] stayed, fought, and filed reports that proved useful. The doubts in the officers' mess have not disappeared but they have quieted. This is progress.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_07 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_07_DONE` — [COMMANDER_NAME]'S REDEMPTION ARC IS COMPLETE — THE TURNCOAT HAS TURNED

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Quiet/Resolved
**Chain** Loyalist Turncoat · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_07`, objective #3 · priority 2  <sub>`TRIG_047`</sub>

**Subhead — first draft**

> Loyalty Proven. City Liberated. Crown Influence Cleared.

**Body — first draft**

> The word 'turncoat' has a complicated meaning for [COMMANDER_NAME] now. They turned away from the Crown. They turned toward something. Three objectives complete: survived, liberated, cleaned up the corruption they once facilitated. The arc closes. The title does not fit anymore.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Loyalist Turncoat's Work Deserves Its Reward | `standard` | gold +15 | — |

**Design notes** Fires when ARC_07 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_08_FIRST` — [COMMANDER_NAME] TAKES THE FARMLANDS — THE DRIFTER FOUND A REASON TO STAY

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Laconic/Surprised
**Chain** Tobacco Belt Drifter · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_08`, objective #1 · priority 2  <sub>`TRIG_048`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Stopped Moving Long Enough to Liberate Something.

**Body — first draft**

> A Tobacco Belt Drifter does not usually hold ground — they move through it. [COMMANDER_NAME] liberated a farmlands tile and, unexpectedly, did not leave. The field report was two words: got it. Hold count is at four turns and climbing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_08 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_08_DONE` — [COMMANDER_NAME]'S DRIFTER ARC IS COMPLETE — THE ROAD ENDS HERE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Quiet/Satisfied
**Chain** Tobacco Belt Drifter · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_08`, objective #3 · priority 2  <sub>`TRIG_049`</sub>

**Subhead — first draft**

> Farmlands Held. Six Turns. Morale Restored. The Drifter Stopped Drifting.

**Body — first draft**

> Something about the farmlands made the Drifter stop drifting. [COMMANDER_NAME] held the tile, held it some more, and quietly brought the morale decay down to something livable. No ceremony was requested. None will be given. The work speaks for itself, which is how [COMMANDER_NAME] always preferred it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Tobacco Belt Drifter's Work Deserves Its Reward | `standard` | food +15 | — |

**Design notes** Fires when ARC_08 completes all 3 objectives; BTN1: morale+20, BTN2: food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_09_FIRST` — [COMMANDER_NAME] DISPATCHES FROM THE METRO — A CITY TILE FOR THE WIDOW

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Tense/Determined
**Chain** War Widow · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_09`, objective #1 · priority 2  <sub>`TRIG_050`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Took the City. It Was Personal.

**Body — first draft**

> A War Widow understands the weight of a liberated city differently than most. [COMMANDER_NAME]'s dispatch was one sentence: the city is ours, and I am still here. The eight-turn survival clock is running. The city does not know it is being held by someone who has already lost more than it can offer.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_09 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_09_DONE` — [COMMANDER_NAME]'S ARC IS COMPLETE — THE WIDOW HAS BUILT SOMETHING THAT STAYS

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Somber/Triumphant
**Chain** War Widow · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_09`, objective #3 · priority 2  <sub>`TRIG_051`</sub>

**Subhead — first draft**

> Metro Taken. Eight Turns Survived. City Held Five More.

**Body — first draft**

> Three objectives completed over a long campaign that asked for patience, endurance, and the particular stubbornness of someone with nothing to prove and everything to honor. [COMMANDER_NAME]'s final dispatch said nothing about the personal cost. It said: the city stands. So do I.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A War Widow's Work Deserves Its Reward | `standard` | gold +20 | — |

**Design notes** Fires when ARC_09 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_10_FIRST` — [COMMANDER_NAME] TAKES THE WOODS — THE SCOUT MOVES WHERE THE CROWN CANNOT FOLLOW

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Quiet/Knowing
**Chain** Indigenous Scout · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_10`, objective #1 · priority 2  <sub>`TRIG_052`</sub>

**Subhead — first draft**

> A Woods Tile Is Secured. [COMMANDER_NAME] Was Already There.

**Body — first draft**

> The Crown forces did not know [COMMANDER_NAME] had been in those woods for three days before the engagement. An Indigenous Scout does not announce their presence — they establish it quietly and then it is done. The woods are ours. They were always ours.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_10 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_10_DONE` — [COMMANDER_NAME]'S FOREST ARC IS COMPLETE — THE WOODS HOLD THEIR OWN

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Spare/Triumphant
**Chain** Indigenous Scout · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_10`, objective #3 · priority 2  <sub>`TRIG_053`</sub>

**Subhead — first draft**

> Woods Liberated. Held. Commander Present. The Forest Remembers.

**Body — first draft**

> Three objectives met with a precision that required no explanation. [COMMANDER_NAME]'s final dispatch was a single note: the trees know us now. The Crown cannot hold forests they cannot find their way through. The arc is complete and the woods will not forget.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Indigenous Scout's Work Deserves Its Reward | `standard` | wood +15 | — |

**Design notes** Fires when ARC_10 completes all 3 objectives; BTN1: morale+20, BTN2: wood

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_11_FIRST` — [COMMANDER_NAME] TAKES THE CITY — THE RABBLE-ROUSER HAS FOUND THEIR STAGE

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Loud/Principled
**Chain** Boston Rabble-Rouser · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_11`, objective #1 · priority 2  <sub>`TRIG_054`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Liberated a Metro Tile and Immediately Gave a Speech About It.

**Body — first draft**

> The liberation of the Metro tile was operationally competent. The speech that followed it was, by every report, extraordinary. [COMMANDER_NAME] has a talent for making large groups of people feel that history is happening right now and they are the right people to be making it. They are correct.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_11 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_11_DONE` — [COMMANDER_NAME]'S RALLY ARC IS COMPLETE — THE CITY IS LOUD AND FREE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Rousing/Satisfied
**Chain** Boston Rabble-Rouser · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_11`, objective #3 · priority 2  <sub>`TRIG_055`</sub>

**Subhead — first draft**

> Metro Taken. Culture at 100. The Morale Decay Is Gone. The Rabble-Rouser Has Roused.

**Body — first draft**

> Three objectives and three speeches — one for each. [COMMANDER_NAME] turned a city tile, a culture surplus, and a suppressed home district into something the Republic can be proud of. The final dispatch was, predictably, also a speech. It was a good speech.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Boston Rabble-Rouser's Work Deserves Its Reward | `standard` | culture +25 | — |

**Design notes** Fires when ARC_11 completes all 3 objectives; BTN1: morale+20, BTN2: culture

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_12_FIRST` — [COMMANDER_NAME] CLEARS THE INFECTION — HOME TILE CORRUPTION BELOW 20

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Clinical/Steady
**Chain** Continental Surgeon · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_12`, objective #1 · priority 2  <sub>`TRIG_056`</sub>

**Subhead — first draft**

> The Surgeon Has Diagnosed the Problem and Is Treating It.

**Body — first draft**

> A Continental Surgeon operates on whatever is in front of them. [COMMANDER_NAME] looked at the home tile, identified the corruption as a wound, and began the standard treatment: document it, isolate it, reduce it. Corruption below 20. The patient is improving. More work required.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_12 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_12_DONE` — [COMMANDER_NAME]'S FIELD HOSPITAL ARC IS COMPLETE — THE REPUBLIC IS HEALTHIER

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Clinical/Relieved
**Chain** Continental Surgeon · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_12`, objective #3 · priority 2  <sub>`TRIG_057`</sub>

**Subhead — first draft**

> Corruption Cleared. Food Built. Home Tile Expanded. The Surgeon Is Satisfied.

**Body — first draft**

> A surgeon does not declare victory — they declare stability, and stability is what [COMMANDER_NAME] has delivered. Three objectives: the home tile is clean, the nation's food supply is adequate, and the facilities are expanded. The arc closes on a patient that is no longer critical.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Continental Surgeon's Work Deserves Its Reward | `standard` | food +25 | — |

**Design notes** Fires when ARC_12 completes all 3 objectives; BTN1: morale+20, BTN2: food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_13_FIRST` — [COMMANDER_NAME] TAKES A PORT — THE SAILOR HAS WATER UNDER THEIR FEET AGAIN

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Salty/Direct
**Chain** Nantucket Sailor · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_13`, objective #1 · priority 2  <sub>`TRIG_058`</sub>

**Subhead — first draft**

> Dock Secured. [COMMANDER_NAME] Has Opinions About Its Condition.

**Body — first draft**

> The dock was secured and [COMMANDER_NAME] immediately filed a list of structural complaints that were not requested but were entirely accurate. A Nantucket Sailor cannot look at a dock without assessing it. This one needs work. The important thing is we have it now.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_13 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_13_DONE` — [COMMANDER_NAME]'S COASTAL ARC IS COMPLETE — THE SEA REMEMBERS ITS OWN

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Salty/Satisfied
**Chain** Nantucket Sailor · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_13`, objective #3 · priority 2  <sub>`TRIG_059`</sub>

**Subhead — first draft**

> Port Held. Wetlands Five Turns. Coastal Station Confirmed.

**Body — first draft**

> Three objectives and [COMMANDER_NAME] completed each one in the order that made nautical sense: take the port, hold the coastline, be present in the water. The final dispatch confirmed position and ended with the Nantucket Sailor's customary sign-off: conditions at sea, manageable.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Nantucket Sailor's Work Deserves Its Reward | `standard` | gold +20 | — |

**Design notes** Fires when ARC_13 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_14_FIRST` — [COMMANDER_NAME] TAKES THE FOREST — THE PREACHER HAS FOUND A CONGREGATION

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Earnest/Spiritual
**Chain** Frontier Preacher · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_14`, objective #1 · priority 2  <sub>`TRIG_060`</sub>

**Subhead — first draft**

> The Woods Are Liberated. The Preacher Has Delivered the First Sermon of Several.

**Body — first draft**

> A Frontier Preacher does not simply liberate a woods tile — they consecrate it. [COMMANDER_NAME]'s field report included a formal prayer for the men and women who took that ground, which was unusual in a military dispatch but entirely appropriate to the person delivering it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_14 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_14_DONE` — [COMMANDER_NAME]'S REVIVAL ARC IS COMPLETE — THE FRONTIER IS RESTORED

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Warm/Triumphant
**Chain** Frontier Preacher · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_14`, objective #3 · priority 2  <sub>`TRIG_061`</sub>

**Subhead — first draft**

> Forest Liberated. Morale Decay Cleared. Culture Inspired. The Congregation Is Full.

**Body — first draft**

> The Frontier Preacher's arc ends where it should: the woods held, the people's spirits lifted, and the culture of the district renewed. [COMMANDER_NAME] delivered the closing sermon without notes. 'The frontier,' they said, 'belongs to the people who believe in it.' The Republic believed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Frontier Preacher's Work Deserves Its Reward | `standard` | culture +20 | — |

**Design notes** Fires when ARC_14 completes all 3 objectives; BTN1: morale+20, BTN2: culture

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_15_FIRST` — [COMMANDER_NAME] CLEARS THE METRO — THE BUREAUCRAT SECURES THE PAPERWORK OF LIBERATION

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Formal/Systematic
**Chain** DC Bureaucrat · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_15`, objective #1 · priority 2  <sub>`TRIG_062`</sub>

**Subhead — first draft**

> A Metro Tile Is Liberated. The Filing Has Begun.

**Body — first draft**

> A DC Bureaucrat's liberation is documented in triplicate. [COMMANDER_NAME] secured the Metro tile, filed the standard occupation notice, submitted the supply requisition, and initiated the corruption-reduction protocol — all within six hours of the engagement. The forms were correct.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_15 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_15_DONE` — [COMMANDER_NAME]'S ADMINISTRATIVE ARC IS COMPLETE — THE HOME TILE PASSES INSPECTION

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Dry/Satisfied
**Chain** DC Bureaucrat · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_15`, objective #3 · priority 2  <sub>`TRIG_063`</sub>

**Subhead — first draft**

> Metro Liberated. Home Tile Built Out. Corruption Below 10. All Forms Filed.

**Body — first draft**

> Three objectives completed in exact sequence with full documentation. [COMMANDER_NAME]'s final report was forty pages. The summary on page one said: objectives met, home district in compliance, corruption at acceptable levels, construction complete. The bureaucrat closed their file. The file was immaculate.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A DC Bureaucrat's Work Deserves Its Reward | `standard` | gold +20 | — |

**Design notes** Fires when ARC_15 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_16_FIRST` — [COMMANDER_NAME] TAKES THE SUBURB — THE STEELWORKER CLAIMS THE INDUSTRIAL DISTRICT

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Working-Class/Direct
**Chain** Rust Belt Steelworker · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_16`, objective #1 · priority 2  <sub>`TRIG_064`</sub>

**Subhead — first draft**

> Suburbs Tile Secured. [COMMANDER_NAME] Already Has Construction Plans.

**Body — first draft**

> A Rust Belt Steelworker sees every liberation as a construction opportunity. [COMMANDER_NAME] secured the Suburbs tile, assessed the existing infrastructure, and dispatched a materials requisition before the Crown forces were fully cleared. The home tile build-out begins immediately.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_16 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_16_DONE` — [COMMANDER_NAME]'S INDUSTRIAL ARC IS COMPLETE — THE FORGE IS RUNNING

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Gruff/Satisfied
**Chain** Rust Belt Steelworker · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_16`, objective #3 · priority 2  <sub>`TRIG_065`</sub>

**Subhead — first draft**

> Suburbs Held. Three Levels Built. Forge Operational. The Belt Is Back.

**Body — first draft**

> The Rust Belt Steelworker's arc ends with the sound of something being made. [COMMANDER_NAME] built three levels, got the forge operational, and sent one final note: the machines are running. The Republic has industrial capacity at this position. That was the objective. That is what was built.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Rust Belt Steelworker's Work Deserves Its Reward | `standard` | metal +25 | — |

**Design notes** Fires when ARC_16 completes all 3 objectives; BTN1: morale+20, BTN2: metal

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_17_FIRST` — [COMMANDER_NAME] TAKES THE FARMLANDS — THE DESERTER HAS CHOSEN WHICH SIDE OF THE PLOW

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Deliberate/Defiant
**Chain** Plantation Deserter · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_17`, objective #1 · priority 2  <sub>`TRIG_066`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Left One Plantation to Liberate Another Kind of Land.

**Body — first draft**

> A Plantation Deserter understands farmland from a specific and uncommon angle. [COMMANDER_NAME] liberated the farmlands tile with a deliberateness that was noticed in the field reports: this ground, they said afterward, will not be worked for someone else's profit again.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_17 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_17_DONE` — [COMMANDER_NAME]'S DESERTION ARC IS COMPLETE — THE FARMLANDS ARE FREE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Defiant/Resolved
**Chain** Plantation Deserter · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_17`, objective #3 · priority 2  <sub>`TRIG_067`</sub>

**Subhead — first draft**

> Land Held. Six Turns. Morale Decay Cleared. The Deserter Has Finished Leaving.

**Body — first draft**

> Leaving the plantation was the first act. The second act took fifteen more turns and three objectives. [COMMANDER_NAME] held the land, held it longer, and cleared the morale decay that the old order had left behind. The arc closes. The land belongs to different people now.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Plantation Deserter's Work Deserves Its Reward | `standard` | food +20 | — |

**Design notes** Fires when ARC_17 completes all 3 objectives; BTN1: morale+20, BTN2: food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_18_FIRST` — [COMMANDER_NAME] CLAIMS THE SWAMP — THE WITCH HAS RETURNED TO THE WATER

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Arcane/Knowing
**Chain** Swamp Witch · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_18`, objective #1 · priority 2  <sub>`TRIG_068`</sub>

**Subhead — first draft**

> A Wetlands Tile Is Secured. [COMMANDER_NAME] Was Probably Already There.

**Body — first draft**

> The Department of Mythological Affairs noted, without much surprise, that the wetlands tile [COMMANDER_NAME] liberated had already been flagged as anomalous in three separate intelligence reports. The corruption there was unusually organized. The Swamp Witch, it appears, had personal reasons for the engagement.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_18 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_18_DONE` — [COMMANDER_NAME]'S MARSH ARC IS COMPLETE — THE SWAMP IS CLEAN AND OURS

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Arcane/Satisfied
**Chain** Swamp Witch · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_18`, objective #3 · priority 2  <sub>`TRIG_069`</sub>

**Subhead — first draft**

> Wetlands Secured. Corruption Purged. The Witch Has Settled Their Account.

**Body — first draft**

> Three objectives met: the swamp liberated, the corruption cleared to single digits, the commander stationed in the water where they belong. [COMMANDER_NAME]'s final dispatch was not in standard format. It contained an herbal recipe for the garrison and a note that the marsh is now safe. The DMA is treating this as a formal report.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Swamp Witch's Work Deserves Its Reward | `standard` | magic +15 | — |

**Design notes** Fires when ARC_18 completes all 3 objectives; BTN1: morale+20, BTN2: magic

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_19_FIRST` — [COMMANDER_NAME] TAKES THE PORT — THE PRIVATEER HAS FOUND THEIR HARBOR

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Charming/Mercenary
**Chain** Caribbean Privateer · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_19`, objective #1 · priority 2  <sub>`TRIG_070`</sub>

**Subhead — first draft**

> Dock Secured. Prizes Expected. [COMMANDER_NAME] Sends Coordinates.

**Body — first draft**

> A Caribbean Privateer's relationship with the word 'liberate' is creative but not incorrect. [COMMANDER_NAME] secured the dock, assessed its prize-taking potential, and sent a brief note: the port is ours, the gold will follow, the Crown's naval presence in this district has a new and personal enemy.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_19 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_19_DONE` — [COMMANDER_NAME]'S PRIVATEERING ARC IS COMPLETE — THE HARBOR PAYS FOR ITSELF

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Wry/Satisfied
**Chain** Caribbean Privateer · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_19`, objective #3 · priority 2  <sub>`TRIG_071`</sub>

**Subhead — first draft**

> Port Held. 150 Gold. Coastal Station Confirmed. The Privateer Has Earned Their Letter of Marque.

**Body — first draft**

> Three objectives in the order that makes sense to someone who thinks of war as commerce with cannons: take the port, fill the treasury, hold the coast. [COMMANDER_NAME]'s final dispatch came with a personal invoice for services rendered that was attached to, but legally distinct from, their field report.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Caribbean Privateer's Work Deserves Its Reward | `standard` | gold +30 | — |

**Design notes** Fires when ARC_19 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_21_FIRST` — [COMMANDER_NAME] TAKES THE SUBURB — THE MERCENARY HAS DECIDED THIS ONE COUNTS

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Pragmatic/Direct
**Chain** Border Mercenary · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_21`, objective #1 · priority 2  <sub>`TRIG_074`</sub>

**Subhead — first draft**

> Suburbs Secured. [COMMANDER_NAME] Notes the Work Is On Schedule.

**Body — first draft**

> A Border Mercenary does not distinguish between conviction and contract as motivations — both produce results. [COMMANDER_NAME] liberated the Suburbs tile with the particular focus of someone who has been paid to have opinions about strategic objectives. The suburb is held. The hold is proceeding to schedule.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_21 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_21_DONE` — [COMMANDER_NAME]'S CONTRACT ARC IS COMPLETE — THE BORDER MERCENARY HAS CHOSEN A SIDE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Dry/Resolved
**Chain** Border Mercenary · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_21`, objective #3 · priority 2  <sub>`TRIG_075`</sub>

**Subhead — first draft**

> Suburb Held Eight Turns. Arsenal Supplied. The Mercenary Has Terms.

**Body — first draft**

> Three objectives met: the ground held, the weapons delivered, and somewhere in the course of eight turns a contract became a commitment. [COMMANDER_NAME]'s final dispatch was the first one that did not read like a quarterly report. It said: I'm staying. The Republic has my terms. The terms are reasonable.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Border Mercenary's Work Deserves Its Reward | `standard` | weapons +20 | — |

**Design notes** Fires when ARC_21 completes all 3 objectives; BTN1: morale+20, BTN2: weapons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_22_FIRST` — [COMMANDER_NAME] CLAIMS THE FOREST — THE RANGER HAS COME HOME

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Quiet/Belonging
**Chain** Acadian Forest Ranger · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_22`, objective #1 · priority 2  <sub>`TRIG_076`</sub>

**Subhead — first draft**

> A Woods Tile Is Liberated. [COMMANDER_NAME] Already Knew Every Tree.

**Body — first draft**

> The Acadian Forest Ranger does not liberate a woods tile — they reclaim it. [COMMANDER_NAME]'s field note was three sentences: the forest is secured, the patrol routes are set, the Crown will not find us again. It reads like a welcome-home note, which is approximately what it is.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_22 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_22_DONE` — [COMMANDER_NAME]'S FOREST ARC IS COMPLETE — THE ACADIAN WOODS ARE FREE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Quiet/Triumphant
**Chain** Acadian Forest Ranger · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_22`, objective #3 · priority 2  <sub>`TRIG_077`</sub>

**Subhead — first draft**

> Forest Held Five Turns. Ranger Present. The Acadian Range Remembers Its Own.

**Body — first draft**

> Three objectives in the particular order of someone who has lived in these woods and knows what they require. [COMMANDER_NAME] held the territory, held it properly, and took their station in the forest that was always theirs. The final dispatch was in French. The DMA translator noted it was very good.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Acadian Forest Ranger's Work Deserves Its Reward | `standard` | wood +20 | — |

**Design notes** Fires when ARC_22 completes all 3 objectives; BTN1: morale+20, BTN2: wood

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_23_FIRST` — [COMMANDER_NAME] REACHES GETTYSBURG — THE DESCENDANT ARRIVES AT THE GROUND

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Weighted/Determined
**Chain** Gettysburg Descendant · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_23`, objective #1 · priority 2  <sub>`TRIG_078`</sub>

**Subhead — first draft**

> The Field Is Ours. [COMMANDER_NAME] Sends Word From the Crossroads.

**Body — first draft**

> Gettysburg has been important twice now. [COMMANDER_NAME] stood at the ridge where the first battle turned and thought about what it means to fight for the same ground twice. The field report was short but unusual: the memorial was still standing. We did not break anything. I am staying.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_23 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_23_DONE` — [COMMANDER_NAME]'S GETTYSBURG ARC IS COMPLETE — THE DESCENDANT HAS EARNED THEIR PLACE IN THE RECORD

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Somber/Triumphant
**Chain** Gettysburg Descendant · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_23`, objective #3 · priority 2  <sub>`TRIG_079`</sub>

**Subhead — first draft**

> Gettysburg Held Five Turns. Fifteen Turns Survived. The Line Holds.

**Body — first draft**

> Three objectives and fifteen turns, all of them on meaningful ground. [COMMANDER_NAME]'s final dispatch came from the ridge. It said: I understand now what they were doing here. I understand what we are doing here. The arc closes. The record adds another name from the same line.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Gettysburg Descendant's Work Deserves Its Reward | `standard` | manpower +20 | — |

**Design notes** Fires when ARC_23 completes all 3 objectives; BTN1: morale+20, BTN2: manpower

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_24_FIRST` — [COMMANDER_NAME] TAKES THE METRO — THE ORGANIZER HAS OPENED THE HALL

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Principled/Visible
**Chain** LGBTQ+ Organizer · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_24`, objective #1 · priority 2  <sub>`TRIG_080`</sub>

**Subhead — first draft**

> A City Tile Is Liberated. [COMMANDER_NAME] Is Already Holding Community Meetings.

**Body — first draft**

> An LGBTQ+ Organizer liberates a city tile the same way they organize a community: by showing up, being visible, and making it clear that this space is for the people who live in it. [COMMANDER_NAME] secured the Metro tile and then held a meeting. The meeting was well attended.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_24 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_24_DONE` — [COMMANDER_NAME]'S COALITION ARC IS COMPLETE — THE MOVEMENT HAS REACHED EVERYWHERE

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Principled/Satisfied
**Chain** LGBTQ+ Organizer · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_24`, objective #3 · priority 2  <sub>`TRIG_081`</sub>

**Subhead — first draft**

> Metro Taken. 120 Culture. Three States. The Organizer Has Organized.

**Body — first draft**

> Three objectives and three constituencies — the city, the culture, the geography. [COMMANDER_NAME] built the coalition that the arc required: urban ground, national culture, multi-state reach. The final dispatch said: the coalition is holding. That is what an organizer reports when the work is done.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A LGBTQ+ Organizer's Work Deserves Its Reward | `standard` | culture +25 | — |

**Design notes** Fires when ARC_24 completes all 3 objectives; BTN1: morale+20, BTN2: culture

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_25_FIRST` — [COMMANDER_NAME] TAKES THE SHOW ON THE ROAD — FIVE TILES LIBERATED, CROWD ESTIMATED LARGE

**Status** FIRST PASS · **Type** `commander_objective` · **Country** `USA` · **Tone** Theatrical/Charming
**Chain** Carnival Barker · position Milestone 1
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_25`, objective #1 · priority 2  <sub>`TRIG_082`</sub>

**Subhead — first draft**

> [COMMANDER_NAME] Has Liberated Five Tiles and Made It Look Easy. The Crowd Was Impressed.

**Body — first draft**

> A Carnival Barker liberates territory the way they run a carnival: with energy, with showmanship, and with the persistent ability to make the audience believe the outcome was inevitable. Five tiles. [COMMANDER_NAME] filed a single dispatch: good crowd.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Field Dispatch Acknowledged. | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when ARC_25 completes objective 1; BTN1: nothing

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ARC_25_DONE` — [COMMANDER_NAME]'S GRAND TOUR IS COMPLETE — THE CARNIVAL HAS CLOSED ITS FINAL SHOW

**Status** FIRST PASS · **Type** `commander_complete` · **Country** `USA` · **Tone** Theatrical/Triumphant
**Chain** Carnival Barker · position Resolution
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Commander objective** — archetype `ARC_25`, objective #3 · priority 2  <sub>`TRIG_083`</sub>

**Subhead — first draft**

> Five Tiles. 100 Gold. Commander Present. The Barker Takes a Bow.

**Body — first draft**

> Three objectives and [COMMANDER_NAME] made all of them look effortless, which required considerable effort. The final dispatch was theatrical and correct: the house is full, the till is healthy, and the Republic's most flamboyant field commander is accepting a standing ovation. How they prefer to end a show.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formally Recognize [COMMANDER_NAME]'s Service | `standard` | morale +20 | — |
| 2 | A Carnival Barker's Work Deserves Its Reward | `standard` | gold +20 | — |

**Design notes** Fires when ARC_25 completes all 3 objectives; BTN1: morale+20, BTN2: gold

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LVL2_HONOR` — FIELD CITATION — [COMMANDER_NAME]

**Status** FULL COMPLETION · **Type** `commander_milestone` · **Country** `USA` · **Tone** Terse/Warm
**Chain** Governor Ceremony · position Level-Up
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> [COMMANDER_NAME] Has Reached Second Rank. The Republic Notes the Service.

**Body — first draft**

> [COMMANDER_NAME] has met the standard for second-rank field citation. The Republic does not hand these out casually. The paperwork was filed from Washington. It reads: demonstrated command capacity under sustained field conditions. The record is updated. Headquarters concurs.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Citation Received. | `standard` | morale +10 | — |

**Design notes** Fires on promote_commander to lvl 2; BTN1: morale+10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_LVL3_CEREMONY` — GENERAL [COMMANDER_NAME] — WHITE HOUSE RECOGNITION CEREMONY

**Status** FULL COMPLETION · **Type** `commander_milestone` · **Country** `USA` · **Tone** Warm/Triumphant
**Chain** Governor Ceremony · position Level-Up
**Art** `gov_lvl3_ceremony_scene` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:28`

**Subhead — first draft**

> Ualani Presents the Third-Rank Citation. It Was a Good Ceremony.

**Body — first draft**

> The White House advance team filed four memos before [COMMANDER_NAME] arrived. Three were standard. The fourth concerned the apple boxes — the standing order to locate them whenever an honoree's height differential with President Ualani exceeds comfortable framing range. The boxes were already positioned when [COMMANDER_NAME] walked in. The full service record was read aloud. President Ualani shook [COMMANDER_NAME]'s hand for an unusually long time. [COMMANDER_NAME] appeared genuinely moved. The press pool described it as 'the good kind of ceremony.' White House Production marked the event: Complete.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Dismiss the General — Back to the Field | `standard` | morale +20 | — |
| 2 | Invite the General to Stay the Night | `standard` | _no mechanical effect_; army: `GOV_REWARD` | — |

**Design notes** Fires on promote_commander to lvl 3; BTN1: morale+20; BTN2: → GOV_REWARD

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GOV_REWARD` — GENERAL [COMMANDER_NAME] — THE LINCOLN BEDROOM

**Status** FULL COMPLETION · **Type** `commander_intimate` · **Country** `USA` · **Tone** Intimate/Warm
**Chain** Governor Ceremony · position Intimate
**Art** `gov_reward_scene` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** true · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:29`

**Subhead — first draft**

> [COMMANDER_NAME] Had Never Felt So Taken Care Of.

**Body — first draft**

> [COMMANDER_NAME] had held difficult ground for the better part of a year. It showed — not in their posture but in the pauses between sentences‚ in the way veterans carry things nobody asks them about. Ualani noticed. She had made a plan for the evening. She discarded the plan. Instead she turned the entire night around — not toward herself but toward [COMMANDER_NAME]‚ toward the quiet question of what a general actually needs when no one is watching and nothing is being asked in return. [COMMANDER_NAME] had not expected that. The Lincoln Bedroom has a long record. It added another entry.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The Morning After | `standard` | governor loyalty `` +3 | — |

**Design notes** Fires from GOV_LVL3_CEREMONY BTN2; BTN1: governor_loyalty +3

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CMD_THANKS_INTIMATE` — PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [COMM... — BY MORNING

**Status** FIRST PASS · **Type** `commander_thanks` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Commander Arc · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CMD_THANKS` — "The Full Presidential Visit" fires <sub>(PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [)</sub>
- Chained from `CMD_THANKS` — scene nav: "intimate" from <sub>(PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [)</sub>

**Subhead — first draft**

> The President Doesn't Visit Everyone. She Visited [CMD_OBJECT].

**Body — first draft**

> The citation was filed before she came in — that part was staff, procedure, the Republic's paperwork done properly. What happened after was not in any procedure. She came to the command tent after the formal business was complete. Not with a retinue. Alone. [COMMANDER_NAME] had been reviewing the next deployment when she arrived, and something about the way she arrived — without announcement, without the press corps, without the weight of office she usually carries as a visible thing — told [CMD_SUBJECT] this was different from the citation. She said: I wanted to tell you myself. Not in a speech. Not for the record. [COMMANDER_NAME] set down the maps. She talked for a while. What she said is not in any record and does not need to be. [COMMANDER_NAME] did not say much. There was, at the end, a quality of silence between them that had not existed before she started talking — not empty, not awkward, but the specific kind that means something has been properly acknowledged by the people who needed to acknowledge it. She left before the next shift. [COMMANDER_NAME] picked up the maps. [COMMANDER_NAME] did not put them back down for a while.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Commander — authored; command tent after citation; proper silence, maps set down

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
