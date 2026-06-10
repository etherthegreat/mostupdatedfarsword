The user is dropping art into the game. Follow these steps exactly:

1. **Identify the file path.** The user will either:
   - Drop a PNG directly into the conversation (check if a file path is visible in their message or in a recent tool result)
   - Provide an explicit path (e.g. "~/Downloads/scene.png" or a path in the repo)
   - If unclear, ask: "What's the path to the PNG?"

2. **Identify the event or gallery ID.** The user will say which event it's for (e.g. "CAN_ALLIANCE_SIGNED" or "WH_SECRET_01"). If not clear, ask.

3. **Run the integration script:**
   ```
   python3 scripts/integrate_art.py <source_path> <event_id>
   ```
   Use the exact source path provided. Run from repo root.

4. **If the script reports it couldn't auto-update art_status**, manually find the entry in the relevant masterdoc script and update `"Not Started"` to `"Integrated"` (events) or `"Done"` (preslib), then rerun the masterdoc builder.

5. **Commit and push everything the script touched:**
   - The copied PNG in `art assets/AmericanRevolutionArt/Panel/`
   - `data/events.csv` (if image_tag was set)
   - `scripts/build_event_masterdoc.py` or `scripts/build_preslib_masterdoc.py`
   - The regenerated `.xlsx` file
   Use a commit message like: `Integrate art: <event_id> (<image_tag>.png)`

6. **Report back** with: what was copied where, what status changed, and whether /ethertask will auto-advance.

**Note on file delivery in remote sessions:** If the user is on the web version of Claude Code, they may need to push the PNG to the repo from their local machine first (git add + push), then run /artdrop with the repo-relative path. The integration script handles the rest.
