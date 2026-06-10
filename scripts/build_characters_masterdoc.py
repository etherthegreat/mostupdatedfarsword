#!/usr/bin/env python3
"""
Generate character_masterdoc.xlsx — physical + personality design bible for all
named characters in Farsword (excluding procedurally generated commanders).

Sheets:
  1. OVERVIEW     — character count by country/status, design completeness
  2. PLAYABLE     — USA named governors (hire-able characters)
  3. CANADIAN     — Canadian named governors and leaders
  4. NPC          — Non-playable named characters (event figures, antagonists, etc.)
  5. DESIGN NOTES — Art direction and consistency rules

Status scale:
  FINAL     — physical + personality fully locked, art approved
  DESIGNED  — fully described, not yet in final art
  PARTIAL   — some info defined, gaps remain
  STUB      — character exists in code, not yet designed

Run from repo root:  python3 scripts/build_characters_masterdoc.py
"""

import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

OUT_PATH = "character_masterdoc.xlsx"

# ── PALETTE ──────────────────────────────────────────────────────────────────
HDR_BG, HDR_FG     = "1F2D3D", "FFFFFF"
USA_BG, USA_FG     = "1F3864", "FFFFFF"
CA_BG,  CA_FG      = "9B1C1C", "FFFFFF"
NPC_BG, NPC_FG     = "4A3728", "FFFFFF"
ALT_BG             = "EEF2F7"
WHITE              = "FFFFFF"

FINAL_BG,   FINAL_FG   = "00B050", "FFFFFF"
DESIGN_BG,  DESIGN_FG  = "92D050", "1A3A00"
PARTIAL_BG, PARTIAL_FG = "FFEB9C", "7A5A00"
STUB_BG,    STUB_FG    = "C9B1E8", "3A1A6A"

STATUS_BG = {
    "FINAL":    FINAL_BG,
    "DESIGNED": DESIGN_BG,
    "PARTIAL":  PARTIAL_BG,
    "STUB":     STUB_BG,
}
STATUS_FG = {
    "FINAL":    FINAL_FG,
    "DESIGNED": DESIGN_FG,
    "PARTIAL":  PARTIAL_FG,
    "STUB":     STUB_FG,
}

# ── HELPERS ───────────────────────────────────────────────────────────────────
def _fill(h):
    return PatternFill("solid", fgColor=h)

def _border():
    s = Side(style="thin", color="CCCCCC")
    return Border(left=s, right=s, top=s, bottom=s)

def _font(bold=False, italic=False, color="000000", size=10):
    return Font(bold=bold, italic=italic, color=color, size=size, name="Calibri")

def _hdr(ws, row, col, text, bg=HDR_BG, fg=HDR_FG, bold=True, size=10, wrap=True):
    c = ws.cell(row=row, column=col, value=text)
    c.font = _font(bold=bold, color=fg, size=size)
    c.fill = _fill(bg)
    c.border = _border()
    c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=wrap)
    return c

def _cell(ws, row, col, text, bg=WHITE, bold=False, italic=False, wrap=True, align="left"):
    c = ws.cell(row=row, column=col, value=text)
    c.font = _font(bold=bold, italic=italic)
    c.fill = _fill(bg)
    c.border = _border()
    c.alignment = Alignment(horizontal=align, vertical="top", wrap_text=wrap)
    return c

def _status_cell(ws, row, col, status):
    bg = STATUS_BG.get(status, "FFFFFF")
    fg = STATUS_FG.get(status, "000000")
    c = ws.cell(row=row, column=col, value=status)
    c.font = _font(bold=True, color=fg)
    c.fill = _fill(bg)
    c.border = _border()
    c.alignment = Alignment(horizontal="center", vertical="center")
    return c

def _set_col_widths(ws, widths):
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[get_column_letter(i)].width = w

def _freeze(ws, cell="A2"):
    ws.freeze_panes = cell

# ── CHARACTER DATA ─────────────────────────────────────────────────────────────
#
# Columns: name, position, faction, ethnicity_background, physical_description,
#          personality_traits, narrative_hook, relationships, loyalty_base, status
#
# Physical descriptions are the ART BIBLE — what artists draw, consistent across
# all appearances (cards, events, portraits, cutscenes).
#
# Personality traits are comma-separated keywords for writers (tone of voice,
# behavioral tendencies, dialogue beats).

