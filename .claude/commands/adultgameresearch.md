You are doing adult game research for SpaceDesk. Use your built-in WebSearch tool to search for real, existing adult video games with strategy/management/city-builder elements. Then build an Excel spreadsheet from what you find.

No external API calls, no API key needed — use your own search capabilities.

---

## CONTENT RULES

**NEVER include** games with: incest / step-family / step-relative content · non-consensual content (rape, forced) · content sexualizing minors. If a game has any of these, set `incest_flag: true` and skip it.

**PRIORITIZE** games with: grand strategy · 4X · city builder · management · political simulation · turn-based strategy · nation-building · sandbox · tycoon · dungeon management · resource management.

---

## SEARCH QUERIES — run ALL of these with WebSearch

Run a WebSearch for each query below. For each one, find 3–8 real, existing games. Check multiple sources per query (itch.io, F95Zone, DLsite, Steam, dev Patreon/SubscribeStar pages).

1. `"adult strategy game" site:itch.io NSFW city builder management 2023 2024 2025`
2. `"adult city builder" OR "adult management game" site:itch.io NSFW 2024 2025`
3. `F95Zone "grand strategy" adult game 2024 2025 new release management thread`
4. `F95Zone "city builder" adult management game 2024 2025 thread`
5. `Brazilian Portuguese adult strategy game itch.io developer 2023 2024 2025`
6. `Spanish language adult strategy city builder itch.io Argentina Chile Mexico developer`
7. `Russian adult strategy NSFW itch.io 2023 2024 стратегия взрослый`
8. `Polish Czech Romanian adult indie strategy game NSFW 2023 2024 2025`
9. `Southeast Asia Philippines Indonesia Thailand adult NSFW strategy game 2024 2025`
10. `Chinese adult strategy game English patch DLsite 2023 2024 2025`
11. `Korean adult strategy game DLsite 성인 전략 2023 2024`
12. `adult game nation building political simulator indie developer 2024 2025`
13. `obscure indie adult strategy game developer 2024 2025 itch.io management`
14. `adult game developer Africa Nigeria Kenya South Africa strategy indie`
15. `adult game developer India strategy management NSFW 2024 2025`
16. `adult game developer Turkey Middle East strategy NSFW 2024 2025`
17. `Australian adult strategy game developer NSFW indie 2023 2024 2025`
18. `DLsite western developer adult strategy English 2023 2024 2025`
19. `adult strategy RPG tactical management Patreon SubscribeStar 2024 2025 indie`
20. `"queer" OR "gay" adult strategy game itch.io tactical management 2020 2025`

---

## GAME DATA FORMAT

For each real game you find, collect this exact structure:

```json
{
  "title": "exact game title",
  "developer": "developer name or Unknown",
  "country": "country of origin or Unknown",
  "year": "release year or In dev or Unknown",
  "genre": "specific genre e.g. Grand Strategy / City Builder / Nation-Building Sim",
  "strategy_depth": 3,
  "adult_level": 3,
  "platform": "PC / Android / Browser / etc.",
  "status": "Released or Early Access or In dev or Alpha or Beta or Abandoned",
  "english_available": "Yes or No or Partial or Unknown",
  "where_to_play": "direct URL or platform name",
  "lgbtq_content": "Yes or No or Some or Unknown",
  "content_warnings": "specific warnings or None noted",
  "notes": "1-2 sentences on what makes this notable or interesting",
  "incest_flag": false,
  "region_found": "which query number and region found it e.g. Query 5 — Brazil"
}
```

`strategy_depth` 1–5: 1 = no strategy, 3 = meaningful, 5 = deep grand strategy
`adult_level` 1–5: 1 = suggestive only, 3 = explicit optional, 5 = fully explicit

---

## AFTER SEARCHING

1. Collect all found games into a single JSON array. Remove duplicates (same title = one entry — keep the richer record).

2. Write the array to `/tmp/spacedesk_games.json` using the Write tool or a Bash command:
   ```bash
   python3 -c "import json; data = <YOUR_ARRAY>; open('/tmp/spacedesk_games.json','w').write(json.dumps(data, indent=2))"
   ```

3. Run the builder:
   ```bash
   python3 scripts/adultgameresearch.py --from-json /tmp/spacedesk_games.json
   ```

4. Send the output file `SpaceDesk_GameDB_Research_YYYY-MM-DD.xlsx` to the user.

5. Report in one line: total games, high-priority count (strategy_depth ≥ 4), regions covered.

---

## NOTES

- Only include games you found real evidence for. Don't invent entries.
- Prefer games with actual strategy/management depth over pure visual novels with a strategy wrapper.
- Include games regardless of language — note in `english_available` if no English version exists.
- Early access and in-dev games are valuable — include them with correct `status`.
- If a query returns nothing relevant, move on — don't pad with low-quality entries.
