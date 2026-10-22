# Canada

22 events · FIRST PASS 20 · FULL COMPLETION 2

[← back to index](00_INDEX.md)

---

### `UK_BUILDUP_01` — INTELLIGENCE REPORT: CROWN FORCES AMASSING ON ALL BORDERS

**Status** FIRST PASS · **Type** `war_buildup` · **Country** `GEN` · **Tone** Tense/Urgent
**Chain** War Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4620`, `Game Scenes and Scripts/world.gd:4624`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4628`, `Game Scenes and Scripts/world.gd:4636`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4660`, `Game Scenes and Scripts/world.gd:4669`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4673`, `Game Scenes and Scripts/world.gd:4679`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4683`, `Game Scenes and Scripts/world.gd:4689`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4693`, `Game Scenes and Scripts/world.gd:4697`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4701`, `Game Scenes and Scripts/world.gd:4709`

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

- Fired from code: `GalleryTab.gd:22`, `GalleryTab.gd:23`, `Game Scenes and Scripts/world.gd:4713`, `Game Scenes and Scripts/world.gd:4717`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4721`, `Game Scenes and Scripts/world.gd:4733`

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

- Fired from code: `Game Scenes and Scripts/world.gd:4737`, `Game Scenes and Scripts/world.gd:4743`

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

- Fired from code: `Game Scenes and Scripts/world.gd:5530`, `Game Scenes and Scripts/world.gd:5552`, `Game Scenes and Scripts/world.gd:5553`

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

- Fired from code: `Game Scenes and Scripts/world.gd:5661`, `Game Scenes and Scripts/world.gd:5662`

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

- Fired from code: `Game Scenes and Scripts/world.gd:5668`, `Game Scenes and Scripts/world.gd:5669`

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

