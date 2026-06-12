#!/usr/bin/env python3
"""
pick_ethertask.py — Pull one unfinished content item from all masterdocs.
Prints a single focused task card (one event, one art, one text).

Run:  python3 scripts/pick_ethertask.py          # show current task (or pick one)
      python3 scripts/pick_ethertask.py --next    # mark current done, pick next
      python3 scripts/pick_ethertask.py --seed 42 # force a specific seed (picks new)

State:  data/current_ethertask.json  — persists the active task between runs.
        The task is shown on every /ethertask call until it is marked complete
        in its source data (status → FULL PASS/FULL COMPLETION).  At that point
        the next call auto-advances to the next task.
"""
import sys, os, json, importlib.util, random
from datetime import date, datetime

STATE_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                          "data", "current_ethertask.json")

ROOT    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCR_DIR = os.path.join(ROOT, "scripts")

def _load(filename):
    path = os.path.join(SCR_DIR, filename)
    spec = importlib.util.spec_from_file_location("_bld_tmp", path)
    mod  = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod

DONE = {"FULL PASS", "FULL COMPLETION"}


def collect():
    tasks = []

    # ── EVENTS (build_event_masterdoc.py → EVENTS) ────────────────────────────
    # tuple: category, chain, eid, headline, _, _, _, status, art_tag, art_status,
    #        explicit_art, content_flag, cooldown, notes
    ev = _load("build_event_masterdoc.py")
    for t in ev.EVENTS:
        (category, chain, eid, headline,
         _cp, _par, _chi,
         status, art_tag, art_status, explicit_art, content_flag, _cd, notes) = t
        if status in DONE:
            continue
        w = 4 if status == "IDEA" else 3
        if art_status == "Not Started" and content_flag in ("explicit", "kinky"):
            w += 4
        elif art_status == "Not Started":
            w += 2
        # Fall back to event-id-derived name when art tag is blank
        effective_art_tag = art_tag if art_tag else eid.lower() + "_scene"
        tasks.append({
            "w": w,
            "source": f"Events › {category}",
            "id": eid,
            "name": headline,
            "status": status,
            "art_tag": effective_art_tag,
            "art_status": art_status,
            "flag": content_flag,
            "notes": notes,
            "script": "build_event_masterdoc.py",
            "attr": "EVENTS",
            "done_status": "FULL COMPLETION",
            "done_art": "Integrated",
            "regen": "python3 scripts/build_event_masterdoc.py",
            "csv": "data/events.csv",
        })

    # ── PRESLIB GALLERY (build_preslib_masterdoc.py → GALLERY_DATA) ───────────
    # tuple: group, id, name, content_flag, trigger, flavor,
    #        writing_status, art_status, art_path, notes
    pres = _load("build_preslib_masterdoc.py")
    for t in pres.GALLERY_DATA:
        (group, gid, name, content_flag, trigger, flavor,
         w_status, art_status, _path, notes) = t
        if w_status in DONE and art_status == "Done":
            continue
        w = 4 if w_status in ("IDEA", "FIRST DRAFT", "STUB") else 3
        if art_status == "Not Started" and content_flag in ("explicit", "kinky"):
            w += 4
        elif art_status == "Not Started":
            w += 2
        tasks.append({
            "w": w,
            "source": f"Presidential Library › {group}",
            "id": gid,
            "name": name,
            "status": w_status,
            "art_tag": gid.lower(),
            "art_status": art_status,
            "flag": content_flag,
            "notes": flavor or trigger or "",
            "script": "build_preslib_masterdoc.py",
            "attr": "GALLERY_DATA",
            "done_status": "FULL PASS",
            "done_art": "Done",
            "regen": "python3 scripts/build_preslib_masterdoc.py",
            "csv": None,
        })

    # ── FLAVORDOC: ICONS ───────────────────────────────────────────────────────
    # tuple: country, tier, name, dates, building_effect, art_tag, status, description
    flav = _load("build_flavordoc.py")
    for t in flav.ICONS:
        country, tier, name, dates, bldg_fx, art_tag, status, desc = t
        if status in DONE:
            continue
        a_status = "Not Started" if art_tag == "—" else "Needed"
        w = 4 if status in ("IDEA", "FIRST DRAFT") else 2
        if a_status == "Needed":
            w += 1
        art_out = art_tag if art_tag != "—" else name.lower().replace(" ", "_")
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Icons ({country} · {tier})",
            "id": name,
            "name": f"{name}  ({dates})",
            "status": status,
            "art_tag": art_out,
            "art_status": a_status,
            "flag": "",
            "notes": f"{bldg_fx}  ·  {desc}",
            "script": "build_flavordoc.py",
            "attr": "ICONS",
            "done_status": "FULL PASS",
            "done_art": "Done",
            "regen": "python3 scripts/build_flavordoc.py",
            "csv": None,
        })

    # ── FLAVORDOC: GOVERNORS ─────────────────────────────────────────────────
    # tuple: country, id, name, role, faction, ideology, description, status
    for t in flav.GOVERNORS:
        country, gov_id, name, role, faction, ideology, desc, status = t
        if status in DONE:
            continue
        w = 4 if status in ("IDEA", "FIRST DRAFT") else 2
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Governors ({country})",
            "id": gov_id,
            "name": f"{name}  [{role}]",
            "status": status,
            "art_tag": f"gov_{gov_id.lower()}",
            "art_status": "Not Started",
            "flag": "",
            "notes": f"{faction}  ·  {ideology}  ·  {desc}",
            "script": "build_flavordoc.py",
            "attr": "GOVERNORS",
            "done_status": "FULL PASS",
            "done_art": "Done",
            "regen": "python3 scripts/build_flavordoc.py",
            "csv": None,
        })

    # ── FLAVORDOC: VP_ARC + CA_PM_ARC ─────────────────────────────────────────
    # tuple: eid, headline, trigger, effect, buttons, status
    for attr, label in (("VP_ARC", "VP Arc"), ("CA_PM_ARC", "CA PM Arc")):
        for t in getattr(flav, attr, []):
            eid, headline, trigger, effect, buttons, status = t
            if status in DONE:
                continue
            tasks.append({
                "w": 3,
                "source": f"Flavordoc › {label}",
                "id": eid,
                "name": headline,
                "status": status,
                "art_tag": eid.lower() + "_scene",
                "art_status": "Not Started",
                "flag": "",
                "notes": f"{trigger}  ·  {effect}",
                "script": "build_flavordoc.py",
                "attr": attr,
                "done_status": "FULL PASS",
                "done_art": "Done",
                "regen": "python3 scripts/build_flavordoc.py",
                "csv": "data/events.csv",
            })

    # ── FLAVORDOC: LAWS ───────────────────────────────────────────────────────
    # tuple: country, name, category, effect, hist_ref, flavor_text, icon_path, status
    for t in flav.LAWS:
        country, name, category, effect, hist_ref, flavor_text, icon_path, status = t
        if status in DONE:
            continue
        w = 5 if status in ("IDEA", "FIRST DRAFT") else 1
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Laws ({country})",
            "id": name,
            "name": name,
            "status": status,
            "art_tag": "—",
            "art_status": "N/A",
            "flag": "",
            "notes": effect or flavor_text or "",
            "script": "build_flavordoc.py",
            "attr": "LAWS",
            "done_status": "FULL PASS",
            "done_art": "N/A",
            "regen": "python3 scripts/build_flavordoc.py",
            "csv": None,
        })

    # ── FLAVORDOC: DOCTRINES ─────────────────────────────────────────────────
    # tuple: country, tier, name, hist_ref, year, effect, notes, axis, status
    for t in flav.DOCTRINES:
        country, tier, name, hist_ref, year, effect, notes, axis, status = t
        if status in DONE:
            continue
        w = 5 if status in ("IDEA", "FIRST DRAFT") else 1
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Doctrines ({country} · {tier})",
            "id": name,
            "name": name,
            "status": status,
            "art_tag": "—",
            "art_status": "N/A",
            "flag": "",
            "notes": effect or "",
            "script": "build_flavordoc.py",
            "attr": "DOCTRINES",
            "done_status": "FULL PASS",
            "done_art": "N/A",
            "regen": "python3 scripts/build_flavordoc.py",
            "csv": None,
        })

    return tasks


