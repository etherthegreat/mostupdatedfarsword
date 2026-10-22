# Canada

22 events · FIRST PASS 13 · IDEA 7 · FULL COMPLETION 2

[← back to index](00_INDEX.md)

---

### `UK_BUILDUP_01` — INTELLIGENCE REPORT: CROWN FORCES AMASSING ON ALL BORDERS

**Status** FIRST PASS · **Type** `war_buildup` · **Country** `GEN` · **Tone** Tense/Urgent
**Chain** War Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3751`, `Game Scenes and Scripts/world.gd:3755`

**Subhead — first draft**

> The Ships Started Arriving Three Days Ago. They Have Not Stopped.

**Body — first draft**

> The intelligence arrived simultaneously from three Culper Ring assets — that redundancy means it is not a mistake. Royal Navy man-o-wars have been observed offloading troops at every major Crown-controlled port on the Atlantic seaboard. The numbers are not patrol numbers. They are not garrison numbers. They are invasion numbers. The repositioning that has been happening quietly for months is now complete. The border with British-occupied Canadian territory is active. Additional Crown regiments arrive by sea every seventy-two hours. President Carlisle's intelligence chief has delivered this assessment with the particular energy of someone who prepared for this briefing and hoped never to give it. The man-o-wars are still coming. There is no ambiguity about what this means. There is a question about whether anyone else on this continent has noticed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Alert All Command Posts | `standard` | sets flag `uk_buildup_known` | — |
| 2 | Contact Ottawa — We May Not Be Alone | `standard` | sets flag `uk_buildup_known` | — |

**Design notes** Fires turn 7, one-time; BTN1 alert / BTN2 contact Ottawa; both set uk_buildup_known

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UK_DECLARATION_01` — KING GEORGE III DECLARES WAR: THE CROWN HAS MOVED ON BOTH FRONTS

