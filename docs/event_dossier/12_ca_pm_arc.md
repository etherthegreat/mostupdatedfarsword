# CA PM Arc

8 events · FIRST PASS 8

[← back to index](00_INDEX.md)

---

### `CA_PM_FIRST_MEETING` — MARC PENOIT REQUESTS A WAR COUNCIL

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Tense/Candid
**Chain** CA PM Arc · position Root
**Art** `mark_penoit` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4442`, `Game Scenes and Scripts/world.gd:4446`

**Subhead — first draft**

> The Deputy Governor Has Opinions About the Eastern Flank. Several of Them Are Correct.

**Body — first draft**

> The dispatch from Quebec City arrived at Prime Ministerial residence before breakfast and was considerably longer than any dispatch needed to be — Marc Penoit has opinions about supply chains‚ the eastern flank‚ the positioning of the 3rd Militia‚ and at least one strong objection to a recent deployment decision he did not make. He requests a formal war council. He will‚ he notes‚ be arriving regardless of whether the request is approved.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Convene the War Council | `standard` | sets flag `ca_pm_met` | — |
| 2 | Table His Assessment — For Now | `standard` | sets flag `ca_pm_met` | — |

**Design notes** Deputy Governor demands a war council; BTN1 morale / BTN2 harmony

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_COUNSEL` — PENOIT COUNSELS RESTRAINT — OR POSSIBLY AGGRESSION

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Candid/Military
**Chain** CA PM Arc · position Branch
**Art** `penoit_counsel` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4450`, `Game Scenes and Scripts/world.gd:4456`

**Subhead — first draft**

> The Deputy Governor Has Read the Numbers and Has Thoughts.

**Body — first draft**

> Marc Penoit spread the territorial maps across the floor of the command tent and pointed at each one in turn. His analysis was precise‚ quietly furious‚ and correct. The Republic's grip on the eastern territories is weaker than the official reports suggest. He is not panicking. He is doing the thing he always does: seeing the situation clearly and telling you about it at length. The Prime Minister has the option to listen or to delegate. He will notice which option is chosen.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept His Assessment | `standard` | morale +10 | — |
| 2 | Ask Penoit to Lead the Eastern Response | `standard` | loyalty `ca_pm_faction` +10 | — |

**Design notes** Penoit analyzes eastern flank; BTN1 morale / BTN2 harmony

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_DOUBT` — PENOIT QUESTIONS THE MILITIA'S RESOLVE

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Tense/Urgent
**Chain** CA PM Arc · position Branch
**Art** `penoit_doubt` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4460`, `Game Scenes and Scripts/world.gd:4466`

**Subhead — first draft**

> Morale in the Quebec Corridor Is Low. The Deputy Governor Is Not Surprised.

**Body — first draft**

> The French Habitants have been holding the Saint Lawrence corridor for six weeks without reinforcement‚ relief‚ or any apparent acknowledgement from the capital that the corridor exists. Marc Penoit filed a report that said‚ essentially: I told you this would happen. The report contained tactical recommendations‚ a request for additional weapons shipments‚ and a single handwritten note at the bottom: Fix this or we lose Quebec. He means it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Remind the Habitants Why They Fight | `standard` | morale +15 | — |
| 2 | Penoit Needs More Than Words Right Now | `sensual` | morale +25 | — |

**Design notes** Morale low in Quebec corridor; BTN1 weapons / BTN2 harmony

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_LOYALTY_TEST` — FRENCH HABITANTS FEEL LEFT BEHIND

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Tense/Political
**Chain** CA PM Arc · position Branch
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4470`, `Game Scenes and Scripts/world.gd:4478`

**Subhead — first draft**

> A Québécois Veteran Speaks from the Capitol Steps

**Body — first draft**

> French Canadian citizenry have gathered in Ottawa to demand the Prime Minister recognize their cultural autonomy rights under emergency law. "French is being systematically suppressed in the Canadian armed forces in favour of the aggressor's own language‚" one Québécois veteran declared from the capitol steps. How the Republic responds will define its relationship with its Francophone citizens for a generation.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Promise Dual Language Rights | `standard` | `add_law` `French Language Rights` +0 | — |
| 2 | Patronize Québécois Cultural Institutes | `standard` | `add_law` `French Cultural Identity Enshrined` +0 | — |

**Design notes** French Habitants ultimatum; BTN1 harmony / BTN2 mandate

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_BATTLEFIELD` — JUST IN FROM THE FRONT — PRESIDENT PENOIT IS LEADING THE CHARGE PERSONALLY

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Tense/Decisive
**Chain** CA PM Arc · position Branch
**Art** `ca_pm_battlefield_scene` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:20`, `Game Scenes and Scripts/world.gd:4483`, `Game Scenes and Scripts/world.gd:4491`

**Subhead — first draft**

> The Deputy Governor Filed One Dispatch. It Read: I Am Where I Am Needed.

**Body — first draft**

> The dispatch arrived before the reports did. Penoit has moved up. No one had ordered Penoit to move up. No one‚ apparently‚ had ordered Penoit not to. He is currently on the field at [TILE_NAME]‚ has assumed tactical command of the militia units present‚ and by all accounts is personally leading saber charges against the Crown's infantry. The photography unit has images. Prime Minister Clear-Water has seen the images. She is deciding whether to release them to the public — valuable as a symbol of presidential courage‚ dangerous as an invitation for every soldier in Quebec to believe they can do the same. Both assessments are correct.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Spread the Images — Let the Republic See What Its President Does | `standard` | `propaganda_spread` +2 | — |
| 2 | Limited Recruitment Drive — Quebec Needs Soldiers Not Legends | `standard` | `quebec_manpower_refill` +0 | — |

**Design notes** Penoit moves up without orders; BTN1 morale_boost +20 / BTN2 harmony_boost +5

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_PRE_ELECTION` — PENOIT ADDRESSES THE REPUBLIC: THE ELECTION IS COMING

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Principled/Political
**Chain** CA PM Arc · position Branch
**Art** `penoit_speech` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4495`, `Game Scenes and Scripts/world.gd:4501`

**Subhead — first draft**

> The Deputy Governor Has Prepared a Speech. It Is Not a Short Speech.

**Body — first draft**

> Marc Penoit has not historically been a speech-giver. He is a report-writer‚ a flank-watcher‚ a person who disagrees with the alliance about once a week but never enough to leave. The speech he delivered in Quebec City was thirty-two minutes long and contained precise tactical breakdowns‚ three direct appeals to French Habitant constituents‚ and one moment at the end that was quiet and uncharacteristically personal. He said: I did not march this far to hand the colony back to London in a different hat. The crowd responded appropriately.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Endorse the Speech — Release It to the Press | `standard` | claim → `` +1 | — |
| 2 | Ask Penoit to Adjust the Tone | `standard` | morale +10 | — |

**Design notes** Penoit's 32-minute speech in Quebec City; BTN1 culture / BTN2 harmony

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_SOLIDARITY` — PENOIT AND THE PROTECTORS — THE DEPUTY GOVERNOR ACKNOWLEDGES THE CREATURES

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Wry/Principled
**Chain** CA PM Arc · position Branch
**Art** `penoit_solidarity` (Integrated) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:4506`, `Game Scenes and Scripts/world.gd:4512`

**Subhead — first draft**

> He Stepped Outside This Morning. The Snow Was Different.

**Body — first draft**

> Marc Penoit has spent thirty years writing reports about things he could measure. This morning he went outside and stood in the snow for a long time and did not write anything. His dog was with him. The dog seemed to know where to walk. The Quebec woods that have been wrong since before the first muster — too quiet‚ too cold‚ something absent from the underside of things — are not wrong anymore. He has three protector acknowledgments on file. He did not understand what they meant when he signed them. He stood in the snow until the cold became unremarkable and then he came inside and wrote one line in the daily report: the land has changed. Filed it. Did not explain.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Forward the Report to the Alliance — They Should Know What They're Working With | `standard` | morale +15 | — |
| 2 | File It With the Records Office | `standard` | harmony +10 | — |

**Design notes** Penoit stands in the snow; land has changed; BTN1 / BTN2

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CA_PM_LEGACY` — MARC PENOIT SUBMITS HIS FINAL REPORT — THE ALLIANCE HAS BEEN WORTH IT

