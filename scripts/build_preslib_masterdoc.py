#!/usr/bin/env python3
"""
Generate preslib_masterdoc.xlsx — full content tracker for the Presidential Library.
Sheets: GALLERY · RECORDS · JOURNAL
Run from repo root: python3 scripts/build_preslib_masterdoc.py

HOW TO UPDATE:
  GALLERY → edit GALLERY_DATA list below
  RECORDS → edit RECORDS_DATA list below
  JOURNAL → edit JOURNAL_DATA list below
  Status values: "FULL PASS" | "FIRST PASS" | "FIRST DRAFT" | "IDEA" | "STUB"
  Art status:    "Not Started" | "In Progress" | "Done"
  Content flags: "sensual" | "explicit" | "kinky"
"""

import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

OUT_PATH = "preslib_masterdoc.xlsx"

# ── palette ───────────────────────────────────────────────────────────────────
HDR_BG, HDR_FG   = "1F2D3D", "FFFFFF"
CAT_BG, CAT_FG   = "2E4057", "FFFFFF"
ALT_BG = "EEF2F7"
WHITE  = "FFFFFF"

SENSUAL_BG,  SENSUAL_FG  = "FFE0F0", "660033"
EXPLICIT_BG, EXPLICIT_FG = "FFB3D1", "660033"
KINKY_BG,    KINKY_FG    = "BB44AA", "FFFFFF"

ART_NONE_BG, ART_NONE_FG = "FFD7D7", "8B0000"
ART_WIP_BG,  ART_WIP_FG  = "FFEB9C", "7A5A00"
ART_DONE_BG, ART_DONE_FG = "C6EFCE", "1A4A1A"

FULL_BG,   FULL_FG   = "00B050", "FFFFFF"
FPASS_BG,  FPASS_FG  = "92D050", "1A3A00"
FDRAFT_BG, FDRAFT_FG = "BFEA7C", "2A4A00"
IDEA_BG,   IDEA_FG   = "FFEB9C", "7A5A00"
STUB_BG,   STUB_FG   = "FFD7D7", "8B0000"

EYES_BG, EYES_FG = "CC0000", "FFFFFF"
TOP_BG,  TOP_FG  = "FF4444", "FFFFFF"
SEC_BG,  SEC_FG  = "E06000", "FFFFFF"
CONF_BG, CONF_FG = "2255AA", "FFFFFF"
DECL_BG, DECL_FG = "226622", "FFFFFF"

GROUP_COLORS = {
    "White House Secrets":    "F5E6F0",
    "Ualani Personal Events": "D6F5EA",
    "Commander Thanks":       "D6E1F7",
    "Protector Arcs":         "EDD6F7",
}

CAT_COLORS = {
    "Game Systems":           "D6E4F7",
    "Terrain":                "D6F5D6",
    "Resources & Ores":       "FFF3CC",
    "Buildings":              "F7DDD6",
    "Governor Archetypes":    "D6EAF8",
    "Military Modifiers":     "FDEBD0",
    "Laws & Edicts":          "EDE0F7",
    "Technologies":           "D6F0D6",
    "Factions":               "FCE0D6",
    "Army Units":             "DCDCDC",
    "Magic Schools & Spells": "EDD6F7",
    "Protectors":             "B8D6F7",
    "Mythic Weapons":         "F5ECD5",
    "Lore & History":         "F5E6D6",
}


# ── helpers ───────────────────────────────────────────────────────────────────
def _fill(h):   return PatternFill("solid", fgColor=h)
def _border():
    s = Side(style="thin", color="CCCCCC")
    return Border(left=s, right=s, top=s, bottom=s)
def _font(bold=False, italic=False, color="000000", size=10):
    return Font(bold=bold, italic=italic, color=color, name="Calibri", size=size)
def _wrap():    return Alignment(wrap_text=True, vertical="top")
def _center():  return Alignment(horizontal="center", vertical="center", wrap_text=True)

def _hdr(ws, cols):
    for i, (label, width) in enumerate(cols, 1):
        c = ws.cell(row=1, column=i, value=label)
        c.fill = _fill(HDR_BG)
        c.font = _font(bold=True, color=HDR_FG, size=11)
        c.alignment = _center()
        c.border = _border()
        ws.column_dimensions[get_column_letter(i)].width = width
    ws.row_dimensions[1].height = 24

def _status_style(s):
    return {"FULL PASS":(FULL_BG,FULL_FG), "FIRST PASS":(FPASS_BG,FPASS_FG),
            "FIRST DRAFT":(FDRAFT_BG,FDRAFT_FG), "IDEA":(IDEA_BG,IDEA_FG),
            "STUB":(STUB_BG,STUB_FG)}.get(s, (WHITE,"000000"))

def _art_style(s):
    return {"Not Started":(ART_NONE_BG,ART_NONE_FG),
            "In Progress":(ART_WIP_BG,ART_WIP_FG),
            "Done":(ART_DONE_BG,ART_DONE_FG)}.get(s, (WHITE,"000000"))

def _cflag_style(f):
    return {"sensual":(SENSUAL_BG,SENSUAL_FG), "explicit":(EXPLICIT_BG,EXPLICIT_FG),
            "kinky":(KINKY_BG,KINKY_FG)}.get(f, (WHITE,"000000"))