**Status** FIRST PASS · **Type** `war_declaration` · **Country** `GEN` · **Tone** Tense/Rousing
**Chain** War Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3759`, `Game Scenes and Scripts/world.gd:3767`

**Subhead — first draft**

> The Redcoats Crossed the Line at Dawn. Both Lines.

**Body — first draft**

> At 6:04 a.m. Crown forces crossed into Continental territory at seventeen simultaneous points. At 6:06 a.m. the same deployment crossed into Canadian colonial territory. The formal declaration — read by a Crown herald outside the former British Embassy in Boston — cited the persistent criminal disruption of lawful Crown authority and the seditious governance of the Continental Republic. The declaration named the Continental Republic. It also named Canada, which until this morning maintained a working peace with the Crown. George III has apparently calculated that a two-front war against an unprepared continent is simpler than a one-front war against an organized one. The war is no longer a theoretical future problem. The war is here. On both sides of every border. The question is whether anyone fights it alone.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Deploy All Available Forces | `standard` | sets flag `uk_declared_war` | — |
| 2 | Dispatch Emergency Contact to Ottawa | `standard` | sets flag `uk_declared_war` | — |

**Design notes** Fires turns 10-16 (30%/turn) once uk_buildup_known; sets uk_declared_war

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_CALL_01` — THE OTTAWA CALL: PRESIDENT PENOIT AND PM CLEAR-WATER ARE ON THE LINE

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Serious/Hopeful
**Chain** Canadian Alliance · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3791`, `Game Scenes and Scripts/world.gd:3800`

**Subhead — first draft**

> They Picked Up. That's Already More Than the Last President Got.

**Body — first draft**

> The secure line to Ottawa connected on the second ring which the President's communications officer noted with cautious relief. Canadian President Marc Penoit's voice was measured. Canadian Prime Minister Jessica Commanda Odjick's voice was warm — or warm in the way that people are warm when they are deciding how warm to be and have not decided yet. The last American president shattered the Canada-USA-Mexico alliance through a sequence of decisions that both Canadian leaders can recite from memory in order with dates. They know what American promises have historically been worth. They also know what Crown forces on their border look like. The call lasted forty-seven minutes. Neither side made commitments. Both sides said things that can be built on. Ualani Carlisle set down the receiver and looked at her chief of staff. 'They are still angry,' she said. 'But they are listening.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Broken Alliance — We Start Fresh | `standard` | sets flag `can_contact` | — |
| 2 | All for One as They Say — The Republic Stands Alone | `standard` | sets flag `can_rejected` | — |

**Design notes** Fires turn 8+ after uk_buildup_known; BTN1 sets can_contact / BTN2 sets can_rejected (ends arc)

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_PENOIT_01` — PRESIDENT PENOIT'S CONDITIONS: MARC PENOIT PUTS IT IN WRITING

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Serious/Tense
**Chain** Canadian Alliance · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3804`, `Game Scenes and Scripts/world.gd:3810`

**Subhead — first draft**

> He Has Four Conditions. They Are All Reasonable. That Is What Makes Them Hard.

**Body — first draft**

> Marc Penoit's letter arrived through diplomatic channels and the official State Department translation arrived two hours after the original — which meant the President read it herself first using what her aide described as the French she claims not to speak. The letter is four pages. The conditions are four items: a formal acknowledgment of the CUM alliance violations with specific dates and administrations named; a constitutional commitment to joint defense that cannot be revoked by executive order alone; a mutual intelligence-sharing protocol that Canada reviews and approves; and a personal in-person conversation with the President before the formal alliance document is signed. The conditions are reasonable. Marc Penoit knows they are reasonable. He wrote them to be reasonable specifically so they cannot be dismissed without looking unreasonable. Ualani Carlisle read them twice. 'He is good,' she told her chief of staff.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept All Four Conditions | `standard` | sets flag `can_penoit_agreed` | — |
| 2 | Negotiate — Personal Meetings Are Complicated | `standard` | sets flag `can_penoit_negotiating` | — |

**Design notes** Fires turn 12+ after can_contact; BTN1 can_penoit_agreed / BTN2 can_penoit_negotiating

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_CLEARWATER_01` — PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES OUTSIDE OFFICIAL CHANNELS

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Intimate
**Chain** Canadian Alliance · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3814`, `Game Scenes and Scripts/world.gd:3820`

**Subhead — first draft**

> The Letter Did Not Go Through the State Department. It Came Directly to Her.

**Body — first draft**

> The note arrived not through diplomatic mail but through the Culper Ring — Clear-Water had independently established a contact which the intelligence chief filed with what he described as professional appreciation. The note is handwritten and personal in the way official correspondence never is. Clear-Water writes that she was twenty-three at the original CUM alliance signing and she believed in it completely and she has spent every year since watching it be dismantled by a government that was not Ualani Carlisle's. She writes that she has been watching the Continental protector network. She writes that she has been watching Carlisle specifically. The note ends with a question — not a diplomatic question but a real one. A question about whether the President believes in what she is building the way Clear-Water believed in the original alliance at twenty-three. What Carlisle writes back will set the tone for everything that follows.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Answer Honestly — Yes I Believe It | `standard` | sets flag `can_clearwater_warm` | — |
| 2 | Answer the Way the Question Was Really Asked | `sensual` | sets flag `can_clearwater_close` | — |

**Leads to**

- scene nav: "intimate" → `CAN_CLEARWATER_01_INTIMATE` — PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES OUT... — BY MORNING

**Design notes** After penoit path + can_contact; BTN1 can_clearwater_warm / BTN2 sensual can_clearwater_close

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_JOINT_OPS_01` — JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHARE ONE MAP

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Serious/Tense
**Chain** Canadian Alliance · position Branch
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3824`, `Game Scenes and Scripts/world.gd:3828`

**Subhead — first draft**

> The Map Is the Same Map. That Is a Start.

**Body — first draft**

> The first joint session between Continental and Canadian intelligence produced what President Carlisle assessed as the most useful four hours in the history of an alliance that until recently existed primarily as a cautionary tale. Marc Penoit arrived with Crown positioning data the Culper Ring had been missing for months. Jessica Commanda Odjick arrived with a separate analysis using Canadian surveillance methods Continental intelligence has been trying to replicate for two years. When the three principals looked at the same map simultaneously none of them spoke for a while. The picture was larger than any of them had seen individually. It contained one specific window — a time-limited operational opportunity that requires coordination across both governments and closes in nine days. The window is real. The question is how seriously they are treating this partnership.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Act on the Intelligence Window Together | `standard` | weapons +20 | — |
| 2 | The Full Joint Operation — All Three Committed | `explicit` | morale +25 | — |

**Leads to**

- scene nav: "intimate" → `CAN_JOINT_OPS_01_INTIMATE` — JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHARE O... — BY MORNING

**Design notes** After penoit+clearwater paths; BTN1 +weapons 20 / BTN2 explicit +morale 25

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_SUMMIT_01` — THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FOR THE FIRST TIME

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Serious/Warm
**Chain** Canadian Alliance · position Branch
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3832`, `Game Scenes and Scripts/world.gd:3840`

**Subhead — first draft**

> The Room Had History in It Before Any of Them Sat Down.

**Body — first draft**

> The summit was held in the Canadian Parliament building's east conference room — technically neutral ground in the sense that it was Canadian and not in Ualani's jurisdiction which Marc Penoit noted with the dry humor of someone who had been making that point for three years and intended to continue. The formal session lasted six hours. The informal session — after the aides were asked to leave and the security detail cleared the adjacent hallways at the principals' request — lasted considerably longer. What was discussed during that period is sealed under joint diplomatic privilege. What is in the official record: when formal proceedings resumed the following morning all three principals had reached agreement on four items that had been deadlocked for two weeks. The alliance document was initialed. Marc Penoit looked different than he did when he walked in. So did Jessica. So did the President. The morning felt like a new thing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Sign the Framework Agreement | `standard` | sets flag `can_summit_complete` | — |
| 2 | The Full Ottawa Summit — All Diplomatic Protocols Observed | `explicit` | sets flag `can_summit_complete` | — |

**Leads to**

- scene nav: "intimate" → `CAN_SUMMIT_01_INTIMATE` — THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FOR TH... — BY MORNING

**Design notes** EXPLICIT #1 (all three); turn 13+, penoit_agreed+clearwater; BTN1/BTN2 set can_summit_complete

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_ALLIANCE_SIGNED` — THE CONTINENTAL DEFENSE ALLIANCE IS SIGNED: THREE NATIONS — ONE FRONT

