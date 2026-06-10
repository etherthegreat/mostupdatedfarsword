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

## Branch

All development goes on `claude/farsword-recent-push-JL6OS`. Always push to that branch.

## Git Identity

Use `git -c user.name="Claude" -c user.email="noreply@anthropic.com"` when committing if identity is not already set.
