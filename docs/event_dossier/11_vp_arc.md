# VP Arc

13 events · FIRST PASS 13

[← back to index](00_INDEX.md)

---

### `VP_FIRST_MEETING` — THE VICE PRESIDENT REQUESTS A WORD: [COMMANDER_NAME] MAKES THEIR POSITION CLEAR

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Serious
**Chain** VP Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4319`, `Game Scenes and Scripts/world.gd:4323`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4327`, `Game Scenes and Scripts/world.gd:4333`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4337`, `Game Scenes and Scripts/world.gd:4343`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4347`, `Game Scenes and Scripts/world.gd:4355`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4360`, `Game Scenes and Scripts/world.gd:4368`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4372`, `Game Scenes and Scripts/world.gd:4378`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4382`, `Game Scenes and Scripts/world.gd:4390`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4394`, `Game Scenes and Scripts/world.gd:4400`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4404`, `Game Scenes and Scripts/world.gd:4410`

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

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_DOUBT` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT AT 2 A.M.: [COMMANDER_NAME] I)</sub>

**Subhead — first draft**

> They Didn't Come to the President. The President Came to Them. That's How She Is.

**Body — first draft**

> The coffee was still cold. Neither of them had touched it since the first cup. This is how Ualani knew the conversation had gone somewhere real — she stops drinking when she is actually present, and she had been actually present since approximately the third sentence, when [COMMANDER_NAME] stopped saying the diplomatic version of the thing and said the thing. She did not respond with the thing she would have said in a meeting with staff in the room. She responded with the thing she actually thought, which was quieter and took longer and was, she believes, correct. [COMMANDER_NAME] looked at her for a moment after she finished. Then [COMMANDER_NAME] said: is that what you tell yourself, or is that what you believe. She said: it started as the first one. [COMMANDER_NAME] said: and now. She said: now I've been saying it long enough that I can't find the seam anymore. [COMMANDER_NAME] looked at the newspapers from Crown territory, still spread across the table. [COMMANDER_NAME] said: that's either very good or very concerning. She said: I think it's the job. The state dining room at 3 AM has a quality that the state dining room at 3 PM does not — the formality has gone out of it, the institutional weight has lifted slightly, and what is left is two people who have been in the same building for nine months and have just, in the last forty minutes, started talking to each other rather than at each other. [COMMANDER_NAME] did not have an answer about the letter from the home district by the time they left. But [COMMANDER_NAME] had a different question, which Ualani believes is more useful. What changed: the cold coffee, and the specific register of the silence that had replaced it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** VP arc — authored; cold coffee scene, 2AM conversation; no explicit content

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_BATTLEFIELD_INTIMATE` — THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER_NAM... — BY MORNING

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_BATTLEFIELD` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT PICKS UP A MUSKET: [COMMANDER)</sub>

**Subhead — first draft**

> This Was Not in the Job Description. They Did It Anyway.

**Body — first draft**

> The garrison commander's report described [COMMANDER_NAME] as having exceeded operational expectations. What the garrison commander's report did not include: Ualani's reaction when she read it, which was not entirely professional and which she will not be having recorded. She called [COMMANDER_NAME]. The call lasted eleven minutes. The first four minutes she said very little. [COMMANDER_NAME] said: I was there. It seemed necessary. She said: I know it seemed necessary. [COMMANDER_NAME] said: the advance has been repelled. She said: I know the advance has been repelled. [COMMANDER_NAME] said: so. She said: so I am going to ask you not to do this again and you are going to say what you always say and then I am going to tell you that I need you alive and you are going to tell me that you know and then we are going to be in the same position we are currently in. [COMMANDER_NAME] said: that's a very accurate summary. There was a pause. Then [COMMANDER_NAME] said: the musket was actually very good. A Continental Long Rifle, modified. The garrison armorer had done exceptional work. She said: I will pass that along. [COMMANDER_NAME] said: Ualani. She said: yes. [COMMANDER_NAME] said: I know. She said: I know you know. That's not the point. The point is that I need you here. [COMMANDER_NAME] did not say anything for a moment. Then [COMMANDER_NAME] said: here as in the Vice Presidency, or here as in. She said: yes. [COMMANDER_NAME] said: alright. The call ended. What changed: [COMMANDER_NAME] did not agree not to do it again. They agreed to something else, which Ualani will take.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** VP arc — authored; musket call aftermath; Ualani and VP on the phone

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_PRE_ELECTION_INTIMATE` — THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING — [C... — BY MORNING

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_PRE_ELECTION` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT CALLS AN UNSCHEDULED MEETING )</sub>

