# City Liberated

5 events · FIRST PASS 5

[← back to index](00_INDEX.md)

---

### `CL_182` — NASSAU FALLS: THE PIRATES STAND WITH THE REPUBLIC

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Tense/Triumphant
**Chain** Nassau · position Root
**Art** `nassau_alliance` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `182` · tile owner `USA` · priority 2  <sub>`TRIG_033`</sub>

**Subhead — first draft**

> Calico Jack Offers Alliance

**Body — first draft**

> The Pirate Republic of Nassau does not bother with formalities. When Continental forces secured the harbor, a figure in a particularly dramatic coat — identified in intelligence reports as Calico Jack, nominal commander of what Nassau calls its navy and everyone else calls a well-organized problem — produced a document. The document said, more or less: same enemy, different methods. The alliance was not exactly official. It was extremely effective. The Royal Navy filed three separate objections. All three were intercepted by Nassau privateers. This was considered a reply.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Alliance | `standard` | weapons +30 | — |
| 2 | Grant Safe Harbor | `standard` | loyalty `Nassau Pirates` +15 | — |
| 3 | Commission the Fleet | `standard` | sets flag `nassau_privateers_active` | — |

**Design notes** Tile 182; non-repeatable; 3 alliance buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CL_001` — NYC FALLS TO THE REPUBLIC

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Triumphant/Satirical
**Chain** New York City · position Root
**Art** `nyc_liberation` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `14` · tile owner `USA` · priority 2  <sub>`TRIG_006`</sub>

**Subhead — first draft**

> Stock Market Confused Statue of Liberty Visibly Moved

**Body — first draft**

> New York City has been liberated. The Stock Market resumed operations immediately, issuing seventeen contradictory reports before noon. BUY: Liberty Bonds. SELL: Crown shipping. HOLD: general uncertainty about whether liberty is a growth sector. The Statue of Liberty wept.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Open the Stock Exchange | `standard` | gold +30 | — |
| 2 | Secure the Harbor | `standard` | army buff `defense_bonus` +3 | — |
| 3 | Summon Liberty | `standard` | fires **PROT_09_SUMMON** immediately | `PROT_09_SUMMON` |

**Leads to**

- "Summon Liberty" fires `PROT_09_SUMMON` — THE GUARDIAN OF VALLEY FORGE STIRS

**Design notes** Tile 14; non-repeatable; BTN3 summons Valley Forge Guardian

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CL_006` — GETTYSBURG SECURED

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Serious/Wry
**Chain** Gettysburg · position Root
**Art** `gettysburg_memorial` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `11` · tile owner `USA` · priority 2  <sub>`TRIG_007`</sub>

**Subhead — first draft**

> Memorial Staff Very Tired of Explaining This Is the Second Time

**Body — first draft**

> The Gettysburg Memorial has been secured by Continental forces. Tour guides who had continued operating throughout the occupation welcomed the development. 'Twice,' said head docent Patricia Eubanks. 'This field has been important twice.' She did not elaborate.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Honor the Memorial | `standard` | morale +15 | — |
| 2 | Brief Patricia Eubanks | `standard` | sets flag `eubanks_briefed` | — |

**Design notes** Tile 11; tile_feature=Gettysburg Memorial; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CL_007` — KENNETT SQUARE FREE

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Quirky/Wholesome
**Chain** Kennett Square · position Root
**Art** `mushroom_victory` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `10` · tile owner `USA` · priority 2  <sub>`TRIG_008`</sub>

**Subhead — first draft**

> Mushroom Capital of the World Emerges From Darkness (Appropriately)

**Body — first draft**

> The liberation of Kennett Square was celebrated with the largest fungi-themed victory banquet in recorded human history. Crown forces had commandeered the entire mushroom crop. It has been recovered. It is delicious. Continental supply officers are unsure how to log 'liberated mushrooms' in the official ledger but are doing their best.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Restore the Harvest | `standard` | food +25 | — |
| 2 | Enter in Ledger | `standard` | gold +10 | — |

**Design notes** Tile 10; tile_feature=Mushroom Capital; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CL_009` — BRATTLEBORO LIBERATED

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Quirky/Regional
**Chain** Brattleboro · position Root
**Art** `brattleboro_liberation` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `76` · tile owner `USA` · priority 2  <sub>`TRIG_009`</sub>

**Subhead — first draft**

> Green Mountain Boys Celebrate With Locally Grown Provisions

**Body — first draft**

> Vermont, true to form, has been quietly doing things its own way throughout the occupation. Brattleboro — which produces what the tile manifest lists as 'cannabis' and the supply ledger lists as 'morale crops' — welcomed Continental forces with characteristic Vermont energy: genuine, slightly unfocused, ultimately very effective.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Provisions | `standard` | food +20 | — |
| 2 | Update Supply Ledger | `standard` | _no mechanical effect_ | — |

**Design notes** Tile 76; tile_feature=Green Mountains; non-repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
