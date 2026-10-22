# Chalchiuhtotolin

5 events · FIRST PASS 5

[← back to index](00_INDEX.md)

---

### `CHALCH_SUMMON` — CHALCHIUHTOTOLIN ARRIVES AT PLYMOUTH ON THANKSGIVING

**Status** FIRST PASS · **Type** `protector_summon` · **Country** `USA` · **Tone** Epic/Absurdist
**Chain** Jade Turkey Arc · position Root
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3350`, `Game Scenes and Scripts/world.gd:3352`, `Game Scenes and Scripts/world.gd:3355`, `Game Scenes and Scripts/world.gd:3356`

**Subhead — first draft**

> The Jade Turkey God Has Chosen the Appropriate Occasion

**Body — first draft**

> It is Thanksgiving. You are in Plymouth. Of course it is happening here. Of course it is happening now. The entity that appeared at the treeline shortly after sunset is large, feathered, and luminously green — a turkey the size of a barn, with jade-bright eyes and the bearing of something that has been waiting for exactly this moment for approximately four hundred and fifty years. It has a name. The Department of Mythological Affairs would later confirm it from the Florentine Codex: Chalchiuhtotolin, the Jade Turkey, divine aspect of Tezcatlipoca, bringer of pestilence to enemies and abundance to those it protects. It has chosen Plymouth. It has chosen Thanksgiving. It is looking at you like this is very obvious.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Pact with the Jade Turkey | `standard` | _no mechanical effect_ | — |
| 2 | Attempt to Ignore the Jade Turkey (It Is Still There) | `standard` | _no mechanical effect_ | — |

**Design notes** Month 11, Ualani at tile 66 (Plymouth); one-shot; sets chalch_summoned flag

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CHALCH_Q1` — THE JADE TURKEY DEMANDS THREE GRANARIES

**Status** FIRST PASS · **Type** `protector_quest` · **Country** `USA` · **Tone** Quirky/Epic
**Chain** Jade Turkey Arc · position Quest 1
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3364`, `Game Scenes and Scripts/world.gd:3366`, `Game Scenes and Scripts/world.gd:3369`, `Game Scenes and Scripts/world.gd:3370`

**Subhead — first draft**

> Chalchiuhtotolin Has Reviewed Your Agricultural Report and Found It Wanting

**Body — first draft**

> The message arrived at dawn in a format the DMA had not previously encountered: corn kernels arranged on a flat stone in the unmistakable pattern of a demand letter. Three farms. The Jade Turkey wants three farms before the next time it visits you in your dreams to deliver its full opinion of your food policy. The request is, in context, extremely reasonable. The entity is motivated. The harvest requires more faith than this.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Present the Granaries to the Jade Turkey | `standard` | food +30 | — |

**Design notes** Fires when chalch_summoned + 3+ farms; reward: +30 food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CHALCH_Q2` — THE JADE TURKEY DEMANDS A STOCKPILE WORTHY OF ITS REGARD

**Status** FIRST PASS · **Type** `protector_quest` · **Country** `USA` · **Tone** Quirky/Epic
**Chain** Jade Turkey Arc · position Quest 2
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3375`, `Game Scenes and Scripts/world.gd:3377`, `Game Scenes and Scripts/world.gd:3380`, `Game Scenes and Scripts/world.gd:3381`

**Subhead — first draft**

> 150 Units of Food. The Turkey Is Watching.

**Body — first draft**

> The second message arrived in the form of a cornucopia left on the White House doorstep and a dream in which an enormous jade-feathered entity stood in the White House kitchen and reviewed your pantry with obvious professional disappointment. 150 units of food. The Jade Turkey expects abundance, not austerity. It is the divine embodiment of harvest and plague and it will not be party to a Republic that runs out of corn. Fill the stockpile.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Fill the Stockpile as Demanded | `standard` | food +50 | — |

**Design notes** Fires when chalch_q1_done + TotalFood >= 150; reward: +50 food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CHALCH_Q3` — THE JADE TURKEY DEMANDS A NATION OF FARMS

**Status** FIRST PASS · **Type** `protector_quest` · **Country** `USA` · **Tone** Quirky/Epic
**Chain** Jade Turkey Arc · position Quest 3
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3386`, `Game Scenes and Scripts/world.gd:3388`, `Game Scenes and Scripts/world.gd:3391`, `Game Scenes and Scripts/world.gd:3392`

**Subhead — first draft**

> Five Farms. The God of the Harvest Has Standards.

**Body — first draft**

> The third demand arrived carved into a squash the size of a wagon wheel, delivered to the Presidential residence by means nobody witnessed and nobody could explain. Five farms. The nation must be capable of feeding itself before the Jade Turkey will formalize the arrangement. Chalchiuhtotolin has watched four hundred years of what happens to civilizations that don't take their grain seriously. It is not interested in watching it happen again.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Show the Turkey God Five Farms | `standard` | food +40 | — |

**Design notes** Fires when chalch_q2_done + 5+ farms; reward: +40 food

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CHALCH_AGREE` — CHALCHIUHTOTOLIN ACCEPTS THE PACT — THE REPUBLIC HAS EARNED THE TURKEY GOD'S PROTECTION

**Status** FIRST PASS · **Type** `protector_quest` · **Country** `USA` · **Tone** Epic/Triumphant
**Chain** Jade Turkey Arc · position Resolution
**Art** `—` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. Values above are the corrected reading.

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3397`, `Game Scenes and Scripts/world.gd:3398`, `Game Scenes and Scripts/world.gd:3399`, `Game Scenes and Scripts/world.gd:3400`

**Subhead — first draft**

> The Jade Turkey Is Satisfied. This Is Unprecedented.

**Body — first draft**

> The entity arrived at the White House steps at noon on a Sunday with the bearing of something that has been running agricultural inspections for four hundred years and has finally found a client worth protecting. Chalchiuhtotolin, the Jade Turkey of Tezcatlipoca, formally endorses the Second American Republic. The endorsement came with a gift: an enormous deposit of jade-green corn, more than the kitchen staff had ever seen in one place, arranged on the South Lawn before dawn. The Department of Mythological Affairs filed a report. The report was titled: 'Turkey God, Jade. Status: Pleased. Recommendation: Continue farming.'

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Jade Turkey's Protection | `standard` | food +100 | — |

**Design notes** Fires when chalch_q3_done; BTN1: +100 food; closes the arc

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