USA_CHARACTERS = [
    {
        "name": "Ualani Carlisle",
        "position": "PRESIDENT & COMMANDER",
        "faction": "Federal",
        "ethnicity": "Hawaiian / Filipina",
        "physical": (
            "Athletic build, medium height. Warm brown skin. Belly-length straight black hair, "
            "usually worn loose or in a single thick braid during field command. Gold hoop earrings "
            "always present — a personal constant across every context. Sharp dark eyes with "
            "a commander's flat affect. Presidential uniform: deep blue with gold braid and "
            "campaign medals. In the field: same uniform, sleeves rolled, hair braided back. "
            "No powder, no wig. The face of a republic that stopped asking for permission."
        ),
        "personality": "Decisive, unflappable, dry wit, physically present in danger, reads rooms instantly, allergic to pomp, loyal to institutions over individuals",
        "hook": "Commands the APF personally. Security detail has filed 17 formal objections. She has read none of them.",
        "relationships": "Marc Penoit: alliance partner, mutual respect; Jessica Commanda Odjick: peer leader, growing trust; Benjamin Tallmadge: relies on his intel, trusts his discretion",
        "loyalty_base": 20,
        "status": "DESIGNED",
    },
    {
        "name": "Patrick Henry",
        "position": "ORATOR",
        "faction": "Patriot",
        "ethnicity": "Anglo-Virginian",
        "physical": (
            "Lean, angular frame — a man who eats when there's time. Sharp jaw, sunken cheeks, "
            "intense dark eyes that catch light when he speaks. Mid-50s. Dark riding coat, no "
            "powder — he considers it aristocratic affectation. Long fingers, built for pointing "
            "at things accusingly. Often seen mid-gesture, jaw set. The kind of face that looks "
            "like it is always about to say something that will get everyone in trouble."
        ),
        "personality": "Incendiary, rhetorically brilliant, suspicious of centralized power (including his own side), principle over pragmatism, crowd-reader, easily roused, slow to forgive",
        "hook": "'Give me liberty or give me death' — and he means it about every policy disagreement.",
        "relationships": "Ualani Carlisle: respects her directness, uneasy about Federal authority; Thomas Paine: ideological kinship, competitive",
        "loyalty_base": 8,
        "status": "DESIGNED",
    },
    {
        "name": "Abigail Adams",
        "position": "DIPLOMAT",
        "faction": "Moderate",
        "ethnicity": "Anglo-New England",
        "physical": (
            "Composed and precise. Oval face with an expression of patient, slightly disappointed "
            "intelligence. Brown eyes that miss nothing. Dark hair pinned beneath a white cap in "
            "public; loose when writing at her desk — which is where she does her real work. "
            "Colonial dress: practical wool in dark greens and blues, no unnecessary ornament. "
            "The posture of someone who has spent thirty years editing other people's correspondence "
            "and making it better than theirs."
        ),
        "personality": "Methodical, principled, politically sharp, diplomatically patient, holds grudges gracefully, pushes institutions toward their own stated ideals, unfazed by powerful men",
        "hook": "'Remember the ladies' — she said it once and has spent the rest of her career proving she meant it structurally.",
        "relationships": "Patrick Henry: ideological friction; Thomas Paine: finds him too chaotic; Governor Carleton: has his measure completely",
        "loyalty_base": 7,
        "status": "DESIGNED",
    },
    {
        "name": "Thomas Paine",
        "position": "SCHOLAR",
        "faction": "Radical",
        "ethnicity": "Anglo (English immigrant)",
        "physical": (
            "Heavy-browed, broad forehead, quick restless eyes. Mid-40s but looks older from "
            "travel and argument. Ink-stained fingers — always. Worn greatcoat, the collar "
            "turned up against a wind that isn't there. Doesn't own a wig and would never. "
            "Often holding something he's reading. The kind of face that looks like it arrived "
            "from somewhere worse and found this place merely disappointing by comparison."
        ),
        "personality": "Principled to the point of impracticality, believes in people absolutely, distrust of all governments including good ones, tireless pamphleteer, combustible under bad-faith argument, genuinely egalitarian",
        "hook": "His pamphlets lit the fire. He's here to make sure it doesn't burn the wrong things.",
        "relationships": "Patrick Henry: mutual intensity, different targets; Abigail Adams: respects her, exasperates her; Daniel Shays: understands his grievance instinctively",
        "loyalty_base": 4,
        "status": "DESIGNED",
    },
    {
        "name": "Mercy Otis Warren",
        "position": "SCHOLAR",
        "faction": "Patriot",
        "ethnicity": "Anglo-New England",
        "physical": (
            "Sharp-featured, dark quick eyes, an expression of focused appraisal. Mid-50s. "
            "Dark wool dress, simple — she dresses like someone who doesn't need clothes to "
            "make a statement because her words do it. Quill in hand or within reach always. "
            "The posture of a playwright: watching the scene from the wings even when seated "
            "in the center of it."
        ),
        "personality": "Observational, politically precise, satirically sharp, keeps the movement honest, resistant to propaganda from her own side, long memory for hypocrisy",
        "hook": "Her pen is a scalpel. The revolution is her patient. She is not optimistic about the prognosis but keeps working.",
        "relationships": "Abigail Adams: close intellectual partnership; Patrick Henry: respects his fire, documents his contradictions; Thomas Paine: admires his clarity",
        "loyalty_base": 7,
        "status": "DESIGNED",
    },
    {
        "name": "Daniel Shays",
        "position": "FARMER",
        "faction": "Populist",
        "ethnicity": "Anglo-Yankee (Massachusetts)",
        "physical": (
            "Broad-shouldered, weathered. Early 40s but looks 50 — winters, debt, marching. "
            "Continental Army jacket, worn through at the elbows, buttons mismatched where "
            "they've been replaced. Calloused hands. Sun-cracked face with a jaw that's been "
            "set since 1786. Doesn't carry a sword. Carries an axe. The kind of man who "
            "looks exactly like what he is: someone who did everything asked of him and then "
            "found out what it cost."
        ),
        "personality": "Grievance-driven, stubborn, practical anger, distrustful of institutions that have failed him, loyalty earned not given, protective of his people, prone to direct action over deliberation",
        "hook": "He fought for a republic that immediately started taxing him into the ground. He is not impressed by speeches.",
        "relationships": "Thomas Paine: Paine understands him theoretically; Paine has never lost a farm",
        "loyalty_base": 1,
        "status": "DESIGNED",
    },
    {
        "name": "Benjamin Tallmadge",
        "position": "SPYMASTER",
        "faction": "Patriot",
        "ethnicity": "Anglo-Connecticut",
        "physical": (
            "Neat. Precisely neat — the kind of neat that is itself a form of information "
            "control. Mid-30s, trim build, unremarkable in every deliberate way. Brown eyes "
            "that stay still while they assess. Dark coat, clean, no insignia. Hair queued "
            "back — nothing loose. Ink on the inside of his left wrist, below the cuff, "
            "where only he can see it. The face of someone you forgot you met."
        ),
        "personality": "Methodical, deeply loyal, trusts process over instinct, catalogues everything, deeply suspicious of everyone (including himself), calm under duress, keeps ledgers",
        "hook": "The Culper Ring never stopped running. It merely changed names. He is the only one who knows how many names.",
        "relationships": "Ualani Carlisle: serves her completely; Abigail Adams: overlapping intelligence networks; Lord Cornwallis: professional respect across enemy lines",
        "loyalty_base": 9,
        "status": "DESIGNED",
    },
    {
        "name": "Phillis Wheatley",
        "position": "HERALD",
        "faction": "Abolitionist League",
        "ethnicity": "African (Senegalese-born, Boston-raised)",
        "physical": (
            "Small, slight frame with entirely disproportionate presence. Late 20s. "
            "Dark brown skin, large expressive eyes, the careful posture of someone who has "
            "spent a lifetime being watched and learned to use it. Simple but dignified dress — "
            "quality cloth, no excess. Usually holds a quill or has one tucked behind her ear. "
            "The face of someone who has been told, repeatedly, that she cannot do what she "
            "is currently doing."
        ),
        "personality": "Incisive, formally precise, strategically patient, uses language as a weapon, aware of her symbolic weight, refuses to let the revolution forget its contradictions, dignified fury",
        "hook": "She met Washington and wrote him a poem and the poem was better than the war. Crown officers are now confiscating her work. That's how you know it's working.",
        "relationships": "Abigail Adams: mutual regard, different leverage; Francis Asbury: unexpected ideological kinship; Ualani Carlisle: the president reads her work",
        "loyalty_base": 6,
        "status": "DESIGNED",
    },
    {
        "name": "Francis Asbury",
        "position": "CIRCUIT PREACHER",
        "faction": "Common Cause",
        "ethnicity": "Anglo (English immigrant)",
        "physical": (
            "Lean from 300,000 miles of horseback. Mid-50s, permanently wind-burned, "
            "permanently in motion. Simple black Methodist coat, worn smooth at the elbows. "
            "Practical boots. White hair, not powdered — just white. Sharp eyes with "
            "the slightly alarming focus of a man who has decided God wants him specifically "
            "to cover a great deal of ground. His horse looks exhausted. He does not."
        ),
        "personality": "Tireless, democratic, anti-slavery, impossible to stop, converts by sheer relentless presence, more interested in frontier farms than city pulpits, disarming to enemies",
        "hook": "Crown forces tried to arrest him twice. He preached at both arresting officers. One converted.",
        "relationships": "Phillis Wheatley: shared abolition ground; Daniel Shays: knows every farmstead Shays came from; Marc Penoit: has ridden through Habitant territory",
        "loyalty_base": 5,
        "status": "DESIGNED",
    },
]

