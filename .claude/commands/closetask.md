Close the current ethertask as complete. Only run this when the user explicitly invokes `/closetask` — never auto-close a task during normal work.

Steps:

1. Read `data/current_ethertask.json` to get the task `id` and `source`.

2. **If source starts with `AmericaRush ›`** (CODE, EDITOR, or ASSET tasks):
   - Run: `python3 scripts/pick_ethertask.py --close-direct <id>`
   - That marks the row DONE in `data/americarush.csv` and clears state.
   - Commit: `data/americarush.csv` + `data/current_ethertask.json`. Push.
   - Skip steps 3–5. Report what was closed.

3. **Otherwise** — determine which script and status string to use based on SOURCE:
   - **Flavordoc › Doctrines** → `scripts/build_flavordoc.py`, DOCTRINES list, status `"FULL PASS"`
   - **Flavordoc › Icons** → `scripts/build_flavordoc.py`, ICONS list, status `"FULL PASS"`
   - **Flavordoc › Laws** → `scripts/build_flavordoc.py`, LAWS list, status `"FULL PASS"`
   - **Events › White House** (WH_SECRET_NN) → `scripts/build_event_masterdoc.py`, add/update `_WH_SECRET_OVERRIDES[N]`, status `"FULL COMPLETION"`
   - **Events › (other)** → `scripts/build_event_masterdoc.py`, find the matching EVENTS row and update status to `"FULL COMPLETION"`

4. Check whether the art PNG exists:
   - Events: `art assets/AmericanRevolutionArt/Panel/<image_tag>.png`
   - Flavordoc: same folder, filename matches the art tag shown on the task card
   - If the file exists → art status `"Integrated"` (events) or `"Done"` (flavordoc)
   - If not → leave art status `"Not Started"`

5. Edit the script, then run the appropriate builder:
   - Flavordoc tasks: `python3 scripts/build_flavordoc.py`
   - Event tasks: `python3 scripts/build_event_masterdoc.py`

6. Commit and push all changed files (the builder script + the regenerated `.xlsx`) to `claude/farsword-recent-push-JL6OS`. Commit message: `Close ethertask: <task id>`.

7. Report back: what was closed, which status it moved to, and whether art was marked done or is still pending.
