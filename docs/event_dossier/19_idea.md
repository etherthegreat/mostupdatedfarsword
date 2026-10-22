# Idea

6 events · FIRST PASS 6

[← back to index](00_INDEX.md)

---

### `CL_WASHINGTON_01` — WASHINGTON DC RECAPTURED — THE CAPITAL RETURNS TO THE REPUBLIC

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Serious/Triumphant
**Chain** More City Events · position Root
**Art** `dc_recapture` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `188` · tile owner `USA` · priority 2  <sub>`TRIG_089`</sub>

**Subhead — first draft**

> The White House Had Not Been Empty Long. But It Had Been Empty.

**Body — first draft**

> The White House was empty for eleven days. The press corps counted them. The dispatch from the field said: the capital is secure, the flag is up, the coffee machine in the West Wing is still broken. President Carlisle read it three times. She had not expected the coffee machine line. She had the dispatch framed. The formal recapture ceremony was brief by necessity — the administrative infrastructure of the United States government cannot be reassembled in a single afternoon and there are people who will tell you this in considerable detail if you allow them. Carlisle did not allow them. The flag came up. The building is ours. The Republic is home.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Declare a National Day of Thanksgiving | `standard` | morale +30 | — |
| 2 | Return to Washington Immediately — The Republic Comes Home | `standard` | sets flag `dc_recaptured` | — |