CANADIAN_CHARACTERS = [
    {
        "name": "Jessica Commanda Odjick",
        "position": "PRIME MINISTER",
        "faction": "Algonquin Nation",
        "ethnicity": "Algonquin (Kitigan Zibi Anishinàbeg)",
        "physical": (
            "Tall for the room she usually walks into. Late 30s. High cheekbones, sharp jaw, "
            "steady dark eyes that don't blink first in any conversation. Long black hair worn "
            "loose or in a single braid threaded with indigo ribbon — the braid appears in "
            "formal settings, the loose hair in the field. Wears a diplomat's dark overcoat "
            "over traditional Algonquin ribbon-work shirt, the beadwork visible at the collar "
            "and cuffs — a deliberate choice. Not a concession to either world; a statement "
            "that she moves through both on her own terms. Carries nothing decorative. "
            "Everything she wears does something."
        ),
        "personality": "Uncompromising, multilingual, historically precise, reads power structures immediately, refused to ask permission before the Governor's Council did, patient with complexity, direct with dishonesty",
        "hook": "The Governor's Council objected to her presence at the table. The Governor's Council is no longer at the table.",
        "relationships": "Marc Penoit: weekly disagreements, zero desertions — that's trust; Ualani Carlisle: two leaders learning each other's language; Governor Carleton: she has his measure, he has not yet taken hers",
        "loyalty_base": 20,
        "status": "DESIGNED",
    },
    {
        "name": "Marc Penoit",
        "position": "DEPUTY GOVERNOR",
        "faction": "French Habitants",
        "ethnicity": "Québécois (French-Canadian)",
        "physical": (
            "Broad-shouldered, built like someone who spent two winters at a siege. Early 40s. "
            "Salt-and-pepper hair worn short and practical. A trimmed dark beard going grey "
            "at the jaw. Weathered face: not from weather, from everything else. Wears a "
            "worn militia coat — French Habitant cut, brass buttons, several replaced — "
            "over a plain wool shirt. The coat has been repaired in four places he can count "
            "and at least two he hasn't found yet. The face of a man who disagrees with the "
            "alliance about once a week and never disagrees enough to leave."
        ),
        "personality": "Pragmatic, militarily precise, protective of his people, frank to the point of bluntness, loyal to Clear-Water's vision if not always her methods, watches the flanks — literal and political",
        "hook": "Spent two winters at the siege of Saint-Georges before anyone knew his name. He doesn't need recognition. He needs the eastern flank watched.",
        "relationships": "Jessica Commanda Odjick: deep trust expressed through productive friction; Ualani Carlisle: allied commander, mutual respect; Governor Carleton: fought him for years, reads him well",
        "loyalty_base": 15,
        "status": "DESIGNED",
    },
    {
        "name": "Governor Guy Carleton",
        "position": "GOVERNOR-GENERAL",
        "faction": "Crown (British)",
        "ethnicity": "Anglo-Irish (British colonial)",
        "physical": (
            "Formal, trim, everything in its place. Late 50s. Powdered wig or short-queued "
            "grey hair depending on context — wig for official functions, hair for field. "
            "Governor's formal coat: red and gold, medals in correct order of precedence. "
            "Sharp light eyes, a thin mouth that is usually slightly disapproving. The "
            "posture of someone who has administered large territories and found the "
            "colonies moderately more difficult than expected. Holds his hands behind "
            "his back when thinking. When he stops doing that, something has gone wrong."
        ),
        "personality": "Administrative rather than military, prefers negotiation to force, privately more pragmatic than his mandate, reads colonial sentiment accurately (and ignores it), underestimates Jessica Commanda Odjick",
        "hook": "He is not a bad administrator. He is administering the wrong empire at the wrong time.",
        "relationships": "Jessica Commanda Odjick: has not yet taken her full measure; Marc Penoit: underestimates his staying power; Abigail Adams: she has taken his measure completely",
        "loyalty_base": None,
        "status": "DESIGNED",
    },
]