**Status** FULL COMPLETION · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Triumphant/Intimate
**Chain** Canadian Alliance · position Branch
**Art** `can_alliance_signed_scene` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3844`, `Game Scenes and Scripts/world.gd:3848`

**Subhead — first draft**

> The Pen Went Around the Table Three Times. Nobody Put It Down Without Pausing.

**Body — first draft**

> The signing ceremony was held on the western shore of Lake Erie, which was Marc Penoit's suggestion, made twice — once in the official brief and once in a personal note that arrived through non-standard channels. His argument: the document that will determine the shape of this continent should be signed on ground that knew what it was before any of the three governments involved decided what to call it. The ceremony was scheduled for one hour before sunset. This was also his suggestion. The table was brought to the shore. The witnesses and cameras arranged themselves on the grass above the waterline. Ualani Carlisle signed first. She paused before she passed the pen — not hesitation, something else, the kind of pause that means you are making sure you are actually here for this moment and not somewhere else entirely. Marc Penoit signed second. His pause was longer. Jessica Commanda Odjick signed third, and she did not pause — she had already finished the thought that required pausing sometime in the previous week, and when the pen reached her she simply used it. The pen went around the table again. Everyone signed twice. It was at this point that Marc Penoit reached into his coat and produced an additional document. It was handwritten. It had been drafted in two sessions, revised in three more, and finalized on the road to Erie. It was, he explained, a personal diplomatic addendum — not required by protocol, not binding in the legal sense, but specific in the way that personal documents are specific. He set it on the table. Jessica Commanda Odjick, without expression, reached into the interior of her own coat and produced an addendum of her own. President Carlisle looked at both documents. She looked at Marc Penoit. She looked at Jessica Commanda Odjick. She said: we are doing addendums now. I did not bring an addendum. Penoit told her what to write. Clear-Water suggested the exact wording of the second sentence. What the President's addendum says has been placed under executive privilege — unusual for a public treaty and noted as such in the formal record. All three parties reviewed the designation and signed off on it. The Continental Republic and Canada are now formally allied under the Continental Defense Framework. This has been transmitted to London. A Crown correspondent present at the notification described His Majesty's reaction as the fifth time in eighteen months he has made that specific face. The witnesses are dismissed. The cameras are thanked and cleared from the grounds. The security detail withdraws to the perimeter. Lake Erie is doing what Lake Erie does with its last forty minutes of light. Jessica Commanda Odjick removes her fatigues first. She has worn them every day since the first Crown invasion took forty-three people from her territory. She folds them correctly, without ceremony, and sets them on the chair beside her. She will put them back on in the morning. Marc Penoit has produced his pipe. He smokes with the patience of someone who knows when a moment belongs to other people. Ualani Carlisle removes the Washington-style overcoat. The tricolor. The fatigues. She sets the tricorne on the table between them. The sun is maybe twenty minutes from the waterline. The signed treaty curls slightly at the edges in the lake wind. No one moves it. Marc Penoit sees the light change before the other two do. He asks if he can borrow the hat. Ualani Carlisle passes it across the table without a word. He puts it on. He removes it. He puts it on at a different angle and looks at both of them. Jessica Commanda Odjick tells him it looks ridiculous. He thanks her and walks down toward the water. There is no standing record for this configuration. Two women, heads of allied states, at the formal conclusion of the document that stands between this continent and everything the Crown intends for it. History did not anticipate this moment because history has consistently failed to anticipate them. They are both aware of this. They are both aware of each other's awareness of it. The distance between them has been closing, by degrees, since the first letter came through the Culper Ring — since Ottawa, since the morning they sat across a map together and neither of them spoke for a while. They are on the table before the sun touches the water. Marc Penoit, on the beach below, has found the angle. The light is going gold and red and briefly the color of something that has no name in any of the three languages spoken at that table today. He holds the camera up. The tricorne is at the correct degree of tilt. He is genuinely moved by what Lake Erie is doing with its last ten minutes of light and is the kind of man who permits himself to be moved by it. He does not look back toward the table. He does not need to. He gets the shot. The light goes down behind the water. He stands on the beach with the camera in one hand and the hat in the other, and the lake goes dark, and he knows without turning around that the treaty is still on the table and that everything else has changed.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Formalize the Continental Defense Alliance | `standard` | forms alliance with `CA` | — |
| 2 | The Full Ratification Ceremony — All Three in Agreement | `explicit` | forms alliance with `CA` | — |

**Leads to**

- scene nav: "intimate" → `CAN_ALLIANCE_SIGNED_INTIMATE` — LAKE ERIE, AN HOUR AFTER: THREE HEADS OF STATE ON A BEACH

**Design notes** EXPLICIT #2 (all three); fires after can_summit_complete; form_alliance CA outcome. Text polished + art integrated. Intimate variant authored + art integrated. Explicit art (can_alliance_signed_explicit.png) pending final integration.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_ALLIANCE_SIGNED_INTIMATE` — LAKE ERIE, AN HOUR AFTER: THREE HEADS OF STATE ON A BEACH

