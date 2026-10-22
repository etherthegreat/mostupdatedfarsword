# VP Arc

13 events · FIRST PASS 9 · IDEA 4

[← back to index](00_INDEX.md)

---

### `VP_FIRST_MEETING` — THE VICE PRESIDENT REQUESTS A WORD: [COMMANDER_NAME] MAKES THEIR POSITION CLEAR

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Serious
**Chain** VP Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3450`, `Game Scenes and Scripts/world.gd:3454`

**Subhead — first draft**

> It Was Not Exactly a Request. It Was a Very Polite Demand.

**Body — first draft**

> The Vice President arrived in the executive quarters with the specific energy of someone who has been waiting to say something for three weeks. [COMMANDER_NAME] entered without an aide. They sat down without being asked. They produced a folder of intelligence assessments — annotated and cross-referenced — and slid it across the desk. 'I read everything,' [COMMANDER_NAME] said. 'I have opinions.' The President looked at the folder. She looked at the Vice President. 'I thought you might,' she said. The meeting ran two hours past its scheduled slot. Her press secretary is calling it a productive exchange of policy perspectives. The Vice President is calling it a starting point. The President has cleared both of their schedules for the remainder of the week.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hear Them Out | `standard` | sets flag `vp_met` | — |
| 2 | Set the Ground Rules First | `standard` | sets flag `vp_met` | — |

**Design notes** Fires turn 5+, one-time; sets vp_met flag; gates all other VP events

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_COUNSEL` — THE VICE PRESIDENT ARRIVES LATE WITH GOOD ADVICE: [COMMANDER_NAME] READS THE SITUATION

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Serious
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3458`, `Game Scenes and Scripts/world.gd:3464`

**Subhead — first draft**

> They Were Always Going to Come. They Waited Until the Moment Was Right.

**Body — first draft**

> [COMMANDER_NAME] knocked at eleven-thirty p.m. Not because the situation was urgent — it had been urgent for a week — but because the Vice President has a sense for when the President needs counsel and when she needs company and tonight they were the same thing. The numbers on the presidential claim were not good. The map was not good. [COMMANDER_NAME] sat down across from the briefing reports and did not pretend the numbers weren't there. They said: here is what I think needs to happen. Here is the order of priority. Here is what I will personally manage so you don't have to. The President listened. She has been listening to this person for months and she hasn't regretted it once. The situation is still difficult. It is less difficult than it was before the knock at the door.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Their Counsel | `standard` | morale +10 | — |
| 2 | Ask Them to Lead the Response | `standard` | loyalty `vp_faction` +10 | — |

**Design notes** Fires when presidentialClaim < -2; BTN1 morale +10 / BTN2 loyalty vp_faction +10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_DOUBT` — THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] IS QUESTIONING EVERYTHING

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Intimate/Serious
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3468`, `Game Scenes and Scripts/world.gd:3474`

**Subhead — first draft**

> They Didn't Come to the President. The President Came to Them. That's How She Is.

**Body — first draft**

> Ualani Carlisle found [COMMANDER_NAME] in the state dining room at two in the morning with a cold cup of coffee and a stack of newspapers from Crown-controlled territories. The numbers weren't what they were staring at — it was a letter from their home district. 'They want to know if this is worth it,' [COMMANDER_NAME] said without looking up. 'What do I tell them?' The President sat down. She didn't answer immediately. She considered several things she could say that were technically true. Then she said the thing that was actually true. [COMMANDER_NAME] looked at her. They were quiet for a long time. The coffee was still cold when the conversation ended. Neither of them noticed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Remind Them Why They Joined | `standard` | morale +15 | — |
| 2 | Remind Them in a More Convincing Way | `sensual` | morale +25 | — |

**Leads to**

- scene nav: "intimate" → `VP_DOUBT_INTIMATE` — THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] IS QU... — BY MORNING

**Design notes** Fires when VP tile moralDecay >= 30; BTN2 sensual morale +25

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_LOYALTY_TEST` — [COMMANDER_NAME]'S COALITION WANTS ANSWERS — THE FACTION DEMANDS A PUBLIC STATEMENT

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Tense/Serious
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3478`, `Game Scenes and Scripts/world.gd:3486`

**Subhead — first draft**

> The Faction Is Loyal. They Just Need to Hear It Said Out Loud.

**Body — first draft**

> A delegation from [COMMANDER_NAME]'s home faction arrived in Washington with a document signed by forty-seven members and a request that is technically a request and is practically something more. The document asks the Vice President to clarify their position on policy matters the faction believes have been insufficiently addressed. It is a loyalty test. Everyone in the room knows it is a loyalty test. The Vice President is looking at the President with an expression that says: how do you want to handle this. The President is looking back with an expression that says: how do you want to handle this. This is how effective governing partnerships work.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Support the VP's Public Statement | `standard` | loyalty `vp_faction` +15 | — |
| 2 | Let the VP Handle It Alone | `standard` | loyalty `vp_faction` +5 | — |

**Design notes** Fires when VP faction loyalty < 20; BTN1 vp_faction +15 / BTN2 vp_faction +5

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_BATTLEFIELD` — THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER_NAME] AT THE FRONT LINE

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Tense/Triumphant
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3491`, `Game Scenes and Scripts/world.gd:3499`

**Subhead — first draft**

> This Was Not in the Job Description. They Did It Anyway.

**Body — first draft**

> The Vice President's presence at [TILE_NAME] was not planned. The Crown advance was planned — by the Crown — and it arrived on a morning when [COMMANDER_NAME] happened to be conducting a routine civilian inspection. [COMMANDER_NAME] watched the forward scouts come in and then picked up a musket from the armory without being told to. 'I was there,' they said afterward when asked for a statement. 'It seemed necessary.' The garrison commander's report describes [COMMANDER_NAME] as having exceeded the operational expectations established by the Vice Presidential role. The Crown advance has been repelled. [COMMANDER_NAME] has been asked not to do this again. They have not agreed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Stand Beside Them | `standard` | morale +20 | — |
| 2 | More Than Standing Beside Them | `explicit` | morale +30 | — |

**Leads to**

- scene nav: "intimate" → `VP_BATTLEFIELD_INTIMATE` — THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER_NAM... — BY MORNING

**Design notes** Fires when VP tile has UK neighbor + stationed army; BTN2 explicit morale +30

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_PRE_ELECTION` — THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING — [COMMANDER_NAME] ISN'T SURE THEY WANT TO RUN

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Serious/Tense
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3503`, `Game Scenes and Scripts/world.gd:3509`

**Subhead — first draft**

> They Could Step Back. The Question Is Whether They Should.

**Body — first draft**

> [COMMANDER_NAME] arrived in the President's office before the daily briefing and waited until the staff had left. They produced a letter — addressed to the Continental Congress and signed but not yet delivered — formally withdrawing their candidacy from the approaching election. They held it rather than sliding it across the desk. 'It's not that I don't believe in the cause,' [COMMANDER_NAME] said. 'It's that I'm not sure the cause needs my face on it right now.' The President looked at the letter. She looked at [COMMANDER_NAME]. There are two kinds of decisions here: the one that respects their judgment and the one that respects what she knows about them from nine months of governing in the same building.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Their Decision — They Deserve to Choose | `standard` | sets flag `vp_declined_candidacy` | — |
| 2 | Convince Them to Stay In the Race | `explicit` | morale +20 | — |

**Leads to**

- scene nav: "intimate" → `VP_PRE_ELECTION_INTIMATE` — THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING — [C... — BY MORNING

**Design notes** Fires turns 88-92; BTN1 sets vp_declined_candidacy (hides ELECTION_BTN1); BTN2 explicit morale +20

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_SACRIFICE` — THE VICE PRESIDENT OFFERS THEIR RESIGNATION — [COMMANDER_NAME] WANTS TO PROTECT THE REPUBLIC

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Somber/Serious
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3513`, `Game Scenes and Scripts/world.gd:3521`

**Subhead — first draft**

> They Think Their Presence Is Hurting the Cause. They May Be Wrong About That.

**Body — first draft**

> [COMMANDER_NAME] came with a prepared statement and a specific kind of calm that the President recognized immediately as someone who has made a decision. The election pressure at [TILE_NAME] has turned against the Liberty Coalition and the Vice President believes their continued presence in the role is giving Crown propaganda too much material. 'My resignation stabilizes three things,' [COMMANDER_NAME] said and listed them on their fingers. The President listened to all three. The question is not whether [COMMANDER_NAME]'s analysis is correct — it probably is correct in the short term. The question is whether it's the only analysis that matters. Her response is going to define the nature of what they have built together.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Resignation | `standard` | sets flag `vp_resigned` | — |
| 2 | Refuse — The Republic Needs Them | `standard` | loyalty `vp_faction` +10 | — |

**Design notes** Fires when VP tile electionPressure < -20; BTN1 sets vp_resigned / BTN2 vp_faction +10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_SOLIDARITY` — THE VICE PRESIDENT HAS BEEN PAYING ATTENTION — [COMMANDER_NAME] MAKES A SPECIFIC OBSERVATION

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Intimate
**Chain** VP Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3525`, `Game Scenes and Scripts/world.gd:3531`

**Subhead — first draft**

> They Noticed the Protectors. They Have a Question About That.

**Body — first draft**

> [COMMANDER_NAME] produced a personal report — three sheets of paper written in their own hand — and placed it in front of the President. It was a thorough analysis of the protector network Carlisle had been building. Specific agreements. Specific outcomes. Specific evidence that the Continental supernatural defense posture had shifted. At the bottom of the last page in smaller writing: 'I watched you do all of this. I was there for most of it. I need you to know that I know exactly what kind of person it takes to do this.' The President set the report down. She looked at [COMMANDER_NAME]. Then she said: 'You knew about Mothman from the beginning.' [COMMANDER_NAME] smiled. 'I knew about all of them,' they said.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Hear What They Think | `standard` | morale +15 | — |
| 2 | Let Them Know It Was For Them Too | `standard` | loyalty `vp_faction` +10 | — |

**Design notes** Fires when agreed_protectors >= 3; BTN1 morale +15 / BTN2 vp_faction +10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_LEGACY` — THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NAME] HAS SOMETHING TO SAY

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Intimate/Warm
**Chain** VP Arc · position Followup
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3535`, `Game Scenes and Scripts/world.gd:3541`

**Subhead — first draft**

> It Was There When She Came In. She Read It Twice.

**Body — first draft**

> The note was written by hand in handwriting the President knows well enough to recognize before turning it over. [COMMANDER_NAME] did not announce it was coming. They left it before her first meeting of the day and were not in the building when she found it. The note is four paragraphs. The content is sealed under presidential privilege and will remain so. What she shared with her chief of staff: it talks about the war and what they built together and what happens after the election whether they win or lose and what the Republic is made of when the people who built it have to hand it to someone else. In the fourth paragraph it says something about her specifically. The President read the fourth paragraph twice and looked out the window for four minutes before beginning the briefings. 'That,' she said finally, 'is going to the historical archive.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Read It Together | `standard` | claim → `` +1 | — |
| 2 | This Has Always Been Personal | `explicit` | morale +30 | — |

**Leads to**

- scene nav: "intimate" → `VP_LEGACY_INTIMATE` — THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NAME] ... — BY MORNING

**Design notes** Fires turn 96+; BTN1 claim +1 / BTN2 explicit morale +30

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_DOUBT_INTIMATE` — THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] IS QU... — BY MORNING

