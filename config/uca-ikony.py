"""Ustawia ikony akcji Thunara (uca.xml) pasujace do konturowych ikon paska narzedzi.

Zmienia tylko akcje z ponizszej listy i tylko ich ikone; reszta pliku zostaje bez zmian.
"""
import os
import re
import sys

ICONS = {
    "Run command ...": "system-run-symbolic",
    "Open Terminal Here": "jade-terminal-symbolic",
    "Open root Thunar here": "dialog-password-symbolic",
    "Edit as Root": "document-edit-symbolic",
    "Find files here": "edit-find-symbolic",
    "Create symlink": "insert-link-symbolic",
}

path = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/.config/Thunar/uca.xml")
with open(path, encoding="utf-8") as f:
    text = f.read()
for name, icon in ICONS.items():
    pattern = r"(<icon>)[^<]*(</icon>\s*<name>" + re.escape(name) + r"</name>)"
    text = re.sub(pattern, r"\g<1>" + icon + r"\g<2>", text)
with open(path, "w", encoding="utf-8") as f:
    f.write(text)
