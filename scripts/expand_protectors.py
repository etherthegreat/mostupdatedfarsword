"""
Expands all 17 protectors to 3-stage chains: SUMMON → TAME → AGREE.
Run from repo root: python3 scripts/expand_protectors.py

Changes made:
  - events.csv       : appends 17 TAME + 17 AGREE events (34 rows)
  - event_buttons.csv: replaces PROT_01/14 SUMMON buttons, adds SUMMON
                       buttons for 02-13/15-17, plus all TAME + AGREE buttons
"""

import csv, io, os, sys

EVENTS_CSV   = "data/events.csv"
BUTTONS_CSV  = "data/event_buttons.csv"

# ── PROTECTOR MASTER DATA ────────────────────────────────────────────────────
# Each entry:  id, name, kinky_flag, summon_btn1, summon_btn2
# kinky_flag = "kinky_lewd" | "explicit" | ""  (content flag on AGREE event)
PROTECTORS = [
    ("01", "Mothman",            "kinky_lewd",
     "Make Eye Contact", "Hold Your Ground"),
    ("02", "Jersey Devil",       "",
     "Hold Your Position", "Observe and Document"),
    ("03", "Bigfoot",            "",
     "Approach Without Weapons", "Leave Provisions at the Clearing"),
    ("04", "Thunderbird",        "",
     "Request Indigenous Liaison", "Signal a Ceremonial Approach"),
    ("05", "Headless Horseman",  "",
     "Present Continental Credentials", "Stand in the Road"),
    ("06", "Chessie",            "",
     "Signal from the Shore", "Consult the Bay Fishermen"),
    ("07", "Bell Witch",         "",
     "Contact Local Spiritual Practitioners", "Announce Your Purpose Plainly"),
    ("08", "Old Ironsides",      "",
     "Hail Using Original Flag Codes", "Send a Port Authority Team"),
    ("09", "Valley Forge Guardian", "",
     "Walk the Perimeter at Dawn", "Station a Garrison — Wait"),
    ("10", "Snallygaster",       "",
     "Establish a Feeding Station", "Approach from the Supply Route"),
    ("11", "Paul Revere",        "",
     "Prepare an Updated Map", "Intercept the Route — Gently"),
    ("12", "Liberty Bell",       "",
     "Address the Bell Directly", "Establish a Bell Protocol"),
    ("13", "Green Mountain Ghost", "",
     "Consult Vermont Communities", "Walk the Ridgeline at Dusk"),

    ("15", "Skunk Ape",          "",
     "Contact Florida Homesteaders", "Observe from the Swamp Edge"),
    ("16", "Minuteman",          "",
     "Approach on Foot — No Weapons Visible", "Present Your Continental Commission"),
    ("17", "Lincoln's Ghost",    "",
     "Clear Your Thursday Evening", "Leave the Light On in the Executive Quarters"),
]

# ── EVENT TEXT ───────────────────────────────────────────────────────────────
# TAME  : headline, short_desc, long_desc, tone
# AGREE : headline, short_desc, long_desc, tone
# (long_desc must not contain unescaped double-quotes)