NPC_CHARACTERS = [
    {
        "name": "Lord Cornwallis",
        "position": "BRITISH GENERAL",
        "faction": "Crown (British)",
        "ethnicity": "Anglo (British aristocracy)",
        "physical": (
            "Tall, imposing, the full weight of British military tradition in every line. "
            "Mid-40s. Formal scarlet officer's coat with gold epaulettes, the rank "
            "unmistakable from distance. Hawkish features, one eye slightly affected from "
            "a field injury — gives him an unsettlingly focused expression. Clean-shaved, "
            "powdered wig in formal portraits, queued hair in the field. Carries a sword "
            "he knows how to use. The face of a man who has never considered that he might "
            "be on the wrong side of history because the concept had not yet reached him."
        ),
        "personality": "Professionally ruthless, loyal to crown over conscience, genuine military talent, capable of magnanimity in victory, poor at reading asymmetric warfare",
        "hook": "He won Yorktown in this timeline. It didn't help.",
        "relationships": "General Howe: superior officer, occasional friction; Benjamin Tallmadge: professional nemesis",
        "loyalty_base": None,
        "status": "PARTIAL",
    },
    {
        "name": "General Howe",
        "position": "BRITISH COMMANDER",
        "faction": "Crown (British)",
        "ethnicity": "Anglo (British military)",
        "physical": (
            "Heavy build, solid, the physique of a man who campaigns hard and lives well "
            "between campaigns. Mid-50s. Full dress uniform, red and gold. Square face, "
            "confident bearing. Less precise than Cornwallis, more political. "
            "The face of a general who knows how to win battles and is less interested "
            "in the question of whether to fight them."
        ),
        "personality": "Cautious in execution, politically aware, respects formality, occasionally overcautious to the point of strategic failure, convivial away from battle",
        "hook": "Commanded the British forces at a critical juncture. His caution cost them the initiative.",
        "relationships": "Lord Cornwallis: subordinate with his own opinions; Crown command: navigates carefully",
        "loyalty_base": None,
        "status": "PARTIAL",
    },
    {
        "name": "Calico Jack",
        "position": "PIRATE CAPTAIN",
        "faction": "Bahama Free Ports",
        "ethnicity": "Anglo-Caribbean",
        "physical": (
            "The coat is the first thing you see: a long patchwork of calico cloth, "
            "browns and reds and faded blues, sewn from a dozen different sources over "
            "a decade. Mid-30s. Sea-tanned brown skin, a working beard he trims when "
            "he remembers. A single gold earring, left ear. Sharp green eyes and the "
            "slightly amused expression of someone who is always calculating exit routes. "
            "Tricorn hat, battered. Cutlass on the left hip. The kind of man who looks "
            "exactly as dangerous as he is and has decided there's no reason to hide it."
        ),
        "personality": "Opportunist, charismatic, genuinely good at sea warfare, treats his crew fairly by pirate standards, philosophically flexible about law, knows exactly what he is and is comfortable with it",
        "hook": "The Bahamas don't answer to London. Calico Jack is why.",
        "relationships": "Anne Bonny: professional partnership, personal history; Ualani Carlisle: has heard of each other, not yet met",
        "loyalty_base": None,
        "status": "DESIGNED",
    },
    {
        "name": "Anne Bonny",
        "position": "PIRATE FIRST MATE",
        "faction": "Bahama Free Ports",
        "ethnicity": "Anglo-Irish (Caribbean-raised)",
        "physical": (
            "Red-brown hair, salt-stiff, usually tied back with a strip of sail cloth. "
            "Late 20s. Compact, fast, built for deck fighting — not tall but "
            "absolutely present. Sun-burnt nose, freckles, a scar along the left jaw "
            "she got in Nassau and doesn't explain. Sailor's clothing, practical: "
            "loose shirt, breeches, boots. Carries two pistols and is significantly "
            "better with a cutlass. The expression of someone who has made peace with "
            "every decision she has ever made and is prepared to make more of them."
        ),
        "personality": "Direct, impatient with formality, tactically sharp, loyal to chosen crew over all abstractions, fiercely independent, reads people accurately and quickly, dislikes both sides of the war equally",
        "hook": "She left Ireland, then the colonies, then polite society. She stopped at the ocean because there was nowhere left to leave.",
        "relationships": "Calico Jack: complicated, functional, effective; Patricia Eubanks: unlikely alliance of convenience",
        "loyalty_base": None,
        "status": "DESIGNED",
    },
    {
        "name": "Joseph Brant (Thayendanegea)",
        "position": "MOHAWK WAR CHIEF",
        "faction": "Haudenosaunee Confederacy",
        "ethnicity": "Mohawk (Haudenosaunee)",
        "physical": (
            "Striking and deliberate in presentation. Mid-30s. Tall, athletic, "
            "the commanding bearing of a war chief. Long dark hair. Wears a "
            "distinctive combination: British officer's coat (earned, not appropriated) "
            "over Mohawk regalia — gorget, beadwork, clan markings. Both elements "
            "are complete, neither is costume. Face paint in formal contexts. "
            "The appearance of someone navigating two worlds with full knowledge "
            "of what each one costs."
        ),
        "personality": "Strategically sophisticated, bilingual (Mohawk and English), deeply political, prioritizes Haudenosaunee sovereignty over alliance with either side, has been betrayed by British promises before and remembers",
        "hook": "He fights for his people. Everyone else's war is a tool toward that end.",
        "relationships": "Jessica Commanda Odjick: respect across tribal lines, different nations different strategies; Governor Carleton: wary alliance; Lord Cornwallis: uses each other",
        "loyalty_base": None,
        "status": "DESIGNED",
    },
    {
        "name": "Patricia Eubanks",
        "position": "AGENT / UNKNOWN",
        "faction": "Unknown",
        "ethnicity": "Unknown",
        "physical": (
            "Deliberately unremarkable in public — plain dress, hair covered, "
            "nothing that catches the eye. When she wants to be noticed, "
            "she chooses the moment carefully. Eyes that stay still while "
            "assessing. Probably mid-30s. "
            "[DESIGN NOTE: Physical description intentionally incomplete — "
            "her appearance should remain ambiguous until her event arc resolves.]"
        ),
        "personality": "Operationally careful, motives unclear, appears in unexpected contexts, may be working for multiple parties simultaneously",
        "hook": "She appears in event data. Nobody is entirely sure on whose behalf.",
        "relationships": "Anne Bonny: crosses paths in the Bahamas; Benjamin Tallmadge: has noticed her",
        "loyalty_base": None,
        "status": "STUB",
    },
]