**Status** FULL COMPLETION · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `can_alliance_signed_intimate` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_ALLIANCE_SIGNED` — scene nav: "intimate" from <sub>(THE CONTINENTAL DEFENSE ALLIANCE IS SIGNED: THRE)</sub>

**Subhead — first draft**

> Marc Had Thoughts About Sovereignty. He Chose His Moment Poorly. Nobody Put a Line in the Sand.

**Body — first draft**

> The beach is longer than it looks from the table. They have been walking for twenty minutes and nobody has looked back. Marc Penoit has removed the tricorne and is carrying it by the brim. He is no longer asking what the others are thinking. He is telling them what he is thinking, which is how they know something has loosened in him. He is thinking about whether leadership is something you do to people or something you do with them. He asks Jessica Commanda Odjick. She says: the second, but the first is faster, and sometimes that matters, and the question is whether you can live with the difference. Ualani Carlisle says she spends approximately forty percent of her waking hours thinking about that exact sentence. Jessica looks at her. Ualani looks at the lake. Then Marc Penoit says: which is not entirely unlike the question of whether Quebec should be making its own determination about its political future rather than — and he is off. He is genuinely off. He has the demographics. He has the linguistic data. He has a particular feeling about the St. Lawrence that he has been carrying since he was nineteen years old in a specific cafe in Montreal and today, two hours after signing the document that may determine the shape of this continent, he is going to share all of it. He shares all of it. He is mid-sentence — something about the relationship between linguistic continuity and political sovereignty — when he glances at the two people beside him. He looks at Ualani Carlisle. He looks at Jessica Commanda Odjick. He has, it occurs to him with considerable clarity, been delivering a sustained argument for Quebecois independence to the sitting President of the United States and the sitting Prime Minister of Canada. He stops talking. He says: I have been making this case to two people who currently hold legal jurisdiction over the territory in question. Jessica Commanda Odjick says: yes. He puts the tricorne back on. He adjusts the brim with great precision. He says: I am going to look at the lake for a moment. They let him look at the lake for a moment. The border marker is easy to miss — a surveyor post, weathered, half-buried in the sand, indicating the line where one country becomes another. There is something approximately absurd about its being here, on this beach, on this evening, with this light beginning to do what it does. Ualani Carlisle picks up a piece of driftwood. Marc Penoit asks what she is doing. She says: what does it look like. She draws a heart in the sand beside the post. She writes U inside it. She holds the driftwood out. Jessica Commanda Odjick takes it. She adds a J. She holds it out. Marc Penoit looks at the heart for a moment. He looks at both of them. He adds an M. They stand there. The sun is doing the specific thing it does with the last ten minutes of light over Lake Erie — the color that doesn't have a name in any of the three languages spoken at that table today. Marc Penoit takes the tricorne off and holds it at his side. Nobody says anything about the border marker. The heart is in the sand. The sun goes down.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Intimate variant of CAN_ALLIANCE_SIGNED. Beach walk: philosophy of leadership, Marc launches into Québécois independence and visibly regrets his audience, they find the US/CA border marker and draw a heart (U+J+M) in the sand. Sun sets. Art: three-silhouette sunset scene.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_PEACE_01` — THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME TO WASHINGTON

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Triumphant
**Chain** Canadian Alliance · position Followup
**Art** `—` (Integrated) · **Explicit art** YES · **Content flag** `—` · **Repeatable** explicit · **Cooldown** false

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3852`, `Game Scenes and Scripts/world.gd:3864`

**Subhead — first draft**

> They Came Without Protocol. She Was Not Expecting Them. The Protocol Could Wait.

**Body — first draft**

> They came without announcement which the White House staff noted in the event log as highly irregular and then declined to elaborate on. Canadian President Marc Penoit and Prime Minister Jessica Commanda Odjick arrived in Washington two days after Crown forces began their retreat from the northern front. They were not scheduled. They did not file a diplomatic agenda. They brought two aides between them and left them in the anteroom. President Carlisle met them in the residential quarters rather than the office which was itself a statement. The formal portion — reviewing the joint casualty figures confirming territory secured and establishing the terms under which the alliance would continue into peacetime — took approximately ninety minutes. What followed the formal portion is in the President's personal record and not the diplomatic one. Her chief of staff reports that the three of them were in that room for five hours. When they came out all three looked like people who had finished something that had been unfinished for a long time.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Mark This Moment Together | `standard` | morale +20 | — |
| 2 | The Full Continental Peace Proceedings | `explicit` | morale +40 | — |

**Leads to**

- scene nav: "intimate" → `CAN_PEACE_01_INTIMATE` — THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME TO ... — BY MORNING

**Design notes** EXPLICIT #3 (all three); fires when can_allied + UK tiles ≤ 20 + turn ≥ 60; BTN2 +morale 40

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_ELECTION_LUCK` — PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO SAY BEFORE THE ELECTION

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Intimate
**Chain** Canadian Alliance · position Followup
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3868`, `Game Scenes and Scripts/world.gd:3874`

**Subhead — first draft**

> She Called Before Sunrise. The President Picked Up on the First Ring.

**Body — first draft**

> The call came at 5:47 a.m. which Clear-Water does not appear to have considered unusual. The President picked up on the first ring which suggests she was already awake which suggests she had been awake for some time. Jessica Commanda Odjick said she was calling before the election because she wanted to say it before the results made it complicated to say. She said the things she said. The President listened. The call lasted twenty-two minutes. Clear-Water ended it with a specific sentence that the President has declined to share with her chief of staff noting only that it was accurate and that she intended to remember it for a long time. The election is today. The Republic is watching. So is Canada.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Thank Her — The Alliance Made This Possible | `standard` | election pressure +10 | — |
| 2 | Say the Thing That Cannot Be Said After the Results | `sensual` | election pressure +15 | — |

**Leads to**

- scene nav: "intimate" → `CAN_ELECTION_LUCK_INTIMATE` — PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO SAY ... — BY MORNING

**Design notes** End-game; fires turn 93+ if can_allied; BTN1 +pressure 10 / BTN2 sensual +pressure 15

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `GEORGE_PEACE_01` — A ROYAL LETTER ARRIVES — HIS MAJESTY PROPOSES PEACE

**Status** FIRST PASS · **Type** `peace` · **Country** `GEN` · **Tone** Wry/Serious
**Chain** Peace · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4247`, `Game Scenes and Scripts/world.gd:4269`, `Game Scenes and Scripts/world.gd:4270`