TAME_TEXT = {
"01": (
    "MOTHMAN DEESCALATED: THE RIDGE MEETING HOLDS",
    "It Stopped Haunting. It's Still Watching. These Are Different.",
    "The Department of Mythological Affairs field team has submitted a three-page report on the situation at Harper's Ferry. Summary paragraph: Mothman has ceased indiscriminate haunting. The creature attended the initial contact with what the lead agent describes as 'profound focused attention' and departed to a ridge position that is technically not haunting anything within a twelve-mile radius. The surveillance continues. The disruption does not. The department is calling this success and is actively choosing not to examine the exact nature of the interaction that produced it.",
    "Tense/Warm",
),
"02": (
    "JERSEY DEVIL CEASES SUPPLY ROUTE DISRUPTIONS — PINE BARRENS ACCORD",
    "The Wagons Are Getting Through. The Devil Is Still There. It's Fine.",
    "New Jersey's most reliable supernatural problem had been operating with comprehensive indifference to the political sympathies of the wagons it destroyed. The DMA field team, through a combination of persistence and what their report calls 'non-hostile presence in the creature's territory over multiple consecutive nights,' has achieved a working arrangement. The Jersey Devil has agreed — through a process that did not involve written documents and which the lead agent has declined to describe in detail — to restrict operations to Crown-affiliated convoys. The Continental seal on the wagon matters, the agent reports. The seal is working.",
    "Quirky/Warm",
),
"03": (
    "APPALACHIAN PASSES REOPEN: BIGFOOT ACKNOWLEDGES THE REPUBLIC",
    "The Mountain Wasn't His Problem. Now It Isn't Our Problem.",
    "The Appalachian highlands had been experiencing what military dispatches diplomatically call 'unexpected personnel deterrence events' — which is how the Continental Army describes soldiers refusing to pass through mountain corridors because something very large is watching them from the ridgeline. The DMA field team established sustained presence in the affected region, approached without weapons, and left provisions at the clearing the creature regarded as a meeting location. Three visits later, Bigfoot crossed the clearing and stood still for forty seconds. The agents report this as 'communication.' The mountain passes are open.",
    "Quiet/Warm",
),
"04": (
    "THUNDERBIRD STANDS DOWN: STORM ACTIVITY RETURNS TO PREDICTABLE PATTERNS",
    "The Sky Has Calmed. The Bird Is Still Up There.",
    "The Thunderbird had been disrupting Continental signal fires, weather patterns, and field communications across the Hudson Valley simultaneously — with no apparent concern for whose operations it was disrupting. The DMA's ceremonial approach, conducted through Indigenous liaisons who had been suggesting this methodology for two weeks before the DMA listened, produced immediate results. The ceremony involved offerings, a specific protocol, and what the lead agent describes as 'a complete revision of my understanding of what is negotiable with extremely large birds.' The Thunderbird circles. It is no longer descending. This is meaningfully different.",
    "Serious/Warm",
),
"05": (
    "THE HORSEMAN ACCEPTS IDENTIFICATION PROTOCOLS — CONTINENTAL COURIERS SAFE",
    "The Head Was Not the Problem. The Targeting Was the Problem.",
    "Continental couriers in the Hudson Valley had been experiencing the same disruption as Crown couriers, which was technically impressive but logistically catastrophic. The DMA's approach involved a protocol the lead agent describes as 'we showed him a list and he seemed to understand lists.' The list contained Crown courier identification markers. The Horseman reviewed it. Three Crown couriers that week confirmed that the following week featured significantly higher levels of inexplicable mounting accidents than the previous one. No Continental couriers were involved. The protocol is working.",
    "Tense/Dry",
),
"06": (
    "CHESSIE REDIRECTS MARITIME OPERATIONS: CHESAPEAKE FISHING RESTORED",
    "The Fishing Boats Are Fine Now. The Crown Frigates Are Less Fine.",
    "Chesapeake Bay's resident sea creature had been operating with what marine officers described as 'enthusiasm in excess of operational necessity' — meaning it was disrupting commercial fishing alongside Royal Navy operations with identical conviction. The DMA field team coordinated with Chesapeake Bay fishing communities who had, it emerges, been leaving offerings on a specific sandbar for approximately forty years. The offerings were presented. Chessie surfaced, considered the matter for eleven minutes, and returned to the bay. Commercial fishing resumed the following morning. Crown frigates report increased wake disturbances.",
    "Quirky/Warm",
),
"07": (
    "BELL WITCH REDIRECTS HAUNTING OPERATIONS TO CROWN-OCCUPIED TERRITORY",
    "The Soldiers in Tennessee Can Sleep Now. The Crown Ones Cannot.",
    "The Bell Witch of Tennessee had been an equal-opportunity haunter for the duration of the present conflict — afflicting Continental and Crown soldiers with identical supernatural disruption and zero concern for military allegiance. The DMA's approach involved a spiritual practitioner from the local community who had not been consulted by the department despite being available and having opinions about this for months. The three-hour negotiation produced results. Crown-occupied territory in Tennessee reports a significant increase in unexplained disturbances. Continental territory does not.",
    "Tense/Wry",
),
"08": (
    "OLD IRONSIDES ACCEPTS CONTINENTAL NAVAL COMMAND — BOSTON HARBOR STABLE",
    "The Ship Has Docked. It Is Waiting. This Is Not Normal Behavior for a Ship.",
    "The USS Constitution's autonomous operations had been creating navigational hazards for Continental and Crown vessels alike — its targeting was based on criteria no one in naval command could identify. Port authority at Boston, following extended attempts to communicate with an unmanned vessel, established a signal protocol using flag codes dated to the ship's original commissioning. The ship responded to flag signals. This is not something ships do. The port authority has chosen to process this pragmatically. Old Ironsides is docked and waiting. Its guns are loaded.",
    "Epic/Dry",
),
"09": (
    "VALLEY FORGE SPIRITS SETTLE — CARLISLE'S ARMY WELCOMED",
    "The Ground Recognized Her. It Takes Time.",
    "The garrison at Valley Forge had been reporting what their commanding officer called 'an atmosphere of judgment' — the sense that the ground itself was evaluating whether the present army was worthy of occupying it. The DMA recommended President Carlisle visit personally. She did, unannounced, at four in the morning in November. She walked the encampment in silence. What the Guardian communicated during those hours is not recorded. What is recorded is that when she left at dawn, every soldier in the garrison reported that the atmosphere had changed. The verdict had been reached.",
    "Serious/Warm",
),
"10": (
    "SNALLYGASTER REDIRECTS — CONTINENTAL SUPPLY ROUTES NOW CLEAR",
    "It Was Never Personal. It Was Just Hungry.",
    "The Snallygaster's approach to Continental supply depots was, intelligence eventually determined, primarily nutritional rather than ideological — it was eating stored provisions because they were there. The DMA's solution involved establishing a designated feeding station adjacent to supply routes, stocked with provisions marked 'NOT FOR SNALLYGASTER' in Continental standard font. The Snallygaster destroyed the sign immediately and consumed the provisions. This was considered satisfactory. Supply depots since that date have not been disturbed. The feeding station requires restocking every nine days.",
    "Quirky/Wry",
),
"11": (
    "PAUL REVERE INTEGRATES WITH CONTINENTAL COMMAND — MIDNIGHT RIDES COORDINATED",
    "He Was Always Trying to Help. He Needed a Schedule.",
    "Paul Revere's midnight rides were entirely sincere. The problem was coordination: his warnings went to Continental counterintelligence positions as readily as to Crown ones, routes were not mapped to current fortifications, and his schedule bore no relationship to actual Crown movements. The DMA's integration protocol involved what the lead agent describes as 'a very patient map session.' Revere listened, reviewed the updated intelligence, asked one question through his established communication method, and his subsequent rides have aligned precisely with Crown courier movements. No Continental positions have been alarmed.",
    "Warm/Earnest",
),
"12": (
    "LIBERTY BELL RINGS ON SCHEDULE — CIVILIAN PANIC CEASES",
    "It's Not Ringing at 3 A.M. Anymore. This Is an Improvement.",
    "Philadelphia had been experiencing what the city's emergency operations office describes as 'irregular patriotic events' — which is how the city officially logs the Liberty Bell ringing without warning at two and three in the morning, producing civilian evacuations and one canal boat running aground during what the captain described as 'a moment of patriotic confusion.' The DMA conducted what the senior member calls 'a direct and surprisingly productive conversation with a bell.' The Bell listened. It has since rung at dawn. It also rang at 6:47 p.m. on a Tuesday, which the DMA categorizes as within acceptable operational parameters.",
    "Quirky/Warm",
),
"13": (
    "GREEN MOUNTAIN GHOST IDENTIFIES VERMONT MILITIA AS NON-HOSTILE",
    "The Ghost Updated Its Friend/Foe Protocol. This Was Necessary.",
    "Vermont's spectral irregular force had been engaging Vermont militia units with the same tactical aggression applied to Crown forces. The Vermont militia had been filing incident reports. The DMA field team consulted with Vermont communities who described the situation as 'the Ghost doesn't know who you are yet.' The introduction was arranged through local channels. The Ghost, having received context, withdrew from two contested positions and was subsequently observed operating exclusively in Crown-adjacent territory. Vermont has updated its incident reports accordingly.",
    "Quirky/Regional",
),
"14": (
    "MOUNT RUSHMORE COUNCIL REACHES INTERNAL CONSENSUS — DEBATES FORMALIZED",
    "They Have Agreed to Disagree Quietly. This Is Progress.",
    "The four stone presidents had been engaged in what the DMA's report describes as 'a continuous and very loud policy discussion that does not account for the acoustic impact on the surrounding region.' Washington attempted to chair. Roosevelt continued interrupting. Jefferson raised structural objections. Lincoln sat quietly and looked troubled. The civilian disruption from four very large men arguing about constitutional theory at unreasonable volume had reached the level of a formal noise ordinance complaint filed with no one in particular. The DMA intervention imposed one agenda item and a strict time limit. The debates are now held in session. The volume has decreased. The topics have not.",
    "Epic/Satirical",
),
"15": (
    "SKUNK APE WITHDRAWS FROM ACTIVE DISRUPTION ZONES — SOUTHERN OPERATIONS STABLE",
    "It Smells Worse Than Before. But It's Staying in the Swamp.",
    "The Skunk Ape's excursions from the Florida wetlands into Continental operating territory had been causing what southern field command describes as 'substantial logistical and morale complications.' The DMA's approach relied entirely on local Florida homesteaders who had been coexisting with the creature for generations. Their method involved a specific frequency of sound produced by a specific instrument at a specific distance from the creature's patrol area. The Skunk Ape listened. It returned to the swamp. The frequency and instrument have been added to the field manual as Protocol 7.",
    "Quirky/Warm",
),
"16": (
    "THE MINUTEMAN ACKNOWLEDGES CONTINENTAL FORCES — LEXINGTON GREEN ACCESS RESTORED",
    "He Wasn't Going to Stand Down for Anyone. He Did Anyway.",
    "The eternal Minuteman at Lexington had been challenging every military unit approaching the Green — Continental, Crown, civilian militia — with what witnesses describe as 'extremely focused attention and an expression that suggests the concept of surrender has not entered his operational framework.' Three Continental units had been turned back. The DMA's recommendation was that a senior officer approach on foot alone, without visible weapons, in formal Continental uniform. The officer who performed this approach filed a report consisting primarily of: 'He looked at me for a long time and then stepped aside.' Access to Lexington Green has been restored.",
    "Serious/Rousing",
),
"17": (
    "LINCOLN'S GHOST ESTABLISHES OFFICE HOURS — PRESIDENTIAL SCHEDULE RESTORED",
    "He's Still Here. He Now Knocks.",
    "Abraham Lincoln's ghost had been appearing in the White House executive quarters at two and three in the morning regardless of scheduling, affecting President Carlisle's operational capacity in a way the press secretary categorized as 'a situation we are not equipped to communicate publicly.' The DMA's solution was endorsed by the President personally: she sat down with Lincoln for two hours, listened without interruption, and asked two questions. Lincoln, the President told her senior staff, 'had been trying to say something for a long time and needed someone to actually listen.' He now appears at scheduled intervals. He knocks. The President has cleared Thursday evenings.",
    "Serious/Intimate",
),
}