def _load_state():
    try:
        with open(STATE_PATH) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return None


def _save_state(task, started_at=None):
    payload = {
        "id": task["id"],
        "source": task["source"],
        "started_at": started_at or datetime.now().isoformat(),
    }
    with open(STATE_PATH, "w") as f:
        json.dump(payload, f, indent=2)


def _clear_state():
    try:
        os.remove(STATE_PATH)
    except FileNotFoundError:
        pass


def _find_task(tasks, task_id, source):
    for t in tasks:
        if t["id"] == task_id and t["source"] == source:
            return t
    return None


def main():
    tasks = collect()
    force_next = "--next" in sys.argv
    force_seed = "--seed" in sys.argv

    if not tasks:
        _clear_state()
        print("🎉  ALL CONTENT IS FULL PASS — nothing left to finish!")
        return

    # ── Determine the active task ─────────────────────────────────────────────
    state = _load_state()
    t = None
    continuing = False

    if not force_next and not force_seed and state:
        # Try to find the stored task in the current unfinished pool
        t = _find_task(tasks, state["id"], state["source"])
        if t:
            continuing = True
        # If not found, it was completed — fall through to pick a new one

    if t is None:
        # Pick a new task
        if force_seed:
            try:
                seed_val = int(sys.argv[sys.argv.index("--seed") + 1])
            except (IndexError, ValueError):
                seed_val = int(date.today().strftime("%Y%j"))
        else:
            seed_val = int(date.today().strftime("%Y%j"))

        rng = random.Random(seed_val)
        weights = [t["w"] for t in tasks]
        t = rng.choices(tasks, weights=weights, k=1)[0]
        _save_state(t)

    seed_val = int(date.today().strftime("%Y%j"))

    # ── CARD ──────────────────────────────────────────────────────────────────
    W    = 62
    rule = "━" * W
    line = "─" * (W - 2)

    needs_art = t["art_status"] not in ("N/A", "Done", "Integrated")
    flag_str  = f"  [{t['flag'].upper()}]" if t["flag"] else ""

    mode_str = "CONTINUING" if continuing else "NEW TASK"

    print(rule)
    print(f"  ETHER TASK  ·  {mode_str}  ·  {date.today().strftime('%B %d, %Y')}")
    print(rule)
    print(f"  SOURCE   {t['source']}")
    print(f"  ID       {t['id']}")
    print(f"  NAME     {t['name']}{flag_str}")
    print(f"  STATUS   {t['status']}")

    if needs_art:
        print(f"\n  ── ART {line[5:]}")
        print(f"  Tag:     {t['art_tag']}")
        print(f"  Status:  {t['art_status']}")

    if t["notes"] and t["notes"].strip() not in ("—", ""):
        print(f"\n  ── TEXT {line[6:]}")
        note = t["notes"].replace("\n", " · ")
        if len(note) > 160:
            note = note[:157] + "…"
        print(f"  {note}")

    print(f"\n  ── TO COMPLETE {line[13:]}")
    step = 1

    if needs_art:
        art_dir = "art assets/AmericanRevolutionArt/Panel"
        print(f"  {step}. Draw 1 illustration")
        print(f"     Save to: {art_dir}/{t['art_tag']}.png")
        step += 1

    if t["csv"]:
        print(f"  {step}. Polish headline + text in  {t['csv']}  (row {t['id']})")
    else:
        print(f"  {step}. Polish text/effect in  scripts/{t['script']}  ({t['attr']})")
    step += 1

    print(f"  {step}. In scripts/{t['script']} ({t['attr']}):")
    print(f"     status  → \"{t['done_status']}\"")
    if needs_art and t["done_art"] not in ("N/A", ""):
        print(f"     art     → \"{t['done_art']}\"")
    step += 1

    print(f"  {step}. {t['regen']}")

    print(rule)
    remaining = len(tasks)
    if continuing:
        print(f"  Tasks in pool: {remaining}  ·  This task is ACTIVE until marked complete.")
        print(f"  Complete it, update status in source, then run:  python3 scripts/pick_ethertask.py")
        print(f"  To skip ahead without completing:  pick_ethertask.py --next")
    else:
        print(f"  Tasks in pool: {remaining}  ·  seed {seed_val}  ·  use --seed N for another")
    print(rule)


if __name__ == "__main__":
    main()