**Subhead — first draft**

> George III Suggests in Writing That Everyone Stop.

**Body — first draft**

> The letter is sealed with the royal crest and delivered under flag of truce to Continental headquarters. President Carlisle read it aloud to her staff without sitting down. His Majesty George III requests, in four pages of formal English, a restoration of the territorial status as it stood before the present conflict — meaning both sides stop where they are and agree to consider the matter settled. The letter uses the word 'gracious' nine times. It uses 'sovereign' fourteen times. It uses 'regrettable' once, in reference to the war, with no indication of who His Majesty holds responsible for it. It does not use the words 'losing' or 'assistance.' The DMA summary reads: 'The timing of this letter is not coincidental.' If the alliance with Canada is in effect, any terms accepted here bind both nations. If you stand alone, you speak only for the Republic.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept His Majesty's Terms — The War Ends Here | `standard` | **george peace accept** | — |
| 2 | Decline — The Republic Does Not Negotiate on the Crown's Schedule | `standard` | **george peace reject** | — |

**Design notes** Fires turn 75-80 if war ongoing; BTN1 george_peace_accept (allied=both peaces, unallied=USA only); BTN2 george_peace_reject (+claim +1); never fires if peace already settled

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_ALLIED_01` — PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM THE CONTINENT

**Status** FIRST PASS · **Type** `peace` · **Country** `GEN` · **Tone** Epic/Triumphant
**Chain** Peace · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4378`, `Game Scenes and Scripts/world.gd:4379`

