# Farsword Demo Build Plan
**Session saved:** 2026-06-25  
**Branch:** `claude/farsword-recent-push-JL6OS`

---

## Demo Pitch (for context)
Play as the President of the USA during a second British invasion. Hold your tiles, recruit legendary American protectors, and navigate a complicated relationship with your VP while the bombs fall.

Target session length: 20–40 turns. Designed to show to a cousin / outside player.

---

## BUILD ORDER FOR TOMORROW

### MORNING — Protectors & Events (writing/data)
1. Write `governor.gd` `buildSelf()` cases for 5 missing protectors (see section below)
2. Write the 7 VP arc events into `build_event_masterdoc.py` / `events.csv` / `event_buttons.csv`
3. Run `/masterdoc` to regenerate and verify

### AFTERNOON — Combat & UI polish
4. Trace and confirm `_uk_calculate_turn()` is firing each AI round
5. Smoke-test floating damage numbers in-game (just implemented 2026-06-25)
6. Wire CL_001 (NYC Falls, tile 14) and CX_001 (DC Falls, tile 188) defeat/crisis conditions
7. Full smoke-test session: turn 1 through ~20

### EVENING — Content pass
8. Audit DE_001–DE_005 fire correctly on turn 1 and calendar triggers
9. Verify VP arc events appear in correct turn windows
10. Test each protector SUMMON → TAME → AGREE chain end-to-end

---

## PROTECTORS — 5 Missing `governor.gd` Cases

Each needs a `buildSelf()` match block in `governor.gd` (see existing Mothman ~line 333 for template).

| Protector | PROT ID | Pronouns | Notes |
|---|---|---|---|
| Jersey Devil | PROT_02 | they/them | Event chain complete |
| Goatman | PROT_06 | they/them | Tagged "Chessie" in some places — pick one name and be consistent |
| Bell Witch | PROT_07 | she/her | Event chain complete |
| Old Ironsides | PROT_08 | he/him | Ship-as-commander; combat-focused mil mods |
| Agent 355 | PROT_16 | she/her | Also labeled "Minuteman" in some places — canonize as Agent 355 |

**What each block needs:**
- `governorType` (display name string)
- `governorTexture` / portrait path (use placeholder if art not ready)
- `pronouns` dict `{subject: "she", object: "her", possessive: "her", reflexive: "herself"}`
- `questComplete = true`
- Any relevant mil mods or tile bonuses

---

## VP SEDUCTION ARC — 7 Events to Write

New vars needed on `playerCountryNode` (in `country.gd`):
- `var vp_affinity: int = 0` (range -30 to 100)
- `var vp_committed: bool = false`
- `var vp_stays_on_ticket: bool = false`

Content-gated buttons check existing `explicit_content_enabled` flag in `event_scene.gd`.

---

### VP_FIRST_MEETING
**Trigger:** Turn 2–3, auto-fires after DE_001  
**Flavor:** The VP shows up at your war council. First impressions.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "Glad to have you." | +vp_affinity 5, set VP_MET flag |
| BTN2 | "I run this office alone." | +Mandate 3, -vp_affinity 5 |
| BTN3 (sensual) | "You have... interesting timing." | +vp_affinity 10, -Dollars 5 |

---

### VP_COUNSEL
**Trigger:** Turn 5–7, fires when Britain attacks first tile  
**Flavor:** Britain just took something. The VP has a plan.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "Follow their strategy." | +Science 5, set VP_PLAN_FOLLOWED |
| BTN2 | "Override them." | +Mandate 5, -vp_affinity 5 |
| BTN3 (sensual) | Late-night strategy session | +vp_affinity 15, +Manpower 3 |

---

### VP_DOUBT
**Trigger:** Turn 8–10, fires if USA has lost 2+ tiles  
**Flavor:** The VP is wavering. Faction pressure is mounting against them.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "Stand firm." | +vp_affinity 10 |
| BTN2 | "Step aside if you must." | -vp_affinity 20, +Mandate 5 |
| BTN3 (explicit) | Affirmation scene | +vp_affinity 20, +Happiness 10, set `vp_committed = true` |

---

### VP_LOYALTY_TEST
**Trigger:** Turn 11–13, fires when a hostile faction event fires  
**Flavor:** A rival faction approaches the VP with a better offer.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "I trust you." | if vp_committed: +loyalty 15; else: -loyalty 10 |
| BTN2 | "I'm watching you." | +Mandate 3, -vp_affinity 10 |
| BTN3 (sensual) | Make it personal, not political | +vp_affinity 15, faction threat neutralized |

