#!/usr/bin/env python3
"""
integrate_art.py — Wire a PNG art asset into the game and update all tracking.

Usage:
    python3 scripts/integrate_art.py <source_path> <event_id_or_gallery_id>

    source_path  — path to the PNG (absolute or relative to repo root)
    id           — event_id from events.csv  (e.g. CAN_ALLIANCE_SIGNED)
                   OR gallery id from build_preslib_masterdoc.py  (e.g. WH_SECRET_01)

What it does:
    1. Locates the source PNG
    2. Looks up the art destination from events.csv image_tag or preslib art_path
    3. Copies the PNG to the correct Panel/gallery folder with the correct filename
    4. Updates build_event_masterdoc.py or build_preslib_masterdoc.py:
         art_status: "Not Started" → "Integrated"
    5. If text status is already "FIRST PASS" or better, promotes to "FULL COMPLETION"
    6. Regenerates the relevant masterdoc xlsx
    7. Prints a clear summary of everything that changed

Examples:
    python3 scripts/integrate_art.py ~/Downloads/can_alliance_signed_scene.png CAN_ALLIANCE_SIGNED
    python3 scripts/integrate_art.py /tmp/uploaded.png WH_SECRET_01
    python3 scripts/integrate_art.py art_assets/draft.png BIRTH_OF_LIBERTY
"""

import sys
import os
import csv
import shutil
import subprocess
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Art destination roots
PANEL_DIR  = ROOT / "art assets" / "AmericanRevolutionArt" / "Panel"
PRESLIB_DIR = ROOT / "art assets" / "AmericanRevolutionArt" / "Panel"  # same dir for now

EVENTS_CSV        = ROOT / "data" / "events.csv"
EVENT_SCRIPT      = ROOT / "scripts" / "build_event_masterdoc.py"
PRESLIB_SCRIPT    = ROOT / "scripts" / "build_preslib_masterdoc.py"

DONE_STATUSES = {"FULL PASS", "FULL COMPLETION"}
PASS_STATUSES = {"FIRST PASS", "FULL PASS", "FULL COMPLETION"}


# ── Utilities ─────────────────────────────────────────────────────────────────

def _err(msg):
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(1)


