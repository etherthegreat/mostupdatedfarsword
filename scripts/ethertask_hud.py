#!/usr/bin/env python3
"""
ethertask_hud.py — Persistent floating HUD for the active EtherTask.

Run from your LOCAL machine (not the container):
    Windows:  python scripts\ethertask_hud.py
    Mac/Linux: python3 scripts/ethertask_hud.py

Always-on-top, borderless, centers on your leftmost monitor.
Drag to reposition. Escape or ✕ to close.

Optional better monitor detection:  pip install screeninfo

Errors are logged to ethertask_hud.log in the repo root.
"""

import os, sys, json, tkinter as tk
from datetime import datetime

REPO_ROOT  = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE_PATH = os.path.join(REPO_ROOT, "data", "current_ethertask.json")
LOG_PATH   = os.path.join(REPO_ROOT, "ethertask_hud.log")

BG   = "#070710"
GOLD = "#C9A84C"
TEAL = "#0A7C6E"
DIM  = "#3A3050"

HUD_W = 430
HUD_H = 92


def _get_left_monitor(root):
    """Return (x, y, w, h) of the leftmost monitor. Takes the live root window
    so we never create a second Tk instance (which breaks Tk on Windows)."""

    # 1. screeninfo (pip install screeninfo) — best cross-platform option
    try:
        from screeninfo import get_monitors
        monitors = sorted(get_monitors(), key=lambda m: m.x)
        m = monitors[0]
        return m.x, m.y, m.width, m.height
    except Exception:
        pass

    # 2. Windows ctypes — built-in, no extra packages
    try:
        import ctypes
        u32 = ctypes.windll.user32
        u32.SetProcessDPIAware()
        vx = u32.GetSystemMetrics(76)   # SM_XVIRTUALSCREEN  (leftmost x)
        vy = u32.GetSystemMetrics(77)   # SM_YVIRTUALSCREEN  (topmost y)
        pw = u32.GetSystemMetrics(0)    # SM_CXSCREEN        (primary width)
        ph = u32.GetSystemMetrics(1)    # SM_CYSCREEN        (primary height)
        # On a right-extended setup the left monitor starts at vx (often 0).
        return vx, vy, pw, ph
    except Exception:
        pass

    # 3. Pure tkinter fallback — use the already-open root, never spawn another
    root.update_idletasks()
    sw = root.winfo_screenwidth()
    sh = root.winfo_screenheight()
    return 0, 0, sw // 2, sh   # assume left monitor = left half of virtual desktop


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
    RELOAD_TICKS = 30   # re-read JSON every N seconds

    def __init__(self, root):
        self.root  = root
        self.state = {}
        self._tick = 0

        root.title("EtherTask HUD")
        root.configure(bg=BG)
        root.resizable(False, False)
        root.wm_attributes("-topmost", True)
        root.overrideredirect(True)          # borderless
        root.bind("<Escape>", lambda _: root.destroy())

        # Thin gold border via nested frames
        outer = tk.Frame(root, bg=GOLD, padx=1, pady=1)
        outer.pack(fill="both", expand=True)
        inner = tk.Frame(outer, bg=BG, padx=14, pady=8)
        inner.pack(fill="both", expand=True)

        def _lbl(**kw):
            return tk.Label(inner, bg=BG, anchor="w", **kw)

        self.lbl_header = _lbl(font=("Arial", 8, "bold"), fg=TEAL)
        self.lbl_header.pack(fill="x")

        self.lbl_id = _lbl(font=("Courier", 13, "bold"), fg=GOLD)
        self.lbl_id.pack(fill="x", pady=(2, 0))

        self.lbl_source = _lbl(font=("Arial", 8), fg=DIM)
        self.lbl_source.pack(fill="x")

        tk.Button(
            inner, text="✕", command=root.destroy,
            bg=BG, fg=DIM, activebackground=BG, activeforeground=GOLD,
            relief="flat", bd=0, font=("Arial", 9), cursor="hand2",
        ).place(relx=1.0, rely=0.0, anchor="ne")

        # Drag support on every visible surface
        self._drag_ox = self._drag_oy = 0
        for widget in (root, outer, inner,
                       self.lbl_header, self.lbl_id, self.lbl_source):
            widget.bind("<Button-1>",  self._drag_start)
            widget.bind("<B1-Motion>", self._drag_move)

        # Place window AFTER update_idletasks so geometry is valid
        root.update_idletasks()
        self._place_window()
        self._refresh()

    def _place_window(self):
        mx, my, mw, mh = _get_left_monitor(self.root)
        x = mx + mw // 2 - HUD_W // 2
        y = my + mh // 2 - HUD_H // 2
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
    root.withdraw()          # hide until positioned to avoid top-left flash
    EtherHUD(root)
    root.deiconify()
    root.mainloop()


if __name__ == "__main__":
    try:
        main()
    except Exception:
        import traceback
        with open(LOG_PATH, "w", encoding="utf-8") as f:
            traceback.print_exc(file=f)
        raise
