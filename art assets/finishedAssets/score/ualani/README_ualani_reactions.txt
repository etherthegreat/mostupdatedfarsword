UALANI SCORE REACTIONS — art slot for the Standing panel (run_progress.gd)
=========================================================================
Click the turn countdown on the bottom flag band during a run. The left side of
the Standing panel shows Ualani reacting to the grade the player is on RIGHT NOW.

Put each reaction in the folder for its grade:
  S/  A/  B/  C/  D/  F/  L/      (L = secret grade: lost the war holding 0 tiles)

FRAMES
  - PNG sequence, transparent background. Any names; they play in alphabetical
    order, so number them: ualani_B_000.png, ualani_B_001.png ...
  - Loops at 12 fps (UALANI_FPS in run_progress.gd if you want it slower).
  - One PNG on its own = a still. That's a fine first pass.
  - The box is 380 x 500 on a 1920x1080 screen. Draw at 760 x 1000 (2x) so it
    stays crisp; anything with that 19:25 shape fills it, other shapes letterbox.

An empty or missing folder shows a labelled placeholder, so nothing breaks while
the art is in progress. Drop frames in, open Godot once so it imports them, done.