**Subhead — first draft**

> They Could Step Back. The Question Is Whether They Should.

**Body — first draft**

> The letter was still in [COMMANDER_NAME]'s hand. They had not put it down. Ualani had been watching this for the duration of the conversation — the way [COMMANDER_NAME] held it, not sliding it across the desk, not letting go of it either. She knew what this meant. She had held things the same way in the months before certain decisions. She said: you're not actually asking for my permission. [COMMANDER_NAME] said: no. She said: and you're not asking me to talk you out of it. [COMMANDER_NAME] said: I don't know. She said: what are you asking for. [COMMANDER_NAME] looked at the letter for a moment. Then [COMMANDER_NAME] said: I think I'm asking you to tell me what you see when you look at me. Not what the polling says. Not what headquarters says. What you see. She looked at [COMMANDER_NAME] for a while. She said what she saw. It took longer than either of them expected. [COMMANDER_NAME] did not say anything when she finished. The letter was still in their hand. After a while [COMMANDER_NAME] set it on the desk — not sliding it across, just setting it down, which is not the same thing. [COMMANDER_NAME] said: you really believe that. She said: I've had nine months to watch you. Yes. [COMMANDER_NAME] looked at the letter on the desk. [COMMANDER_NAME] did not pick it back up. What changed: the letter stayed on the desk. That is not the same as a decision, but it is adjacent to one.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** VP arc — authored; the letter scene; what Ualani sees when she looks

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `VP_LEGACY_INTIMATE` — THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NAME] ... — BY MORNING

**Status** FIRST PASS · **Type** `vp_event` · **Country** `USA` · **Tone** Warm/Tender
**Chain** VP Arc · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `VP_LEGACY` — scene nav: "intimate" from <sub>(THE VICE PRESIDENT LEAVES A NOTE — [COMMANDER_NA)</sub>

**Subhead — first draft**

> It Was There When She Came In. She Read It Twice.

**Body — first draft**

> She read the fourth paragraph twice and then she called [COMMANDER_NAME]. [COMMANDER_NAME] did not pick up, which she had expected — [COMMANDER_NAME] had left before her first meeting deliberately, and [COMMANDER_NAME] knows her well enough to know she would call, and [COMMANDER_NAME] had chosen anyway not to be reachable for this part. She sat with the note for four minutes before the briefings started. She did not tell her chief of staff what was in the fourth paragraph. She said it was going to the historical archive. This is true. What is also true: she read the fourth paragraph a third time after the briefings, alone, and she did not move for a while after. The note says things about the war and what they built and what the Republic is made of when the people who built it have to hand it to someone else. These things are in the first three paragraphs and they are correct and they are the kind of thing that will look right in the archive. The fourth paragraph is different. The fourth paragraph is not for the archive. It is for her specifically, written in handwriting she knows as well as she knows most things she has known long enough to stop thinking about. [COMMANDER_NAME] called back at 6 PM. She picked up. Neither of them said anything for a moment. Then she said: the fourth paragraph. [COMMANDER_NAME] said: I know. She said: you should have stayed. [COMMANDER_NAME] said: I know. She said: [COMMANDER_NAME]. [COMMANDER_NAME] said: I know. What changed: nothing that was not already true. What is different: she has now read it three times and intends to read it again.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** VP arc — authored; fourth paragraph scene; three readings, one call

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
