Run the adult game research script:

```
python3 scripts/adultgameresearch.py
```

Run from the repo root. The script queries the Claude API with web search enabled to find adult strategy/management games, deduplicates them, and writes a 4-sheet Excel workbook.

After the script finishes, send the output file `adult_game_research.xlsx` to the user with a one-line summary: number of new games found, high-priority count (strategy/management tags), and whether any new regions were covered.

If the script errors, report the error message directly — do not retry automatically.

**Optional args the user may pass:**
- `--quick` — reduces API calls for a faster run
- `--append` — appends to an existing `adult_game_research.xlsx` rather than overwriting

Forward any args the user provides after `/adultgameresearch` directly to the script. Example: if the user types `/adultgameresearch --quick`, run `python3 scripts/adultgameresearch.py --quick`.
