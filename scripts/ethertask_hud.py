#!/usr/bin/env python3
"""
ethertask_hud.py — Persistent floating HUD for the active EtherTask.

Run once from your LOCAL machine (not the container):
    python3 scripts/ethertask_hud.py &

The window is borderless, always-on-top, and centered on your leftmost monitor.
Drag it anywhere. Press Escape or click ✕ to close.

Optional: pip install screeninfo  (for accurate multi-monitor positioning)
"""

import os, json, tkinter as tk
from datetime import datetime

REPO_ROOT  = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE_PATH = os.path.join(REPO_ROOT, "data", "current_ethertask.json")

# ── Palette (matches Farsword spreadsheet aesthetic) ─────────────────────────
BG     = "#070710"
GOLD   = "#C9A84C"
GOLD_L = "#FFF3C4"
TEAL   = "#0A7C6E"
DIM    = "#3A3050"
BORDER = "#2A1F4A"

HUD_W = 430
HUD_H = 92


def _left_monitor_center():
    """Return (cx, cy) for the center of the leftmost monitor."""
    try:
        from screeninfo import get_monitors
        monitors = sorted(get_monitors(), key=lambda m: m.x)
        m = monitors[0]
        return m.x + m.width // 2, m.y + m.height // 2
    except Exception:
        pass
    # Fallback: assume left monitor is the left half of the virtual desktop
    import tkinter as _tk
    _r = _tk.Tk()
    _r.withdraw()
    sw, sh = _r.winfo_screenwidth(), _r.winfo_screenheight()
    _r.destroy()
    return sw // 4, sh // 2   # center of the assumed left half


def _fmt_elapsed(started_at_str):
    if not started_at_str:
        return "no timer"
    try:
        started = datetime.fromisoformat(started_at_str)
    except (ValueError, TypeError):
        return "—"
    secs  = max(0, int((datetime.now() - started).total_seconds()))
    days  = secs // 86400
    hours = (secs % 86400) // 3600
    mins  = (secs % 3600) // 60
    if days:
        return f"{days}d {hours}h {mins}m"
    if hours:
        return f"{hours}h {mins}m"
    return f"{mins}m"


def _read_state():
    try:
        with open(STATE_PATH, encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


class EtherHUD:
    RELOAD_TICKS = 30   # reload JSON every N seconds

    def __init__(self, root):
        self.root  = root
        self.state = {}
        self._tick = 0

        root.title("EtherTask HUD")
        root.configure(bg=BORDER)
        root.resizable(False, False)
        root.wm_attributes("-topmost", True)
        root.overrideredirect(True)          # borderless
        root.bind("<Escape>", lambda _: root.destroy())

        # 1-px gold border via outer frame
        outer = tk.Frame(root, bg=GOLD, padx=1, pady=1)
        outer.pack(fill="both", expand=True)
        inner = tk.Frame(outer, bg=BG, padx=14, pady=8)
        inner.pack(fill="both", expand=True)

        _lbl = lambda **kw: tk.Label(inner, bg=BG, anchor="w", **kw)

        self.lbl_header = _lbl(
            font=("Arial", 8, "bold"), fg=TEAL
        )
        self.lbl_header.pack(fill="x")

        self.lbl_id = _lbl(
            font=("Courier", 13, "bold"), fg=GOLD
        )
        self.lbl_id.pack(fill="x", pady=(2, 0))

        self.lbl_source = _lbl(
            font=("Arial", 8), fg=DIM
        )
        self.lbl_source.pack(fill="x")

        # Close button — top-right corner
        close_btn = tk.Button(
            inner, text="✕", command=root.destroy,
            bg=BG, fg=DIM, activebackground=BG, activeforeground=GOLD,
            relief="flat", bd=0, font=("Arial", 9), cursor="hand2",
        )
        close_btn.place(relx=1.0, rely=0.0, anchor="ne")

        # Drag support
        self._drag_ox = self._drag_oy = 0
        for widget in (root, outer, inner, self.lbl_header, self.lbl_id, self.lbl_source):
            widget.bind("<Button-1>",   self._drag_start)
            widget.bind("<B1-Motion>",  self._drag_move)

        self._place_window()
        self._refresh()

    def _place_window(self):
        cx, cy = _left_monitor_center()
        x = cx - HUD_W // 2
        y = cy - HUD_H // 2
        self.root.geometry(f"{HUD_W}x{HUD_H}+{x}+{y}")

    def _drag_start(self, e):
        self._drag_ox = e.x
        self._drag_oy = e.y

    def _drag_move(self, e):
        x = self.root.winfo_x() + (e.x - self._drag_ox)
        y = self.root.winfo_y() + (e.y - self._drag_oy)
        self.root.geometry(f"+{x}+{y}")

    def _refresh(self):
        self._tick += 1
        if self._tick >= self.RELOAD_TICKS or not self.state:
            self.state = _read_state()
            self._tick = 0

        task_id    = self.state.get("id", "—")
        source     = self.state.get("source", "")
        started_at = self.state.get("started_at")
        elapsed    = _fmt_elapsed(started_at)

        source_short = source.split("›")[-1].strip() if "›" in source else source

        self.lbl_header.config(text=f"ETHER TASK  ·  running: {elapsed}")
        self.lbl_id.config(    text=task_id)
        self.lbl_source.config(text=source_short[:58])

        self.root.after(1000, self._refresh)


def main():
    root = tk.Tk()
    EtherHUD(root)
    root.mainloop()


if __name__ == "__main__":
    main()