**Subhead — first draft**

> All Ports Restored. George III Departs. The War Is Over.

**Body — first draft**

> The last Crown vessel has departed [TILE_NAME]. President Carlisle and Chief Clear-Water received the formal British notice of cessation before dawn — the messenger did not wait for a reply. Every American and Canadian harbor, every dock, every fortified port the Crown held on this continent has been returned to the people it was taken from. George III's standard no longer flies here. The Continental Republic and the Indigenous Alliance of the North stand as they chose to stand: together, and victorious. The harbor is ours. The land is ours. The war is over.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Sign the Treaty — The Crown Departs the Continent | `standard` | sets flag `peace_allied_signed` | — |
| 2 | The Night After the Peace Was Signed — Ualani Carlisle and Jessica Commanda Odjick Celebrate Alone | `sensual` | sets flag `peace_allied_signed` | — |

**Leads to**

- scene nav: "intimate" → `PEACE_ALLIED_01_INTIMATE` — PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM THE C... — BY MORNING

**Design notes** Allied peace: fires when all UK dock tiles in USA+CA regions liberated (can_allied); sets uk_usa_peace+uk_ca_peace on UK country; BTN2 sensual — Ualani+Jessica celebrate

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_USA_01` — PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED THE CROWN

**Status** FIRST PASS · **Type** `peace` · **Country** `USA` · **Tone** Epic/Triumphant
**Chain** Peace · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4385`, `Game Scenes and Scripts/world.gd:4386`