# ── ART DIRECTION NOTES ───────────────────────────────────────────────────────
DESIGN_NOTES = [
    ("UNIVERSAL RULES", "Color temperature", "Each faction has a dominant palette: Federal = deep blue/gold; Patriot = navy/cream; Crown = scarlet/gold; Algonquin Nation = forest green/indigo/copper; French Habitants = grey-blue/brown; Bahama Free Ports = sun-bleached warm tones."),
    ("UNIVERSAL RULES", "Era consistency", "Clothing is 1770s-1790s American/British/Canadian colonial, but the game's alt-history allows for slight anachronisms in vocabulary and attitude — not in silhouette. No modern cuts."),
    ("UNIVERSAL RULES", "No placeholder art rule", "Every named character should eventually have a bespoke portrait. The current placeholder (4-22-Ikra-Colors) is identical for all characters — this is known and tracked here."),
    ("UNIVERSAL RULES", "Gold earrings = Ualani", "Gold hoop earrings appear on Ualani Carlisle in ALL contexts: card art, event scenes, portraits. They are a visual signature. No other character wears gold hoop earrings."),
    ("UALANI CARLISLE", "Hair", "Belly-length straight black hair. In field/combat scenes: single thick braid. In diplomatic/presidential scenes: loose OR braided — artist's choice but must reach belly minimum."),
    ("UALANI CARLISLE", "Uniform color", "Deep blue with gold braid. NOT the British scarlet. The blue is deliberate — republic colors."),
    ("JESSICA COMMANDA ODJICK", "Signature element", "Indigo ribbon threaded through braid in formal settings. Algonquin ribbon-work (geometric floral, multi-color) visible at collar and cuffs. These two elements appear in every portrait."),
    ("JESSICA COMMANDA ODJICK", "Clothing philosophy", "Neither full Western diplomatic dress nor full traditional regalia — always both simultaneously. The combination is intentional and should read as authority, not as compromise."),
    ("MARC PENOIT", "Signature element", "The repaired militia coat. Four visible repairs minimum. Should look functional and worn, not derelict."),
    ("MARC PENOIT", "Hair/beard", "Short salt-and-pepper hair, trimmed dark beard going grey at jaw. Practical. No wig."),
    ("CALICO JACK", "Signature element", "The calico coat — patchwork of browns, reds, faded blues. It is the character's most recognizable feature. Should appear in all depictions."),
    ("ANNE BONNY", "Signature element", "Red-brown hair tied with sail cloth. Left jaw scar. Two pistols visible on her person."),
    ("JOSEPH BRANT", "Clothing", "British officer's coat + Mohawk regalia simultaneously. Both elements are complete and intentional. Not costume; not appropriation. Historical accuracy is important here — Brant was a real historical figure who navigated exactly this presentation."),
    ("BENJAMIN TALLMADGE", "Presence", "He is the most deliberately unremarkable-looking person in any scene he is in. This is intentional. His portrait should feel like you almost didn't notice him."),
    ("PHILLIS WHEATLEY", "Signature element", "Quill in hand or tucked behind ear in every depiction. The quill is the weapon."),
]

