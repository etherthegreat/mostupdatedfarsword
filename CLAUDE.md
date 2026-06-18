# Farsword Project — Claude Instructions

## Flavordoc Rule

**Whenever you add or modify any flavor content, update `scripts/build_flavordoc.py` and regenerate `flavordoc.xlsx`.**

Flavor content includes:
- Laws (American or Canadian)
- Beliefs: doctrines or icons (American or Canadian)
- Mil mods (especially belief-granted or axis-granted ones)
- Factions
- Governors / protectors
- VP arc events or CA events

Steps after adding flavor content:
1. Add the new entry to the appropriate data tuple in `scripts/build_flavordoc.py`
2. Run `python3 scripts/build_flavordoc.py` from the repo root
3. Commit both `scripts/build_flavordoc.py` and `flavordoc.xlsx`

## Canada Lore Rule

Canada in this game is a **parliamentary republic** — not a monarchy, not a dominion.

- Use **"Republic"** everywhere "Dominion" would appear in lore, law text, event descriptions, and flavor writing
- Use **"Republic of Canada"** for formal references, **"the Republic"** for shorthand
- Law/doctrine names that historically include "Dominion" are renamed in-game: e.g. "Republic Elections Act", "Republic Lands Act"
- Canada's government is led by a **Prime Minister** and a **Parliament** (not a Governor-General or Crown)
- The word **"Dominion"** should not appear in any new lore, event text, law description, or flavor text referring to Canada

## Ethertask Close Rule

**Never mark an ethertask as FULL PASS, FULL COMPLETION, or update its status in any builder script unless the user explicitly runs `/closetask`.**

- Do the work (write text, implement mechanics, polish flavor) — but hold the status update.
- Only `/closetask` triggers the status change, builder rerun, and commit.
- This applies to both `scripts/build_flavordoc.py` (icons, doctrines, laws) and `scripts/build_event_masterdoc.py` (all event types).

## Governor Event Writing Rule

**Any event text that refers to a governor or commander must use tokens, never hardcoded names or pronouns.**

Available tokens (resolved by `_substitute()` in `event_scene.gd`):

| Token | Resolves to | Fallback |
|---|---|---|
| `[COMMANDER_NAME]` | governor's display name | "the Commander" |
| `[TILE_NAME]` | tile name | "the front" |
| `[GOVERNOR_TITLE]` | General / Governor / Commander by level | "Commander" |
| `[CMD_SUBJECT]` | he / she / they | "they" |
| `[CMD_OBJECT]` | him / her / them | "them" |
| `[CMD_POSSESSIVE]` | his / her / their | "their" |
| `[CMD_REFLEXIVE]` | himself / herself / themselves | "themselves" |

Rules:
- Never write "him", "her", "them", "his", "their", "they", "she", "he" when referring to a procedural governor — always use the token
- Named governors (Ualani, Lincoln's Ghost, etc.) that lack a `pronouns` dict will fall back to they/them — acceptable unless you explicitly set their pronouns in `governor.gd`
- `_substitute()` has a final safety sweep so no token ever leaks as a raw string into the UI, even if the tile or governor is null

## Branch

All development goes on `claude/farsword-recent-push-JL6OS`. Always push to that branch.

## Git Identity

Use `git -c user.name="Claude" -c user.email="noreply@anthropic.com"` when committing if identity is not already set.