- Fired from code: `Game Scenes and Scripts/world.gd:5679`, `Game Scenes and Scripts/world.gd:5680`

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

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_CLEARWATER_01` — scene nav: "intimate" from <sub>(PM CLEAR-WATER'S PRIVATE CHANNEL: JESSICA WRITES)</sub>

**Subhead — first draft**

> The Letter Did Not Go Through the State Department. It Came Directly to Her.

**Body — first draft**

> The letter was handwritten, which is not how international communications work, which is how she knew it was not an international communication. Jessica wrote it in her personal capacity, not as Prime Minister, which is a distinction that has approximately no legal weight but carries very specific emotional weight. Ualani read it three times before she responded. The first time she read it as a diplomatic document, which is the wrong way to read it and which she corrected by the third sentence. The second time she read it as what it was, which is a letter from someone who has been trying to say something for several weeks through official channels and has decided official channels are the wrong container for it. The third time she sat with it. What Jessica said in the letter is under executive privilege and will remain there. What Ualani wrote back is under the same privilege, was shorter, and said what she meant, which she almost never does in written form. The secure channel logged the exchange as a diplomatic communication. The diplomatic communication was, in fact, a conversation that two people had needed to have for a while, conducted across the border in handwriting, which is slower than a signal and more permanent.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Canada — authored; handwritten letter outside official channels; permanent across the border

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_JOINT_OPS_01_INTIMATE` — JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHARE O... — BY MORNING

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_JOINT_OPS_01` — scene nav: "intimate" from <sub>(JOINT INTELLIGENCE SUMMIT: THREE GOVERNMENTS SHA)</sub>

**Subhead — first draft**

> The Map Is the Same Map. That Is a Start.

**Body — first draft**

> The map was still on the table at midnight. Penoit had gone — he had an early briefing and he had the quality of someone who knows when his presence is no longer the primary thing in the room. Three governments' intelligence in one place is a map that is very full and very complicated and by midnight it had been understood and analyzed and the next moves had been agreed and the formal summit had ended an hour before. What remained: Ualani, Jessica, the map, and the specific quality of a room where something important has been worked out and the people who worked it out are still in it. Jessica said: I think we've done something here. Ualani said: I think so too. Jessica said: I don't say that about a lot of things. Ualani said: I know. They looked at the map. Three colors on it — three countries' operations, interlocking in ways that hadn't existed in the spring. Jessica said, after a while: I didn't think this would work when Marc first proposed it. Ualani said: what changed your mind. Jessica said: you, mostly. She said it the way people say things that are true and which they have been delaying saying. Ualani looked at the map. She said: same. The room was quiet. The map was full of their work. That is what a shared intelligence operation looks like at midnight when it has actually worked.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Canada — authored; intelligence map at midnight; Marc leaves, Jessica stays

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_SUMMIT_01_INTIMATE` — THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FOR TH... — BY MORNING

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_SUMMIT_01` — scene nav: "intimate" from <sub>(THE OTTAWA SUMMIT: ALL THREE IN THE SAME ROOM FO)</sub>

**Subhead — first draft**

> The Room Had History in It Before Any of Them Sat Down.

**Body — first draft**

> The room had been built for governance — high ceilings, long table, the architectural weight of consequence. By midnight it had been a diplomatic summit and a war planning session and a meal and three separate bilateral conversations that had somehow occurred simultaneously. Now it was the end of the evening and the room had changed from formal to the particular informal that only emerges when people have been in the same space long enough to stop performing in it. Marc Penoit had the quality of someone who is present and also cataloguing everything, which is his characteristic mode. He said, to both of them: this is the first time in the history of these two countries that the leadership of both is in the same room without a crisis. Ualani said: there is still a war. He said: I mean without one country asking the other for something out of desperation. Which is a different quality of meeting. He was right. What happened in Ottawa was not desperation diplomacy — it was two governments that had chosen each other. Jessica said something to Marc in French. He said something back in French. Ualani said: I don't speak French. Jessica said: I know. She said it in the particular register that means: I will tell you later. Ualani said: will you. Jessica said: yes. That is a promise. Which is a different kind of diplomatic instrument.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Canada — authored; Ottawa Summit night; Marc's 'I told you'; promise to translate later

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_ELECTION_LUCK_INTIMATE` — PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO SAY ... — BY MORNING

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Canadian Alliance · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_ELECTION_LUCK` — scene nav: "intimate" from <sub>(PM CLEAR-WATER'S CALL: JESSICA HAS SOMETHING TO )</sub>

**Subhead — first draft**

> She Called Before Sunrise. The President Picked Up on the First Ring.

**Body — first draft**

> She called before sunrise. Ualani was already awake because she is always already awake before sunrise when something large is happening, which is the specific insomnia of people who find it easier to be awake and watching than asleep and unaware. She picked up on the first ring. Jessica said: I don't have an official statement. She said: I know. Jessica said: I just wanted to call. She said: I know that too. Jessica was quiet for a moment and then said the things she had called to say, which were not strategy and not endorsement and not anything the communications office would have cleared, which is why she did not go through the communications office. She called in her personal capacity. She said the thing she had wanted to say since the spring and had found no official occasion for. Ualani listened. The Republic is not, technically, supposed to be influenced by the opinions of foreign heads of government about domestic elections. The Republic can, however, take a phone call before sunrise from someone who has been building something alongside you and who wants to tell you what she has watched you become in the last two years. Ualani said: I'll tell you on Wednesday how it went. Jessica said: I'll be watching. She said: I know. She said: thank you for calling. The specific quality of dawn has something to do with it — the hour when what is real and what is performed are the same thing.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Canada — authored; before-sunrise call; unofficial, personal capacity

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CAN_PEACE_01_INTIMATE` — THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME TO ... — BY MORNING

**Status** FIRST PASS · **Type** `canada_diplomacy` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `CAN_PEACE_01` — scene nav: "intimate" from <sub>(THE TIDE HAS TURNED: PENOIT AND CLEAR-WATER COME)</sub>

**Subhead — first draft**

> They Came Without Protocol. She Was Not Expecting Them. The Protocol Could Wait.

**Body — first draft**

