"""
Appends 50 commander arc events, ~75 buttons, and 50+2 trigger rows for ARC_01–25.
Also updates TRIG_016/017 to point to ARC_01_FIRST / ARC_01_DONE.
Run from repo root: python3 scripts/gen_commander_arcs.py
"""

import csv, re, os, io

# ── ARCHETYPE DEFINITIONS ────────────────────────────────────────────────────
# (arc_id, name, first_headline, first_short, first_long, first_tone,
#           done_headline,  done_short,  done_long,  done_tone,
#           done_btn2_resource, done_btn2_amount)

ARCS = [
    ("ARC_01","Wetlands Fisher",
     "[COMMANDER_NAME] REPORTS IN FROM THE WETLANDS — FIRST GROUND HELD",
     "The Marsh Has Been Cleared. [COMMANDER_NAME] Sends Word.",
     "The dispatch arrived wet. [COMMANDER_NAME] does not write long field reports — the note says: we have the wetlands, the Crown does not, and the herons seem fine. A Wetlands Fisher does not require validation from headquarters but headquarters is providing it anyway.",
     "Terse/Determined",
     "[COMMANDER_NAME] HAS EARNED THE SWAMP — THE WETLANDS ARE OURS",
     "The Fisher Has Proven Their Arc. The Wetlands Remember.",
     "Three objectives. Achieved without drama — which is the Wetlands Fisher's particular talent. [COMMANDER_NAME] sent a final dispatch from the water's edge: the ground holds. The fish are good. The Redcoats did not understand wetlands. We do.",
     "Quiet/Triumphant",
     "food", 20),

    ("ARC_02","Appalachian Miner",
     "[COMMANDER_NAME] BREAKS THROUGH IN THE FOOTHILLS — FIRST GROUND TAKEN",
     "The Miner Found Their Hill. [COMMANDER_NAME] Sends the Report.",
     "The first foothills tile is secured. [COMMANDER_NAME]'s field note was four sentences and a diagram of the defensive position. Engineers communicate in structures. The structure is sound.",
     "Gruff/Determined",
     "[COMMANDER_NAME] HAS CARVED THE MOUNTAIN — THE FOOTHILLS ARC COMPLETE",
     "Built It. Cleared It. Held It.",
     "An Appalachian Miner does not celebrate — they assess, and [COMMANDER_NAME]'s assessment is: the ground is developed, the corruption is cleared, and the home tile is fortified to standard. The arc is complete. The mountains are ours.",
     "Terse/Satisfied",
     "metal", 20),

    ("ARC_03","Ivy League Dropout",
     "[COMMANDER_NAME] DISPATCHES FROM THE CITY — FIRST URBAN GROUND SECURED",
     "The Scholar Has Discovered That Theory Meets Practice at [TILE_NAME].",
     "The dispatch was three pages. [COMMANDER_NAME] has liberated a Metro tile and taken fifteen hundred words to explain exactly why this was historically inevitable and what it means for the broader strategic picture. President Carlisle read page one. Page one was good.",
     "Verbose/Self-Aware",
     "[COMMANDER_NAME]'S URBAN ARC COMPLETE — THE SCHOLAR CLOSES THE BOOK",
     "Ten Turns Survived. Two Hundred Gold. One Metro. The Curriculum Is Complete.",
     "The final dispatch was characteristically long and characteristically correct. [COMMANDER_NAME] has survived the full engagement, built the treasury, and proven that an Ivy League dropout with a usable theory and the sense to adapt it is worth twice a graduate who cannot. The arc is closed.",
     "Wry/Satisfied",
     "gold", 25),

    ("ARC_04","Seminole Fighter",
     "[COMMANDER_NAME] HOLDS THE WETLANDS — THE FIGHTER HAS FOUND THEIR GROUND",
     "[COMMANDER_NAME] Did Not Send a Long Report. The Ground Speaks for Itself.",
     "The Seminole Fighter does not explain what they do — they do it. A wetlands tile was liberated. [COMMANDER_NAME] is stationed there. The Crown has not retaken it. The eight-turn hold is in progress.",
     "Terse/Martial",
     "[COMMANDER_NAME] HAS HELD THE SWAMP — THE SEMINOLE FIGHTER'S ARC IS COMPLETE",
     "Eight Turns. The Wetlands Still Ours.",
     "Three objectives met without ceremony. [COMMANDER_NAME] filed a single field note at the completion of the third: done. The Wetlands are ours. I am staying. The Republic does not need to tell the Seminole Fighter how to hold ground. They already knew.",
     "Spare/Triumphant",
     "manpower", 15),

    ("ARC_05","Green Mountain Farmer",
     "[COMMANDER_NAME] SECURES THE FARMLANDS — THE FARMER FINDS THEIR FIELD",
     "Good Ground Taken. [COMMANDER_NAME] Puts Down Roots.",
     "A farmlands tile is secured and [COMMANDER_NAME] has already started thinking about what grows there. The Green Mountain Farmer does not clearly distinguish between liberation and cultivation — both require patience, good soil, and the willingness to be there in the morning. The dispatch was brief: we have it. The land is good.",
     "Warm/Grounded",
     "[COMMANDER_NAME]'S HARVEST IS COMPLETE — THE GREEN MOUNTAIN ARC CLOSES",
     "Farm Built. Food Stockpiled. The Land Knows Who It Belongs To.",
     "Three objectives in the order a farmer would have listed them. [COMMANDER_NAME]'s final note said: the farm is built, the stores are full, and Vermont knows which side of this war feeds people. The arc is complete. The harvest is in.",
     "Warm/Triumphant",
     "food", 30),

    ("ARC_06","Chesapeake Shipwright",
     "[COMMANDER_NAME] SECURES A PORT — THE SHIPWRIGHT FINDS THEIR HARBOR",
     "Dock Taken. [COMMANDER_NAME] Reports the Water Is Deep Enough.",
     "A dock tile is secured and [COMMANDER_NAME] immediately sent measurements. A Chesapeake Shipwright does not simply liberate a port — they assess it. Draft depth: adequate. Berth capacity: expandable. Strategic value: obvious. Construction begins on schedule.",
     "Methodical/Precise",
     "[COMMANDER_NAME]'S SHIPYARD ARC IS COMPLETE — THE HARBOR IS OURS",
     "Dock Held. Home Tile Built. Coastal Position Confirmed.",
     "Three objectives met with the systematic precision of someone who builds ships and therefore understands that every component must be right in sequence. [COMMANDER_NAME]'s final dispatch included a draft budget for expanded dock facilities that was not requested. It was also excellent.",
     "Satisfied/Methodical",
     "wood", 20),

    ("ARC_07","Loyalist Turncoat",
     "[COMMANDER_NAME] PROVES LOYALTY — FIVE TURNS SURVIVED, DOUBTS QUIETED",
     "They Stayed. That Is the First Evidence.",
     "Five turns is not long. Five turns as a former Loyalist serving the Continental Army while the Army debates whether to trust you is a different matter. [COMMANDER_NAME] stayed, fought, and filed reports that proved useful. The doubts in the officers' mess have not disappeared but they have quieted. This is progress.",
     "Cautious/Earnest",
     "[COMMANDER_NAME]'S REDEMPTION ARC IS COMPLETE — THE TURNCOAT HAS TURNED",
     "Loyalty Proven. City Liberated. Crown Influence Cleared.",
     "The word 'turncoat' has a complicated meaning for [COMMANDER_NAME] now. They turned away from the Crown. They turned toward something. Three objectives complete: survived, liberated, cleaned up the corruption they once facilitated. The arc closes. The title does not fit anymore.",
     "Quiet/Resolved",
     "gold", 15),

    ("ARC_08","Tobacco Belt Drifter",
     "[COMMANDER_NAME] TAKES THE FARMLANDS — THE DRIFTER FOUND A REASON TO STAY",
     "[COMMANDER_NAME] Stopped Moving Long Enough to Liberate Something.",
     "A Tobacco Belt Drifter does not usually hold ground — they move through it. [COMMANDER_NAME] liberated a farmlands tile and, unexpectedly, did not leave. The field report was two words: got it. Hold count is at four turns and climbing.",
     "Laconic/Surprised",
     "[COMMANDER_NAME]'S DRIFTER ARC IS COMPLETE — THE ROAD ENDS HERE",
     "Farmlands Held. Six Turns. Morale Restored. The Drifter Stopped Drifting.",
     "Something about the farmlands made the Drifter stop drifting. [COMMANDER_NAME] held the tile, held it some more, and quietly brought the morale decay down to something livable. No ceremony was requested. None will be given. The work speaks for itself, which is how [COMMANDER_NAME] always preferred it.",
     "Quiet/Satisfied",
     "food", 15),

    ("ARC_09","War Widow",
     "[COMMANDER_NAME] DISPATCHES FROM THE METRO — A CITY TILE FOR THE WIDOW",
     "[COMMANDER_NAME] Took the City. It Was Personal.",
     "A War Widow understands the weight of a liberated city differently than most. [COMMANDER_NAME]'s dispatch was one sentence: the city is ours, and I am still here. The eight-turn survival clock is running. The city does not know it is being held by someone who has already lost more than it can offer.",
     "Tense/Determined",
     "[COMMANDER_NAME]'S ARC IS COMPLETE — THE WIDOW HAS BUILT SOMETHING THAT STAYS",
     "Metro Taken. Eight Turns Survived. City Held Five More.",
     "Three objectives completed over a long campaign that asked for patience, endurance, and the particular stubbornness of someone with nothing to prove and everything to honor. [COMMANDER_NAME]'s final dispatch said nothing about the personal cost. It said: the city stands. So do I.",
     "Somber/Triumphant",
     "gold", 20),

    ("ARC_10","Indigenous Scout",
     "[COMMANDER_NAME] TAKES THE WOODS — THE SCOUT MOVES WHERE THE CROWN CANNOT FOLLOW",
     "A Woods Tile Is Secured. [COMMANDER_NAME] Was Already There.",
     "The Crown forces did not know [COMMANDER_NAME] had been in those woods for three days before the engagement. An Indigenous Scout does not announce their presence — they establish it quietly and then it is done. The woods are ours. They were always ours.",
     "Quiet/Knowing",
     "[COMMANDER_NAME]'S FOREST ARC IS COMPLETE — THE WOODS HOLD THEIR OWN",
     "Woods Liberated. Held. Commander Present. The Forest Remembers.",
     "Three objectives met with a precision that required no explanation. [COMMANDER_NAME]'s final dispatch was a single note: the trees know us now. The Crown cannot hold forests they cannot find their way through. The arc is complete and the woods will not forget.",
     "Spare/Triumphant",
     "wood", 15),

    ("ARC_11","Boston Rabble-Rouser",
     "[COMMANDER_NAME] TAKES THE CITY — THE RABBLE-ROUSER HAS FOUND THEIR STAGE",
     "[COMMANDER_NAME] Liberated a Metro Tile and Immediately Gave a Speech About It.",
     "The liberation of the Metro tile was operationally competent. The speech that followed it was, by every report, extraordinary. [COMMANDER_NAME] has a talent for making large groups of people feel that history is happening right now and they are the right people to be making it. They are correct.",
     "Loud/Principled",
     "[COMMANDER_NAME]'S RALLY ARC IS COMPLETE — THE CITY IS LOUD AND FREE",
     "Metro Taken. Culture at 100. The Morale Decay Is Gone. The Rabble-Rouser Has Roused.",
     "Three objectives and three speeches — one for each. [COMMANDER_NAME] turned a city tile, a culture surplus, and a suppressed home district into something the Republic can be proud of. The final dispatch was, predictably, also a speech. It was a good speech.",
     "Rousing/Satisfied",
     "culture", 25),

    ("ARC_12","Continental Surgeon",
     "[COMMANDER_NAME] CLEARS THE INFECTION — HOME TILE CORRUPTION BELOW 20",
     "The Surgeon Has Diagnosed the Problem and Is Treating It.",
     "A Continental Surgeon operates on whatever is in front of them. [COMMANDER_NAME] looked at the home tile, identified the corruption as a wound, and began the standard treatment: document it, isolate it, reduce it. Corruption below 20. The patient is improving. More work required.",
     "Clinical/Steady",
     "[COMMANDER_NAME]'S FIELD HOSPITAL ARC IS COMPLETE — THE REPUBLIC IS HEALTHIER",
     "Corruption Cleared. Food Built. Home Tile Expanded. The Surgeon Is Satisfied.",
     "A surgeon does not declare victory — they declare stability, and stability is what [COMMANDER_NAME] has delivered. Three objectives: the home tile is clean, the nation's food supply is adequate, and the facilities are expanded. The arc closes on a patient that is no longer critical.",
     "Clinical/Relieved",
     "food", 25),

    ("ARC_13","Nantucket Sailor",
     "[COMMANDER_NAME] TAKES A PORT — THE SAILOR HAS WATER UNDER THEIR FEET AGAIN",
     "Dock Secured. [COMMANDER_NAME] Has Opinions About Its Condition.",
     "The dock was secured and [COMMANDER_NAME] immediately filed a list of structural complaints that were not requested but were entirely accurate. A Nantucket Sailor cannot look at a dock without assessing it. This one needs work. The important thing is we have it now.",
     "Salty/Direct",
     "[COMMANDER_NAME]'S COASTAL ARC IS COMPLETE — THE SEA REMEMBERS ITS OWN",
     "Port Held. Wetlands Five Turns. Coastal Station Confirmed.",
     "Three objectives and [COMMANDER_NAME] completed each one in the order that made nautical sense: take the port, hold the coastline, be present in the water. The final dispatch confirmed position and ended with the Nantucket Sailor's customary sign-off: conditions at sea, manageable.",
     "Salty/Satisfied",
     "gold", 20),

    ("ARC_14","Frontier Preacher",
     "[COMMANDER_NAME] TAKES THE FOREST — THE PREACHER HAS FOUND A CONGREGATION",
     "The Woods Are Liberated. The Preacher Has Delivered the First Sermon of Several.",
     "A Frontier Preacher does not simply liberate a woods tile — they consecrate it. [COMMANDER_NAME]'s field report included a formal prayer for the men and women who took that ground, which was unusual in a military dispatch but entirely appropriate to the person delivering it.",
     "Earnest/Spiritual",
     "[COMMANDER_NAME]'S REVIVAL ARC IS COMPLETE — THE FRONTIER IS RESTORED",
     "Forest Liberated. Morale Decay Cleared. Culture Inspired. The Congregation Is Full.",
     "The Frontier Preacher's arc ends where it should: the woods held, the people's spirits lifted, and the culture of the district renewed. [COMMANDER_NAME] delivered the closing sermon without notes. 'The frontier,' they said, 'belongs to the people who believe in it.' The Republic believed.",
     "Warm/Triumphant",
     "culture", 20),

    ("ARC_15","DC Bureaucrat",
     "[COMMANDER_NAME] CLEARS THE METRO — THE BUREAUCRAT SECURES THE PAPERWORK OF LIBERATION",
     "A Metro Tile Is Liberated. The Filing Has Begun.",
     "A DC Bureaucrat's liberation is documented in triplicate. [COMMANDER_NAME] secured the Metro tile, filed the standard occupation notice, submitted the supply requisition, and initiated the corruption-reduction protocol — all within six hours of the engagement. The forms were correct.",
     "Formal/Systematic",
     "[COMMANDER_NAME]'S ADMINISTRATIVE ARC IS COMPLETE — THE HOME TILE PASSES INSPECTION",
     "Metro Liberated. Home Tile Built Out. Corruption Below 10. All Forms Filed.",
     "Three objectives completed in exact sequence with full documentation. [COMMANDER_NAME]'s final report was forty pages. The summary on page one said: objectives met, home district in compliance, corruption at acceptable levels, construction complete. The bureaucrat closed their file. The file was immaculate.",
     "Dry/Satisfied",
     "gold", 20),

    ("ARC_16","Rust Belt Steelworker",
     "[COMMANDER_NAME] TAKES THE SUBURB — THE STEELWORKER CLAIMS THE INDUSTRIAL DISTRICT",
     "Suburbs Tile Secured. [COMMANDER_NAME] Already Has Construction Plans.",
     "A Rust Belt Steelworker sees every liberation as a construction opportunity. [COMMANDER_NAME] secured the Suburbs tile, assessed the existing infrastructure, and dispatched a materials requisition before the Crown forces were fully cleared. The home tile build-out begins immediately.",
     "Working-Class/Direct",
     "[COMMANDER_NAME]'S INDUSTRIAL ARC IS COMPLETE — THE FORGE IS RUNNING",
     "Suburbs Held. Three Levels Built. Forge Operational. The Belt Is Back.",
     "The Rust Belt Steelworker's arc ends with the sound of something being made. [COMMANDER_NAME] built three levels, got the forge operational, and sent one final note: the machines are running. The Republic has industrial capacity at this position. That was the objective. That is what was built.",
     "Gruff/Satisfied",
     "metal", 25),

    ("ARC_17","Plantation Deserter",
     "[COMMANDER_NAME] TAKES THE FARMLANDS — THE DESERTER HAS CHOSEN WHICH SIDE OF THE PLOW",
     "[COMMANDER_NAME] Left One Plantation to Liberate Another Kind of Land.",
     "A Plantation Deserter understands farmland from a specific and uncommon angle. [COMMANDER_NAME] liberated the farmlands tile with a deliberateness that was noticed in the field reports: this ground, they said afterward, will not be worked for someone else's profit again.",
     "Deliberate/Defiant",
     "[COMMANDER_NAME]'S DESERTION ARC IS COMPLETE — THE FARMLANDS ARE FREE",
     "Land Held. Six Turns. Morale Decay Cleared. The Deserter Has Finished Leaving.",
     "Leaving the plantation was the first act. The second act took fifteen more turns and three objectives. [COMMANDER_NAME] held the land, held it longer, and cleared the morale decay that the old order had left behind. The arc closes. The land belongs to different people now.",
     "Defiant/Resolved",
     "food", 20),

    ("ARC_18","Swamp Witch",
     "[COMMANDER_NAME] CLAIMS THE SWAMP — THE WITCH HAS RETURNED TO THE WATER",
     "A Wetlands Tile Is Secured. [COMMANDER_NAME] Was Probably Already There.",
     "The Department of Mythological Affairs noted, without much surprise, that the wetlands tile [COMMANDER_NAME] liberated had already been flagged as anomalous in three separate intelligence reports. The corruption there was unusually organized. The Swamp Witch, it appears, had personal reasons for the engagement.",
     "Arcane/Knowing",
     "[COMMANDER_NAME]'S MARSH ARC IS COMPLETE — THE SWAMP IS CLEAN AND OURS",
     "Wetlands Secured. Corruption Purged. The Witch Has Settled Their Account.",
     "Three objectives met: the swamp liberated, the corruption cleared to single digits, the commander stationed in the water where they belong. [COMMANDER_NAME]'s final dispatch was not in standard format. It contained an herbal recipe for the garrison and a note that the marsh is now safe. The DMA is treating this as a formal report.",
     "Arcane/Satisfied",
     "magic", 15),

    ("ARC_19","Caribbean Privateer",
     "[COMMANDER_NAME] TAKES THE PORT — THE PRIVATEER HAS FOUND THEIR HARBOR",
     "Dock Secured. Prizes Expected. [COMMANDER_NAME] Sends Coordinates.",
     "A Caribbean Privateer's relationship with the word 'liberate' is creative but not incorrect. [COMMANDER_NAME] secured the dock, assessed its prize-taking potential, and sent a brief note: the port is ours, the gold will follow, the Crown's naval presence in this district has a new and personal enemy.",
     "Charming/Mercenary",
     "[COMMANDER_NAME]'S PRIVATEERING ARC IS COMPLETE — THE HARBOR PAYS FOR ITSELF",
     "Port Held. 150 Gold. Coastal Station Confirmed. The Privateer Has Earned Their Letter of Marque.",
     "Three objectives in the order that makes sense to someone who thinks of war as commerce with cannons: take the port, fill the treasury, hold the coast. [COMMANDER_NAME]'s final dispatch came with a personal invoice for services rendered that was attached to, but legally distinct from, their field report.",
     "Wry/Satisfied",
     "gold", 30),

    ("ARC_20","Hawaiian Refugee",
     "[COMMANDER_NAME] REACHES THE MAINLAND — FIRST TILES SECURED FOR THE REPUBLIC",
     "A Refugee Who Kept Moving Until the Ground Was Worth Stopping For.",
     "A Hawaiian Refugee knows what it costs to be somewhere you were not born and to fight for it anyway. [COMMANDER_NAME] has liberated three tiles — enough to prove the point. The dispatch said: I found a monument. It was still standing. I think that means something.",
     "Earnest/Hopeful",
     "[COMMANDER_NAME]'S HOMELAND ARC IS COMPLETE — THE REFUGEE HAS FOUND HOME",
     "Three Tiles Liberated. Monument Secured. A Place to Stay.",
     "Three objectives: the tiles, the monument, the station. [COMMANDER_NAME]'s final dispatch was the first one that didn't mention distance. It said only: I know where I am now. The Republic has one more person who chose to be here. That is what the arc was always about.",
     "Warm/Resolved",
     "culture", 20),

    ("ARC_21","Border Mercenary",
     "[COMMANDER_NAME] TAKES THE SUBURB — THE MERCENARY HAS DECIDED THIS ONE COUNTS",
     "Suburbs Secured. [COMMANDER_NAME] Notes the Work Is On Schedule.",
     "A Border Mercenary does not distinguish between conviction and contract as motivations — both produce results. [COMMANDER_NAME] liberated the Suburbs tile with the particular focus of someone who has been paid to have opinions about strategic objectives. The suburb is held. The hold is proceeding to schedule.",
     "Pragmatic/Direct",
     "[COMMANDER_NAME]'S CONTRACT ARC IS COMPLETE — THE BORDER MERCENARY HAS CHOSEN A SIDE",
     "Suburb Held Eight Turns. Arsenal Supplied. The Mercenary Has Terms.",
     "Three objectives met: the ground held, the weapons delivered, and somewhere in the course of eight turns a contract became a commitment. [COMMANDER_NAME]'s final dispatch was the first one that did not read like a quarterly report. It said: I'm staying. The Republic has my terms. The terms are reasonable.",
     "Dry/Resolved",
     "weapons", 20),

    ("ARC_22","Acadian Forest Ranger",
     "[COMMANDER_NAME] CLAIMS THE FOREST — THE RANGER HAS COME HOME",
     "A Woods Tile Is Liberated. [COMMANDER_NAME] Already Knew Every Tree.",
     "The Acadian Forest Ranger does not liberate a woods tile — they reclaim it. [COMMANDER_NAME]'s field note was three sentences: the forest is secured, the patrol routes are set, the Crown will not find us again. It reads like a welcome-home note, which is approximately what it is.",
     "Quiet/Belonging",
     "[COMMANDER_NAME]'S FOREST ARC IS COMPLETE — THE ACADIAN WOODS ARE FREE",
     "Forest Held Five Turns. Ranger Present. The Acadian Range Remembers Its Own.",
     "Three objectives in the particular order of someone who has lived in these woods and knows what they require. [COMMANDER_NAME] held the territory, held it properly, and took their station in the forest that was always theirs. The final dispatch was in French. The DMA translator noted it was very good.",
     "Quiet/Triumphant",
     "wood", 20),

    ("ARC_23","Gettysburg Descendant",
     "[COMMANDER_NAME] REACHES GETTYSBURG — THE DESCENDANT ARRIVES AT THE GROUND",
     "The Field Is Ours. [COMMANDER_NAME] Sends Word From the Crossroads.",
     "Gettysburg has been important twice now. [COMMANDER_NAME] stood at the ridge where the first battle turned and thought about what it means to fight for the same ground twice. The field report was short but unusual: the memorial was still standing. We did not break anything. I am staying.",
     "Weighted/Determined",
     "[COMMANDER_NAME]'S GETTYSBURG ARC IS COMPLETE — THE DESCENDANT HAS EARNED THEIR PLACE IN THE RECORD",
     "Gettysburg Held Five Turns. Fifteen Turns Survived. The Line Holds.",
     "Three objectives and fifteen turns, all of them on meaningful ground. [COMMANDER_NAME]'s final dispatch came from the ridge. It said: I understand now what they were doing here. I understand what we are doing here. The arc closes. The record adds another name from the same line.",
     "Somber/Triumphant",
     "manpower", 20),

    ("ARC_24","LGBTQ+ Organizer",
     "[COMMANDER_NAME] TAKES THE METRO — THE ORGANIZER HAS OPENED THE HALL",
     "A City Tile Is Liberated. [COMMANDER_NAME] Is Already Holding Community Meetings.",
     "An LGBTQ+ Organizer liberates a city tile the same way they organize a community: by showing up, being visible, and making it clear that this space is for the people who live in it. [COMMANDER_NAME] secured the Metro tile and then held a meeting. The meeting was well attended.",
     "Principled/Visible",
     "[COMMANDER_NAME]'S COALITION ARC IS COMPLETE — THE MOVEMENT HAS REACHED EVERYWHERE",
     "Metro Taken. 120 Culture. Three States. The Organizer Has Organized.",
     "Three objectives and three constituencies — the city, the culture, the geography. [COMMANDER_NAME] built the coalition that the arc required: urban ground, national culture, multi-state reach. The final dispatch said: the coalition is holding. That is what an organizer reports when the work is done.",
     "Principled/Satisfied",
     "culture", 25),

    ("ARC_25","Carnival Barker",
     "[COMMANDER_NAME] TAKES THE SHOW ON THE ROAD — FIVE TILES LIBERATED, CROWD ESTIMATED LARGE",
     "[COMMANDER_NAME] Has Liberated Five Tiles and Made It Look Easy. The Crowd Was Impressed.",
     "A Carnival Barker liberates territory the way they run a carnival: with energy, with showmanship, and with the persistent ability to make the audience believe the outcome was inevitable. Five tiles. [COMMANDER_NAME] filed a single dispatch: good crowd.",
     "Theatrical/Charming",
     "[COMMANDER_NAME]'S GRAND TOUR IS COMPLETE — THE CARNIVAL HAS CLOSED ITS FINAL SHOW",
     "Five Tiles. 100 Gold. Commander Present. The Barker Takes a Bow.",
     "Three objectives and [COMMANDER_NAME] made all of them look effortless, which required considerable effort. The final dispatch was theatrical and correct: the house is full, the till is healthy, and the Republic's most flamboyant field commander is accepting a standing ovation. How they prefer to end a show.",
     "Theatrical/Triumphant",
     "gold", 20),
]

