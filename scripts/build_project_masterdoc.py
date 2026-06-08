"""
Generates project_masterdoc.xlsx — full project tracker for Farsword.
Run from repo root: python3 scripts/build_project_masterdoc.py

Sheets:
  1. Character Roster  — from data/character_roster.csv
  2. Game Systems      — hard-coded system inventory
  3. Art Pipeline      — combined from events + characters
  4. Data File Health  — CSV row counts
"""

import csv
import os
import openpyxl
from openpyxl.styles import PatternFill, Font, Alignment, Border, Side
from openpyxl.utils import get_column_letter

OUT_PATH = "project_masterdoc.xlsx"

# ── PALETTE ──────────────────────────────────────────────────────────────────
HEADER_BG = "1F3864"
HEADER_FG = "FFFFFF"

TYPE_COLORS = {
    "GOVERNOR_NAMED": "D6E4F7",
    "FACTION_LEADER": "FCE0D6",
    "EVENT_NPC":      "D6F0D6",
    "PROTECTOR":      "EDD6F7",
    "ARCHETYPE":      "FFF3CC",
}

STATUS_COLORS = {
    "IMPLEMENTED":            "C6EFCE",
    "ADDED":                  "D6F0D6",
    "PROPOSED":               "FFEB9C",
    "IMPLEMENTED (NAME ONLY)":"FFF3CC",
    "IDEA":                   "FCE0D6",
}
STATUS_FG = {
    "IMPLEMENTED":            "1A4A1A",
    "ADDED":                  "1A4A1A",
    "PROPOSED":               "7A5A00",
    "IMPLEMENTED (NAME ONLY)":"7A5A00",
    "IDEA":                   "8B0000",
}

SYS_STATUS_COLORS = {
    "LIVE":    "C6EFCE",
    "PARTIAL": "FFEB9C",
    "STUB":    "FCE0D6",
    "PLANNED": "DCDCDC",
}
SYS_STATUS_FG = {
    "LIVE":    "1A4A1A",
    "PARTIAL": "7A5A00",
    "STUB":    "8B0000",
    "PLANNED": "555555",
}

NORMAL_FG = "1A1A1A"
EXPLICIT_BG = "FF6B35"

thin = Side(style="thin", color="AAAAAA")
BORDER = Border(left=thin, right=thin, top=thin, bottom=thin)


def make_fill(hex_color):
    return PatternFill(fill_type="solid", fgColor=hex_color)

def make_font(bold=False, color=NORMAL_FG, size=10):
    return Font(bold=bold, color=color, name="Calibri", size=size)

def make_header_cell(ws, row, col, text, width=None):
    c = ws.cell(row=row, column=col, value=text)
    c.fill   = make_fill(HEADER_BG)
    c.font   = make_font(bold=True, color=HEADER_FG, size=10)
    c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    c.border = BORDER
    if width:
        ws.column_dimensions[get_column_letter(col)].width = width
    return c

def plain_cell(ws, row, col, value, bg=None, fg=None, bold=False, wrap=True):
    c = ws.cell(row=row, column=col, value=str(value) if value is not None else "")
    c.font   = make_font(bold=bold, color=fg or NORMAL_FG)
    c.alignment = Alignment(vertical="top", wrap_text=wrap)
    c.border = BORDER
    if bg:
        c.fill = make_fill(bg)
    return c


# ── SHEET 1: CHARACTER ROSTER ─────────────────────────────────────────────────

ROSTER_COLS = [
    ("TYPE",           12),
    ("ID",             10),
    ("NAME",           22),
    ("STATUS",         18),
    ("POSITION",       18),
    ("FACTION",        20),
    ("REGION / STATE", 14),
    ("TERRAIN",        16),
    ("NARRATIVE HOOK", 50),
    ("NOTES",          44),
]