**Status** FIRST PASS · **Type** `ca_vp` · **Country** `CA` · **Tone** Serious/Warm
**Chain** CA PM Arc · position Chain
**Art** `penoit_legacy` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `GalleryTab.gd:21`, `Game Scenes and Scripts/world.gd:2812`, `Game Scenes and Scripts/world.gd:2832`, `Game Scenes and Scripts/world.gd:2907`, `Game Scenes and Scripts/world.gd:2918`

**Subhead — first draft**

> The Deputy Governor Has Filed Something That Is Technically a Report. It Is Not Only a Report.

**Body — first draft**

> Marc Penoit filed his final pre-election review at six-thirty in the morning‚ when the Parliament building was quiet and the aide who normally handles distribution had not yet arrived. He printed two copies. One went into the official record. He left the second on the Prime Minister's desk without a cover note‚ which is the most communication he has ever expressed through the absence of words. The review runs seventeen pages. The first fourteen are standard: operational assessment‚ alliance efficacy metrics‚ protector engagement summary‚ Quebec corridor stabilization data. The last three pages are something else. They are not formatted as a report. They are not‚ technically‚ a report. They are Marc Penoit writing‚ in the voice he uses when no one is watching him write‚ about what he has watched the Republic become in the time since the first emergency session. He describes the militia's resolve. The protectors' patience. The specific morning in late autumn when he stood in the snow and understood that the land had already decided. He describes the Prime Minister without using her name once‚ which is its own kind of precision. He does not end with a conclusion. He ends with: this record is accurate as of the date filed. It will remain accurate. Some things do not require revision. The aide distributed the official copy at eight-thirty. The PM's copy was still on the desk when Penoit arrived for the morning briefing. He did not mention it. She did not mention it. This is how they have always worked.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Record — The Alliance Archives Will Know His Name | `standard` | claim → `` +1 | — |

**Design notes** Dynamic event assembled at runtime; BTN1 / BTN2

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
