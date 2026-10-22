#!/usr/bin/env python3
"""
pick_ethertask.py — Pull one unfinished content item from the AmericaRush manifest.

When data/americarush.csv exists it is used as the EXCLUSIVE task source.
Tasks are tiered: all P0 items clear before P1, P1 before P2, P2 before P3.
CODE / EDITOR / ASSET tasks track their own done-state in the CSV (status=DONE).
EVENT / ICON / DOCTRINE / FACTION / LAW tasks are marked done through their
normal builder scripts; this picker cross-checks builder data to detect completion.

Run:  python3 scripts/pick_ethertask.py          # show current task (or pick one)
      python3 scripts/pick_ethertask.py --next    # skip current, pick next
      python3 scripts/pick_ethertask.py --seed 42 # force a specific seed (picks new)

State:  data/current_ethertask.json  — persists the active task between runs.
        The task is shown on every /ethertask call until it is marked complete.
        At that point the next call auto-advances to the next task.
"""
import sys, os, json, importlib.util, random, re as _re, glob as _glob
from datetime import date, datetime

_PORTRAIT_DIR = "art assets/finishedAssets/religiousIcons"

def _slug(name):
    return _re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")

def _portrait_check(slug):
    color = bool(_glob.glob(f"{_PORTRAIT_DIR}/{slug}.*"))
    bw    = bool(_glob.glob(f"{_PORTRAIT_DIR}/{slug}_bw.*"))
    if color and bw:   return "Done"
    if color:          return "BW Missing"
    return "Not Started"

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
        p_slug   = _slug(name)
        p_status = _portrait_check(p_slug)
        w = 4 if status in ("IDEA", "FIRST DRAFT") else 2
        if a_status == "Needed":
            w += 1
        if p_status != "Done":
            w += 2
        art_out = art_tag if art_tag != "—" else name.lower().replace(" ", "_")
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Icons ({country} · {tier})",
            "id": name,
            "name": f"{name}  ({dates})",
            "status": status,
            "art_tag": art_out,
            "art_status": a_status,
            "portrait_slug": p_slug,
            "portrait_status": p_status,
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
            art_tag = eid.lower() + "_scene"
            import glob as _glob
            art_matches = _glob.glob(
                f"art assets/AmericanRevolutionArt/Panel/{art_tag}.*"
            )
            art_status = "Integrated" if art_matches else "Not Started"
            tasks.append({
                "w": 3,
                "source": f"Flavordoc › {label}",
                "id": eid,
                "name": headline,
                "status": status,
                "art_tag": art_tag,
                "art_status": art_status,
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
        p_slug   = _slug(name)
        p_status = _portrait_check(p_slug)
        w = 5 if status in ("IDEA", "FIRST DRAFT") else 1
        if p_status != "Done":
            w += 2
        tasks.append({
            "w": w,
            "source": f"Flavordoc › Doctrines ({country} · {tier})",
            "id": name,
            "name": name,
            "status": status,
            "art_tag": "—",
            "art_status": "N/A",
            "portrait_slug": p_slug,
            "portrait_status": p_status,
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


# ── AmericaRush manifest path ─────────────────────────────────────────────────
RUSH_CSV = os.path.join(ROOT, "data", "americarush.csv")

# Category sets
_DIRECT_CATS   = {"CODE", "EDITOR", "ASSET"}   # done via CSV status=DONE
_CONTENT_CATS  = {"EVENT", "ICON", "DOCTRINE", "FACTION", "LAW"}

# Priority weights used for random selection WITHIN a tier
_PRIO_WEIGHT = {"P0": 10, "P1": 5, "P2": 3, "P3": 1}


def _read_rush_manifest():
    """Return list of dicts from americarush.csv."""
    import csv as _csv
    with open(RUSH_CSV, newline="", encoding="utf-8") as f:
        return list(_csv.DictReader(f))


def _write_rush_manifest(rows):
    """Rewrite americarush.csv preserving column order."""
    import csv as _csv
    fieldnames = ["id", "name", "category", "priority", "status", "notes"]
    with open(RUSH_CSV, "w", newline="", encoding="utf-8") as f:
        w = _csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)


def mark_rush_done(task_id):
    """Mark a CODE/EDITOR/ASSET row as DONE in americarush.csv."""
    rows = _read_rush_manifest()
    for r in rows:
        if r["id"] == task_id:
            r["status"] = "DONE"
    _write_rush_manifest(rows)


def collect_rush():
    """
    Build task list from americarush.csv.

    - CODE/EDITOR/ASSET: done if status==DONE in CSV.
    - Content tasks (EVENT/ICON/etc): done if the builder data shows FULL PASS/FULL COMPLETION.
      We cross-check by running the normal collect() and building a lookup dict.
    Returns a list of task dicts identical in shape to collect() output,
    plus an extra "rush_priority" key.
    """
    if not os.path.exists(RUSH_CSV):
        return collect()

    manifest = _read_rush_manifest()

    # Build lookup of task-id → task dict from the standard collector
    # (only for content categories, to avoid expensive builder loads when not needed)
    content_rows = [r for r in manifest if r["category"] in _CONTENT_CATS]
    content_ids  = {r["id"] for r in content_rows}

    content_lookup = {}
    if content_ids:
        for t in collect():
            if t["id"] in content_ids:
                content_lookup[t["id"]] = t

    tasks = []
    for row in manifest:
        cat  = row["category"]
        prio = row["priority"]
        rid  = row["id"]

        if cat in _DIRECT_CATS:
            if row["status"] == "DONE":
                continue
            # Build a synthetic task dict for display
            tasks.append({
                "w":           _PRIO_WEIGHT.get(prio, 1),
                "rush_priority": prio,
                "source":      f"AmericaRush › {cat}",
                "id":          rid,
                "name":        row["name"],
                "status":      row["status"],
                "art_tag":     "",
                "art_status":  "N/A",
                "flag":        "",
                "notes":       row["notes"],
                "script":      "",
                "attr":        "",
                "done_status": "DONE",
                "done_art":    "",
                "regen":       f"Mark DONE in data/americarush.csv  (row {rid})",
                "csv":         None,
                "is_direct":   True,
            })

        elif cat in _CONTENT_CATS:
            t = content_lookup.get(rid)
            if t is None:
                continue  # already FULL PASS/COMPLETION — not in collect() pool
            t = dict(t)
            t["rush_priority"] = prio
            t["w"] = _PRIO_WEIGHT.get(prio, 1)
            # Boost weight when art is still needed
            if t.get("art_status") not in ("N/A", "Done", "Integrated"):
                t["w"] += 2
            tasks.append(t)

    return tasks


def _pick_from_rush(tasks, rng):
    """
    Priority-tiered selection: clear all P0 before P1, etc.
    Within a tier use weighted random choice.
    """
    for tier in ("P0", "P1", "P2", "P3"):
        pool = [t for t in tasks if t.get("rush_priority") == tier]
        if pool:
            weights = [t["w"] for t in pool]
            return rng.choices(pool, weights=weights, k=1)[0]
    return rng.choices(tasks, k=1)[0]


def _rush_mode():
    return os.path.exists(RUSH_CSV)


def _rush_remaining(tasks):
    by_prio = {}
    for t in tasks:
        p = t.get("rush_priority", "P?")
        by_prio[p] = by_prio.get(p, 0) + 1
    return by_prio


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
    rush = _rush_mode()
    tasks = collect_rush() if rush else collect()
    force_next = "--next" in sys.argv
    force_seed = "--seed" in sys.argv

    if not tasks:
        _clear_state()
        print("ALL TASKS COMPLETE — nothing left in the AmericaRush queue!")
        return

    # ── Determine the active task ─────────────────────────────────────────────
    state = _load_state()
    t = None
    continuing = False

    if not force_next and not force_seed and state:
        t = _find_task(tasks, state["id"], state["source"])
        if t:
            continuing = True

    if t is None:
        if force_seed:
            try:
                seed_val = int(sys.argv[sys.argv.index("--seed") + 1])
            except (IndexError, ValueError):
                seed_val = int(date.today().strftime("%Y%j"))
        else:
            seed_val = int(date.today().strftime("%Y%j"))

        rng = random.Random(seed_val)
        if rush:
            t = _pick_from_rush(tasks, rng)
        else:
            weights = [t["w"] for t in tasks]
            t = rng.choices(tasks, weights=weights, k=1)[0]
        _save_state(t)

    seed_val = int(date.today().strftime("%Y%j"))

    # ── CARD ──────────────────────────────────────────────────────────────────
    W    = 62
    rule = "━" * W
    line = "─" * (W - 2)

    is_direct      = t.get("is_direct", False)
    needs_art      = not is_direct and t["art_status"] not in ("N/A", "Done", "Integrated")
    needs_portrait = not is_direct and t.get("portrait_status") not in (None, "Done")
    flag_str       = f"  [{t['flag'].upper()}]" if t.get("flag") else ""

    mode_str  = "CONTINUING" if continuing else "NEW TASK"
    prio_str  = f"  ·  {t['rush_priority']}" if rush and t.get("rush_priority") else ""
    hdr_label = "AMERICA RUSH" if rush else "ETHER TASK"

    print(rule)
    print(f"  {hdr_label}  ·  {mode_str}{prio_str}  ·  {date.today().strftime('%B %d, %Y')}")
    print(rule)
    print(f"  SOURCE   {t['source']}")
    print(f"  ID       {t['id']}")
    print(f"  NAME     {t['name']}{flag_str}")
    print(f"  STATUS   {t['status']}")

    if needs_art:
        print(f"\n  ── ART {line[5:]}")
        print(f"  Tag:     {t['art_tag']}")
        print(f"  Status:  {t['art_status']}")

    if needs_portrait:
        p_slug   = t["portrait_slug"]
        p_status = t["portrait_status"]
        print(f"\n  ── PORTRAITS {line[11:]}")
        print(f"  Status:  {p_status}")
        if p_status == "Not Started":
            print(f"  Color  → {_PORTRAIT_DIR}/{p_slug}.png")
        print(f"  BW     → {_PORTRAIT_DIR}/{p_slug}_bw.png")

    if t.get("notes") and t["notes"].strip() not in ("—", ""):
        hdr_lbl = "WHAT TO DO" if is_direct else "TEXT"
        print(f"\n  ── {hdr_lbl} {line[len(hdr_lbl)+1:]}")
        note = t["notes"].replace("\n", " · ")
        if len(note) > 200:
            note = note[:197] + "…"
        print(f"  {note}")

    print(f"\n  ── TO COMPLETE {line[13:]}")
    step = 1

    if is_direct:
        print(f"  {step}. Complete the task described above")
        step += 1
        print(f"  {step}. Run:  python3 scripts/pick_ethertask.py --close-direct {t['id']}")
        step += 1
    else:
        if needs_art:
            art_dir = "art assets/AmericanRevolutionArt/Panel"
            print(f"  {step}. Draw 1 illustration")
            print(f"     Save to: {art_dir}/{t['art_tag']}.png")
            step += 1

        if needs_portrait:
            p_slug   = t["portrait_slug"]
            p_status = t["portrait_status"]
            if p_status == "Not Started":
                print(f"  {step}. Draw portrait (color) → {_PORTRAIT_DIR}/{p_slug}.png")
                step += 1
            print(f"  {step}. Draw portrait (BW)    → {_PORTRAIT_DIR}/{p_slug}_bw.png")
            step += 1

        if t.get("csv"):
            print(f"  {step}. Polish headline + text in  {t['csv']}  (row {t['id']})")
        elif t.get("script"):
            print(f"  {step}. Polish text/effect in  scripts/{t['script']}  ({t['attr']})")
        step += 1

        if t.get("script"):
            print(f"  {step}. In scripts/{t['script']} ({t['attr']}):")
            print(f"     status  → \"{t['done_status']}\"")
            if needs_art and t.get("done_art") not in ("N/A", ""):
                print(f"     art     → \"{t['done_art']}\"")
            step += 1

        if t.get("regen"):
            print(f"  {step}. {t['regen']}")

    # Handle --close-direct flag
    if "--close-direct" in sys.argv:
        try:
            close_id = sys.argv[sys.argv.index("--close-direct") + 1]
            mark_rush_done(close_id)
            _clear_state()
            print(f"\n  Marked {close_id} as DONE in americarush.csv.")
        except (IndexError, ValueError):
            pass
        return

    print(rule)
    remaining = len(tasks)
    if rush:
        by_prio = _rush_remaining(tasks)
        prio_summary = "  ".join(f"{p}:{n}" for p, n in sorted(by_prio.items()))
        if continuing:
            print(f"  AmericaRush: {remaining} tasks remaining  ·  {prio_summary}")
            print(f"  Task is ACTIVE until completed. Run pick_ethertask.py --next to skip.")
        else:
            print(f"  AmericaRush: {remaining} tasks remaining  ·  {prio_summary}")
    else:
        if continuing:
            print(f"  Tasks in pool: {remaining}  ·  This task is ACTIVE until marked complete.")
            print(f"  Complete it, update status in source, then run:  python3 scripts/pick_ethertask.py")
            print(f"  To skip ahead without completing:  pick_ethertask.py --next")
        else:
            print(f"  Tasks in pool: {remaining}  ·  seed {seed_val}  ·  use --seed N for another")
    print(rule)


if __name__ == "__main__":
    main()
