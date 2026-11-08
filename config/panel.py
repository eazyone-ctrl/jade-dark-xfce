#!/usr/bin/env python3
import os
"""Ustawia panel XFCE w stylu Omarchy Jade Horse.

Układ pierwszego panelu: menu, pulpity, zadania | zegar, pogoda | dźwięk, zasobnik.
Wtyczki, których nie ma w panelu, są pomijane (poza dwoma rozpychaczami, które
skrypt dodaje sam). Wywoływać przy zatrzymanym panelu: wtyczka pogody przy
zamykaniu nadpisuje swoje ustawienia.

Wypisuje numery wtyczek jako PAGER=.. SYSTRAY=.. PULSE=.. WEATHER=.. DOCK=..
"""
import re
import subprocess

CH = "xfce4-panel"


def q(*args):
    return subprocess.run(["xfconf-query", "-c", CH, *args], capture_output=True, text=True)


def setp(prop, typ, val):
    if q("-p", prop, "-s", str(val)).returncode != 0:
        q("-p", prop, "-n", "-t", typ, "-s", str(val))


def plugin_types():
    out = q("-lv").stdout
    return {int(m.group(1)): m.group(2) for m in re.finditer(r"^/plugins/plugin-(\d+)\s+(\S+)$", out, re.M)}


def panel_ids(panel):
    out = q("-p", f"/panels/{panel}/plugin-ids").stdout
    return [int(x) for x in re.findall(r"^\s*(\d+)\s*$", out, re.M)]


def first_panel():
    out = q("-p", "/panels").stdout
    ids = re.findall(r"^\s*(\d+)\s*$", out, re.M)
    return f"panel-{ids[0]}" if ids else None


def main():
    panel = first_panel()
    if not panel:
        print("BRAK_PANELU=1")
        return
    types = plugin_types()
    ids = panel_ids(panel)
    by_type = {}
    for i in ids:
        by_type.setdefault(types.get(i), []).append(i)

    def take(t):
        lst = by_type.get(t, [])
        return lst.pop(0) if lst else None

    # dwa rozpychacze wokół zegara: istniejące separatory albo nowe wtyczki
    nxt = max(types) + 1 if types else 1
    spacers = []
    for _ in range(2):
        s = take("separator")
        if s is None:
            s, nxt = nxt, nxt + 1
            setp(f"/plugins/plugin-{s}", "string", "separator")
        setp(f"/plugins/plugin-{s}/expand", "bool", "true")
        setp(f"/plugins/plugin-{s}/style", "uint", 0)
        spacers.append(s)

    menu, appmenu, pager = take("whiskermenu"), take("applicationsmenu"), take("pager")
    dock, tasks = take("docklike"), take("tasklist")
    clock, weather = take("clock"), take("weather")
    pulse, tray = take("pulseaudio"), take("systray")
    left = [x for x in (menu, appmenu, pager, dock, tasks) if x is not None]
    mid = [x for x in (clock, weather) if x is not None]
    right = [x for x in (pulse, tray) if x is not None]
    rest = [i for t in by_type.values() for i in t]  # pozostałe wtyczki na końcu
    order = left + [spacers[0]] + mid + [spacers[1]] + right + rest
    args = ["-p", f"/panels/{panel}/plugin-ids", "-a"]
    for i in order:
        args += ["-t", "int", "-s", str(i)]
    q(*args)

    setp(f"/panels/{panel}/size", "uint", 26)
    setp(f"/panels/{panel}/icon-size", "uint", 16)
    if tray is not None:
        setp(f"/plugins/plugin-{tray}/icon-size", "int", 16)
    # tlo panelu pochodzi z motywu, wiec zmienia sie razem z nim
    setp(f"/panels/{panel}/background-style", "uint", 0)

    if pager is not None:
        setp(f"/plugins/plugin-{pager}/rows", "int", 1)
        setp(f"/plugins/plugin-{pager}/miniature-view", "bool", "false")
    if clock is not None:
        p = f"/plugins/plugin-{clock}"
        setp(f"{p}/mode", "uint", 2)
        setp(f"{p}/digital-layout", "uint", 3)
        setp(f"{p}/digital-time-format", "string", "%A %H:%M")
        setp(f"{p}/digital-time-font", "string", "JetBrains Mono Bold 10")
    if weather is not None:
        setp(f"/plugins/plugin-{weather}/theme-dir", "string", os.path.expanduser("~/.config/xfce4/weather/icons/jade-outline"))
        p = f"/plugins/plugin-{weather}/scrollbox"
        setp(f"{p}/font", "string", "JetBrains Mono Bold 10")
        setp(f"{p}/use-color", "bool", "false")  # kolor tekstu z motywu
    if menu is not None:
        p = f"/plugins/plugin-{menu}"
        for k, t, v in [("view-mode", "int", 1), ("launcher-icon-size", "int", 1),
                        ("launcher-show-name", "bool", "true"), ("launcher-show-description", "bool", "false"),
                        ("category-icon-size", "int", 2), ("category-show-name", "bool", "true"),
                        ("hover-switch-category", "bool", "true"), ("position-search-alternate", "bool", "false"),
                        ("position-commands-alternate", "bool", "true"),
                        ("position-categories-alternate", "bool", "true"),
                        ("position-categories-horizontal", "bool", "false"),
                        ("menu-width", "int", 820), ("menu-height", "int", 786)]:
            setp(f"{p}/{k}", t, v)

    print(f"PAGER={pager or 0} SYSTRAY={tray or 0} PULSE={pulse or 0} WEATHER={weather or 0} DOCK={dock or 0}")


if __name__ == "__main__":
    main()
