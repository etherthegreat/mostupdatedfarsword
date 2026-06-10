#!/usr/bin/env python3
"""
adultgameresearch.py — SpaceDesk Adult Game Research Excel Builder

Reads a JSON file of game objects and builds the SpaceDesk research spreadsheet.
The research (web searching) is done by Claude Code via the /adultgameresearch command.

Usage:
    python3 scripts/adultgameresearch.py --from-json /tmp/spacedesk_games.json
    python3 scripts/adultgameresearch.py --from-json /tmp/spacedesk_games.json --output mydb.xlsx
    python3 scripts/adultgameresearch.py --from-json /tmp/spacedesk_games.json --append existing.xlsx

Input JSON format (array of game objects):
    [
      {
        "title": "game title",
        "developer": "dev name or Unknown",
        "country": "country or Unknown",
        "year": "2024 or In dev or Unknown",
        "genre": "Grand Strategy / City Builder / etc.",
        "strategy_depth": 4,
        "adult_level": 3,
        "platform": "PC / Android / Browser",
        "status": "Released / Early Access / In dev / Alpha / Beta / Abandoned",
        "english_available": "Yes / No / Partial / Unknown",
        "where_to_play": "https://... or itch.io / F95Zone / etc.",
        "lgbtq_content": "Yes / No / Some / Unknown",
        "content_warnings": "specific warnings or None noted",
        "notes": "why this is notable",
        "incest_flag": false,
        "region_found": "Which query found it"
      },
      ...
    ]
"""

import os, sys, json, argparse, re
from datetime import date
from openpyxl import Workbook, load_workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

# ─── Content filter ───────────────────────────────────────────────────────────
BLOCKED_TAGS = {
    "incest","step-family","step-sister","step-brother","step-mom",
    "step-dad","step-parent","step-son","step-daughter","stepsister",
    "stepbrother","stepmother","stepfather","rape","non-con","noncon",
    "non_con","forced","sexual assault","sleep","sleeping"
}

PRIORITY_TAGS = {
    "strategy","grand-strategy","grand strategy","city-builder","city builder",
    "management","nation-building","nation building","political","political-simulator",
    "turn-based","turn based","tactical","simulation","4x","rts","wargame",
    "conquest","empire","colony","civilization","resource management",
    "kingdom","dungeon management","tycoon","sandbox","war"
}

# ─── Excel palette ────────────────────────────────────────────────────────────
C = {
    "void":   "070710", "violet": "5A1F8A", "teal":   "0A7C6E",
    "gold":   "C9A84C", "red":    "C0392B", "white":  "FFFFFF",
    "ink":    "1A1410", "grey":   "F0EEE8", "gold_l": "FFF3C4",
    "red_l":  "FCE8E6", "teal_l": "E0F5F0", "viol_l": "EDE0FF",
    "blue_l": "E0EEFF", "grn_l":  "E0FFE8",
}

def fill(c): return PatternFill("solid", fgColor=c)
def af(bold=False, sz=10, color="1A1410", italic=False):
    return Font(name="Arial", bold=bold, size=sz, color=color, italic=italic)
def al(h="left", wrap=True):
    return Alignment(horizontal=h, vertical="center", wrap_text=wrap)
def bd():
    s = Side(style="thin", color="D0C8B0")
    return Border(left=s, right=s, top=s, bottom=s)

def wcell(ws, r, col, v="", bg=None, fg="1A1410", bold=False,
          sz=10, align="left", italic=False):
    cell = ws.cell(row=r, column=col, value=v)
    if bg:
        cell.fill = fill(bg)
    cell.font = af(bold=bold, sz=sz, color=fg, italic=italic)
    cell.alignment = al(align)
    cell.border = bd()
    return cell

def mtitle(ws, r, c1, c2, v, bg="070710", fg="C9A84C", sz=13):
    ws.merge_cells(start_row=r, start_column=c1, end_row=r, end_column=c2)
    cell = ws.cell(row=r, column=c1, value=v)
    cell.fill = fill(bg)
    cell.font = af(bold=True, sz=sz, color=fg)
    cell.alignment = al("center")

def tier_color(game):
    depth = game.get("strategy_depth", 1)
    region = game.get("region_found", "")
    if depth >= 4:
        return C["gold_l"]
    if "itch" in region.lower() or "f95" in region.lower():
        return C["teal_l"]
    if any(r in region for r in ["Brazil","Latin","Russia","Eastern","Asia","Africa","India","Korea","China","Turkey","Middle"]):
        return C["viol_l"]
    return C["blue_l"]

def strategy_score(game):
    text = " ".join([game.get("genre",""), game.get("notes","")]).lower()
    score = sum(1 for tag in PRIORITY_TAGS if tag in text)
    score += game.get("strategy_depth", 0)
    return -score