def build_roster_sheet(wb):
    ws = wb.create_sheet("Character Roster")
    ws.row_dimensions[1].height = 28

    for ci, (header, width) in enumerate(ROSTER_COLS, 1):
        make_header_cell(ws, 1, ci, header, width)

    roster_path = os.path.join("data", "character_roster.csv")
    row = 2
    type_order = ["GOVERNOR_NAMED", "FACTION_LEADER", "EVENT_NPC", "PROTECTOR", "ARCHETYPE"]
    records = []
    with open(roster_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for rec in reader:
            records.append(rec)

    records.sort(key=lambda r: (
        type_order.index(r["Type"]) if r["Type"] in type_order else 99,
        r["Name"]
    ))

    for rec in records:
        t      = rec.get("Type", "")
        status = rec.get("Status", "")
        bg     = TYPE_COLORS.get(t, "FFFFFF")
        sbg    = STATUS_COLORS.get(status, "FFFFFF")
        sfg    = STATUS_FG.get(status, NORMAL_FG)

        plain_cell(ws, row, 1, t,                           bg=bg)
        plain_cell(ws, row, 2, rec.get("ID",""),            bg=bg)
        plain_cell(ws, row, 3, rec.get("Name",""),          bg=bg, bold=True)
        plain_cell(ws, row, 4, status,                      bg=sbg, fg=sfg, bold=True)
        plain_cell(ws, row, 5, rec.get("Position",""),      bg=bg)
        plain_cell(ws, row, 6, rec.get("Country_Faction",""),bg=bg)
        plain_cell(ws, row, 7, rec.get("Region_State",""),  bg=bg)
        plain_cell(ws, row, 8, rec.get("Terrain_Affinity",""),bg=bg)
        plain_cell(ws, row, 9, rec.get("Narrative_Hook",""),bg=bg)
        plain_cell(ws, row,10, rec.get("Notes",""),         bg=bg)
        ws.row_dimensions[row].height = 42
        row += 1

    ws.freeze_panes = "A2"


# ── SHEET 2: GAME SYSTEMS ────────────────────────────────────────────────────
# (category, system_name, status, key_files, notes)

SYSTEMS = [
    # ── CORE WORLD ────────────────────────────────────────────────────────────
    ("Core World", "Turn / Date System",
     "LIVE", "world.gd, tile.gd",
     "currentWorldTurn + month; evaluateDateEvents() called each turn"),

    ("Core World", "Tile Ownership",
     "LIVE", "world.gd, tile.gd",
     "tileOwner string; OwnedTileList on country; liberation/loss events wired"),

    ("Core World", "Resource System",
     "LIVE", "world.gd, country.gd",
     "food/gold/weapons/manpower/etc; _apply_resource_change(); TotalFood etc on country"),

    ("Core World", "Building System",
     "LIVE", "tile.gd, building.gd",
     "tileBuildingsList; disabled_buildings dict; disable/enable_building outcomes"),

    ("Core World", "Presidential Claim",
     "LIVE", "world.gd",
     "_calculate_presidential_claim(); drives secession + legitimacy crisis events"),

    ("Core World", "State Secession",
     "LIVE", "world.gd",
     "checkStateSecessionConditions(); rebel_ flags; STATE_REBEL/REINTEGRATED events"),

    ("Core World", "Republic Collapse",
     "LIVE", "world.gd",
     "_execute_republic_collapse(); COLLAPSE_01 → COLLAPSE_02 chain"),

    ("Core World", "Winter Supply Drain",
     "PARTIAL", "world.gd",
     "Winter scoring on tiles; army supply drain referenced; not fully wired to all events"),

    # ── COMBAT ────────────────────────────────────────────────────────────────
    ("Combat", "Battle System",
     "LIVE", "battle.gd, army.gd",
     "armyPunch/armyBlock/armyDefence/armyShield; melee + ranged combat rounds"),

    ("Combat", "Army Survey (stat calc)",
     "LIVE", "army.gd surveySelf()",
     "Recalculates all stats from unitsList + milMods each call"),

    ("Combat", "MilMod System",
     "LIVE", "army.gd, governor.gd",
     "Unit.addMilMod(); commanderModifiers1/2/3; govMilModsLvl1-3"),

    ("Combat", "Morale System",
     "LIVE", "governor.gd, army.gd",
     "governor.morale 0-100; multiplies armyPunch/armyDefence up to +25%; morale_boost outcome now real"),

    ("Combat", "Commander Assignment",
     "LIVE", "army.gd, world.gd",
     "army.commander = governor; addUnitCommander(); commanderCheck() applies milMods by level"),

    ("Combat", "Commander Progression",
     "LIVE", "world.gd, governor.gd",
     "_commander_turns dict; CMD_MERIT/RECOGNITION/THANKS fire at 5/20/50 turns; promote_commander outcome"),

    ("Combat", "Army Buff Outcome",
     "STUB", "world.gd _apply_army_buff()",
     "Outcome type exists; function body is pass — needs implementation"),

    ("Combat", "Recon Debuff",
     "PARTIAL", "army.gd",
     "reconDebuffed flag exists on army; wiring to espionage events incomplete"),

    # ── GOVERNORS & CHARACTERS ────────────────────────────────────────────────
    ("Governors", "Governor Loyalty",
     "LIVE", "governor.gd, world.gd",
     "loyalty –20 to +20; update_loyalty() per turn; questComplete uncaps to 20; TURNCOAT fires at ≤ –8"),

    ("Governors", "Governor Loyalty (tile outcome)",
     "LIVE", "world.gd executeOutcome()",
     "governor_loyalty_change outcome; clamped ±20"),

    ("Governors", "tileMoralDecay",
     "LIVE", "tile.gd, world.gd",
     "0-100 political corruption; CORRUPT events fire at ≥50; tile_moral_decay_change outcome"),

    ("Governors", "Procedural Governor Gen",
     "LIVE", "world.gd _generate_and_assign_governor()",
     "25 archetypes × terrain affinity; NP_xx name pools; govMilMods by archetype"),

    ("Governors", "Named Historical Governors",
     "LIVE", "governor.gd buildSelf()",
     "Patrick Henry / Abigail Adams / Paine / Warren / Shays / Ualani / Tallmadge / Wheatley / Asbury"),

    # ── EVENTS ───────────────────────────────────────────────────────────────
    ("Events", "Event CSV Pipeline",
     "LIVE", "EventDatabase.gd, world.gd, event_scene.gd",
     "events.csv + event_buttons.csv → evaluate_date_triggers() → createNewEvent() → event_scene.build_from_csv()"),

    ("Events", "Event Cooldown System",
     "LIVE", "world.gd",
     "_event_cooldowns dict; _event_on_cooldown() / _start_cooldown() / _tick_event_cooldowns()"),

    ("Events", "Mission Flag System",
     "LIVE", "world.gd",
     "mission_<id>_<tile> flags; set_mission_flag / set_mission_flag_own outcomes; checkPendingMissions()"),

    ("Events", "Button Content Filtering",
     "LIVE", "event_scene.gd _build_buttons()",
     "button_type (standard/explicit/kinky_lewd) checked against Settings before rendering"),

    ("Events", "Tile Crisis Events (9 chains)",
     "LIVE", "world.gd",
     "Harvest/Harbor/Forge/Corrupt/Border/Garrison/Legitimacy/Turncoat/Memorial — all wired"),

    ("Events", "Ualani Tile Events (9 events)",
     "LIVE", "world.gd",
     "_find_ualani_tile(); Ambush/Dignitary/Memorial/Wounded/Winter/Forge/Culper/Alliance/Frontier"),

    ("Events", "Protector 3-Stage Chain (17×3)",
     "LIVE", "world.gd, events.csv",
     "SUMMON→TAME→AGREE per protector; wild corruption 25%/turn; staggered turn thresholds"),

    ("Events", "Fort Disrepair Chain",
     "LIVE", "world.gd",
     "FORT_001 → FORT_003 (public) or FORT_004 → FORT_005 (private/explicit)"),

    ("Events", "Date / Calendar Events",
     "LIVE", "EventDatabase.gd, event_triggers.csv",
     "DE_001-005; annual events by month; evaluate_date_triggers() handles cooldowns"),

    ("Events", "City Liberated / Lost Events",
     "LIVE", "events.csv",
     "CL_001/006/007/009/182; CX_001/005; non-repeatable tile capture/loss events"),

    ("Events", "State Events",
     "LIVE", "events.csv",
     "SL_001/004 (liberated); STATE_REBEL_01 → STATE_REINTEGRATED_01 secession chain"),

    ("Events", "Commander Event Chain",
     "LIVE", "world.gd, events.csv",
     "CMD_MERIT / CMD_RECOGNITION / CMD_THANKS; fires at governorLevel 1/2/3 + turns_served thresholds"),

    # ── FACTIONS & POLITICS ──────────────────────────────────────────────────
    ("Factions", "Faction System",
     "LIVE", "faction_control.gd, world.gd",
     "Loyalty scores per faction; changeFactionLoyalty(); 9 USA factions defined"),

    ("Factions", "Espionage System",
     "PARTIAL", "tile.gd, world.gd",
     "espionageActive on tile; has_neighbor_with_espionage() helper; Culper Ring flag; no full spy action loop yet"),

    ("Factions", "Codebook / Spell Schools",
     "PARTIAL", "world.gd, country.gd",
     "levelUpSchool(); spell_schools_control.gd; protector spell unlocks defined; full casting loop TBD"),

    # ── UI & INFRASTRUCTURE ──────────────────────────────────────────────────
    ("UI / Infra", "Camera / Map Navigation",
     "LIVE", "camera_movement_controller.gd",
     "Pan/zoom; tile selection; path control"),

    ("UI / Infra", "Resource Bar",
     "LIVE", "ResourceBar.gd",
     "Displays all resource totals; updates on turn"),

    ("UI / Infra", "Military Panel",
     "LIVE", "military_panel_control.gd",
     "Army roster; unit management; commander picker"),

    ("UI / Infra", "Governor Selection Panel",
     "LIVE", "governor_selection.gd",
     "Shows governor level + loyalty; assign to tile; pick from pool"),

    ("UI / Infra", "Tech Tree",
     "PARTIAL", "tech_tree.gd",
     "UI exists; add_tech outcome wired; full research action loop TBD"),

    ("UI / Infra", "Civilian Control",
     "PARTIAL", "civilian_control.gd, civilian_action_buttons.gd",
     "Civilian unit actions; partial — some buttons wired, some stubs"),
]

SYS_COLS = [
    ("CATEGORY",    14),
    ("SYSTEM",      28),
    ("STATUS",      10),
    ("KEY FILES",   34),
    ("NOTES",       56),
]

def build_systems_sheet(wb):
    ws = wb.create_sheet("Game Systems")
    ws.row_dimensions[1].height = 28

    for ci, (header, width) in enumerate(SYS_COLS, 1):
        make_header_cell(ws, 1, ci, header, width)

    current_cat = None
    row = 2
    for (cat, name, status, files, notes) in SYSTEMS:
        if cat != current_cat:
            # category divider row
            for ci in range(1, 6):
                c = ws.cell(row=row, column=ci, value=cat if ci == 1 else "")
                c.fill   = make_fill("2F4F6F")
                c.font   = make_font(bold=True, color="FFFFFF", size=10)
                c.alignment = Alignment(vertical="center", wrap_text=False)
                c.border = BORDER
            ws.row_dimensions[row].height = 18
            row += 1
            current_cat = cat

        sbg = SYS_STATUS_COLORS.get(status, "FFFFFF")
        sfg = SYS_STATUS_FG.get(status, NORMAL_FG)
        plain_cell(ws, row, 1, cat,    bg="EEF2F7")
        plain_cell(ws, row, 2, name,   bg="EEF2F7", bold=True)
        plain_cell(ws, row, 3, status, bg=sbg, fg=sfg, bold=True)
        plain_cell(ws, row, 4, files,  bg="EEF2F7")
        plain_cell(ws, row, 5, notes,  bg="EEF2F7")
        ws.row_dimensions[row].height = 32
        row += 1

    ws.freeze_panes = "A2"


# ── SHEET 3: ART PIPELINE ────────────────────────────────────────────────────

ART_COLS = [
    ("SOURCE",        10),
    ("ID",            22),
    ("NAME / TITLE",  38),
    ("ART TAG",       22),
    ("EXPLICIT?",     10),
    ("ART STATUS",    13),
    ("NOTES",         36),
]

def build_art_sheet(wb):
    ws = wb.create_sheet("Art Pipeline")
    ws.row_dimensions[1].height = 28

    for ci, (header, width) in enumerate(ART_COLS, 1):
        make_header_cell(ws, 1, ci, header, width)

    row = 2

    # ── Characters (named + NPCs) from character_roster.csv ─────────────────
    roster_path = os.path.join("data", "character_roster.csv")
    with open(roster_path, newline="", encoding="utf-8") as f:
        for rec in csv.DictReader(f):
            t = rec.get("Type","")
            if t == "ARCHETYPE":
                continue  # archetypes share pooled art, skip for now
            name = rec.get("Name","")
            status = rec.get("Status","")
            notes = rec.get("Notes","")
            explicit = "YES" if "kinky_lewd" in notes.lower() or "explicit" in notes.lower() else "NO"
            art_status = "Not Started"

            bg = "D6E1F7" if t == "GOVERNOR_NAMED" else \
                 "FCE0D6" if t == "FACTION_LEADER" else \
                 "D6F0D6" if t == "EVENT_NPC" else \
                 "EDD6F7"  # PROTECTOR

            ebg = EXPLICIT_BG if explicit == "YES" else None
            efg = "FFFFFF"    if explicit == "YES" else None

            plain_cell(ws, row, 1, t,          bg=bg)
            plain_cell(ws, row, 2, rec.get("ID",""), bg=bg)
            plain_cell(ws, row, 3, name,        bg=bg, bold=True)
            plain_cell(ws, row, 4, "",          bg=bg)
            plain_cell(ws, row, 5, explicit,    bg=ebg or bg, fg=efg, bold=(explicit=="YES"))
            plain_cell(ws, row, 6, art_status,  bg="FFD7D7", fg="8B0000")
            plain_cell(ws, row, 7, status,      bg=bg)
            ws.row_dimensions[row].height = 18
            row += 1

    # ── Events with art tags from events.csv ─────────────────────────────────
    events_path = os.path.join("data", "events.csv")
    with open(events_path, newline="", encoding="utf-8") as f:
        for rec in csv.DictReader(f):
            art_tag = rec.get("image_tag","").strip()
            if not art_tag:
                continue
            eid     = rec.get("event_id","")
            headline= rec.get("headline","")
            cflag   = rec.get("content_flag","").strip()
            explicit = "YES" if cflag in ("explicit","kinky_lewd") else "NO"

            ebg = EXPLICIT_BG if explicit == "YES" else "FFF3CC"
            efg = "FFFFFF"    if explicit == "YES" else NORMAL_FG

            plain_cell(ws, row, 1, "Event",     bg="FFF3CC")
            plain_cell(ws, row, 2, eid,         bg="FFF3CC")
            plain_cell(ws, row, 3, headline,    bg="FFF3CC")
            plain_cell(ws, row, 4, art_tag,     bg="FFF3CC", bold=True)
            plain_cell(ws, row, 5, explicit,    bg=ebg, fg=efg, bold=(explicit=="YES"))
            plain_cell(ws, row, 6, "Not Started", bg="FFD7D7", fg="8B0000")
            plain_cell(ws, row, 7, cflag,       bg="FFF3CC")
            ws.row_dimensions[row].height = 18
            row += 1

    ws.freeze_panes = "A2"


# ── SHEET 4: DATA FILE HEALTH ────────────────────────────────────────────────

DATA_FILES = [
    ("data/events.csv",                          "Event definitions (id, text, triggers, content flags)"),
    ("data/event_buttons.csv",                   "Button definitions per event (outcomes, types, chains)"),
    ("data/event_triggers.csv",                  "Date/turn trigger rules for calendar events"),
    ("data/character_roster.csv",                "All characters: governors, NPCs, archetypes, protectors"),
    ("data/protector_objectives.csv",            "Protector resource unlock ranges and dev levels"),
    ("data/tiles_final.csv",                     "All map tiles: terrain, state, features, neighbors"),
    ("data/building_modifiers_reference_pass_2.csv", "Building modifier table: all resource effects by governor/law/tech"),
    ("data/armies/army_templates.csv",           "Starting army templates per country"),
    ("data/countries/countries.csv",             "Country definitions and starting state"),
]

HEALTH_COLS = [
    ("FILE PATH",      44),
    ("ROWS (excl. header)", 18),
    ("DESCRIPTION",   52),
    ("LAST KNOWN STATUS", 16),
]

def build_health_sheet(wb):
    ws = wb.create_sheet("Data File Health")
    ws.row_dimensions[1].height = 28

    for ci, (header, width) in enumerate(HEALTH_COLS, 1):
        make_header_cell(ws, 1, ci, header, width)

    row = 2
    for (path, desc) in DATA_FILES:
        try:
            with open(path, newline="", encoding="utf-8") as f:
                count = sum(1 for _ in f) - 1  # subtract header
            bg = "D6F0D6"
            status = f"{count} rows"
        except FileNotFoundError:
            count = 0
            bg = "FCE0D6"
            status = "FILE NOT FOUND"

        plain_cell(ws, row, 1, path,   bg=bg, bold=True)
        plain_cell(ws, row, 2, count,  bg=bg)
        plain_cell(ws, row, 3, desc,   bg=bg)
        plain_cell(ws, row, 4, status, bg=bg)
        ws.row_dimensions[row].height = 20
        row += 1

    ws.freeze_panes = "A2"


# ── LEGEND SHEET ──────────────────────────────────────────────────────────────

def build_legend_sheet(wb):
    ws = wb.create_sheet("Legend")

    def leg_row(ws, row, label, color, fg=NORMAL_FG, note=""):
        c1 = ws.cell(row=row, column=1, value=label)
        c1.fill = make_fill(color)
        c1.font = make_font(bold=True, color=fg)
        c1.border = BORDER
        c1.alignment = Alignment(vertical="center")
        c2 = ws.cell(row=row, column=2, value=note)
        c2.font = make_font()
        c2.border = BORDER
        c2.alignment = Alignment(vertical="center", wrap_text=True)
        ws.row_dimensions[row].height = 18

    ws.column_dimensions["A"].width = 28
    ws.column_dimensions["B"].width = 52

    r = 1
    ws.cell(r, 1, "CHARACTER STATUS").font = make_font(bold=True, size=11)
    r += 1
    for status, color in STATUS_COLORS.items():
        leg_row(ws, r, status, color, STATUS_FG.get(status, NORMAL_FG))
        r += 1
    r += 1
    ws.cell(r, 1, "SYSTEM STATUS").font = make_font(bold=True, size=11)
    r += 1
    for status, color in SYS_STATUS_COLORS.items():
        descriptions = {
            "LIVE":    "Fully implemented and wired into the game loop",
            "PARTIAL": "Exists but missing key pieces (stubs, incomplete wiring)",
            "STUB":    "Function/outcome defined but body is pass or empty",
            "PLANNED": "Designed, not yet started",
        }
        leg_row(ws, r, status, color, SYS_STATUS_FG.get(status, NORMAL_FG), descriptions.get(status,""))
        r += 1
    r += 1
    ws.cell(r, 1, "EXPLICIT ART").font = make_font(bold=True, size=11)
    r += 1
    leg_row(ws, r, "Explicit / Kinky-Lewd", EXPLICIT_BG, "FFFFFF",
            "Art required for content-gated buttons/events. Prioritize these for the explicit content pipeline.")


# ── MAIN ─────────────────────────────────────────────────────────────────────

def main():
    wb = openpyxl.Workbook()
    wb.remove(wb.active)

    build_roster_sheet(wb)
    build_systems_sheet(wb)
    build_art_sheet(wb)
    build_health_sheet(wb)
    build_legend_sheet(wb)

    wb.save(OUT_PATH)

    # summary counts
    live    = sum(1 for s in SYSTEMS if s[2] == "LIVE")
    partial = sum(1 for s in SYSTEMS if s[2] == "PARTIAL")
    stub    = sum(1 for s in SYSTEMS if s[2] == "STUB")

    roster_path = os.path.join("data", "character_roster.csv")
    with open(roster_path, newline="", encoding="utf-8") as f:
        chars = list(csv.DictReader(f))
    impl    = sum(1 for c in chars if c["Status"].startswith("IMPLEMENTED"))
    added   = sum(1 for c in chars if c["Status"] == "ADDED")
    proposed= sum(1 for c in chars if c["Status"] == "PROPOSED")

    print(f"Saved: {OUT_PATH}")
    print(f"  Systems  : {live} LIVE / {partial} PARTIAL / {stub} STUB")
    print(f"  Characters: {impl} implemented / {added} added / {proposed} proposed")


if __name__ == "__main__":
    main()