AGREE_TEXT = {
"01": (
    "MOTHMAN FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC",
    "The Agreement Required No Words. The Words Came Anyway.",
    "President Carlisle went to Harper's Ferry alone. Her security detail was told to stay and did not listen and was subsequently convinced to stay by a look from both the President and the creature that the senior agent described as 'a rethinking of my entire professional situation.' The meeting on the ridge was not recorded. What is recorded is what followed: Mothman, which had been causing generalized supernatural disruption across the eastern highland corridor, has realigned entirely to Continental interests. The Department of Mythological Affairs has filed the paperwork. The paperwork required a new category.",
    "kinky_lewd",
    "Tense/Intimate",
),
"02": (
    "JERSEY DEVIL FORMALLY ENDORSES THE CONTINENTAL CAUSE",
    "New Jersey's Most Complicated Asset Has Chosen a Side.",
    "President Carlisle drove to the Pine Barrens edge after dark without her security detail, which her chief of staff has noted in his personal log as 'the second time this week she's done something I wasn't told about.' She returned several hours later. What she said to the Jersey Devil, and what it communicated back, has not been included in the official record. What IS in the record: Crown supply convoys in New Jersey now experience what their logistics office describes as 'selective and targeted interference' with a consistency that suggests coordination rather than random destruction. No Continental convoy has been disrupted since the meeting.",
    "",
    "Quirky/Triumphant",
),
"03": (
    "BIGFOOT FORMALLY GUIDES THE CONTINENTAL CAUSE THROUGH THE MOUNTAINS",
    "He Doesn't Speak. He Moves. That Is Communication.",
    "President Carlisle went to the Appalachian clearing alone and sat down. After twenty minutes, the clearing was no longer empty. She sat with the creature for an hour in silence. Neither party required words. Continental forces since that meeting report that mountain routes previously described as difficult and hostile are now navigated with a confidence their officers attribute to 'a general sense that the terrain is cooperative.' Three scouting units reported arranged rocks and disturbed paths pointing the correct direction that they followed to significant tactical advantage. Bigfoot has not been seen again. The signs have not stopped appearing.",
    "",
    "Quiet/Triumphant",
),
"04": (
    "THUNDERBIRD FORMALLY ALLIES WITH THE CONTINENTAL REPUBLIC",
    "The Sky Has Taken a Side. This Is Historically Unusual.",
    "The formal agreement with Thunderbird was reached through the Indigenous liaison network. President Carlisle attended the ceremony without her staff, without her security detail, and without — notably — her shoes, a gesture the lead cultural liaison describes as 'exactly correct in a way that suggests someone has been paying attention.' The ceremony is not described in the official record at the liaison's request. The agreement stands. Thunderbird has since been observed disrupting Crown signal fires along the northern border with precision that the DMA's meteorological analysts attribute to 'deliberate and intentional atmospheric intervention by an entity that understands the operational significance of what it is doing.'",
    "",
    "Epic/Rousing",
),
"05": (
    "THE HORSEMAN RIDES FOR THE REPUBLIC — FORMALLY",
    "He Was Always Going to Choose a Side. She Just Had to Ask.",
    "President Carlisle found the Headless Horseman in the Hudson Valley before midnight on a night when neither was expected to be there. She stood in the road and he stopped. The exchange was brief — her words, his silence, and a single gesture that her aide (who was there despite explicit instructions) describes as 'the kind of nod that means something specific and permanent.' The Horseman has since operated with perfect Crown courier interdiction. Not a single Continental messenger in the Hudson Valley has been impeded. The Crown's courier casualty rate in the corridor has reached what their dispatches call 'an unsustainable operational situation.'",
    "",
    "Tense/Triumphant",
),
"06": (
    "CHESSIE FORMALLY PATROLS FOR THE CONTINENTAL NAVY",
    "The Chesapeake Has Chosen. The Bay Knows Whose Side It Is On.",
    "President Carlisle stood at the water's edge of the Chesapeake at low tide at the specific sandbar the fishing community identified as meaningful. She waded out in the dark. After thirteen minutes, something very large surfaced nearby. The agreement was brief. Her security detail, watching from shore, observed a 'sustained period of proximity' and the President emerging from the water looking 'focused in a way that suggested something specific had been communicated.' Crown frigates in the Chesapeake since report what the Admiralty describes as 'inexplicable structural damage to hulls at depth.' Continental fishing boats report excellent conditions.",
    "",
    "Tense/Triumphant",
),
"07": (
    "THE BELL WITCH FORMALLY COMMITS TO THE CONTINENTAL CAUSE",
    "She Didn't Need to Be Convinced. She Needed to Be Asked.",
    "President Carlisle asked the spiritual practitioner who had negotiated the earlier arrangement to set up a second meeting — just Carlisle and the intermediary, no DMA personnel. The meeting in the Tennessee highlands lasted ninety minutes. The Bell Witch, the practitioner reports, 'had a great deal to say about how this should have been approached in the first place, and the President listened to all of it without interrupting.' The agreement was reached in the final twenty minutes. Crown-occupied Tennessee now experiences supernatural disruption at a level their garrison commanders describe as 'incompatible with maintained occupancy.' Three Crown units have requested redeployment to locations described as 'anywhere that isn't this.'",
    "",
    "Tense/Rousing",
),
"08": (
    "OLD IRONSIDES FORMALLY JOINS THE CONTINENTAL NAVY",
    "The Ship Has Its Orders. It Seems to Understand Them.",
    "The recommissioning ceremony for Old Ironsides was held at Boston Harbor with full naval honors and what the port authority describes as 'an unusually attentive vessel.' President Carlisle addressed the ship directly — her staff noted this without comment and has continued not commenting — and read the commission aloud. When she finished, the ship's bell rang once. The port authority logged this as 'acknowledgment of commission.' Old Ironsides has since operated as the most effective element of the Continental Navy, engaging Crown vessels with targeting precision that no living crew could match. Nobody is asking follow-up questions.",
    "",
    "Epic/Triumphant",
),
"09": (
    "VALLEY FORGE GUARDIAN FORMALLY BLESSES THE CONTINENTAL ARMY",
    "The Ground Accepted Her Army. That Is Not a Small Thing.",
    "President Carlisle spent a night at the Valley Forge encampment. She woke before dawn and walked the original perimeter of Washington's winter camp — alone, in silence, in November. The Guardian walked with her. Not metaphorically. The DMA's spiritual analyst submitted a report using the phrase 'direct and unambiguous supernatural endorsement' fourteen times. The Continental Army stationed at Valley Forge reports a change in its operational capacity that their commanding officer attributes to 'morale, or something close enough to morale that I am not pursuing the distinction further.' The ground that held Washington's army has accepted Carlisle's.",
    "",
    "Serious/Rousing",
),
"10": (
    "SNALLYGASTER FORMALLY GUARDS THE CONTINENTAL SUPPLY NETWORK",
    "It Has Stopped Eating Our Supplies. It Has Started Eating Theirs.",
    "The arrangement reached its formal stage when President Carlisle visited the feeding station in Maryland and waited. The creature arrived twenty minutes later, ate approximately four hundred pounds of provisions with efficiency, and then sat down near the President, which the field agent present describes as 'not something I had a protocol for.' The conversation — described by Carlisle as 'nonverbal but extremely clear' — produced a working relationship. Continental supply routes in the Maryland corridor now have zero unexplained losses. Crown supply operations in the same corridor report what their dispatches call 'persistent heavy losses from an unknown source.'",
    "",
    "Quirky/Triumphant",
),
"11": (
    "PAUL REVERE FORMALLY INTEGRATES WITH CONTINENTAL INTELLIGENCE",
    "He Has Always Been Ready. Now He Knows Where to Go.",
    "The formal integration of Paul Revere was, remarkably, the simplest alliance in DMA operational history. He arrived at the designated location, sat down with the intelligence brief, reviewed it completely, and looked at the lead agent with what the agent describes as 'the specific expression of someone who has been doing this alone for too long and is relieved to have a map.' He left immediately. The following week included three Crown courier interceptions, two supply depot locations identified in advance, and one alarm raised with thirty minutes for the Continental garrison to prepare. Revere has asked for a better map. A better map has been provided.",
    "",
    "Warm/Rousing",
),
"12": (
    "THE LIBERTY BELL FORMALLY RINGS FOR THE REPUBLIC",
    "It Has Always Been Ringing for the Republic. Now It Knows When to Ring.",
    "The Liberty Bell does not negotiate in the conventional sense. What it does is respond. President Carlisle went to Independence Hall and stood with the Bell for an hour without talking points. She stood in silence and thought about what she was asking it to do. The Bell rang once at the beginning and once at the end of the hour. The DMA's spiritual analyst believes this constitutes formal agreement. The Bell has since rung exactly when the President needed it to ring — once during a Continental morale crisis, once at the liberation of a key city, and once on a night when Carlisle was reading casualty reports at four in the morning. That last one was just for her. She is grateful for it.",
    "",
    "Triumphant/Intimate",
),
"13": (
    "GREEN MOUNTAIN GHOST FORMALLY PROTECTS VERMONT FOR THE REPUBLIC",
    "The Mountains Have Always Been His. Now They Are Also Ours.",
    "President Carlisle drove to the ridge above Brattleboro and stood at the tree line at dusk. The Ghost arrived — not dramatically, just the particular quality of attention the local communities recognize as presence. They stood together. Carlisle asked one question. The Ghost's response, described by the interpreter she brought, was 'the mountains themselves agreeing.' Crown forces in Vermont have begun what their dispatches call 'strategic repositioning' out of terrain they could not operate in. The terrain has not changed. The Ghost has.",
    "",
    "Supernatural/Regional",
),
"14": (
    "THE RUSHMORE COUNCIL FORMALLY ENDORSES PRESIDENT CARLISLE",
    "They Came to a Vote. The Vote Was Unanimous. Lincoln Broke the Tie.",
    "The four stone presidents convened for a final session on the matter of President Ualani Carlisle's administration. Washington presented the case. Roosevelt called it excellent and interrupted three times. Jefferson raised a procedural objection that was noted, recorded, and overruled. Lincoln, who had been quiet throughout, spoke last. His remarks were brief — the DMA transcript records approximately fourteen words — and produced immediate consensus. The formal endorsement was made in the manner available to entities made of granite: each looked at her for a sustained moment and she looked back. Lincoln's sustained moment was the longest. The endorsement stands.",
    "kinky_lewd",
    "Epic/Satirical",
),
"15": (
    "SKUNK APE FORMALLY PATROLS FLORIDA FOR THE CONTINENTAL REPUBLIC",
    "The Swamp Is His. The Republic Is Grateful.",
    "The formal commitment was negotiated entirely through the Florida homesteader network with zero DMA involvement, which the homesteaders view as improvement and the DMA views as a departmental lesson. President Carlisle visited the edge of the Skunk Ape's territory — the boundary where it decides whether strangers are threats. She stood there. The Skunk Ape came to the boundary. They spent forty minutes in proximity, neither advancing, both aware of exactly what was being negotiated. Crown forces in the Florida theater have since begun what their dispatches describe as 'unexpected and persistent difficulty with swamp terrain' they had managed fine in previous months.",
    "",
    "Quirky/Triumphant",
),
"16": (
    "THE MINUTEMAN FORMALLY DECLARES FOR THE CONTINENTAL REPUBLIC",
    "He Said One Thing. It Was Enough.",
    "The formal declaration came at Lexington Green at dawn. President Carlisle arrived early and stood on the Green and waited. He came at first light from the direction of the old battle position, musket ready, in the posture witnesses describe as 'someone who has never once been unprepared for anything.' She did not speak first. He did. The DMA transcript records three sentences. Two were about the Republic. One was about her specifically. Her aide, present against instructions, describes it as 'the most direct presidential endorsement I have ever heard.' The Minuteman has formally declared the Continental Army as his army and President Carlisle as his President.",
    "",
    "Rousing/Serious",
),
"17": (
    "LINCOLN FORMALLY ENDORSES PRESIDENT CARLISLE'S ADMINISTRATION",
    "He Has Been Waiting to Say This Since 1865.",
    "The formal endorsement meeting took place on a Thursday evening, as scheduled. Lincoln arrived on time. He sat across from Carlisle at the long table in the executive quarters and told her, for the first time without interruption or qualification, what he had been trying to tell every president who passed through these rooms since his own presidency ended. What he said is in her personal record, not the public record, because it was meant for her. What she has shared: he told her the arc bends toward justice. He said this is the bending. He said she is exactly who the Republic needs for this specific moment. He said he has not been this certain about something since the Emancipation Proclamation.",
    "",
    "Serious/Triumphant",
),
}