**Status** IDEA · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_DOUBT` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] I)</sub>

**Subhead — first draft**

> They Didn't Come to the President. The President Came to Them. That's How She Is.

**Body — first draft**

> [INTIMATE STUB — VP_DOUBT] VP arc intimate version: THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] IS QUESTIONING EVERYTHING. Write the emotional version — the conversation that happens instead of or alongside the physical scene. The VP relationship developing in a quieter register. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of VP_DOUBT. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_BATTLEFIELD_INTIMATE` — THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER_NAM... — BY MORNING

**Status** IDEA · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_BATTLEFIELD` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER)</sub>

**Subhead — first draft**

> This Was Not in the Job Description. They Did It Anyway.

**Body — first draft**

> [INTIMATE STUB — VP_BATTLEFIELD] VP arc intimate version: THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER_NAME] AT THE FRONT LINE. Write the emotional version — the conversation that happens instead of or alongside the physical scene. The VP relationship developing in a quieter register. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of VP_BATTLEFIELD. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_PRE_ELECTION_INTIMATE` — THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING — [C... — BY MORNING

**Status** IDEA · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_PRE_ELECTION` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING )</sub>

**Subhead — first draft**

> They Could Step Back. The Question Is Whether They Should.

**Body — first draft**

> [INTIMATE STUB — VP_PRE_ELECTION] VP arc intimate version: THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING — [COMMANDER_NAME] ISN'T SURE TH. Write the emotional version — the conversation that happens instead of or alongside the physical scene. The VP relationship developing in a quieter register. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of VP_PRE_ELECTION. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_LEGACY_INTIMATE` — THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NAME] ... — BY MORNING

**Status** IDEA · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_LEGACY` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NA)</sub>

**Subhead — first draft**

> It Was There When She Came In. She Read It Twice.

**Body — first draft**

> [INTIMATE STUB — VP_LEGACY] VP arc intimate version: THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NAME] HAS SOMETHING TO SAY. Write the emotional version — the conversation that happens instead of or alongside the physical scene. The VP relationship developing in a quieter register. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of VP_LEGACY. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