# ── WRITE EVENTS ─────────────────────────────────────────────────────────────
EVENTS_PATH   = "data/events.csv"
BUTTONS_PATH  = "data/event_buttons.csv"
TRIGGERS_PATH = "data/event_triggers.csv"

EVENT_HEADER = (
    "event_id,event_type,country_cid,headline,short_desc,long_desc,"
    "image_tag,tone,tile_required,tile_feature_required,tile_state_required,"
    "content_flag,repeatable,cooldown_turns"
)

# Read existing events to avoid duplicates
with open(EVENTS_PATH, "r", encoding="utf-8") as f:
    existing_events = f.read()

new_event_rows = []
for arc in ARCS:
    (arc_id, arc_name,
     f_head, f_short, f_long, f_tone,
     d_head, d_short, d_long, d_tone,
     _res, _amt) = arc

    first_id = f"{arc_id}_FIRST"
    done_id  = f"{arc_id}_DONE"

    if first_id not in existing_events:
        new_event_rows.append([
            first_id, "commander_objective", "USA",
            f_head, f_short, f_long,
            "", f_tone, "", "", "", "", "false", "0"
        ])
    if done_id not in existing_events:
        new_event_rows.append([
            done_id, "commander_complete", "USA",
            d_head, d_short, d_long,
            "", d_tone, "", "", "", "", "false", "0"
        ])

