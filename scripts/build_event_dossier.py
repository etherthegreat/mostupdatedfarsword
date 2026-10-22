"""
Generates docs/event_dossier/ — a writer's packet for every event in the game.

One markdown file per category. Each entry carries the first-draft prose, the
context that makes it fire, every button with its mechanical outcome, where
those buttons lead, and an empty FINAL PASS slot to write into.

Run from the repo root: python3 scripts/build_event_dossier.py
"""

import csv
import os
import re
from collections import defaultdict, Counter

EVENTS_CSV   = "data/events.csv"
BUTTONS_CSV  = "data/event_buttons.csv"
TRIGGERS_CSV = "data/event_triggers.csv"
MASTERDOC    = "scripts/build_event_masterdoc.py"
OUT_DIR      = "docs/event_dossier"

EVENT_FIELDS = 14
BUTTON_FIELDS = 12

# ── TOLERANT CSV READING ─────────────────────────────────────────────────────
# Two rows in the shipped data have the wrong field count (see 00_INDEX.md
# "Data integrity"). Repair them on read so the dossier is complete, and
# record what was repaired so the index can report it.
REPAIRS = []


def read_rows(path, expected, long_field_index):
    """Read a CSV, folding any over-long row back into long_field_index."""
    with open(path, encoding="utf-8") as fh:
        rows = list(csv.reader(fh))
    header = [h.strip() for h in rows[0]]
    out = []
    for lineno, row in enumerate(rows[1:], start=2):
        if not any(c.strip() for c in row):
            continue
        if len(row) > expected:
            # A column was skipped mid-row and the row padded at the end.
            # Dropping the pad makes the row parse, but every value after the
            # skipped column still sits one place to the right — see the
            # misfiled-link check below, which catches the consequence.
            while len(row) > expected and row[-1] == "":
                row = row[:-1]
                REPAIRS.append((path, lineno, row[0],
                                "trailing pad field dropped so the row parses; "
                                "values after the skipped column are still "
                                "shifted one place right"))
        if len(row) > expected:
            # Anything left is an unquoted comma inside the long prose field.
            extra = len(row) - expected
            merged = ",".join(row[long_field_index:long_field_index + extra + 1])
            row = row[:long_field_index] + [merged] + row[long_field_index + extra + 1:]
            REPAIRS.append((path, lineno, row[0], f"{extra} stray comma(s) folded back into "
                                                  f"'{header[long_field_index]}'"))
        if len(row) < expected:
            row = row + [""] * (expected - len(row))
        out.append(dict(zip(header, row)))
    return out


def load_data():
    events = read_rows(EVENTS_CSV, EVENT_FIELDS, 5)      # long_desc
    buttons = read_rows(BUTTONS_CSV, BUTTON_FIELDS, 2)   # button_text
    triggers = read_rows(TRIGGERS_CSV, 14, 12)           # trigger_condition
    events = [e for e in events if e["event_id"].strip()]
    return events, buttons, triggers


# ── MASTERDOC METADATA ───────────────────────────────────────────────────────
MD_KEYS = ["category", "chain", "event_id", "headline", "chain_pos", "parent",
           "child", "status", "art_tag", "art_status", "explicit_art",
           "content_flag", "cooldown", "notes"]


def load_masterdoc():
    """Pull the EVENTS tuple list out of the masterdoc builder for status/chain."""
    src = open(MASTERDOC, encoding="utf-8").read()
    start = src.index("EVENTS = [")
    end = src.index("def make_fill")
    ns = {}
    exec(src[start:end], ns)
    return {row[2]: dict(zip(MD_KEYS, row)) for row in ns["EVENTS"]}


# ── SHIFTED-COLUMN NORMALISATION ─────────────────────────────────────────────
def normalise(event):
    """Some rows were authored with content_flag omitted, shifting the tail.

    Signature: content_flag holds a repeatable literal and cooldown is blank.
    world.gd:5521 already guards against this at runtime; we undo it here so
    the dossier reports the author's intent.
    """
    cf = event["content_flag"].strip()
    rp = event["repeatable"].strip()
    cd = event["cooldown_turns"].strip()
    if cf in ("true", "false") and cd == "" and rp.isdigit():
        event["_shifted"] = True
        event["content_flag"] = ""
        event["repeatable"] = cf
        event["cooldown_turns"] = rp
    else:
        event["_shifted"] = False
    return event


