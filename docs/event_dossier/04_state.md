# State

4 events · FIRST PASS 4

[← back to index](00_INDEX.md)

---

### `SL_001` — PENNSYLVANIA FULLY LIBERATED

**Status** FIRST PASS · **Type** `state_liberated` · **Country** `USA` · **Tone** Triumphant/Warm
**Chain** Pennsylvania · position Root
**Art** `pa_liberated` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **State liberated** — `PA` · priority 2  <sub>`TRIG_012`</sub>

**Subhead — first draft**

> Birthplace of America Again Officially

**Body — first draft**

> The Commonwealth of Pennsylvania has been fully secured. President Carlisle flew to Philadelphia and rang the Liberty Bell. It cracked slightly. 'Tradition,' she said. The Appalachian mineral operations are back online. Corn is abundant. Pennsylvania is, as it has always been, extremely Pennsylvania.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Ring the Liberty Bell | `standard` | morale +30 | — |
| 2 | Begin Reconstruction | `standard` | food +20 | — |

**Design notes** state_liberated type; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `SL_004` — VERMONT LIBERATED

**Status** FIRST PASS · **Type** `state_liberated` · **Country** `USA` · **Tone** Quirky/Regional
**Chain** Vermont · position Root
**Art** `vermont_liberated` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **State liberated** — `VT` · priority 2  <sub>`TRIG_013`</sub>

**Subhead — first draft**

> Green Mountains Free State Insists They Were Always Kind of Free Honestly

**Body — first draft**

> Vermont has been fully liberated, which the state is accepting with the particular Vermont energy of someone who was already doing things their own way. Brattleboro's morale crop yield is up 23%. The state's collective response to liberation can be summarized as: 'Cool. Anyone want some apples?'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept Vermont's Terms | `standard` | loyalty `Common Cause` +10 | — |
| 2 | Yes I Want Some Apples | `standard` | food +15 | — |

**Design notes** state_liberated type; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `STATE_REBEL_01` — STATE DECLARES INDEPENDENCE: [TILE_NAME] RAISES A NEW FLAG

**Status** FIRST PASS · **Type** `secession` · **Country** `USA` · **Tone** Somber/Tense
**Chain** Secession Chain · position Root
**Art** `state_secession` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:2768`

**Subhead — first draft**

> The Last Letter Arrived Before Dawn.

**Body — first draft**

> The proclamation from [TILE_NAME] arrived before the sun did. The governor's signature is at the bottom. The language is formal, grievance-laden, and entirely correct about most of the facts. The state has declared independence from the Republic of the United States, citing federal neglect, unanswered correspondence, and a government that was not there when it was needed. The militia has taken the courthouse. The Continental flag has been replaced. What was once a state of the Republic is now, on paper and at gunpoint, something else entirely. President Carlisle sets the document down very carefully. She knows this name. She knows this place. The question is whether she can get it back — and whether, when she does, she wants to.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Acknowledge the Secession | `standard` | _no mechanical effect_ | — |

**Design notes** Fires when presidentialClaim very low per-state; secession type

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `STATE_REINTEGRATED_01` — [TILE_NAME] RETURNS TO THE REPUBLIC

**Status** FIRST PASS · **Type** `reintegration` · **Country** `USA` · **Tone** Somber/Decisive
**Chain** Secession Chain · position Followup
**Art** `state_reintegration` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:2806`

**Subhead — first draft**

> The State Capitol Has Fallen. The Rebellion Is Over.

**Body — first draft**

> Continental forces have retaken [TILE_NAME] — the courthouse is secured and the rebel flag has come down. The declaration of independence that seemed so permanent three weeks ago is now a historical document filed under 'problems that were solved.' What remains is the question every reconquest faces: what do you do with the people who governed against you? They were your citizens once. They had reasons. Some of those reasons were even correct. The President has to decide what the Republic stands for before sunset — not in theory but in practice and in the faces of the commanders who are waiting to find out if they have jobs tomorrow.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Pardon All — They Fought for What They Believed | `standard` | pardons state governors | — |
| 2 | Remove Them — Clean Slate, New Loyalty | `standard` | `replace_state_governors` +0 | — |

**Design notes** Fires after reconquest; pardon vs replace governors choice

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