# ── BUILD FUNCTIONS ────────────────────────────────────────────────────────────

def _build_overview(wb, usa, canadian, npc):
    ws = wb.create_sheet("OVERVIEW")
    ws.sheet_view.showGridLines = False

    # Title
    ws.merge_cells("A1:H1")
    _hdr(ws, 1, 1, "CHARACTER MASTERDOC — FARSWORD DESIGN BIBLE", HDR_BG, HDR_FG, bold=True, size=13)

    # Stats block
    stats = [
        ("Total Named Characters", len(usa) + len(canadian) + len(npc)),
        ("USA / Playable Governors", len(usa)),
        ("Canadian Governors / Leaders", len(canadian)),
        ("NPC / Event Characters", len(npc)),
        ("", ""),
        ("Design Complete (FINAL)", sum(1 for c in usa+canadian+npc if c["status"] == "FINAL")),
        ("Described (DESIGNED)", sum(1 for c in usa+canadian+npc if c["status"] == "DESIGNED")),
        ("Partial (PARTIAL)", sum(1 for c in usa+canadian+npc if c["status"] == "PARTIAL")),
        ("Stub Only (STUB)", sum(1 for c in usa+canadian+npc if c["status"] == "STUB")),
    ]
    row = 3
    _hdr(ws, row, 1, "METRIC", HDR_BG, HDR_FG)
    _hdr(ws, row, 2, "COUNT", HDR_BG, HDR_FG)
    row += 1
    alt = False
    for label, val in stats:
        bg = ALT_BG if alt else WHITE
        _cell(ws, row, 1, label, bg=bg, bold=bool(label))
        _cell(ws, row, 2, val if val != "" else "", bg=bg, align="center")
        if label:
            alt = not alt
        row += 1

    # Character quick-list
    row += 1
    _hdr(ws, row, 1, "NAME", USA_BG, USA_FG)
    _hdr(ws, row, 2, "POSITION", USA_BG, USA_FG)
    _hdr(ws, row, 3, "FACTION", USA_BG, USA_FG)
    _hdr(ws, row, 4, "COUNTRY", USA_BG, USA_FG)
    _hdr(ws, row, 5, "STATUS", USA_BG, USA_FG)
    row += 1

    groups = [("USA", usa, "D6E4F7"), ("CANADA", canadian, "FCE0D6"), ("NPC", npc, "EEF2F7")]
    for group_name, chars, bg in groups:
        for i, c in enumerate(chars):
            row_bg = bg if i % 2 == 0 else WHITE
            _cell(ws, row, 1, c["name"], bg=row_bg, bold=True)
            _cell(ws, row, 2, c["position"], bg=row_bg)
            _cell(ws, row, 3, c["faction"], bg=row_bg)
            _cell(ws, row, 4, group_name, bg=row_bg)
            _status_cell(ws, row, 5, c["status"])
            row += 1

    _set_col_widths(ws, [30, 28, 25, 12, 12])
    _freeze(ws, "A2")