---

### VP_BATTLEFIELD
**Trigger:** Turn 14–16, fires when first tile is recaptured from Britain  
**Flavor:** Victory on the field. A moment of relief and closeness.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "This is what we're fighting for." | +Happiness 10, +Manpower 5 |
| BTN2 | "Don't get sentimental." | +Mandate 5 |
| BTN3 (explicit) | Celebrate in private | +vp_affinity 20, +Happiness 15, unlocks VP_PRE_ELECTION |

---

### VP_PRE_ELECTION
**Trigger:** Turn 17–19, fires as `presidentialClaim` variable crosses threshold  
**Flavor:** The VP is being pressured to drop off the ticket. They're asking you directly.

| Button | Label | Outcome |
|---|---|---|
| BTN1 | "You're staying." | +vp_affinity 15, -presidentialClaim 5 |
| BTN2 | "It's your choice." | VP stays/leaves based on vp_affinity threshold (>=40 stays) |
| BTN3 (explicit) | "Convince Them to Stay In the Race" | +vp_affinity 20, set `vp_stays_on_ticket = true` |

---

### VP_SOLIDARITY
**Trigger:** Turn 20+, fires after Britain is decisively pushed back OR after election result  
**Flavor:** Denouement. The arc closes based on accumulated flags.

| Button | Condition | Outcome |
|---|---|---|
| BTN1 | vp_stays_on_ticket + vp_committed | +Happiness 20, +presidentialClaim 10 |
| BTN2 | VP left ticket | +Mandate 5, -Happiness 10 (bittersweet farewell) |
| BTN3 (sensual) | Both committed flags set | Final intimate beat. The war changed both of you. |

---

## BRITAIN COMBAT — Polish Checklist

- [ ] Confirm `_uk_calculate_turn()` is called inside `computerTurn()` each AI round
- [ ] Test `_on_ai_army_repositioned()` fires and APF token visibly moves
- [ ] Test floating damage numbers appear above tile during UK attacks
- [ ] Wire CX_001 (DC Falls tile 188) — should fire crisis event + recovery path
- [ ] Wire CL_001 (NYC Falls tile 14) — triggers PROT_09_SUMMON via BTN3
- [ ] Dock tiles are visually identifiable so player knows what to defend

---

## UI MINIMUM VIABLE (needs smoke-test, not rebuild)

| Panel | Check |
|---|---|
| TileInfoPanel resource outputs | Fixed 2026-06-24; test 5 different tiles |
| Top bar resource hover → map mode | Fixed 2026-06-24; all 10 resource types |
| Event panel (fires, advances, closes) | Test DE_001 on turn 1 |
| Governor assign (protector to tile) | Test after adding 5 missing protectors |
| APF tokens after Britain conquest | No orphans after _on_ai_army_repositioned |
| AI turn report | _show_ai_turn_report() fires after AI turn ends |

**Not needed for demo (leave stubbed):** civilian buttons, factions panel, belief control, tech tree, co-op.

---

## KEY FILES

| File | What to touch |
|---|---|
| `governor.gd` | Add 5 protector buildSelf() blocks (~line 333) |
| `Game Scenes and Scripts/country.gd` | Add vp_affinity, vp_committed, vp_stays_on_ticket vars |
| `scripts/build_event_masterdoc.py` | Add 7 VP arc event tuples |
| `data/events.csv` | Add VP_FIRST_MEETING through VP_SOLIDARITY rows |
| `data/event_buttons.csv` | Add button rows for all 7 VP events |
| `Game Scenes and Scripts/world.gd` | Trace computerTurn() → UK turn firing |

---

## RECENT CHANGES (2026-06-24/25 sessions)

- Fixed TileInfoPanel resource panels showing 0 (dic clear order + enabled=true bug)
- Added `calculateOutputsForMap()` silent census for resource map modes
- Fixed Canadian map color → arctic cold white-blue `Color(0.82, 0.93, 1.0)`
- Resource map modes activate on top-bar hover
- Army spawn now guarantees courthouse-tile capitals get armies first
- Implemented UK AI: `_uk_calculate_turn`, `_uk_attack_tile`, `_uk_reinforce`, `_uk_spawn_reinforcement`
- Added APF repositioning signal chain for AI conquest
- Added AI combat log + `_show_ai_turn_report()`
- Added floating damage number animations (`floating_damage_number.gd/.tscn`, `battleResolved` signal)