# ── AGREE BUTTON TEXTS ───────────────────────────────────────────────────────
# (standard_btn_text, explicit_btn_text)
AGREE_BUTTONS = {
"01": ("Accept the Alliance",                         "The Complete Accord at Harper's Ferry"),
"02": ("Accept New Jersey's Commitment",              "The Full Pine Barrens Meeting"),
"03": ("Accept Bigfoot's Guidance Through the Mountains", "The Full Mountain Agreement"),
"04": ("Accept the Thunderbird's Alignment",          "The Full Ceremonial Alliance"),
"05": ("Accept the Horseman's Declaration",           "The Full Hudson Valley Accord"),
"06": ("Accept Chessie's Patrol Commitment",          "The Full Chesapeake Accord"),
"07": ("Accept the Bell Witch's Commitment",          "The Full Tennessee Alliance"),
"08": ("Formally Commission Old Ironsides",           "The Full Naval Recommissioning"),
"09": ("Accept the Guardian's Blessing",              "The Full Valley Forge Ceremony"),
"10": ("Accept the Snallygaster's Protection",        "The Full Maryland Agreement"),
"11": ("Formally Integrate Paul Revere",              "The Full Intelligence Alliance"),
"12": ("Accept the Liberty Bell's Commitment",        "The Full Independence Hall Accord"),
"13": ("Accept the Ghost's Protection of Vermont",    "The Full Green Mountain Ceremony"),
"14": ("Accept the Rushmore Endorsement",             "The Complete Presidential Council"),
"15": ("Accept the Skunk Ape's Patrol Commitment",    "The Full Everglades Accord"),
"16": ("Accept the Minuteman's Declaration",          "The Full Lexington Green Ceremony"),
"17": ("Accept Lincoln's Endorsement",                "The Full Presidential Consultation"),
}