def _build_character_sheet(wb, sheet_name, characters, hdr_bg, hdr_fg):
    ws = wb.create_sheet(sheet_name)
    ws.sheet_view.showGridLines = False

    cols = [
        "NAME", "POSITION", "FACTION", "ETHNICITY / BACKGROUND",
        "PHYSICAL DESCRIPTION (ART BIBLE)",
        "PERSONALITY TRAITS",
        "NARRATIVE HOOK",
        "RELATIONSHIPS",
        "LOYALTY BASE",
        "STATUS",
    ]
    widths = [22, 22, 22, 24, 60, 45, 45, 45, 12, 10]

    for col, label in enumerate(cols, 1):
        _hdr(ws, 1, col, label, hdr_bg, hdr_fg)

    for i, c in enumerate(characters):
        row = i + 2
        bg = ALT_BG if i % 2 == 0 else WHITE
        _cell(ws, row, 1, c["name"], bg=bg, bold=True)
        _cell(ws, row, 2, c["position"], bg=bg)
        _cell(ws, row, 3, c["faction"], bg=bg)
        _cell(ws, row, 4, c["ethnicity"], bg=bg)
        _cell(ws, row, 5, c["physical"], bg=bg)
        _cell(ws, row, 6, c["personality"], bg=bg)
        _cell(ws, row, 7, c["hook"], bg=bg)
        _cell(ws, row, 8, c["relationships"], bg=bg)
        lb = c["loyalty_base"]
        _cell(ws, row, 9, str(lb) if lb is not None else "N/A", bg=bg, align="center")
        _status_cell(ws, row, 10, c["status"])
        ws.row_dimensions[row].height = 120

    _set_col_widths(ws, widths)
    _freeze(ws, "A2")