def _find_event_in_csv(event_id: str) -> dict | None:
    """Return the row dict for event_id from events.csv, or None."""
    with open(EVENTS_CSV, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row["event_id"].strip() == event_id:
                return row
    return None


def _update_csv_image_tag(event_id: str, image_tag: str):
    """Set image_tag in events.csv for the given event_id."""
    rows = []
    updated = False
    with open(EVENTS_CSV, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            if row["event_id"].strip() == event_id:
                if not row.get("image_tag", "").strip():
                    row["image_tag"] = image_tag
                    updated = True
            rows.append(row)

    if updated:
        with open(EVENTS_CSV, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)
        print(f"  ✓ events.csv: image_tag set to '{image_tag}'")
    else:
        print(f"  · events.csv: image_tag already set, no change")


def _update_script_art_status(script_path: Path, target_id: str,
                               old_status: str = "Not Started",
                               new_status: str = "Integrated",
                               also_promote_text: bool = False) -> tuple[bool, bool]:
    """
    In the given Python masterdoc script, find the tuple for target_id and:
      - Replace the first occurrence of old_status after the id line with new_status
      - If also_promote_text=True and text status is FIRST PASS, promote to FULL COMPLETION

    Returns (art_updated, text_updated).
    """
    text = script_path.read_text(encoding="utf-8")
    lines = text.splitlines()

    art_updated = False
    text_updated = False
    in_block = False
    scan_depth = 0

    for i, line in enumerate(lines):
        # Detect start of the target event's tuple
        if f'"{target_id}"' in line:
            in_block = True
            scan_depth = 0

        if in_block:
            scan_depth += 1
            if scan_depth > 12:          # give up after ~12 lines
                in_block = False
                continue

            # Update art status
            if not art_updated and f'"{old_status}"' in line:
                lines[i] = line.replace(f'"{old_status}"', f'"{new_status}"', 1)
                art_updated = True

            # Optionally promote text status to FULL COMPLETION
            if also_promote_text and not text_updated and art_updated:
                for pass_s in ("FIRST PASS",):
                    if f'"{pass_s}"' in line:
                        lines[i] = lines[i].replace(f'"{pass_s}"', '"FULL COMPLETION"', 1)
                        text_updated = True
                        break

            # Stop scanning after the closing paren of the tuple
            if art_updated and line.strip().endswith("),"):
                in_block = False

    script_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return art_updated, text_updated


def _find_preslib_entry(target_id: str) -> dict | None:
    """
    Parse GALLERY_DATA from build_preslib_masterdoc.py looking for target_id.
    Returns a dict with keys: group, id, title, art_path, art_status, writing_status.
    Uses simple line scanning rather than AST (robust for the expected format).
    """
    text = PRESLIB_SCRIPT.read_text(encoding="utf-8")
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if f'"{target_id}"' in line:
            # Collect the surrounding lines (up to 10) to extract fields
            block = "\n".join(lines[max(0,i-1):i+10])
            # Extract writing_status and art_status (positions 6 and 7 in the tuple)
            # They appear as "FIRST PASS", "Not Started" etc.
            statuses = re.findall(r'"((?:FULL (?:PASS|COMPLETION)|FIRST (?:PASS|DRAFT)|IDEA|STUB|Not Started|Integrated|Done|Needed))"', block)
            art_path_match = re.search(r'"((?:art assets|res://)[^"]*)"', block)
            return {
                "id": target_id,
                "writing_status": statuses[0] if statuses else "",
                "art_status": statuses[1] if len(statuses) > 1 else "Not Started",
                "art_path": art_path_match.group(1) if art_path_match else "",
            }
    return None


def _update_preslib_art_path(target_id: str, dest_path: str):
    """Set art_path in build_preslib_masterdoc.py for the given id."""
    text = PRESLIB_SCRIPT.read_text(encoding="utf-8")
    lines = text.splitlines()
    in_block = False
    scan_depth = 0
    updated = False

    for i, line in enumerate(lines):
        if f'"{target_id}"' in line:
            in_block = True
            scan_depth = 0

        if in_block:
            scan_depth += 1
            if scan_depth > 12:
                in_block = False
                continue
            # Replace empty art_path "" with the actual path
            if '""' in line and not updated:
                # Only replace the first empty string that looks like an art_path slot
                # (appears after the art_status value)
                if re.search(r'"(?:Not Started|Integrated|Done|Needed)"', lines[i-1] if i>0 else ""):
                    lines[i] = line.replace('""', f'"{dest_path}"', 1)
                    updated = True
            if line.strip().endswith("),"):
                in_block = False

    PRESLIB_SCRIPT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return updated


# ── Main logic ────────────────────────────────────────────────────────────────

def integrate(source_path: str, target_id: str):
    source = Path(source_path)
    if not source.is_absolute():
        source = ROOT / source
    source = source.resolve()

    if not source.exists():
        _err(f"Source file not found: {source}")
    if source.suffix.lower() not in (".png", ".jpg", ".jpeg", ".webp"):
        _err(f"Expected an image file (.png/.jpg/.jpeg/.webp), got: {source.suffix}")

    print(f"\n{'━'*58}")
    print(f"  ART INTEGRATION  ·  {target_id}")
    print(f"{'━'*58}")
    print(f"  Source : {source}")

    # ── Try events.csv first ───────────────────────────────────────────────────
    event_row = _find_event_in_csv(target_id)
    if event_row is not None:
        image_tag = event_row.get("image_tag", "").strip()
        if not image_tag:
            # Derive from event_id if missing
            image_tag = target_id.lower()
            print(f"  ! image_tag missing in events.csv — using '{image_tag}'")

        dest_filename = image_tag if "." in image_tag else image_tag + source.suffix.lower()
        dest = PANEL_DIR / dest_filename
        PANEL_DIR.mkdir(parents=True, exist_ok=True)

        shutil.copy2(source, dest)
        print(f"  ✓ Copied to: art assets/AmericanRevolutionArt/Panel/{dest_filename}")

        # Update events.csv image_tag if blank
        _update_csv_image_tag(target_id, image_tag)

        # Update masterdoc script
        text_is_pass = event_row.get("status", "").strip() in PASS_STATUSES
        art_updated, text_updated = _update_script_art_status(
            EVENT_SCRIPT, target_id,
            old_status="Not Started",
            new_status="Integrated",
            also_promote_text=text_is_pass,
        )

        if art_updated:
            print(f"  ✓ build_event_masterdoc.py: art_status → \"Integrated\"")
        else:
            print(f"  ! Could not auto-update art_status in build_event_masterdoc.py")
            print(f"    Find '{target_id}' and set art_status to \"Integrated\" manually.")

        if text_updated:
            print(f"  ✓ build_event_masterdoc.py: status → \"FULL COMPLETION\"")
        elif text_is_pass:
            print(f"  · Text already at a passing status — manually promote to FULL COMPLETION if ready.")

        # Regenerate masterdoc
        print(f"  · Regenerating event_masterdoc.xlsx …")
        result = subprocess.run(
            ["python3", "scripts/build_event_masterdoc.py"],
            cwd=ROOT, capture_output=True, text=True
        )
        if result.returncode == 0:
            print(f"  ✓ event_masterdoc.xlsx updated")
        else:
            print(f"  ! Masterdoc regeneration failed:\n{result.stderr}")

        print(f"\n  ── NEXT STEPS {'─'*40}")
        print(f"  1. git add art assets/AmericanRevolutionArt/Panel/{dest_filename}")
        print(f"  2. git add data/events.csv scripts/build_event_masterdoc.py event_masterdoc.xlsx")
        print(f"  3. git commit + push")
        print(f"  4. /ethertask  — will auto-advance if status is FULL COMPLETION")
        print(f"{'━'*58}\n")
        return

    # ── Try preslib GALLERY_DATA ───────────────────────────────────────────────
    preslib_entry = _find_preslib_entry(target_id)
    if preslib_entry is not None:
        dest_filename = target_id.lower() + source.suffix.lower()
        dest = PANEL_DIR / dest_filename
        PANEL_DIR.mkdir(parents=True, exist_ok=True)

        shutil.copy2(source, dest)
        rel_dest = f"art assets/AmericanRevolutionArt/Panel/{dest_filename}"
        print(f"  ✓ Copied to: {rel_dest}")

        # Update art_path in preslib script
        path_updated = _update_preslib_art_path(target_id, rel_dest)
        if path_updated:
            print(f"  ✓ build_preslib_masterdoc.py: art_path set")

        # Update art_status in preslib script
        art_updated, text_updated = _update_script_art_status(
            PRESLIB_SCRIPT, target_id,
            old_status="Not Started",
            new_status="Done",
            also_promote_text=(preslib_entry.get("writing_status","") in PASS_STATUSES),
        )
        if art_updated:
            print(f"  ✓ build_preslib_masterdoc.py: art_status → \"Done\"")
        else:
            print(f"  ! Could not auto-update art_status — update manually.")

        # Regenerate preslib masterdoc
        print(f"  · Regenerating preslib_masterdoc.xlsx …")
        result = subprocess.run(
            ["python3", "scripts/build_preslib_masterdoc.py"],
            cwd=ROOT, capture_output=True, text=True
        )
        if result.returncode == 0:
            print(f"  ✓ preslib_masterdoc.xlsx updated")
        else:
            print(f"  ! Masterdoc regeneration failed:\n{result.stderr}")

        print(f"\n  ── NEXT STEPS {'─'*40}")
        print(f"  1. git add {rel_dest}")
        print(f"  2. git add scripts/build_preslib_masterdoc.py preslib_masterdoc.xlsx")
        print(f"  3. git commit + push")
        print(f"{'━'*58}\n")
        return

    # ── Not found anywhere ─────────────────────────────────────────────────────
    _err(
        f"ID '{target_id}' not found in events.csv or GALLERY_DATA.\n"
        f"  Check the ID spelling. Run:  grep '{target_id}' data/events.csv"
    )


# ── Entry point ───────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(0)
    integrate(sys.argv[1], sys.argv[2])


if __name__ == "__main__":
    main()