# ── HELPER ───────────────────────────────────────────────────────────────────
def csv_row(*fields) -> str:
    buf = io.StringIO()
    w   = csv.writer(buf, quoting=csv.QUOTE_MINIMAL, lineterminator="")
    w.writerow(fields)
    return buf.getvalue()


# ── BUILD EVENT ROWS ─────────────────────────────────────────────────────────
def build_event_rows() -> list[str]:
    rows = []
    # cols: event_id,event_type,country_cid,headline,short_desc,long_desc,
    #        image_tag,tone,tile_required,tile_feature_required,
    #        tile_state_required,content_flag,repeatable,cooldown_turns
    for pid, name, kinky, *_ in PROTECTORS:
        th, ts, tl, tt = TAME_TEXT[pid]
        rows.append(csv_row(
            f"PROT_{pid}_TAME", "protector_tame", "USA",
            th, ts, tl,
            "", tt,
            "", "", "", "",
            "true", "0",
        ))
        ah, as_, al, acf, at = AGREE_TEXT[pid]
        rows.append(csv_row(
            f"PROT_{pid}_AGREE", "protector_agree", "USA",
            ah, as_, al,
            "", at,
            "", "", "", acf,
            "true", "0",
        ))
    return rows


# ── BUILD BUTTON ROWS ────────────────────────────────────────────────────────
def build_button_rows() -> list[str]:
    # cols: button_id,event_id,button_text,button_type,outcome_type,
    #        outcome_value,outcome_amount,loyalty_change,tile_effect,
    #        army_effect,next_event_id,prerequisite_flag
    rows = []

    for pid, name, kinky, btn1, btn2 in PROTECTORS:
        tame_id  = f"PROT_{pid}_TAME"
        agree_id = f"PROT_{pid}_AGREE"
        summon_id = f"PROT_{pid}_SUMMON"

        # ── SUMMON buttons (all lead to TAME) ──
        rows.append(csv_row(
            f"PROT_{pid}_S_BTN1", summon_id, btn1,
            "standard", "trigger_event", tame_id, "0",
            "", "", "", "", "",
        ))
        rows.append(csv_row(
            f"PROT_{pid}_S_BTN2", summon_id, btn2,
            "standard", "trigger_event", tame_id, "0",
            "", "", "", "", "",
        ))

        # ── TAME buttons (set_flag prot_XX_tame + chain to AGREE) ──
        tame_flag = f"prot_{pid}_tame"
        rows.append(csv_row(
            f"PROT_{pid}_T_BTN1", tame_id,
            "Acknowledge the Deescalation",
            "standard", "set_flag", tame_flag, "0",
            "", "", "", agree_id, "",
        ))
        rows.append(csv_row(
            f"PROT_{pid}_T_BTN2", tame_id,
            "File the Departmental Report — What Comes Next",
            "standard", "set_flag", tame_flag, "0",
            "", "", "", agree_id, "",
        ))

        # ── AGREE buttons ──
        std_text, exp_text = AGREE_BUTTONS[pid]
        agree_btn_type = "kinky_lewd" if kinky == "kinky_lewd" else "explicit"
        rows.append(csv_row(
            f"PROT_{pid}_A_BTN1", agree_id, std_text,
            "standard", "set_flag", f"prot_{pid}_agreed", "0",
            "", "", "", "", "",
        ))
        rows.append(csv_row(
            f"PROT_{pid}_A_BTN2", agree_id, exp_text,
            agree_btn_type, "set_flag", f"prot_{pid}_agreed", "0",
            "", "", "", "", "",
        ))

    return rows