# ── CONTEXT: WHY AN EVENT FIRES ──────────────────────────────────────────────
def describe_trigger(t):
    tt = t["trigger_type"]
    cond = t.get("trigger_condition", "").strip()
    bits = []
    if tt == "game_start":
        bits.append("**Game start** — fires on turn 1")
    elif tt == "annual_date":
        bits.append(f"**Annual date** — every year in month `{cond or '?'}`")
    elif tt == "winter_onset":
        bits.append("**Winter onset** — month 11 or 12")
    elif tt in ("tile_liberated", "tile_lost"):
        verb = "liberated" if tt == "tile_liberated" else "lost"
        tid = t.get("tile_id", "").strip()
        bits.append(f"**Tile {verb}** — tile `{tid}`" if tid and tid != "0"
                    else f"**Tile {verb}** — any tile")
    elif tt == "state_liberated":
        bits.append(f"**State liberated** — `{t.get('state_code','').strip() or 'any'}`")
    elif tt == "commander_objective":
        bits.append(f"**Commander objective** — archetype "
                    f"`{t.get('commander_archetype','').strip()}`, objective #{cond or '?'}")
    elif tt in ("protector_summon", "protector_tame", "protector_agree"):
        bits.append(f"**{tt.replace('_',' ').title()}** — protector "
                    f"`{t.get('protector_id','').strip()}`")
    else:
        bits.append(f"**{tt}**" + (f" — condition `{cond}`" if cond else ""))

    owner = t.get("tile_owner", "").strip()
    if owner:
        bits.append(f"tile owner `{owner}`")
    lo, hi = t.get("turn_min", "").strip(), t.get("turn_max", "").strip()
    if lo not in ("", "0") or hi not in ("", "0", "9999"):
        bits.append(f"turns {lo or '0'}–{hi or '∞'}")
    ml = t.get("min_liberty_score", "").strip()
    if ml not in ("", "0"):
        bits.append(f"liberty ≥ {ml}")
    mc = t.get("min_corruption", "").strip()
    if mc not in ("", "0"):
        bits.append(f"corruption ≥ {mc}")
    pr = t.get("priority", "").strip()
    if pr:
        bits.append(f"priority {pr}")
    return " · ".join(bits)


# ── OUTCOMES: WHAT A BUTTON DOES ─────────────────────────────────────────────
def describe_outcome(b):
    ot = b["outcome_type"].strip()
    ov = b["outcome_value"].strip()
    oa = b["outcome_amount"].strip()
    parts = []

    def amt(v):
        return f"+{v}" if v and not v.startswith("-") else v

    if ot in ("", "nothing", "standard"):
        parts.append("_no mechanical effect_")
    elif ot == "set_flag":
        parts.append(f"sets flag `{ov}`")
    elif ot in ("set_mission_flag", "set_mission_flag_own"):
        parts.append(f"sets mission flag `{ov}`"
                     + (" (own country)" if ot.endswith("_own") else ""))
    elif ot == "morale_boost":
        parts.append(f"morale {amt(oa)}")
    elif ot == "resource_change":
        parts.append(f"{ov} {amt(oa)}")
    elif ot == "trigger_event":
        parts.append(f"fires **{ov}** immediately")
    elif ot == "tile_yield":
        parts.append(f"tile yield `{ov}` {amt(oa)}")
    elif ot == "claim_change":
        parts.append(f"claim → `{ov}`" + (f" {amt(oa)}" if oa else ""))
    elif ot == "loyalty_change":
        parts.append(f"loyalty `{ov}` {amt(oa)}")
    elif ot == "governor_loyalty_change":
        parts.append(f"governor loyalty `{ov}` {amt(oa)}")
    elif ot == "election_pressure_change":
        parts.append(f"election pressure {amt(oa)}")
    elif ot == "tile_moral_decay_change":
        parts.append(f"tile moral decay {amt(oa)}")
    elif ot == "remove_governor":
        parts.append("removes the governor")
    elif ot == "pardon_state_governors":
        parts.append("pardons state governors")
    elif ot == "reveal_tiles":
        parts.append(f"reveals tiles `{ov}`" if ov else "reveals tiles")
    elif ot == "promote_commander":
        parts.append(f"promotes commander `{ov}`" if ov else "promotes the commander")
    elif ot == "harmony_boost":
        parts.append(f"harmony {amt(oa)}")
    elif ot == "army_buff":
        parts.append(f"army buff `{ov}`" + (f" {amt(oa)}" if oa else ""))
    elif ot == "form_alliance":
        parts.append(f"forms alliance with `{ov}`")
    elif ot == "trigger_collapse":
        parts.append("**triggers republic collapse**")
    elif ot == "repair_fort":
        parts.append("repairs the fort")
    elif ot == "disable_building":
        parts.append(f"disables building `{ov}`")
    elif ot in ("george_peace_accept", "george_peace_reject"):
        parts.append(f"**{ot.replace('_',' ')}**")
    else:
        parts.append(f"`{ot}`" + (f" `{ov}`" if ov else "") + (f" {amt(oa)}" if oa else ""))

    if b["loyalty_change"].strip():
        parts.append(f"loyalty {amt(b['loyalty_change'].strip())}")
    if b["tile_effect"].strip():
        parts.append(f"tile: `{b['tile_effect'].strip()}`")
    if b["army_effect"].strip():
        parts.append(f"army: `{b['army_effect'].strip()}`")
    return "; ".join(parts)


