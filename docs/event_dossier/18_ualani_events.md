# Ualani Events

4 events · FIRST PASS 4

[← back to index](00_INDEX.md)

---

### `UALANI_DOCK_01` — PRESIDENT CARLISLE SURVEYS THE HARBOR AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Businesslike/Warm
**Chain** Ualani Expansion · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Ships Were Already There. She Knew Their Names Too.

**Body — first draft**

> The harbor at [TILE_NAME] operates on the schedule the Continental Navy has kept since the first commissioning — tide-dependent, cargo-heavy, and largely indifferent to whether anyone important is watching. President Carlisle arrived before the dock supervisor was informed she was coming. She walked the length of the working quay with [COMMANDER_NAME] at the hour the morning crew reports and asked the kind of questions that indicate she has personally reviewed the shipping manifests and the tonnage logs and has opinions about both. The dock crew found her presence alarming for approximately six minutes and then not alarming at all. She understood what moved through here and why it mattered. She understood which routes were exposed and which held. When she left, the harbor supervisor filed a report noting that the President had identified an inefficiency in the eastern loading rotation that his office had been meaning to address for four months. He addressed it that afternoon.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Authorize Extended Dock Operations | `standard` | boats +20 | — |
| 2 | Inspect the Supply Routes | `standard` | morale +25 | — |
| 3 | The Full Presidential Dock Survey | `explicit` | boats +35 | — |

**Design notes** Ualani at tile with enabled Dock; triggers via _check_ualani_dock()

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_FARM_01` — PRESIDENT CARLISLE VISITS THE FARMLANDS AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Grounded/Warm
**Chain** Ualani Expansion · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Harvest Does Not Wait. Neither Did She.

**Body — first draft**

> The farmlands at [TILE_NAME] run on the calendar the land sets, not the one the administration files. President Carlisle arrived during the pre-dawn window before the field work begins, which the farm supervisors describe as 'earlier than expected' and the President describes as 'the only honest hour.' She walked the acreage with [COMMANDER_NAME]. She asked about soil composition, water access, the specific math of what this land can yield under current conditions. [COMMANDER_NAME] provided the figures. She did not write them down. She had already read them. The workers who were already in the fields when she arrived report that she spoke to them by name — that she knew the names because she had read the labor reports and remembered them, not as an abstraction but as specific names belonging to specific people doing specific work that the Republic depends on. The farm output assessment filed the following week notes conditions as stable. The morale assessment notes conditions as considerably better than stable.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Issue Emergency Harvest Authorization | `standard` | food +40 | — |
| 2 | Walk the Fields | `standard` | morale +30 | — |
| 3 | The Full Farmland Visit | `explicit` | food +60 | — |

**Design notes** Ualani at Farmlands terrain tile; triggers via _check_ualani_farm()

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_BARRACKS_01` — PRESIDENT CARLISLE CONDUCTS REGIMENTAL REVIEW AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Military/Crisp
**Chain** Ualani Expansion · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Regiment Was Ready. The President Made Certain of It.

**Body — first draft**

> The regimental review at [TILE_NAME] was announced at 0500. President Carlisle was on the parade ground at 0445. [COMMANDER_NAME] reports this as consistent with the President's general approach to being somewhere before anyone can prepare for her to be there. The regiment was under arms before first light. She walked the line. She reviewed the arms condition, the manpower count, the supply state, and the specific readiness notes [COMMANDER_NAME] had filed in the preceding month. She had read those notes. She asked about them specifically. The regiment, which had been at standard readiness, is now at a readiness level that does not have an official category. The category would be approximately: aware that the President has personally reviewed the ammunition count and found it sufficient.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Full Regimental Inspection | `standard` | army buff `Inspired` +3 | — |
| 2 | Issue Field Citation | `standard` | morale +35 | — |
| 3 | The Full Presidential Review | `explicit` | army buff `Inspired` +5 | — |

**Design notes** Ualani at tile with Barracks + stationed army; triggers via _check_ualani_barracks()

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `UALANI_COURTHOUSE_01` — PRESIDENT CARLISLE HOLDS TOWN HALL AT [TILE_NAME]

**Status** FIRST PASS · **Type** `ualani_event` · **Country** `USA` · **Tone** Political/Warm
**Chain** Ualani Expansion · position Root
**Art** `—` (Not Started) · **Explicit art** YES · **Content flag** `sensual` · **Repeatable** 15 · **Cooldown** 0

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The President Asked for Questions. There Were Many Questions.

**Body — first draft**

> The courthouse at [TILE_NAME] was not designed for town halls. It was designed for jurisprudence, which requires a specific kind of order that town halls do not reliably provide. President Carlisle occupied it for three hours with [COMMANDER_NAME] in attendance and the local population in attendance and at least one person who had been waiting to ask about the road access situation since before the war started and asked about it at length. The President answered. She answered the road access question, the supply shortage question, the question about the garrison rotation schedule, the three questions about the eastern tile boundary that were technically the same question asked by different people, and a question from a child about whether the Continental Army had horses. The meeting ran forty minutes over schedule. The courthouse administrator noted in the post-meeting report that attendance had exceeded projections and that civilian approval metrics had improved in a way that would normally require a dedicated outreach campaign and did not require one this time.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Address the Assembly | `standard` | tile moral decay -20 | — |
| 2 | Hold Open Questions | `standard` | morale +30 | — |
| 3 | The Full Town Hall Session | `explicit` | tile moral decay -35 | — |

**Design notes** Ualani at Courthouse tile; no moralDecay gate (cf. UALANI_DIGNITARY_01); triggers via _check_ualani_courthouse()

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