> They came without an appointment, which Marc Penoit has never done in his life, which is how Ualani knew what the visit meant before she saw their faces. She opened the door at 9 PM to Marc, and Jessica behind him, and the specific quality of two people who have come a long way without the formal apparatus of the visit, because the formal apparatus is the wrong container for this. She said: come in. They came in. Marc set down his coat and immediately found the kitchen — he locates the kitchen and determines the coffee situation in any building he enters — and this time he also made tea without asking, because Marc Penoit knows when people need tea. Jessica stood in the living room of the residence and looked at it — the way you look at a place that has been, in some real sense, a partner in what you've been doing, even though it's a building. She said: is this what it looked like when it was rebuilt. Ualani said: more or less. Jessica said: it held. Ualani said: yes. Marc brought the tea. They sat down. Outside, the Republic that had held was still holding. Inside, three people who had made sure it held sat with that fact for the first time without a crisis requiring them to do something about it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Canada — authored; Marc and Jessica arrive unannounced; Marc makes tea

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_ALLIED_01_INTIMATE` — PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM THE C... — BY MORNING

**Status** FIRST PASS · **Type** `peace` · **Country** `GEN` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PEACE_ALLIED_01` — scene nav: "intimate" from <sub>(PEACE OF [TILE_NAME] — THE CROWN EXPELLED FROM T)</sub>

**Subhead — first draft**

> All Ports Restored. George III Departs. The War Is Over.

**Body — first draft**

> The treaty was signed at 14:00 and the press corps documented the signing and the handshake and the formal exchange of instruments and all the proper record-making that peace requires. What the press corps did not document: 22:00, the same building, the formal occasion over, the principals still in the building by choice. Ualani. Jessica. Marc, who had been watching from the corner all evening with the specific satisfaction of someone who knew this outcome was possible before anyone else was willing to believe it. The Crown's instruments had been countersigned and dispatched. The last British transport was already in the outer harbor. The Republic — both Republics — were intact. Jessica said something in French that she did not translate. Ualani did not ask for the translation. She understood the weight of it, which is the same as the meaning in the register it was offered. Marc raised his glass and said something brief and entirely sincere, which is unusual enough from Marc that both of them looked at him. He said: I told you. Which is not an accurate account of what happened but which is, in spirit, not untrue. The night was long. No one was in a hurry. Somewhere outside, the last Crown standard was coming down. Inside, three people who had built this together sat with it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Peace — authored; treaty signed, 22:00 same room; Marc's 'I told you', Jessica's French

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `PEACE_USA_01_INTIMATE` — PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED THE... — BY MORNING

**Status** FIRST PASS · **Type** `peace` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Peace · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `PEACE_USA_01` — scene nav: "intimate" from <sub>(PEACE OF [TILE_NAME] — THE REPUBLIC HAS EXPELLED)</sub>

**Subhead — first draft**

> All American Ports Restored. The Continental Republic Stands.

**Body — first draft**

> The last dispatch came at 11:17 PM and the last of the war's administrative machinery had been given its instructions and Ualani Carlisle was alone in the West Wing for the first time since the spring of the first year. This is what she had been working toward. This is what the dead had been working toward. This is what Valley Forge is about, and the Liberty Bell, and the Mothman watching from the ridge, and [COMMANDER_NAME] in the cold with insufficient boots, and every person who had handed her a dispatch from a place that was not safe and trusted her to do something useful with the information. She stood at the window. The city was not quiet — cities are never quiet after peace, they make a different kind of noise, the noise of people who have just been told they are allowed to stop being afraid. She thought about calling someone. She thought about who she wanted to tell this to first. The answer was clear and it required no decision. [COMMANDER_NAME] picked up on the second ring. She said nothing for a moment. [COMMANDER_NAME] said nothing back. They stayed on the line. Outside, a city was making the specific noise of not being at war anymore. She listened to it. [COMMANDER_NAME] listened with her. That was all that was necessary.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Peace — authored; last dispatch 11:17PM; COMMANDER_NAME on second ring, listening together

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