**Subhead — first draft**

> All American Ports Restored. The Continental Republic Stands.

**Body — first draft**

> The last British garrison in American territory departed [TILE_NAME] under terms that required them to leave their colors. President Carlisle received the formal notice at dawn and did not acknowledge it immediately — she read it twice, folded it, and set it on her desk. Then she looked out at the harbor. Every dock from Massachusetts to South Carolina flies the Republic's flag. The war in America is over. Whatever Canada decides is Canada's matter. The Republic endures, and it endures on its own terms.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Sign the Treaty — The Republic Stands | `standard` | sets flag `peace_usa_signed` | — |
| 2 | Ualani Carlisle Marks the End of the War in Her Own Way — Alone in the President's Office at Dawn | `sensual` | sets flag `peace_usa_signed` | — |

**Leads to**

- scene nav: "intimate" → `PEACE_USA_01_INTIMATE` — PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED THE... — BY MORNING

**Design notes** USA separate peace (unallied): fires when all USA dock tiles liberated (65,66,67,151); sets uk_usa_peace on UK country; BTN2 sensual — Ualani alone at dawn

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_CA_AI_01` — PEACE OF [TILE_NAME] — CANADA NEGOTIATES SEPARATE PEACE

**Status** FIRST PASS · **Type** `peace` · **Country** `CA` · **Tone** Serious/Triumphant
**Chain** Peace · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4396`, `Game Scenes and Scripts/world.gd:4397`

**Subhead — first draft**

> Halifax Restored. Canada's War With Britain Ends.

**Body — first draft**

> Chief Clear-Water and Deputy Governor Penoit have secured the withdrawal of British forces from [TILE_NAME]. The terms were negotiated directly, without the Crown's usual conditions. Halifax is no longer British. Canada's war with Britain ends today — concluded by the people who fought it, on terms they dictated. The alliance with the Republic may or may not continue in its current form; that is a matter for peacetime politics. What is settled is settled. The Crown no longer holds Canada's ports.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Forward the Dispatch to Washington — Canada Has Made Its Choice | `standard` | sets flag `peace_ca_signed` | — |
| 2 | Send Congratulations to Clear-Water — The Alliance Holds | `standard` | sets flag `peace_ca_signed` | — |

**Design notes** CA separate peace (unallied): fires when Halifax (114), Quebec City (123), and Anticosti (195) all liberated; sets uk_ca_peace on UK+CA; player-visible dispatch; both buttons standard

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_CLEARWATER_01_INTIMATE` — PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES OUT... — BY MORNING

**Status** IDEA · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_CLEARWATER_01` — scene nav: "intimate" from <sub>(PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES)</sub>

**Subhead — first draft**

> The Letter Did Not Go Through the State Department. It Came Directly to Her.

**Body — first draft**