def deduplicate(games):
    seen = set()
    unique = []
    for g in games:
        key = g.get("title","").lower().strip()
        if key and key not in seen:
            seen.add(key)
            unique.append(g)
    return unique

def filter_games(games):
    clean = []
    for g in games:
        if g.get("incest_flag", False):
            continue
        combined = " ".join([
            str(g.get("content_warnings","")),
            str(g.get("notes","")),
            str(g.get("genre","")),
            str(g.get("title",""))
        ]).lower()
        if any(tag in combined for tag in BLOCKED_TAGS):
            continue
        clean.append(g)
    return clean


COLS = [
    "#", "Title", "Developer", "Country", "Year",
    "Genre", "Strategy\nDepth", "Adult\nLevel",
    "Platform", "Status", "English?", "Where to Play",
    "LGBTQ+", "Content Warnings", "Notes", "Found Via"
]
COL_W = [4, 28, 22, 12, 6, 22, 9, 9, 16, 14, 10, 28, 10, 22, 50, 24]


def build_spreadsheet(games, output_path):
    wb = Workbook()
    today = date.today().isoformat()

    # Sheet 1: Full database
    ws = wb.active
    ws.title = "Research Database"
    mtitle(ws, 1, 1, len(COLS),
           f"SPACEDESK — ADULT STRATEGY GAME RESEARCH  ·  Last updated: {today}")
    mtitle(ws, 2, 1, len(COLS),
           f"{len(games)} games  ·  No incest content  ·  Strategy/City Builder priority  ·  International focus",
           bg=C["violet"], fg=C["viol_l"], sz=10)

    for i, h in enumerate(COLS):
        wcell(ws, 4, i+1, h, bg=C["void"], fg=C["gold"], bold=True, sz=10, align="center")

    for idx, game in enumerate(games):
        r = 5 + idx
        bg = tier_color(game)
        vals = [
            str(idx + 1),
            game.get("title",""),
            game.get("developer",""),
            game.get("country",""),
            str(game.get("year","")),
            game.get("genre",""),
            game.get("strategy_depth",""),
            game.get("adult_level",""),
            game.get("platform",""),
            game.get("status",""),
            game.get("english_available",""),
            game.get("where_to_play",""),
            game.get("lgbtq_content",""),
            game.get("content_warnings",""),
            game.get("notes",""),
            game.get("region_found",""),
        ]
        for j, v in enumerate(vals):
            wcell(ws, r, j+1, v, bg=bg, fg=C["ink"], sz=9)
        ws.row_dimensions[r].height = 50

    for i, w in enumerate(COL_W):
        ws.column_dimensions[get_column_letter(i+1)].width = w
    ws.freeze_panes = "A5"

    # Sheet 2: High priority
    ws2 = wb.create_sheet("High Priority")
    mtitle(ws2, 1, 1, 6, "HIGH PRIORITY STREAM LIST — Strategy Depth 4-5",
           bg=C["void"], fg=C["gold"])
    priority = [g for g in games if g.get("strategy_depth", 0) >= 4]
    for i, h in enumerate(["Title", "Developer", "Country", "Genre", "Where to Play", "Notes"]):
        wcell(ws2, 3, i+1, h, bg=C["void"], fg=C["gold"], bold=True)
    for idx, game in enumerate(priority):
        r = 4 + idx
        for j, v in enumerate([game.get("title",""), game.get("developer",""),
                                game.get("country",""), game.get("genre",""),
                                game.get("where_to_play",""), game.get("notes","")]):
            wcell(ws2, r, j+1, v, bg=C["gold_l"], fg=C["ink"], sz=9)
        ws2.row_dimensions[r].height = 45
    for i, w in enumerate([28, 22, 14, 22, 28, 50]):
        ws2.column_dimensions[get_column_letter(i+1)].width = w

    # Sheet 3: By region
    ws3 = wb.create_sheet("By Region")
    mtitle(ws3, 1, 1, 4, "GAMES BY REGION — International Discovery Map",
           bg=C["teal"], fg=C["white"])
    regions = {}
    for g in games:
        regions.setdefault(g.get("region_found","Unknown"), []).append(g)
    r = 3
    for region, rg in sorted(regions.items()):
        ws3.merge_cells(start_row=r, start_column=1, end_row=r, end_column=4)
        hc = ws3.cell(row=r, column=1, value=f"  {region}  ({len(rg)} games)")
        hc.fill = fill(C["void"]); hc.font = af(bold=True, sz=11, color=C["gold"])
        hc.alignment = al("left"); r += 1
        for game in rg:
            wcell(ws3, r, 1, game.get("title",""), bg=C["teal_l"], fg=C["ink"], sz=9, bold=True)
            wcell(ws3, r, 2, game.get("country",""), bg=C["teal_l"], fg=C["ink"], sz=9)
            ws3.merge_cells(start_row=r, start_column=3, end_row=r, end_column=4)
            wcell(ws3, r, 3, game.get("genre",""), bg=C["teal_l"], fg=C["ink"], sz=9)
            ws3.row_dimensions[r].height = 35; r += 1
        r += 1
    for i, w in enumerate([32, 14, 30, 30]):
        ws3.column_dimensions[get_column_letter(i+1)].width = w

    # Sheet 4: Research log
    ws4 = wb.create_sheet("Research Log")
    mtitle(ws4, 1, 1, 3,
           f"RESEARCH LOG  ·  Run: {today}  ·  {len(games)} games discovered",
           bg=C["void"], fg=C["gold"])
    wcell(ws4, 3, 1, "Filter Rules Applied", bg=C["void"], fg=C["gold"], bold=True)
    ws4.merge_cells(start_row=3, start_column=1, end_row=3, end_column=3)
    rules = [
        ("BLOCKED tags",    ", ".join(sorted(BLOCKED_TAGS))),
        ("PRIORITY tags",   ", ".join(sorted(PRIORITY_TAGS))),
        ("Content filter",  "Any game where title, notes, warnings, or genre contains blocked tags is excluded"),
        ("Incest flag",     "Games with incest_flag=true are excluded"),
        ("Source",          "Claude Code with built-in web search — no separate API credits required"),
        ("Deduplication",   "Titles normalized to lowercase, exact duplicates removed"),
    ]
    for i, (k, v) in enumerate(rules):
        r2 = 4 + i
        wcell(ws4, r2, 1, k, bg=C["grey"], fg=C["ink"], bold=True, sz=10)
        c2 = ws4.cell(row=r2, column=2, value=v)
        ws4.merge_cells(start_row=r2, start_column=2, end_row=r2, end_column=3)
        c2.fill = fill(C["grey"]); c2.font = af(sz=9, color=C["ink"])
        c2.alignment = al("left"); c2.border = bd()
        ws4.row_dimensions[r2].height = 40
    ws4.column_dimensions["A"].width = 22
    ws4.column_dimensions["B"].width = 80
    ws4.column_dimensions["C"].width = 10

    wb.save(output_path)
    return len(games)


