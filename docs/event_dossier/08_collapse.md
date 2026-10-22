# Collapse

3 events · FIRST PASS 3

[← back to index](00_INDEX.md)

---

### `COLLAPSE_01` — THE REPUBLIC HAS FALLEN

**Status** FIRST PASS · **Type** `collapse` · **Country** `USA` · **Tone** Somber/Historic
**Chain** Republic Falls · position Root
**Art** `collapse_republic` (Not Started) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3426`, `Game Scenes and Scripts/world.gd:3427`, `Game Scenes and Scripts/world.gd:3441`, `Game Scenes and Scripts/world.gd:3442`

**Subhead — first draft**

> King George III Accepts the Surrender. The Coasts Belong to the Crown.

**Body — first draft**

> The last American metro fell without ceremony. No rousing speech. No dramatic last stand — just the hollow sound of boots on cobblestones and a flag coming down. King George III, through his colonial secretary, has offered terms: the interior states may organize their own governments under British suzerainty. The eastern seaboard — from Maine to Florida — is henceforth Crown territory. President Ualani Carlisle sits in the White House with a cup of coffee that has gone cold and a situation that has gone considerably colder. The Continental Congress has dissolved. Fifteen new flags fly over fifteen new governments that did not exist last week. The Republic, as constituted, is finished. Washington DC stands alone — the last tile, the last address, the last president of the United States of America.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Accept the Terms of Peace | `standard` | **triggers republic collapse** | — |

**Design notes** trigger_collapse outcome; fires when all metros fall

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `COLLAPSE_02` — WASHINGTON STANDS ALONE

**Status** FIRST PASS · **Type** `collapse` · **Country** `USA` · **Tone** Somber/Intimate
**Chain** Republic Falls · position Followup
**Art** `ualani_washington` (Not Started) · **Explicit art** YES · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Fired from code: `Game Scenes and Scripts/world.gd:3739`

**Subhead — first draft**

> The Last Tile. The Last President. The Last Chance.

**Body — first draft**

> The White House is quieter than it has ever been. The flags of fifteen states fly over fifteen new governments. The British fleet patrols the Chesapeake. Technically, historically, this is a loss. Ualani Carlisle walks the National Mall at three in the morning — boots on the same stones that Jefferson walked, that Lincoln walked, that every president who felt the weight of the thing too keenly to carry sitting down had walked before her. She is alone. Washington still stands. That, for now, is enough.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | The Long Night | `explicit` | morale +30 | — |
| 2 | Hold the Line | `standard` | morale +10 | — |

**Leads to**

- scene nav: "intimate" → `COLLAPSE_02_INTIMATE` — WASHINGTON STANDS ALONE — BY MORNING

**Design notes** BTN1 explicit 'The Long Night' morale+30 / BTN2 standard 'Hold the Line' morale+10

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `COLLAPSE_02_INTIMATE` — WASHINGTON STANDS ALONE — BY MORNING

**Status** FIRST PASS · **Type** `collapse` · **Country** `USA` · **Tone** Warm/Tender
**Chain** Republic Falls · position Chain
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- Chained from `COLLAPSE_02` — scene nav: "intimate" from <sub>(WASHINGTON STANDS ALONE)</sub>

**Subhead — first draft**

> The Last Tile. The Last President. The Last Chance.

**Body — first draft**

> There is a particular quality to a building when it is the last building of a government that is no longer sure it will be a government tomorrow. The staff had filed out. The security had their orders. Ualani was at the window with no lights on and the specific dark of a city that has been through something and is waiting to find out if more is coming. [COMMANDER_NAME] came without knocking. She had not asked [COMMANDER_NAME] to stay. [COMMANDER_NAME] had stayed. This is the distinction she will think about later — that [COMMANDER_NAME] understood that what she needed was not advice and not a plan and not a speech about the Republic's resilience. What she needed was another person in the building. They stood at the window for a long time. The city was dark and quiet in the way cities get quiet when people are waiting. She said, eventually: I don't know if we're going to hold. [COMMANDER_NAME] said: I know. She said: I need to know you know. [COMMANDER_NAME] said: I know. That was all. They stayed at the window until the dark started changing. Presence, it turns out, is a form of argument. She did not know this before tonight.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Continue | `standard` | _no mechanical effect_ | — |

**Design notes** Collapse — authored; last tile, window and dark city; presence as argument

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