def _classif_style(c):
    return {"EYES ONLY":(EYES_BG,EYES_FG), "TOP SECRET":(TOP_BG,TOP_FG),
            "SECRET":(SEC_BG,SEC_FG), "CONFIDENTIAL":(CONF_BG,CONF_FG),
            "DECLASSIFIED":(DECL_BG,DECL_FG)}.get(c, (WHITE,"000000"))

def _cat_banner(ws, row, label, ncols, bg=CAT_BG, fg=CAT_FG):
    ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=ncols)
    c = ws.cell(row=row, column=1, value=label)
    c.fill = _fill(bg)
    c.font = _font(bold=True, color=fg, size=10)
    c.alignment = Alignment(horizontal="left", vertical="center")
    c.border = _border()
    ws.row_dimensions[row].height = 18
    return row + 1


# ═══════════════════════════════════════════════════════════════════════════════
# GALLERY DATA
# (group, event_id, title, content_flag, hint, flavor, writing_status, art_status, art_path, notes)
# ═══════════════════════════════════════════════════════════════════════════════
GALLERY_DATA = [
    # ── White House Secrets ───────────────────────────────────────────────────
    ("White House Secrets", "WH_SECRET_01", "The New Year, Privately",
     "sensual",
     "Ualani must be in Washington DC when the new year turns",
     "No ceremony. No camera. No country to perform for.",
     "FIRST PASS", "Not Started", "", ""),

    ("White House Secrets", "WH_SECRET_07", "Independence Day — Hers",
     "explicit",
     "Ualani must be in Washington DC on the Fourth of July",
     "The founding documents were written by people who did not mean her. She means them anyway.",
     "FIRST PASS", "Not Started", "", ""),

    ("White House Secrets", "WH_SECRET_10", "A Letter from Jessica",
     "sensual",
     "Reach the Alliance stage with Canada (Ualani in Washington DC)",
     "Not a diplomatic dispatch. A personal one.",
     "FIRST PASS", "Not Started", "", ""),

    ("White House Secrets", "WH_SECRET_12", "Christmas in Washington",
     "sensual",
     "Ualani must be in Washington DC in winter",
     "She is from Hawaii. This is not Christmas as she knows it.",
     "FIRST PASS", "Not Started", "", ""),

    # ── Ualani Personal Events ────────────────────────────────────────────────
    ("Ualani Personal Events", "UALANI_AMBUSH_01", "The Counteroffensive Briefing",
     "sensual",
     "Hold a tile against a Crown ambush with Ualani present",
     "Ualani was already there. The Crown did not know that.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_DIGNITARY_01", "The Full Presidential Reception",
     "sensual",
     "Host a diplomatic reception at a liberated courthouse tile",
     "The courthouse has never looked this good.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_MEMORIAL_01", "The Presidential Address",
     "sensual",
     "Visit a memorial tile with Ualani",
     "The ground has history. The President has remarks.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_WOUNDED_01", "The Field Hospital Visit",
     "sensual",
     "Ualani visits a field hospital after a battle",
     "She knew their names. That is not an expression.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_WINTER_01", "The Winter March",
     "sensual",
     "March an army through a cold terrain tile in winter",
     "Washington did it once. The precedent is established.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_FORGE_01", "The Surprise Inspection",
     "sensual",
     "Own a Level 2+ Forge with a garrison present",
     "Production numbers were good. The President made them better.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_CULPER_01", "The Culper Meeting",
     "sensual",
     "Activate the Culper Ring intelligence network",
     "The message arrived with no signature. She knew who sent it.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_CULPER_BRIEF_01", "Intelligence Confirmed",
     "sensual",
     "Receive a confirmed intelligence brief from the Culper Ring",
     "The asset delivered. The map is different now.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_ALLIANCE_01", "The Alliance Council",
     "sensual",
     "Meet with a Commander who holds two or more objectives",
     "An alliance was discussed. The discussion went well.",
     "FIRST PASS", "Not Started", "", ""),

    ("Ualani Personal Events", "UALANI_FRONTIER_01", "The Frontier Walk",
     "sensual",
     "Establish presence at a border tile adjacent to Canada",
     "The northern edge of the Republic. She walked it.",
     "FIRST PASS", "Not Started", "", ""),

    # ── Commander Thanks ──────────────────────────────────────────────────────
    ("Commander Thanks", "CMD_THANKS", "A Personal Presidential Visit",
     "explicit",
     "A Commander completes their full arc at maximum loyalty",
     "The President doesn't visit everyone. She visited them.",
     "FIRST PASS", "Not Started", "", ""),

    # ── Protector Arcs ────────────────────────────────────────────────────────
    ("Protector Arcs", "PROT_01_SUMMON", "Mothman Approaches",
     "kinky",
     "Begin the Mothman protector arc (Harper's Ferry region)",
     "A presence in the dark.",
     "FIRST PASS", "Not Started", "", ""),

    ("Protector Arcs", "PROT_01_AGREE", "The Harper's Ferry Accord",
     "kinky",
     "Complete the Mothman protector arc and accept the alliance",
     "The agreement required no words. The words came anyway.",
     "FIRST PASS", "Not Started", "", ""),

    ("Protector Arcs", "PROT_14_SUMMON", "Rushmore Awakens",
     "kinky",
     "Begin the Mount Rushmore protector arc (Gettysburg region)",
     "All four have arrived and they are already arguing.",
     "FIRST PASS", "Not Started", "", ""),

    ("Protector Arcs", "PROT_14_AGREE", "The Presidential Council",
     "kinky",
     "Complete the Mount Rushmore protector arc and accept the endorsement",
     "They came to a vote. The vote was unanimous. Lincoln broke the tie.",
     "FIRST PASS", "Not Started", "", ""),
]