# ── LINK GRAPH ───────────────────────────────────────────────────────────────
def build_graph(events, buttons):
    ids = {e["event_id"] for e in events}
    outgoing = defaultdict(list)   # event_id -> [(label, target)]
    incoming = defaultdict(list)   # event_id -> [(label, source)]

    for b in buttons:
        src = b["event_id"].strip()
        nxt = b["next_event_id"].strip()
        if nxt and nxt in ids:
            label = f'"{b["button_text"].strip()}" →'
            outgoing[src].append((label, nxt))
            incoming[nxt].append((label, src))
        if b["outcome_type"].strip() == "trigger_event":
            tgt = b["outcome_value"].strip()
            if tgt in ids:
                label = f'"{b["button_text"].strip()}" fires'
                outgoing[src].append((label, tgt))
                incoming[tgt].append((label, src))
        # set_mission_flag stores the completion event id as
        # "mission_<eventId>_<tileNum>"; checkPendingMissions() fires that event
        # once the tile condition is met (world.gd:2530).
        if b["outcome_type"].strip() in ("set_mission_flag", "set_mission_flag_own"):
            tgt = b["outcome_value"].strip()
            if tgt in ids:
                turns = b["outcome_amount"].strip()
                window = f" within {turns} turns" if turns and turns != "0" else ""
                kind = ("tile owned" if b["outcome_type"].strip().endswith("_own")
                        else "army present")
                label = f'"{b["button_text"].strip()}" sets mission ({kind}{window})'
                outgoing[src].append((label, tgt))
                incoming[tgt].append((label, src))

    # event_scene.gd:114 — picking "intimate" on X routes to X_INTIMATE
    for eid in ids:
        if eid.endswith("_INTIMATE"):
            base = eid[: -len("_INTIMATE")]
            if base in ids:
                outgoing[base].append(('scene nav: "intimate" →', eid))
                incoming[eid].append(('scene nav: "intimate" from', base))
    return outgoing, incoming


def build_flag_graph(buttons):
    sets = defaultdict(list)   # flag -> [event_id]
    gates = defaultdict(list)  # flag -> [event_id]
    for b in buttons:
        if b["outcome_type"].strip() in ("set_flag", "set_mission_flag",
                                         "set_mission_flag_own"):
            f = b["outcome_value"].strip()
            if f:
                sets[f].append(b["event_id"].strip())
        pre = b["prerequisite_flag"].strip()
        if pre:
            gates[pre].append(b["event_id"].strip())
    return sets, gates


def find_hidden_buttons(buttons, flag_sets):
    """Buttons _build_buttons() skips because their prerequisite can never hold.

    event_scene.gd:69 drops any button whose prerequisite_flag is non-empty and
    unsatisfied, and _check_prerequisite() only ever consults CountryFlags. A
    prerequisite nothing appends can never be met, so the button never renders.
    Mission flags are stored as "mission_<id>_<tile>", so a bare event id in
    this column is never satisfied by one.
    """
    out = []
    for b in buttons:
        pre = b["prerequisite_flag"].strip()
        if pre and pre.lstrip("!") not in flag_sets:
            out.append(b)
    return out