with open(EVENTS_PATH, "a", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    for row in new_event_rows:
        w.writerow(row)

print(f"Events: appended {len(new_event_rows)} rows")

# ── WRITE BUTTONS ────────────────────────────────────────────────────────────
with open(BUTTONS_PATH, "r", encoding="utf-8") as f:
    existing_buttons = f.read()

new_btn_rows = []
for arc in ARCS:
    (arc_id, arc_name,
     _fh, _fs, _fl, _ft,
     _dh, _ds, _dl, _dt,
     done_resource, done_amount) = arc

    first_id = f"{arc_id}_FIRST"
    done_id  = f"{arc_id}_DONE"

    btn1_first = f"{first_id}_BTN1"
    if btn1_first not in existing_buttons:
        new_btn_rows.append([
            btn1_first, first_id,
            "Field Dispatch Acknowledged.", "standard",
            "nothing", "", "0", "", "", "", "", ""
        ])

    btn1_done = f"{done_id}_BTN1"
    btn2_done = f"{done_id}_BTN2"
    if btn1_done not in existing_buttons:
        new_btn_rows.append([
            btn1_done, done_id,
            f"Formally Recognize [COMMANDER_NAME]'s Service", "standard",
            "morale_boost", "", "20", "", "", "", "", ""
        ])
    if btn2_done not in existing_buttons:
        new_btn_rows.append([
            btn2_done, done_id,
            f"A {arc_name}'s Work Deserves Its Reward", "standard",
            "resource_change", done_resource, str(done_amount),
            "", "", "", "", ""
        ])

with open(BUTTONS_PATH, "a", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    for row in new_btn_rows:
        w.writerow(row)

print(f"Buttons: appended {len(new_btn_rows)} rows")

# ── WRITE TRIGGERS ────────────────────────────────────────────────────────────
with open(TRIGGERS_PATH, "r", encoding="utf-8") as f:
    trigger_text = f.read()
    trigger_lines = trigger_text.splitlines()

# Find highest existing TRIG number
max_trig = 35
for line in trigger_lines:
    m = re.match(r"TRIG_(\d+),", line)
    if m:
        max_trig = max(max_trig, int(m.group(1)))

# Update TRIG_016 (CMD_OBJECTIVE_1→ARC_01_FIRST) and TRIG_017 (CMD_REUNION→ARC_01_DONE)
updated = trigger_text
updated = re.sub(r"(TRIG_016,)CMD_OBJECTIVE_1,", r"\1ARC_01_FIRST,", updated)
updated = re.sub(r"(TRIG_017,)CMD_REUNION,",      r"\1ARC_01_DONE,",  updated)

# Determine which arcs still need triggers (ARC_01 already has TRIG_016/017)
# After the update above, ARC_01 is covered. Add ARC_02–25.
new_trigger_rows = []
trig_num = max_trig + 1
for arc in ARCS[1:]:  # skip ARC_01
    arc_id = arc[0]
    first_id = f"{arc_id}_FIRST"
    done_id  = f"{arc_id}_DONE"
    if first_id not in trigger_text and first_id not in updated:
        new_trigger_rows.append(
            f"TRIG_{trig_num:03d},{first_id},commander_objective,"
            f"0,,0,0,0,9999,,{arc_id},,1,2"
        )
        trig_num += 1
    if done_id not in trigger_text and done_id not in updated:
        new_trigger_rows.append(
            f"TRIG_{trig_num:03d},{done_id},commander_objective,"
            f"0,,0,0,0,9999,,{arc_id},,3,2"
        )
        trig_num += 1

# Write the updated file
if new_trigger_rows:
    updated = updated.rstrip("\n") + "\n" + "\n".join(new_trigger_rows) + "\n"

with open(TRIGGERS_PATH, "w", encoding="utf-8") as f:
    f.write(updated)

print(f"Triggers: updated TRIG_016/017, appended {len(new_trigger_rows)} new rows")
print(f"Done. New trigger ceiling: TRIG_{trig_num-1:03d}")