# ═══════════════════════════════════════════════════════════════════════════════
# RECORDS DATA
# (category, id, name, entry_type, description, unlock_flag, has_icon, status, notes)
# entry_type: "Regular" | "Mystery"
# ═══════════════════════════════════════════════════════════════════════════════
RECORDS_DATA = [
    # ── GAME SYSTEMS ──────────────────────────────────────────────────────────
    ("Game Systems","sys_turns","Turns & Time","Regular",
     "Each turn represents a season. Four turns make a year. The game begins in 1782, Year One of the Carlisle Administration. Pressing End Turn advances time, triggers income, building output, army upkeep, event checks, and all AI actions.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_census","Tile Census","Regular",
     "At the end of each turn, every tile you own runs a census. Each building on the tile reports its resource output — Food, Dollars, Wood, Metal, Magic, Culture, Weapons, Science, Mandate, Happiness, Manpower, Influence, and Boats. Governor bonuses are applied first.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_governors","Governors","Regular",
     "Governors are administrators assigned to individual tiles. Each governor has an archetype that determines which buildings they enhance. Governors have three levels. A governor can only manage one tile at a time.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_corruption","Corruption","Regular",
     "Corruption erodes a tile's productivity and morale. It rises from enemy activity, neglect, and certain events. Above 25 it begins to affect output. Above 60 it becomes serious. At 100 the tile may revolt. Buildings that reduce corruption: Baths, Temples, Libraries.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_colonization","Colonization","Regular",
     "Unclaimed tiles can be colonized by accumulating Colonization Points on them. The required points vary by terrain and distance. Naval tiles require a Dock presence.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_factions","Factions","Regular",
     "Factions are political, military, or social groups with their own agendas. Each faction has a Loyalty score toward the player. High loyalty unlocks faction events and bonuses. Low loyalty causes crises, defections, and armed opposition.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_spells","Magic & Spells","Regular",
     "Spells are unlocked through the Spellbook panel. Each spell belongs to a Magic School (Fire, Ice, Nature, Shadow, Light, Storm). Towers produce magic income. Wizards assigned to tiles amplify magical output and may cast defensive or offensive spells each turn.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_autosave","Autosave","Regular",
     "The game saves automatically at the end of each turn to a single autosave slot. The main menu 'Continue' button always loads the most recent autosave. There is no manual save system.",
     "",False,"FIRST PASS",""),
    ("Game Systems","sys_content","Content Flags","Regular",
     "The game contains optional adult content. Sensual, Explicit, and Kinky/Lewd flags can be individually enabled or disabled in Settings. Gallery entries are only unlocked when the corresponding event fires with the flag active.",
     "",False,"FIRST PASS",""),

    # ── TERRAIN ───────────────────────────────────────────────────────────────
    ("Terrain","ter_jungle","Jungle","Regular",
     "Dense tropical growth. High food output from farms. Movement penalties for armies. Reduces corruption spread. Home to rare botanical ores.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_steppe","Steppe","Regular",
     "Open grassland ideal for cavalry movement. Moderate food and manpower output. Vulnerable to storm damage.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_bog","Bog","Regular",
     "Waterlogged ground. Slows all movement. Unique ore deposits. Penalties to building construction speed.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_cold_coast","Cold Coast","Regular",
     "Northern shoreline battered by Atlantic wind. Strong fishing and Boat production from Docks.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_drylands","Drylands","Regular",
     "Arid scrubland with scarce water. Low food output. High weapon and metal production. Corruption spreads faster here.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_warm_coast","Warm Coast","Regular",
     "Southern shoreline with fertile soil and warm waters. High food output. Docks produce double the normal Boat yield. Vulnerable to storm events.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_floodplains","Floodplains","Regular",
     "River delta terrain. Exceptionally fertile — highest food output in the game. Vulnerable to seasonal flooding events.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_desert","Desert","Regular",
     "Barren and hostile. Minimal food. Armies suffer attrition here. Faith bonuses from Temples are doubled.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_meadow","Meadow","Regular",
     "Gentle grassland. Balanced output across most resource types. Easy to colonize. Preferred terrain for initial expansion.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_mountaintop","Mountaintop","Regular",
     "High peaks. Strong mine output for metal and weapons. Armies move slowly. Difficult to colonize. Defensive bonus for stationed armies.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_mountaintop_cold","Frozen Mountaintop","Regular",
     "Snow-covered peaks. All mountaintop properties amplified. Higher defensive bonus. Army attrition risk in winter turns.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_hills","Hills","Regular",
     "Rolling terrain with moderate defensive value. Good for mines and camps. Balanced movement penalty.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_forest","Forest","Regular",
     "Dense woodland. High Wood output. Army movement penalty. Reduces enemy cavalry effectiveness. Source of herbal and magical ores.",
     "",True,"FIRST PASS",""),
    ("Terrain","ter_taiga","Taiga","Regular",
     "Northern boreal forest. High Wood output. Harsh winter penalties apply here first. Unique ores unavailable elsewhere.",
     "",True,"FIRST PASS",""),

    # ── RESOURCES & ORES ──────────────────────────────────────────────────────
    ("Resources & Ores","res_food","Food","Regular",
     "Feeds the population and sustains armies in the field. Produced by Farms, Granaries, and coastal fishing. Shortfalls cause happiness penalties and army attrition.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_dollars","Dollars","Regular",
     "The lifeblood of the republic. Pays for buildings, armies, and political favors. Produced by Markets, Faires, and trade routes. A negative balance triggers economic crisis events.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_wood","Wood","Regular",
     "Essential for construction and naval production. Produced by Camps, Docks, and forest terrain bonuses.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_metal","Metal","Regular",
     "Required for Weapons, advanced buildings, and certain tech upgrades. Produced primarily by Mines.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_weapons","Weapons","Regular",
     "Equips your armies and funds your war effort. Produced by Forges and Arsenals. Army upkeep consumes Weapons each turn.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_science","Science","Regular",
     "Powers the research of new Technologies. Produced by Libraries and Schools. Accumulated science is spent on techs in the Tech Tree panel.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_magic","Magic","Regular",
     "Fuel for spells and arcane infrastructure. Produced by Towers, Wizards, and certain protectors. Required to cast spells in battle and maintain magical buildings.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_faith","Faith","Regular",
     "Spiritual capital of the nation. Produced by Temples and Monasteries. Unlocks religious laws and certain diplomatic options with faith-based factions.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_culture","Culture","Regular",
     "Represents the artistic and intellectual vitality of the republic. Produced by Theaters, Baths, and cultural buildings. Required for Tradition unlocks.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_mandate","Mandate","Regular",
     "The political authority of the presidency. High Mandate unlocks stronger edicts and expands law options. Produced by government buildings and compliance events.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_happiness","Happiness","Regular",
     "National morale. Affects approval rating, faction loyalty, and productivity. Falls under corruption, war exhaustion, and resource shortfalls.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_manpower","Manpower","Regular",
     "The pool from which armies are drawn. Produced by Barracks and population-dense tiles. Consumed when armies are recruited or suffer heavy losses.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_influence","Influence","Regular",
     "Diplomatic capital. Used to sway factions, broker alliances, and suppress opposition. Produced by Forts, Embassies, and named governor bonuses.",
     "",True,"FIRST PASS",""),
    ("Resources & Ores","res_boats","Boats","Regular",
     "Naval capacity. Produced by Docks. Required to move armies across water tiles and to maintain a navy.",
     "",False,"FIRST PASS","Icon pending — see MAN-001 editor task."),

    # ── BUILDINGS ─────────────────────────────────────────────────────────────
    ("Buildings","bld_farm","Farm","Regular",
     "The backbone of agricultural production. Generates Food and small amounts of Wood. FARMER governors dramatically increase output.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_mine","Mine","Regular",
     "Extracts Metal from the earth. Output scales with terrain — Mountains and Hills provide the highest yields.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_barracks","Barracks","Regular",
     "Trains and houses soldiers. Produces Manpower each turn. Stationed armies receive a combat bonus. Required for WARRIOR and SOLDIER governor assignments.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_market","Market","Regular",
     "Generates Dollars through trade. DIPLOMAT and ORATOR governors amplify output. Higher-level markets reduce corruption spread.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_library","Library","Regular",
     "Produces Science and small amounts of Culture. Required for SCHOLAR governor assignment. Level 3 Libraries also produce Influence.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_tower","Tower","Regular",
     "Produces Magic each turn and provides a platform for Wizards. Protectors who join the republic are bound to a Tower at their home tile.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_granary","Granary","Regular",
     "Stores and distributes food surplus. Reduces the penalty of food shortfalls. With the Mandate from Granaries law active, also produces Mandate.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_forge","Forge","Regular",
     "Produces Weapons from Metal. Required for WARRIOR governor assignment. Level 2+ Forges also produce a small amount of Science.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_temple","Temple","Regular",
     "Produces Faith and Happiness. Reduces corruption. HEALER governors amplify output. Required for religious law access.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_bath","Bath","Regular",
     "Generates Happiness and reduces corruption. Level 2+ Baths also produce Culture.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_theater","Theater","Regular",
     "Cultural hub producing Culture and Happiness. ORATOR governors thrive here. Level 3 Theaters produce Influence.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_dock","Dock","Regular",
     "Naval infrastructure on coastal tiles. Produces Boats and Wood. Required for colonizing across water. ADMIRAL governors dramatically amplify output.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_camp","Camp","Regular",
     "Frontier outpost. Produces Wood, Manpower, and Weapons. SCOUT governors thrive in Camps.",
     "",False,"FIRST PASS",""),
    ("Buildings","bld_monument","Monument","Regular",
     "A landmark of national identity. Produces Culture, Mandate, and Happiness. Required for high-level HERALD governor assignment.",
     "",False,"FIRST PASS",""),

    # ── GOVERNOR ARCHETYPES ───────────────────────────────────────────────────
    ("Governor Archetypes","arc_farmer","FARMER","Regular",
     "Masters of the land. Dramatically boost Farm and Granary output. Level 3 unlocks crop rotation events and reduces food spoilage.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_scout","SCOUT","Regular",
     "Explorers and frontier agents. Boost Camp and Mine output. Level 2 reduces colonization costs on adjacent tiles. Level 3 expands tile visibility.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_warrior","WARRIOR","Regular",
     "Combat-focused administrators. Boost Barracks and Forge output and grant a tile defense bonus. Level 3 adds a standing combat modifier to stationed armies.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_scholar","SCHOLAR","Regular",
     "Intellectuals and researchers. Boost Library output and generate bonus Science each turn. Level 3 occasionally unlocks free Technology events.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_engineer","ENGINEER","Regular",
     "Builders and infrastructure experts. Reduce building construction cost and boost Mine and Dock output. Level 3 allows one free building upgrade per year.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_diplomat","DIPLOMAT","Regular",
     "Political operators. Boost Market and Monument output. Generate Influence passively. Level 3 adds a loyalty buffer to the tile's dominant faction.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_orator","ORATOR","Regular",
     "Speakers and agitators. Boost Theater and Market output. Generate Culture and Happiness. Level 3 triggers popular approval events.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_healer","HEALER","Regular",
     "Physicians and spiritual leaders. Boost Temple and Bath output. Reduce corruption. Level 3 provides army recovery bonuses when stationed on their tile.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_spy","SPYMASTER","Regular",
     "Intelligence operatives. Generate Influence and reduce enemy spy effectiveness on the tile. Level 3 can intercept enemy events.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_admiral","ADMIRAL","Regular",
     "Naval commanders in civilian governance. Dramatically boost Dock output. Level 3 doubles Boat production and reduces naval upkeep.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_mage","MAGE","Regular",
     "Arcane administrators. Boost Tower output and Magic generation. Level 3 learns a spell that fires once per year on their tile.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_soldier","SOLDIER","Regular",
     "Veteran fighters in peacetime roles. Boost Barracks and Camp output. Reduce army upkeep on the tile. Level 3 grants a morale bonus to stationed armies.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_bureaucrat","BUREAUCRAT","Regular",
     "Administrative specialists. Boost Mandate and Influence generation. Reduce corruption. Level 3 reduces the cost of laws and edicts.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_herald","HERALD","Regular",
     "Messengers and public figures. Boost Monument and Theater output. Generate Happiness and Culture across multiple tiles. Level 3 triggers national morale events.",
     "",False,"FIRST PASS",""),
    ("Governor Archetypes","arc_preacher","CIRCUIT PREACHER","Regular",
     "Traveling ministers of faith. Boost Temple output significantly. Generate Faith across the region. Level 3 can suppress faction unrest through religious revival events.",
     "",False,"FIRST PASS",""),

    # ── STUB CATEGORIES ───────────────────────────────────────────────────────
    ("Military Modifiers","_stub_milmod","— stub —","Regular",
     "Military Modifiers entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),
    ("Laws & Edicts","_stub_laws","— stub —","Regular",
     "Laws & Edicts entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),
    ("Technologies","_stub_tech","— stub —","Regular",
     "Technologies entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),
    ("Factions","_stub_factions","— stub —","Regular",
     "Factions entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),
    ("Army Units","_stub_army","— stub —","Regular",
     "Army Units entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),
    ("Magic Schools & Spells","_stub_magic","— stub —","Regular",
     "Magic Schools & Spells entries not yet written. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written."),

    # ── PROTECTORS (all mystery until agree) ──────────────────────────────────
    ("Protectors","PROT_01","???","Mystery",
     "Something moves in the mountain passes of West Virginia at night. Old miners refuse to speak its name.",
     "PROT_01",False,"FIRST PASS","Mothman. Revealed entry not yet written."),
    ("Protectors","PROT_02","???","Mystery",
     "Hunters along the Pine Barrens have reported a winged figure that leaves no tracks and makes no sound.",
     "PROT_02",False,"FIRST PASS","Jersey Devil. Revealed entry not yet written."),
    ("Protectors","PROT_03","???","Mystery",
     "The Blue Ridge holds something ancient. Larger than a man. Older than the republic.",
     "PROT_03",False,"FIRST PASS","Bigfoot. Revealed entry not yet written."),
    ("Protectors","PROT_04","???","Mystery",
     "Storm riders speak of a great shape seen above the clouds near the Great Lakes. The thunder that follows it is not natural.",
     "PROT_04",False,"FIRST PASS","Thunderbird. Revealed entry not yet written."),
    ("Protectors","PROT_05","???","Mystery",
     "A horseman without a head has been reported along the Hudson. It rides hard and it rides at night.",
     "PROT_05",False,"FIRST PASS","Headless Horseman. Revealed entry not yet written."),
    ("Protectors","PROT_06","???","Mystery",
     "Chesapeake fishermen have stopped working the deep water. Something beneath the surface watches back.",
     "PROT_06",False,"FIRST PASS","Chessie/sea serpent. Revealed entry not yet written."),
    ("Protectors","PROT_07","???","Mystery",
     "In the hills of Tennessee, a farmhouse was visited nightly by something that could not be touched. It knew names. It remembered.",
     "PROT_07",False,"FIRST PASS","Bell Witch. Revealed entry not yet written."),
    ("Protectors","PROT_08","???","Mystery",
     "A ship that cannot be sunk has been sighted in Boston Harbor. Its crew does not age. Its guns never run dry.",
     "PROT_08",False,"FIRST PASS","Ghost ship / Constitution spirit. Revealed entry not yet written."),
    ("Protectors","PROT_09","???","Mystery",
     "Near Valley Forge, sentries report a figure walking the old encampment grounds in the fog. It wears Continental blue.",
     "PROT_09",False,"FIRST PASS","Washington's Ghost. Revealed entry not yet written."),
    ("Protectors","PROT_10","???","Mystery",
     "Something nests in the Catoctin Mountains. Travelers between the capital and the north have gone missing.",
     "PROT_10",False,"FIRST PASS","Snallygaster. Revealed entry not yet written."),
    ("Protectors","PROT_11","???","Mystery",
     "A rider was seen near Lexington moving faster than any horse alive. The message he carries has not yet been delivered.",
     "PROT_11",False,"FIRST PASS","Paul Revere ghost. Revealed entry not yet written."),
    ("Protectors","PROT_12","???","Mystery",
     "In Philadelphia, on quiet nights, a ringing is heard with no source. It comes from Independence Hall. Nothing is there.",
     "PROT_12",False,"FIRST PASS","Liberty Bell spirit. Revealed entry not yet written."),
    ("Protectors","PROT_13","???","Mystery",
     "The mountains of Vermont are haunted by something patriotic and enormous. It has opinions about taxation.",
     "PROT_13",False,"FIRST PASS","Green Mountain giant (Ethan Allen). Revealed entry not yet written."),
    ("Protectors","PROT_14","???","Mystery",
     "The faces in the rock at Gettysburg open their eyes sometimes. Only sometimes. But when they do, they are looking south.",
     "PROT_14",False,"FIRST PASS","Mount Rushmore (anachronistic). Revealed entry not yet written."),
    ("Protectors","PROT_15","???","Mystery",
     "The Everglades hold something enormous and foul-smelling that the local Seminole call very old. They do not explain further.",
     "PROT_15",False,"FIRST PASS","Skunk Ape. Revealed entry not yet written."),
    ("Protectors","PROT_16","???","Mystery",
     "There is a musket that fires without being loaded, held by someone who cannot be seen, near the Connecticut River valley.",
     "PROT_16",False,"FIRST PASS","Invisible musketeer. Revealed entry not yet written."),
    ("Protectors","PROT_17","???","Mystery",
     "The White House has had a permanent guest since 1862. He walks the halls at night. He is tall. He is patient.",
     "PROT_17",False,"FIRST PASS","Lincoln's Ghost. Revealed entry not yet written."),
    ("Protectors","CA_PROT_01","???","Mystery",
     "Something pulls the ice floes apart along the St. Lawrence. The voyageurs call it a bad crossing year. It is not a crossing year.",
     "CA_PROT_01",False,"FIRST PASS","Canadian protector. Revealed entry not yet written."),
    ("Protectors","CA_PROT_02","???","Mystery",
     "A shape has been seen beneath Lake Ontario for three hundred years. It has not moved. It is waiting.",
     "CA_PROT_02",False,"FIRST PASS","Lake monster (Manipogo). Revealed entry not yet written."),
    ("Protectors","CA_PROT_03","???","Mystery",
     "The Wendigo of the northern forests is not a story parents tell children. It is a warning parents tell each other.",
     "CA_PROT_03",False,"FIRST PASS","Wendigo. Revealed entry not yet written."),
    ("Protectors","CA_PROT_04","???","Mystery",
     "The Ojibwe speak of a great lynx that controls the deep water. It has not been seen since the last winter that killed everyone who saw it.",
     "CA_PROT_04",False,"FIRST PASS","Mishibizhiw. Revealed entry not yet written."),
    ("Protectors","CA_PROT_05","???","Mystery",
     "In the villages near Québec City, they remember a woman who was executed. They do not say she stayed dead.",
     "CA_PROT_05",False,"FIRST PASS","La Corriveau. Revealed entry not yet written."),
    ("Protectors","CA_PROT_06","???","Mystery",
     "The wolverine of Moncton is not an animal. The trappers learned this. The trappers are gone now.",
     "CA_PROT_06",False,"FIRST PASS","Acadian monster. Revealed entry not yet written."),
    ("Protectors","CA_PROT_07","???","Mystery",
     "The flying canoe that travels the river at night does not appear on maps. The men inside it have been paddling for a very long time.",
     "CA_PROT_07",False,"FIRST PASS","Chasse-galerie. Revealed entry not yet written."),
    ("Protectors","CA_PROT_08","???","Mystery",
     "In the bay, where the Chaleur meets the ocean, fishermen sometimes see a light beneath the water. They go home. They do not explain why.",
     "CA_PROT_08",False,"FIRST PASS","Phantom ship of Chaleur Bay. Revealed entry not yet written."),

    # ── MYTHIC WEAPONS ────────────────────────────────────────────────────────
    ("Mythic Weapons","_stub_mythic","— stub —","Regular",
     "Mythic Weapons entries not yet written. Weapons show as mystery entries until first found. Add them to RecordsDatabase.gd.",
     "",False,"STUB","Needs entries written. Each weapon needs a mystery + revealed version."),

    # ── LORE & HISTORY ────────────────────────────────────────────────────────
    ("Lore & History","lore_first_war","The First British Reconquest War","Regular",
     "In 1782, following the unexpected death of King George III, the British Parliament authorized a full military reconquest of the former colonies. What followed was the First Reconquest War — a brutal, satirical, and deeply inconvenient reminder that revolution is easier the second time.\n\nPresident Ualani Carlisle faced the full weight of the British Empire with a standing army, a treasury of questionable depth, and the most politically functional cabinet in American history.",
     "",False,"FIRST PASS",""),
    ("Lore & History","lore_ualani","President Ualani Carlisle","Regular",
     "Hawaii's first President of the United States. Former senator. Former general. Current problem for the British Empire.\n\nUalani Carlisle was elected on a platform of infrastructure, diplomacy, and what her opponents called 'an alarming amount of common sense.' She is known for her directness and her habit of personally responding to threatening letters from foreign heads of state.",
     "",False,"FIRST PASS",""),
]


# ═══════════════════════════════════════════════════════════════════════════════
# JOURNAL DATA
# (event_type, classification, description, status, notes)
# ═══════════════════════════════════════════════════════════════════════════════
JOURNAL_DATA = [
    ("ualani_event",        "EYES ONLY",    "Ualani personal arc events — intimate moments away from official duties",                             "FIRST PASS",""),
    ("white_house_secret",  "EYES ONLY",    "White House holiday intimacy events — seasonal moments in Washington DC",                             "FIRST PASS",""),
    ("vp_event",            "EYES ONLY",    "Vice President relationship arc — private events involving the VP",                                   "FIRST PASS",""),
    ("protector_agree",     "TOP SECRET",   "USA protector alliance agreements — fires when a protector joins the republic",                       "FIRST PASS",""),
    ("ca_protector_agree",  "TOP SECRET",   "Canadian protector alliance agreements",                                                              "FIRST PASS",""),
    ("war_declaration",     "SECRET",       "UK declares war — major historical inflection point",                                                 "FIRST PASS",""),
    ("war_buildup",         "SECRET",       "Pre-war intelligence events — buildup and warning signs before conflict",                             "FIRST PASS",""),
    ("peace",               "SECRET",       "Peace treaty events — resolution of conflicts",                                                       "FIRST PASS",""),
    ("election_season",     "CONFIDENTIAL", "Election campaign events — political maneuvering and platform speeches",                              "FIRST PASS",""),
    ("election_night_win",  "CONFIDENTIAL", "Ualani wins re-election — victory speech and aftermath",                                              "FIRST PASS",""),
    ("election_night_lose", "CONFIDENTIAL", "Ualani loses the election — concession and transition of power",                                      "FIRST PASS",""),
    ("city_liberated",      "CONFIDENTIAL", "Major city liberated from Crown control",                                                             "FIRST PASS",""),
    ("city_lost",           "CONFIDENTIAL", "Major city lost to enemy forces",                                                                     "FIRST PASS",""),
    ("state_liberated",     "CONFIDENTIAL", "Full state liberated — major territorial milestone",                                                  "FIRST PASS",""),
    ("collapse",            "SECRET",       "Republic collapse event — catastrophic failure condition",                                            "FIRST PASS",""),
    ("secession",           "SECRET",       "State secession — a state breaks from the republic",                                                  "FIRST PASS",""),
    ("reintegration",       "CONFIDENTIAL", "State reintegration — a seceded state rejoins the republic",                                         "FIRST PASS",""),
    ("commander_complete",  "DECLASSIFIED", "Commander arc completion — a commander finishes their full loyalty arc",                              "FIRST PASS",""),
]


# ═══════════════════════════════════════════════════════════════════════════════
# SHEET BUILDERS
# ═══════════════════════════════════════════════════════════════════════════════

def build_gallery_sheet(wb):
    ws = wb.create_sheet("GALLERY")
    ws.freeze_panes = "A2"
    COLS = [
        ("Group",           20),
        ("Event ID",        24),
        ("Title",           30),
        ("Content Flag",    14),
        ("Unlock Hint",     44),
        ("Flavor Text",     48),
        ("Writing Status",  16),
        ("Art Status",      14),
        ("Art Path",        28),
        ("Notes",           32),
    ]
    _hdr(ws, COLS)

    row = 2
    current_group = None
    alt = False

    for entry in GALLERY_DATA:
        grp, eid, title, cflag, hint, flavor, wstatus, astatus, apath, notes = entry

        if grp != current_group:
            current_group = grp
            row = _cat_banner(ws, row, f"  ● {grp}", len(COLS),
                              bg=GROUP_COLORS.get(grp, CAT_BG), fg="1A2A3A")
            alt = False

        bg = ALT_BG if alt else WHITE
        alt = not alt
        cflag_bg, cflag_fg = _cflag_style(cflag)
        wst_bg,  wst_fg   = _status_style(wstatus)
        art_bg,  art_fg   = _art_style(astatus)

        vals = [grp, eid, title, cflag, hint, flavor, wstatus, astatus, apath, notes]
        for ci, v in enumerate(vals, 1):
            c = ws.cell(row=row, column=ci, value=v)
            c.border = _border()
            c.alignment = _wrap()
            c.fill = _fill(bg)
            c.font = _font()
            if ci == 4:
                c.fill = _fill(cflag_bg); c.font = _font(bold=True, color=cflag_fg)
                c.alignment = _center()
            elif ci == 7:
                c.fill = _fill(wst_bg);  c.font = _font(bold=True, color=wst_fg)
                c.alignment = _center()
            elif ci == 8:
                c.fill = _fill(art_bg);  c.font = _font(bold=True, color=art_fg)
                c.alignment = _center()

        ws.row_dimensions[row].height = 50
        row += 1

    ws.auto_filter.ref = f"A1:{get_column_letter(len(COLS))}1"


def build_records_sheet(wb):
    ws = wb.create_sheet("RECORDS")
    ws.freeze_panes = "A2"
    COLS = [
        ("Category",            22),
        ("ID",                  22),
        ("Name",                26),
        ("Type",                12),
        ("Description / Hint",  60),
        ("Unlock Flag",         14),
        ("Has Icon",            10),
        ("Status",              14),
        ("Notes",               32),
    ]
    _hdr(ws, COLS)

    row = 2
    current_cat = None
    alt = False

    for entry in RECORDS_DATA:
        cat, eid, name, etype, desc, unlock_flag, has_icon, status, notes = entry

        if cat != current_cat:
            current_cat = cat
            row = _cat_banner(ws, row, f"  ● {cat}", len(COLS),
                              bg=CAT_COLORS.get(cat, CAT_BG), fg="1A2A3A")
            alt = False

        is_stub = eid.startswith("_stub_")
        bg = STUB_BG if is_stub else (ALT_BG if alt else WHITE)
        alt = not alt

        st_bg, st_fg = _status_style(status)
        type_bg = "BB44AA" if etype == "Mystery" else WHITE
        type_fg = "FFFFFF" if etype == "Mystery" else "000000"

        vals = [cat, eid, name, etype, desc, unlock_flag,
                "Yes" if has_icon else "No", status, notes]
        for ci, v in enumerate(vals, 1):
            c = ws.cell(row=row, column=ci, value=v)
            c.border = _border()
            c.alignment = _wrap()
            c.fill = _fill(bg)
            c.font = _font(italic=is_stub)
            if ci == 4:
                c.fill = _fill(type_bg); c.font = _font(bold=True, color=type_fg)
                c.alignment = _center()
            elif ci == 8:
                c.fill = _fill(st_bg); c.font = _font(bold=True, color=st_fg)
                c.alignment = _center()

        ws.row_dimensions[row].height = 55
        row += 1

    ws.auto_filter.ref = f"A1:{get_column_letter(len(COLS))}1"


def build_journal_sheet(wb):
    ws = wb.create_sheet("JOURNAL")
    ws.freeze_panes = "A2"
    COLS = [
        ("Event Type",     28),
        ("Classification", 18),
        ("Description",    55),
        ("Status",         14),
        ("Notes",          32),
    ]
    _hdr(ws, COLS)

    for i, entry in enumerate(JOURNAL_DATA):
        etype, classif, desc, status, notes = entry
        bg = ALT_BG if i % 2 else WHITE
        cl_bg, cl_fg = _classif_style(classif)
        st_bg, st_fg = _status_style(status)

        row = i + 2
        vals = [etype, classif, desc, status, notes]
        for ci, v in enumerate(vals, 1):
            c = ws.cell(row=row, column=ci, value=v)
            c.border = _border()
            c.alignment = _wrap()
            c.fill = _fill(bg)
            c.font = _font()
            if ci == 2:
                c.fill = _fill(cl_bg); c.font = _font(bold=True, color=cl_fg)
                c.alignment = _center()
            elif ci == 4:
                c.fill = _fill(st_bg); c.font = _font(bold=True, color=st_fg)
                c.alignment = _center()

        ws.row_dimensions[row].height = 40

    ws.auto_filter.ref = f"A1:{get_column_letter(len(COLS))}1"


# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

def main():
    wb = openpyxl.Workbook()
    wb.remove(wb.active)

    build_gallery_sheet(wb)
    build_records_sheet(wb)
    build_journal_sheet(wb)

    wb.save(OUT_PATH)

    n_gal   = len(GALLERY_DATA)
    n_sens  = sum(1 for e in GALLERY_DATA if e[3] == "sensual")
    n_expl  = sum(1 for e in GALLERY_DATA if e[3] == "explicit")
    n_kink  = sum(1 for e in GALLERY_DATA if e[3] == "kinky")
    art_done= sum(1 for e in GALLERY_DATA if e[7] == "Done")

    real_rec = [e for e in RECORDS_DATA if not e[1].startswith("_stub_")]
    stub_rec = [e for e in RECORDS_DATA if e[1].startswith("_stub_")]
    n_myst  = sum(1 for e in real_rec if e[3] == "Mystery")

    n_jour  = len(JOURNAL_DATA)

    print(f"Saved: {OUT_PATH}")
    print(f"GALLERY : {n_gal} entries  ({n_sens} sensual, {n_expl} explicit, {n_kink} kinky)"
          f"  |  art done: {art_done}/{n_gal}")
    print(f"RECORDS : {len(real_rec)} entries ({n_myst} mystery)  +  {len(stub_rec)} stub categories")
    print(f"JOURNAL : {n_jour} event types tracked")


if __name__ == "__main__":
    main()
