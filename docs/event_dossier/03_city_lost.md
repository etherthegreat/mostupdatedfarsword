# City Lost

2 events · FIRST PASS 2

[← back to index](00_INDEX.md)

---

### `CX_001` — DC FALLS: Government in Temporary Relocation

**Status** FIRST PASS · **Type** `city_lost` · **Country** `GEN` · **Tone** Tense/Darkly Funny
**Chain** Washington DC · position Root
**Art** `dc_falls` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 50

**Fires when**

- **Tile lost** — tile `188` · tile owner `UK` · priority 1  <sub>`TRIG_010`</sub>

**Subhead — first draft**

> President Carlisle Very Calm Suspiciously Calm

**Body — first draft**

> Washington DC has fallen. The White House press secretary is calling it 'a strategic redeployment of symbolic infrastructure.' President Carlisle has relocated to Valley Forge — quote, for the poetry of it. Her staff has noted that the poetry of Valley Forge historically involves significant casualties from exposure. The President is aware of this.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Relocate to Valley Forge | `standard` | morale +10 | — |
| 2 | Issue a Statement | `standard` | loyalty `Continental Congress` +5 | — |

**Design notes** Tile 188; repeatable cooldown 50

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CX_005` — GETTYSBURG TAKEN

**Status** FIRST PASS · **Type** `city_lost` · **Country** `GEN` · **Tone** Somber/Wry
**Chain** Gettysburg · position Root
**Art** `gettysburg_lost` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 50

**Fires when**

- **Tile lost** — tile `11` · tile owner `UK` · priority 2  <sub>`TRIG_011`</sub>

**Subhead — first draft**

> Memorial Docents Maintaining Composure Army Less So

**Body — first draft**

> Gettysburg has been lost to Crown forces. The memorial staff have remained on-site and are narrating the occupation with exhausted professionalism. 'Three days,' said head docent Patricia Eubanks. 'Last time it was three days.' She is keeping a log. This too shall pass.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Coordinate Recapture | `standard` | army buff `attack_bonus` +3 | — |
| 2 | Support Patricia Eubanks | `standard` | sets flag `eubanks_supported` | — |

**Design notes** Tile 11; tile_feature=Gettysburg Memorial; repeatable

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