> [INTIMATE STUB — CAN_CLEARWATER_01] Canada arc intimate version: PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES OUTSIDE OFFICIAL CHANNELS. Write the 'By morning' version: what the relationship between these leaders looks like when the cameras and the explicit content are both absent. The warmth. The specific trust. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of CAN_CLEARWATER_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_JOINT_OPS_01_INTIMATE` — JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHARE O... — BY MORNING

**Status** IDEA · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_JOINT_OPS_01` — scene nav: "intimate" from <sub>(JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHA)</sub>

**Subhead — first draft**

> The Map Is the Same Map. That Is a Start.

**Body — first draft**

> [INTIMATE STUB — CAN_JOINT_OPS_01] Canada arc intimate version: JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHARE ONE MAP. Write the 'By morning' version: what the relationship between these leaders looks like when the cameras and the explicit content are both absent. The warmth. The specific trust. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of CAN_JOINT_OPS_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_SUMMIT_01_INTIMATE` — THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FOR TH... — BY MORNING

**Status** IDEA · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_SUMMIT_01` — scene nav: "intimate" from <sub>(THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FO)</sub>

**Subhead — first draft**

> The Room Had History in It Before Any of Them Sat Down.

**Body — first draft**

> [INTIMATE STUB — CAN_SUMMIT_01] Canada arc intimate version: THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FOR THE FIRST TIME. Write the 'By morning' version: what the relationship between these leaders looks like when the cameras and the explicit content are both absent. The warmth. The specific trust. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of CAN_SUMMIT_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_ELECTION_LUCK_INTIMATE` — PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO SAY ... — BY MORNING

**Status** IDEA · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_ELECTION_LUCK` — scene nav: "intimate" from <sub>(PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO )</sub>

**Subhead — first draft**

> She Called Before Sunrise. The President Picked Up on the First Ring.

**Body — first draft**

> [INTIMATE STUB — CAN_ELECTION_LUCK] Canada arc intimate version: PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO SAY BEFORE THE ELECTION. Write the 'By morning' version: what the relationship between these leaders looks like when the cameras and the explicit content are both absent. The warmth. The specific trust. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of CAN_ELECTION_LUCK. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_PEACE_01_INTIMATE` — THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME TO ... — BY MORNING

**Status** IDEA · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_PEACE_01` — scene nav: "intimate" from <sub>(THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME)</sub>

**Subhead — first draft**

> They Came Without Protocol. She Was Not Expecting Them. The Protocol Could Wait.

**Body — first draft**

> [INTIMATE STUB — CAN_PEACE_01] Canada arc intimate version: THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME TO WASHINGTON. Write the 'By morning' version: what the relationship between these leaders looks like when the cameras and the explicit content are both absent. The warmth. The specific trust. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of CAN_PEACE_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_ALLIED_01_INTIMATE` — PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM THE C... — BY MORNING

**Status** IDEA · **Type** `peace` · **Country** `GEN` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PEACE_ALLIED_01` — scene nav: "intimate" from <sub>(PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM T)</sub>

**Subhead — first draft**

> All Ports Restored. George III Departs. The War Is Over.

**Body — first draft**

> [INTIMATE STUB — PEACE_ALLIED_01] Peace event intimate version: PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM THE CONTINENT. Write the quieter version of this moment — what peace feels like when you're actually in it, the people around you, what gets said. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PEACE_ALLIED_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_USA_01_INTIMATE` — PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED THE... — BY MORNING

**Status** IDEA · **Type** `peace` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (N/A) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PEACE_USA_01` — scene nav: "intimate" from <sub>(PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED)</sub>

**Subhead — first draft**

> All American Ports Restored. The Continental Republic Stands.

**Body — first draft**

> [INTIMATE STUB — PEACE_USA_01] Peace event intimate version: PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED THE CROWN. Write the quieter version of this moment — what peace feels like when you're actually in it, the people around you, what gets said. Author this scene.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Stub — author intimate version of PEACE_USA_01. By morning: emotional arc, no explicit imagery.

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