def _build_design_notes(wb, notes):
    ws = wb.create_sheet("DESIGN NOTES")
    ws.sheet_view.showGridLines = False

    _hdr(ws, 1, 1, "CHARACTER", HDR_BG, HDR_FG)
    _hdr(ws, 1, 2, "ELEMENT", HDR_BG, HDR_FG)
    _hdr(ws, 1, 3, "NOTE", HDR_BG, HDR_FG)

    char_colors = {
        "UNIVERSAL RULES": "1F2D3D",
        "UALANI CARLISLE": "1F3864",
        "JESSICA COMMANDA ODJICK": "2D6A4F",
        "MARC PENOIT": "5C4033",
        "CALICO JACK": "7A5C00",
        "ANNE BONNY": "7A1A1A",
        "JOSEPH BRANT": "4A3060",
        "BENJAMIN TALLMADGE": "2E4057",
        "PHILLIS WHEATLEY": "1A5C3A",
    }

    last_char = None
    for i, (character, element, note) in enumerate(notes):
        row = i + 2
        bg = ALT_BG if i % 2 == 0 else WHITE
        char_bg = char_colors.get(character, HDR_BG)
        if character != last_char:
            _hdr(ws, row, 1, character, char_bg, "FFFFFF", bold=True)
            last_char = character
        else:
            _cell(ws, row, 1, "", bg=bg)
        _cell(ws, row, 2, element, bg=bg, bold=True)
        _cell(ws, row, 3, note, bg=bg)

    _set_col_widths(ws, [28, 28, 80])
    _freeze(ws, "A2")


# ── MAIN ──────────────────────────────────────────────────────────────────────
def main():
    wb = openpyxl.Workbook()
    wb.remove(wb.active)

    _build_overview(wb, USA_CHARACTERS, CANADIAN_CHARACTERS, NPC_CHARACTERS)
    _build_character_sheet(wb, "PLAYABLE (USA)", USA_CHARACTERS, USA_BG, USA_FG)
    _build_character_sheet(wb, "CANADIAN", CANADIAN_CHARACTERS, CA_BG, CA_FG)
    _build_character_sheet(wb, "NPC", NPC_CHARACTERS, NPC_BG, NPC_FG)
    _build_design_notes(wb, DESIGN_NOTES)

    wb.save(OUT_PATH)
    total = len(USA_CHARACTERS) + len(CANADIAN_CHARACTERS) + len(NPC_CHARACTERS)
    designed = sum(1 for c in USA_CHARACTERS + CANADIAN_CHARACTERS + NPC_CHARACTERS if c["status"] in ("DESIGNED", "FINAL"))
    print(f"Wrote {OUT_PATH}")
    print(f"  {total} total characters: {len(USA_CHARACTERS)} USA, {len(CANADIAN_CHARACTERS)} Canadian, {len(NPC_CHARACTERS)} NPC")
    print(f"  {designed}/{total} fully described  |  {total-designed} partial/stub")


if __name__ == "__main__":
    main()