def find_misfiled_links(buttons, ids):
    """prerequisite_flag holding an event id, with next_event_id empty.

    A prerequisite is a flag name, never an event id, so this is a chain link
    that landed one column to the right.
    """
    out = []
    for b in buttons:
        pre = b["prerequisite_flag"].strip()
        if pre and pre in ids and not b["next_event_id"].strip():
            out.append(b)
    return out


def find_code_refs(ids):
    refs = defaultdict(list)
    for root, dirs, files in os.walk("."):
        dirs[:] = [d for d in dirs if d != ".git"]
        for fn in files:
            if not fn.endswith(".gd"):
                continue
            p = os.path.join(root, fn)
            try:
                lines = open(p, encoding="utf-8", errors="replace").read().splitlines()
            except OSError:
                continue
            for i, line in enumerate(lines, 1):
                for eid in ids:
                    if eid in line:
                        refs[eid].append(f"{p.lstrip('./')}:{i}")
    return refs


# ── RENDERING ────────────────────────────────────────────────────────────────
def quote(text):
    text = (text or "").strip()
    if not text:
        return "> _(empty)_"
    return "\n".join("> " + ln if ln.strip() else ">" for ln in text.split("\n"))


def slug(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")


def render_event(e, md, btns, trigs, outgoing, incoming, code_refs,
                 flag_sets, flag_gates, headline_of):
    eid = e["event_id"]
    L = []
    status = md.get("status", "UNTRACKED")
    L.append(f"### `{eid}` — {e['headline'].strip() or '(no headline)'}")
    L.append("")

    meta = [
        f"**Status** {status}",
        f"**Type** `{e['event_type'].strip() or '—'}`",
        f"**Country** `{e['country_cid'].strip() or '—'}`",
        f"**Tone** {e['tone'].strip() or '—'}",
    ]
    L.append(" · ".join(meta))

    chain = md.get("chain", "")
    pos = md.get("chain_pos", "")
    if chain or pos:
        L.append(f"**Chain** {chain or '—'}" + (f" · position {pos}" if pos else ""))

    prod = [
        f"**Art** `{e['image_tag'].strip() or '—'}`"
        + (f" ({md['art_status']})" if md.get("art_status") else ""),
        f"**Explicit art** {md.get('explicit_art','—') or '—'}",
        f"**Content flag** `{e['content_flag'].strip() or '—'}`",
        f"**Repeatable** {e['repeatable'].strip() or '—'}",
        f"**Cooldown** {e['cooldown_turns'].strip() or '0'}",
    ]
    L.append(" · ".join(prod))
    if e.get("_shifted"):
        L.append("")
        L.append("> ⚠️ Source row omits `content_flag`, shifting `repeatable`/`cooldown_turns`. "
                 "Values above are the corrected reading.")
    L.append("")

    # ── context in
    L.append("**Fires when**")
    L.append("")
    if trigs:
        for t in trigs:
            L.append(f"- {describe_trigger(t)}  <sub>`{t['trigger_id']}`</sub>")
    inb = incoming.get(eid, [])
    for label, src in inb:
        L.append(f"- Chained from `{src}` — {label} <sub>({headline_of.get(src,'')[:48]})</sub>")
    gates_here = [f for f, evs in flag_gates.items() if eid in evs]
    for f in gates_here:
        setters = flag_sets.get(f.lstrip("!"), [])
        where = ", ".join(f"`{s}`" for s in setters[:4]) or "_nothing sets this_"
        L.append(f"- Gated on flag `{f}` — set by {where}")
    if not trigs and not inb and not gates_here:
        refs = code_refs.get(eid, [])
        if refs:
            L.append("- Fired from code: " + ", ".join(f"`{r}`" for r in refs[:5]))
        else:
            L.append("- ⚠️ **No trigger row, no inbound chain link, no code reference.** "
                     "Draft is currently unreachable in game.")
    L.append("")

    # ── prose
    L.append("**Subhead — first draft**")
    L.append("")
    L.append(quote(e["short_desc"]))
    L.append("")
    L.append("**Body — first draft**")
    L.append("")
    L.append(quote(e["long_desc"]))
    L.append("")

    # ── choices
    L.append("**Choices & outcomes**")
    L.append("")
    if btns:
        L.append("| # | Button text | Type | What it does | Leads to |")
        L.append("|---|---|---|---|---|")
        for i, b in enumerate(btns, 1):
            leads = []
            nxt = b["next_event_id"].strip()
            if nxt:
                leads.append(f"`{nxt}`")
            if b["outcome_type"].strip() == "trigger_event" and b["outcome_value"].strip():
                leads.append(f"`{b['outcome_value'].strip()}`")
            txt = b["button_text"].strip().replace("|", "\\|") or "_(blank)_"
            does = describe_outcome(b).replace("|", "\\|")
            L.append(f"| {i} | {txt} | `{b['button_type'].strip() or '—'}` "
                     f"| {does} | {' , '.join(leads) or '—'} |")
    else:
        L.append("_No buttons in `event_buttons.csv`._ "
                 "Choices for this event are built at runtime in code.")
    L.append("")

    out = outgoing.get(eid, [])
    if out:
        L.append("**Leads to**")
        L.append("")
        for label, tgt in out:
            L.append(f"- {label} `{tgt}` — {headline_of.get(tgt,'')}")
        L.append("")

    if md.get("notes"):
        L.append(f"**Design notes** {md['notes']}")
        L.append("")

    # ── writing slot
    L.append("<details><summary><b>FINAL PASS — write here</b></summary>")
    L.append("")
    L.append("- **Headline:**")
    L.append("- **Subhead:**")
    L.append("- **Body:**")
    L.append("- **Button text:**")
    L.append("- **Notes:**")
    L.append("")
    L.append("</details>")
    L.append("")
    L.append("---")
    L.append("")
    return "\n".join(L)


def main():
    events, buttons, triggers = load_data()
    events = [normalise(e) for e in events]
    masterdoc = load_masterdoc()

    ids = {e["event_id"] for e in events}
    headline_of = {e["event_id"]: e["headline"].strip() for e in events}
    by_event_btn = defaultdict(list)
    for b in buttons:
        by_event_btn[b["event_id"].strip()].append(b)
    by_event_trig = defaultdict(list)
    for t in triggers:
        by_event_trig[t["event_id"].strip()].append(t)

    outgoing, incoming = build_graph(events, buttons)
    flag_sets, flag_gates = build_flag_graph(buttons)
    code_refs = find_code_refs(ids)
    misfiled = find_misfiled_links(buttons, ids)
    hidden = find_hidden_buttons(buttons, flag_sets)
    hidden_ids = {b["button_id"].strip() for b in hidden}
    # An event whose every button is hidden renders with no choices, and the
    # panel is only freed by a button press (event_scene.gd:137), so there is
    # no way out of it.
    buttonless = [e for e in events
                  if by_event_btn.get(e["event_id"])
                  and all(b["button_id"].strip() in hidden_ids
                          for b in by_event_btn[e["event_id"]])]

    # Order: follow the masterdoc's arc-coherent ordering, then CSV-only events.
    md_order = {eid: i for i, eid in enumerate(masterdoc)}
    events.sort(key=lambda e: (md_order.get(e["event_id"], 10_000),
                               e["event_id"]))

    groups = defaultdict(list)
    for e in events:
        cat = masterdoc.get(e["event_id"], {}).get("category") or "Untracked (not in masterdoc)"
        groups[cat].append(e)

    os.makedirs(OUT_DIR, exist_ok=True)
    cat_order = [c for c in dict.fromkeys(
        masterdoc[eid]["category"] for eid in masterdoc)] + ["Untracked (not in masterdoc)"]
    cat_order = [c for c in cat_order if c in groups]

    written = []
    for n, cat in enumerate(cat_order, 1):
        evs = groups[cat]
        fname = f"{n:02d}_{slug(cat)}.md"
        counts = Counter(masterdoc.get(e["event_id"], {}).get("status", "UNTRACKED")
                         for e in evs)
        body = [f"# {cat}", ""]
        body.append(f"{len(evs)} events · "
                    + " · ".join(f"{k} {v}" for k, v in counts.most_common()))
        body.append("")
        body.append("[← back to index](00_INDEX.md)")
        body.append("")
        body.append("---")
        body.append("")
        for e in evs:
            eid = e["event_id"]
            body.append(render_event(
                e, masterdoc.get(eid, {}), by_event_btn.get(eid, []),
                by_event_trig.get(eid, []), outgoing, incoming, code_refs,
                flag_sets, flag_gates, headline_of))
        with open(os.path.join(OUT_DIR, fname), "w", encoding="utf-8") as fh:
            fh.write("\n".join(body))
        written.append((fname, cat, len(evs), counts))

    write_index(written, events, masterdoc, by_event_btn, by_event_trig,
                incoming, code_refs, flag_sets, flag_gates, ids, misfiled,
                hidden, buttonless)
    print(f"Wrote {len(written) + 1} files to {OUT_DIR}/")
    for fname, cat, n, counts in written:
        print(f"  {fname:34} {cat:34} {n:4} events")


def write_index(written, events, masterdoc, by_event_btn, by_event_trig,
                incoming, code_refs, flag_sets, flag_gates, ids, misfiled,
                hidden, buttonless):
    total = len(events)
    status_counts = Counter(masterdoc.get(e["event_id"], {}).get("status", "UNTRACKED")
                            for e in events)

    unreachable = []
    for e in events:
        eid = e["event_id"]
        if (not by_event_trig.get(eid) and not incoming.get(eid)
                and not code_refs.get(eid)
                and not [f for f, evs in flag_gates.items() if eid in evs]):
            unreachable.append(e)

    no_buttons = [e for e in events if not by_event_btn.get(e["event_id"])]
    shifted = [e for e in events if e.get("_shifted")]
    md_only = sorted(set(masterdoc) - ids)
    unset_gates = sorted(f for f in flag_gates if f.lstrip("!") not in flag_sets)

    L = ["# Event dossier — writer's packet", ""]
    L.append("Generated by `scripts/build_event_dossier.py`. Regenerate after any "
             "change to `data/events.csv`, `data/event_buttons.csv`, "
             "`data/event_triggers.csv`, or the masterdoc's status column.")
    L.append("")
    L.append("Every entry carries the first-draft prose, the context that makes it "
             "fire, each button's mechanical outcome, where those buttons lead, and "
             "a collapsed **FINAL PASS** slot to write into.")
    L.append("")
    L.append("## Status roll-up")
    L.append("")
    L.append("| Status | Events |")
    L.append("|---|---|")
    for k, v in status_counts.most_common():
        L.append(f"| {k} | {v} |")
    L.append(f"| **Total** | **{total}** |")
    L.append("")
    L.append("## Files")
    L.append("")
    L.append("| File | Category | Events | Status breakdown |")
    L.append("|---|---|---|---|")
    for fname, cat, n, counts in written:
        br = ", ".join(f"{k} {v}" for k, v in counts.most_common())
        L.append(f"| [{fname}]({fname}) | {cat} | {n} | {br} |")
    L.append("")

    L.append("## Reading an entry")
    L.append("")
    L.append("- **Fires when** — explicit trigger rows, inbound chain links, flag "
             "gates, or the code site that spawns it. An `X_INTIMATE` event is "
             "reached from `X` when the player picks *intimate* at the scene-nav "
             "prompt (`event_scene.gd:114`).")
    L.append("- **Choices & outcomes** — one row per button: its text, its "
             "mechanical effect, and any event it leads to.")
    L.append("- **Leads to** — the outbound edges, with the target's headline, so "
             "you can write a hand-off that lands.")
    L.append("")

    L.append("## Data integrity")
    L.append("")
    L.append("Findings from generating this packet. None of these are prose "
             "problems — they are wiring issues worth deciding on before the "
             "final pass locks the text.")
    L.append("")

    L.append(f"### Malformed source rows ({len(REPAIRS)})")
    L.append("")
    if REPAIRS:
        L.append("| File | Line | Row | Repair applied for this packet |")
        L.append("|---|---|---|---|")
        for path, lineno, rid, what in REPAIRS:
            L.append(f"| `{path}` | {lineno} | `{rid}` | {what} |")
        L.append("")
        L.append("These are repaired **on read only** — the CSVs still contain the "
                 "malformed rows.")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Unreachable drafts ({len(unreachable)})")
    L.append("")
    L.append("Prose exists, but nothing found in the data or the code can reach it. "
             "Either the wiring is missing or the draft is a spare.")
    L.append("")
    if unreachable:
        L.append("| Event | Category | Status | Headline |")
        L.append("|---|---|---|---|")
        for e in unreachable:
            md = masterdoc.get(e["event_id"], {})
            L.append(f"| `{e['event_id']}` | {md.get('category','—')} "
                     f"| {md.get('status','UNTRACKED')} | {e['headline'].strip()[:60]} |")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Events that render with no usable choice ({len(buttonless)})")
    L.append("")
    L.append("Every button on these events is dropped by `_build_buttons()` "
             "(`event_scene.gd:69`) because its prerequisite can never hold. The "
             "panel is only freed by a button press (`event_scene.gd:137`) and the "
             "scene has no close control, so reaching one of these leaves the "
             "player with an undismissable modal.")
    L.append("")
    if buttonless:
        L.append("| Event | Category | Headline |")
        L.append("|---|---|---|")
        for e in buttonless:
            md = masterdoc.get(e["event_id"], {})
            L.append(f"| `{e['event_id']}` | {md.get('category','—')} "
                     f"| {e['headline'].strip()[:60]} |")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Buttons hidden by an unsatisfiable prerequisite ({len(hidden)})")
    L.append("")
    L.append("`prerequisite_flag` names a flag no button ever sets.")
    L.append("")
    if hidden:
        L.append("| Button | On event | Button text | Waiting on |")
        L.append("|---|---|---|---|")
        for b in hidden:
            L.append(f"| `{b['button_id'].strip()}` | `{b['event_id'].strip()}` "
                     f"| {b['button_text'].strip()} | `{b['prerequisite_flag'].strip()}` |")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Chain links filed in the wrong column ({len(misfiled)})")
    L.append("")
    L.append("`prerequisite_flag` holds a value that is itself an event id, while "
             "`next_event_id` is empty. A prerequisite is a flag name, never an "
             "event id, so the link landed one column to the right and the chain "
             "is broken in game.")
    L.append("")
    if misfiled:
        L.append("| Button | On event | Button text | Sitting in `prerequisite_flag` |")
        L.append("|---|---|---|---|")
        for b in misfiled:
            L.append(f"| `{b['button_id'].strip()}` | `{b['event_id'].strip()}` "
                     f"| {b['button_text'].strip()} | `{b['prerequisite_flag'].strip()}` |")
        L.append("")
        L.append("Moving each value into `next_event_id` restores the link. The "
                 "masterdoc design note for these events already describes the "
                 "intended chain, so the intent is not in doubt.")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Flags gated but never set ({len(unset_gates)})")
    L.append("")
    if unset_gates:
        for f in unset_gates:
            L.append(f"- `{f}` — gates {', '.join(f'`{e}`' for e in flag_gates[f])}")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Column-shifted rows ({len(shifted)})")
    L.append("")
    L.append("Authored without a `content_flag` value, so `repeatable` and "
             "`cooldown_turns` sit one column to the right. `world.gd:5521` already "
             "guards against the `content_flag == \"false\"` case at runtime, so this "
             "is data hygiene rather than a live bug. This packet reports the "
             "corrected reading.")
    L.append("")
    if shifted:
        L.append(", ".join(f"`{e['event_id']}`" for e in shifted))
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### In the masterdoc but not in `events.csv` ({len(md_only)})")
    L.append("")
    L.append("Tracked as planned work with no row in the data yet.")
    L.append("")
    if md_only:
        L.append("| Event | Category | Status |")
        L.append("|---|---|---|")
        for eid in md_only:
            md = masterdoc[eid]
            L.append(f"| `{eid}` | {md.get('category','—')} | {md.get('status','—')} |")
    else:
        L.append("_None._")
    L.append("")

    L.append(f"### Events with no button rows ({len(no_buttons)})")
    L.append("")
    L.append("Their choices are assembled at runtime in code, so button text for "
             "these lives in `.gd` files rather than the CSV.")
    L.append("")
    if no_buttons:
        L.append(", ".join(f"`{e['event_id']}`" for e in no_buttons))
    else:
        L.append("_None._")
    L.append("")

    with open(os.path.join(OUT_DIR, "00_INDEX.md"), "w", encoding="utf-8") as fh:
        fh.write("\n".join(L))


if __name__ == "__main__":
    main()