def main():
    parser = argparse.ArgumentParser(
        description="Build SpaceDesk adult game research spreadsheet from JSON data"
    )
    parser.add_argument("--from-json", required=True, metavar="FILE",
                        help="Path to JSON file containing game array")
    parser.add_argument("--append", metavar="FILE",
                        help="Existing xlsx to merge with before building")
    parser.add_argument("--output", default=None,
                        help="Output filename (default: SpaceDesk_GameDB_Research_DATE.xlsx)")
    args = parser.parse_args()

    if not os.path.exists(args.from_json):
        print(f"ERROR: JSON file not found: {args.from_json}")
        sys.exit(1)

    with open(args.from_json, encoding="utf-8") as f:
        try:
            games = json.load(f)
        except json.JSONDecodeError as e:
            print(f"ERROR: Invalid JSON in {args.from_json}: {e}")
            sys.exit(1)

    if not isinstance(games, list):
        print("ERROR: JSON must be an array of game objects")
        sys.exit(1)

    games = filter_games(games)

    existing = []
    if args.append and os.path.exists(args.append):
        try:
            ewb = load_workbook(args.append)
            ews = ewb["Research Database"]
            for row in ews.iter_rows(min_row=5, values_only=True):
                if row[1]:
                    existing.append({
                        "title": row[1] or "", "developer": row[2] or "",
                        "country": row[3] or "", "year": row[4] or "",
                        "genre": row[5] or "", "strategy_depth": row[6] or 1,
                        "adult_level": row[7] or 1, "platform": row[8] or "",
                        "status": row[9] or "", "english_available": row[10] or "",
                        "where_to_play": row[11] or "", "lgbtq_content": row[12] or "",
                        "content_warnings": row[13] or "", "notes": row[14] or "",
                        "region_found": row[15] or ""
                    })
            print(f"  Loaded {len(existing)} existing games for merge")
        except Exception as e:
            print(f"  Could not load existing DB: {e}")

    all_games = deduplicate(existing + games)
    all_games.sort(key=strategy_score)

    output_path = args.output or f"SpaceDesk_GameDB_Research_{date.today().isoformat()}.xlsx"
    count = build_spreadsheet(all_games, output_path)

    print(f"Wrote {output_path}")
    print(f"  {count} games total")
    high_priority = sum(1 for g in all_games if g.get("strategy_depth", 0) >= 4)
    print(f"  {high_priority} high priority (strategy depth 4-5)")
    regions = {}
    for g in all_games:
        r = g.get("region_found", "Unknown")
        regions[r] = regions.get(r, 0) + 1
    print(f"  {len(regions)} regions covered")
    for region, n in sorted(regions.items(), key=lambda x: -x[1]):
        print(f"    {region:<42} {n}")


if __name__ == "__main__":
    main()