**Design notes** Fires via TRIG_089 (tile_liberated, 188, USA); one-time historic event; 2 buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CL_VALLEY_FORGE_01` — VALLEY FORGE IS OURS — THE REPUBLIC HOLDS THE GROUND THAT HELD BEFORE

**Status** FIRST PASS · **Type** `city_liberated` · **Country** `GEN` · **Tone** Somber/Determined
**Chain** More City Events · position Root
**Art** `valley_forge_secured` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** false · **Cooldown** 0

**Fires when**

- **Tile liberated** — tile `1` · tile owner `USA` · priority 2  <sub>`TRIG_090`</sub>

**Subhead — first draft**

> First Army Camped Here. This Is the Second.

**Body — first draft**

> Valley Forge has been cold before. It was cold the first time an American army camped here and that army stayed anyway, which is the thing that Valley Forge is about. The dispatch from [TILE_NAME] arrived in the standard format: terrain secured, garrison established, perimeter held. At the bottom, the field commander had written one line that was not in the standard format. It said: we know where we are. The Republic knows the significance. The field commanders who secured this ground have added their names to a record that started in a winter that was considerably worse than this one. The ground is ours.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Fortify the Position — This Ground Will Hold | `standard` | morale +25 | — |
| 2 | Issue Field Citation to the Garrison | `standard` | morale +35 | — |

**Design notes** Fires via TRIG_090 (tile_liberated, 1, USA); one-time; 2 buttons; historical weight tone

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `CX_NYC_01` — NEW YORK CITY HAS FALLEN — AGAIN — THE STOCK MARKET IS FORMALLY AGGRIEVED

**Status** FIRST PASS · **Type** `city_lost` · **Country** `GEN` · **Tone** Darkly Funny/Bitter
**Chain** More City Events · position Root
**Art** `nyc_falls_again` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 30

**Fires when**

- **Tile lost** — tile `14` · tile owner `UK` · priority 2  <sub>`TRIG_091`</sub>

**Subhead — first draft**

> The Statue of Liberty Did Not Weep This Time. She Has Done This Before.

**Body — first draft**

> New York City has been lost before. The first time, the Statue of Liberty was visibly moved. The second time, she looked out at the harbor with the expression of someone who had read this chapter before and knew how it ended — which is with New York being recaptured, eventually, after a period of sustained effort and considerable inconvenience for everyone involved. The Stock Market has filed a formal statement describing the situation as 'temporarily suboptimal.' The harbormaster's office is operating out of a boat. The Republic is adapting. It has done this before. It is very tired of doing this, but it has done it before, and it knows how.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Regroup — Strategic Withdrawal in Progress | `standard` | morale +15 | — |
| 2 | Begin the Counterplan | `standard` | sets flag `cx_nyc_known` | — |

**Design notes** Fires via TRIG_091 (tile_lost, 14, UK); repeatable=true, cooldown=30; satirical callback to CL_001

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `ESPIONAGE_DISCOVERY_01` — SPY NETWORK DISCOVERED AT [TILE_NAME] — CULPER RING CATCHES A CROWN AGENT

**Status** FIRST PASS · **Type** `army_event` · **Country** `USA` · **Tone** Tense/Intelligence
**Chain** Espionage Events · position Root
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 15

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> Someone Was Watching the Supply Routes. We Found Out Before They Finished.

**Body — first draft**

> The garrison at [TILE_NAME] has been under observation for two weeks. The Culper Ring's contact in the local barracks identified the anomaly on a Tuesday — an unfamiliar pattern in the courier routes, a civilian who knew too much about the ammunition schedule. [COMMANDER_NAME]'s office moved quietly. By Thursday the agent had been identified, and by Friday [COMMANDER_NAME] had a choice to make. The Crown has not yet received whatever the spy was sending. The information the agent was collecting — resupply schedules, garrison rotation patterns, the location of the eastern cache — is classified. The situation is contained. The question is what to do with it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Interrogate and Expel — Let London Know We're Watching | `standard` | morale +25 | — |
| 2 | Turn the Agent — Feed London False Intelligence | `standard` | sets flag `double_agent_01` | — |

**Design notes** _uk_plant_spies() in AI round: 20% chance on is_spy_vulnerable+UK-neighbor tile. _check_espionage_discovery(): fires when is_counterintelligence_ready (governor+barracks+espionageActive); calls clear_espionage(); cooldown=15; 2 buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `WINTER_SIEGE_01` — VALLEY FORGE CONDITIONS — TROOPS SUFFER THROUGH ANOTHER NORTHERN WINTER

**Status** FIRST PASS · **Type** `army_event` · **Country** `USA` · **Tone** Grim/Rousing
**Chain** Seasonal Events · position Root
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 12

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Boots Were Already Gone. The Firewood Is Going.

**Body — first draft**

> The army at [TILE_NAME] has not had sufficient firewood since the third week of the month. The field dispatch arrived at headquarters with water damage — courier lost a river crossing, came through on the other side, filed the report anyway. It reads: boots failing, rations low, morale holding but holding is not free. The quartermaster has made a list of what the garrison needs. It is a longer list than the supply manifest can answer. The continental winter is not a tactical adversary — it does not retreat, it does not negotiate, it does not run out of winter. The question is what the Republic does about it.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Issue Emergency Supply Rations | `standard` | food +25 | — |
| 2 | Order the Men to Hold Position | `standard` | morale +20 | — |

**Design notes** _check_winter_siege(): month [11,12,1,2] + owned tile winterScore>=3 + stationedArmy; cooldown=12; 2 buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---

### `SPRING_OFFENSIVE_01` — THE THAW — CROWN FORCES RESUME OFFENSIVE OPERATIONS

**Status** FIRST PASS · **Type** `army_event` · **Country** `USA` · **Tone** Tense/Urgent
**Chain** Seasonal Events · position Root
**Art** `—` (In Progress) · **Explicit art** NO · **Content flag** `—` · **Repeatable** true · **Cooldown** 20

**Fires when**

- ⚠️ **No trigger row, no inbound chain link, no code reference.** Draft is currently unreachable in game.

**Subhead — first draft**

> The Snow Melted. They Were Ready When It Did.

**Body — first draft**

> The Crown forces moved at first thaw — not because they were impatient, but because this is when the roads become passable and when armies can move again without losing a third of their horses. The field reports from [TILE_NAME] arrived in quick succession. Enemy strength increasing. Crossing detected at the north passage. The garrison is holding but the garrison is aware that spring means they will be tested now. The Crown has been waiting for this. The Republic should have expected this, and in fairness to the intelligence office, the intelligence office did expect this. The question is what the Republic does in the next four turns before the full offensive reaches the border.

**Choices & outcomes**

| # | Button text | Type | What it does | Leads to |
|---|---|---|---|---|
| 1 | Issue Defensive Orders to All Border Garrisons | `standard` | morale +20 | — |
| 2 | Preemptive Strike — Move Up the Offensive Timeline | `standard` | army buff `Fortified` +3 | — |

**Design notes** _check_spring_offensive(): month [3,4] + UK neighbor + stationedArmy on owned tile; cooldown=20; 2 buttons

<details><summary><b>FINAL PASS — write here</b></summary>

- **Headline:**
- **Subhead:**
- **Body:**
- **Button text:**
- **Notes:**

</details>

---