# ── APPLY TO CSV FILES ───────────────────────────────────────────────────────
def update_events_csv(new_rows: list[str]) -> None:
    with open(EVENTS_CSV, "a", newline="", encoding="utf-8") as f:
        for row in new_rows:
            f.write("\n" + row)
    print(f"  events.csv   : appended {len(new_rows)} rows")


def update_buttons_csv(new_rows: list[str]) -> None:
    # 1. Read existing content
    with open(BUTTONS_CSV, "r", newline="", encoding="utf-8") as f:
        existing = f.read().rstrip("\n")

    # 2. Parse existing rows via csv reader
    reader = csv.reader(io.StringIO(existing))
    all_rows = list(reader)

    # 3. Remove old PROT_01 SUMMON buttons (they'll be replaced)
    old_summon_events = {"PROT_01_SUMMON"}
    filtered = [r for r in all_rows if not (len(r) >= 2 and r[1] in old_summon_events)]

    # 4. Re-write filtered content
    buf = io.StringIO()
    w   = csv.writer(buf, quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
    w.writerows(filtered)
    base = buf.getvalue().rstrip("\n")

    # 5. Append new rows
    appended = "\n".join(new_rows)
    with open(BUTTONS_CSV, "w", newline="", encoding="utf-8") as f:
        f.write(base + "\n" + appended + "\n")

    removed = len(all_rows) - len(filtered)
    print(f"  event_buttons.csv: removed {removed} old SUMMON buttons, "
          f"appended {len(new_rows)} new buttons")


# ── MAIN ─────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)) + "/..")

    event_rows  = build_event_rows()
    button_rows = build_button_rows()

    print("Writing CSV changes...")
    update_events_csv(event_rows)
    update_buttons_csv(button_rows)

    tame_count  = sum(1 for r in event_rows if "TAME"  in r.split(",")[0])
    agree_count = sum(1 for r in event_rows if "AGREE" in r.split(",")[0])
    print(f"\nDone.")
    print(f"  TAME events added  : {tame_count}")
    print(f"  AGREE events added : {agree_count}")
    print(f"  Button rows added  : {len(button_rows)}")
    print(f"  (2 SUMMON + 2 TAME + 2 AGREE per protector × 17 = 102 rows)")
