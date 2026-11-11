#!/bin/bash
# Motyw XFCE w stylu Omarchy Jade Horse: kolory Jade Horse, czcionka JetBrains Mono,
# ikony Colloid Teal Everforest (z jednokolorowymi ikonami menu i Thunara), tapety w kolorach motywu, panel jak w Omarchy, okna z jadeitową ramką i rogami 10 px,
# pola i przyciski w formie pill, menu programów jako siatka ikon, zwykły cień wokół okien (picom),
# LED-y klawiatury, myszy i wentylatorów w kolorze motywu oraz czcionki w LibreWolf.
# Użycie: ./instaluj.sh   (bez sudo; o hasło zapyta tylko apt, jeśli trzeba)
set -e
cd "$(dirname "$(readlink -f "$0")")"

# Wariant kolorów: jade (domyślnie) albo amber
WARIANT="${1:-jade}"
case "$WARIANT" in
  jade)  MOTYW=Jade-dark;  IKONY=Jade-Colloid;  OKNA=Jade-dark-compact;  SCHEMAT=config/jade-dark.theme;  DOPISEK="" ;;
  amber) MOTYW=Amber-dark; IKONY=Amber-Colloid; OKNA=Amber-dark-compact; SCHEMAT=config/amber-dark.theme; DOPISEK="-amber" ;;
  *) echo "Użycie: ./instaluj.sh [jade|amber]"; exit 1 ;;
esac

say() { printf '\n\033[1;32m==>\033[0m %s\n' "$*"; }
xq() { xfconf-query -c "$1" -p "$2" -n -t "$3" -s "$4" 2>/dev/null || xfconf-query -c "$1" -p "$2" -s "$4"; }

command -v xfconf-query >/dev/null || { echo "To nie wygląda na XFCE (brak xfconf-query)."; exit 1; }
command -v python3 >/dev/null || { echo "Potrzebny jest python3."; exit 1; }

# --- kopia zapasowa ---
K=~/.config/xfce4/kopia-przed-jade-horse-$(date +%Y%m%d-%H%M%S)
mkdir -p "$K"
say "Kopia zapasowa obecnych ustawień: $K"
X=~/.config/xfce4/xfconf/xfce-perchannel-xml
for c in xsettings xfwm4 xfce4-panel xfce4-terminal xfce4-desktop thunar; do
  [ -f "$X/$c.xml" ] && cp "$X/$c.xml" "$K/"
done
[ -f ~/.config/gtk-3.0/gtk.css ] && cp ~/.config/gtk-3.0/gtk.css "$K/"
[ -f ~/.config/Thunar/uca.xml ] && cp ~/.config/Thunar/uca.xml "$K/"
cp -r ~/.config/xfce4/panel "$K/panel" 2>/dev/null || true
[ -f ~/.config/picom/picom.conf ] && cp ~/.config/picom/picom.conf "$K/"
CS=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || echo "'default'")
cat > "$K/przywroc.sh" <<EOF
#!/bin/sh
# Przywraca ustawienia sprzed instalacji motywu Jade Horse
cd ~
pkill -f "keyboard-theme-sync" ; rm -f ~/.config/autostart/keyboard-theme-sync.desktop
xfce4-panel --quit; pkill -x picom; sleep 1
pkill -x xfconfd; sleep 1
for c in xsettings xfwm4 xfce4-panel xfce4-terminal xfce4-desktop thunar; do
  if [ -f "$K/\$c.xml" ]; then cp "$K/\$c.xml" "$X/"; else rm -f "$X/\$c.xml"; fi
done
if [ -f "$K/gtk.css" ]; then cp "$K/gtk.css" ~/.config/gtk-3.0/gtk.css; else rm -f ~/.config/gtk-3.0/gtk.css; fi
[ -f "$K/uca.xml" ] && cp "$K/uca.xml" ~/.config/Thunar/uca.xml
[ -d "$K/panel" ] && cp -r "$K/panel/." ~/.config/xfce4/panel/
[ -f "$K/picom.conf" ] && cp "$K/picom.conf" ~/.config/picom/picom.conf
rm -f ~/.config/autostart/picom.desktop
rm -f ~/.local/share/desktop-directories/xfce-education.directory ~/.local/share/desktop-directories/xfce-other.directory ~/.local/share/applications/alsamixer.desktop
gsettings set org.gnome.desktop.interface color-scheme $CS 2>/dev/null
setsid xfce4-panel >/dev/null 2>&1 &
xfwm4 --replace >/dev/null 2>&1 &
xfdesktop --reload 2>/dev/null
echo "Przywrócono. Najlepiej wyloguj się i zaloguj ponownie."
EOF
chmod +x "$K/przywroc.sh"

# --- pakiety systemowe ---
need=()
command -v picom >/dev/null || need+=(picom)
[ -d /usr/share/icons/Yaru-sage-dark ] || need+=(yaru-theme-icon)
if [ ${#need[@]} -gt 0 ]; then
  say "Instaluję pakiety: ${need[*]} (wymaga hasła sudo)"
  sudo apt install -y "${need[@]}" || echo "Nie udało się zainstalować ${need[*]} — reszta i tak zostanie ustawiona."
fi

# --- czcionki, motywy, tapety ---
say "Czcionki Inter i JetBrains Mono -> ~/.local/share/fonts"
mkdir -p ~/.local/share/fonts
cp fonts/*.otf fonts/*.ttf ~/.local/share/fonts/
fc-cache -f ~/.local/share/fonts >/dev/null

say "Motywy -> ~/.themes, ikony -> ~/.local/share/icons"
mkdir -p ~/.themes ~/.local/share/icons
cp -r themes/Jade-dark themes/Jade-dark-compact themes/Amber-dark themes/Amber-dark-compact ~/.themes/
for i in Jade-Colloid Amber-Colloid Colloid-Teal-Everforest-Dark Colloid-Teal-Everforest-Light; do
  rm -rf ~/.local/share/icons/$i; cp -a ikony/$i ~/.local/share/icons/
  gtk-update-icon-cache -f -q ~/.local/share/icons/$i 2>/dev/null || true
done
mkdir -p ~/.config/xfce4/weather/icons
rm -rf ~/.config/xfce4/weather/icons/jade-outline; cp -a ikony/pogoda/jade-outline ~/.config/xfce4/weather/icons/
cp ikony/pogoda/generuj-jade-outline.py ~/.config/xfce4/weather/icons/
mkdir -p ~/.local/share/desktop-directories ~/.local/share/applications
cp config/xfce-education.directory config/xfce-other.directory ~/.local/share/desktop-directories/
# Alsamixer ma inną ikonę niż Sterowanie głośnością
[ -f /usr/share/applications/alsamixer.desktop ] && sed "s/^Icon=.*/Icon=jade-alsamixer/" /usr/share/applications/alsamixer.desktop > ~/.local/share/applications/alsamixer.desktop
# Akcje Thunara (terminal, root, szukanie, dowiązanie) dostają konturowe ikony pasujące do paska narzędzi
[ -f ~/.config/Thunar/uca.xml ] && python3 -I config/uca-ikony.py ~/.config/Thunar/uca.xml

T=~/Obrazy/Tapety/cyberpunk
[ -d ~/Obrazy ] || T=~/Pictures/Wallpapers/cyberpunk
say "Tapety -> $T"
mkdir -p "$T"; cp tapety/* "$T/"

# --- wygląd ---
say "Wygląd: motyw, ikony, czcionki"
xq xsettings /Net/ThemeName string "$MOTYW"
xq xsettings /Gtk/ButtonImages bool false
xq xsettings /Gtk/MenuImages bool false
gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null || true
xq xsettings /Net/IconThemeName string "$IKONY"
xq xsettings /Gtk/FontName string "JetBrains Mono 9"
xq xsettings /Gtk/MonospaceFontName string "JetBrains Mono 9"
xq xfwm4 /general/theme string "$OKNA"
xq xfwm4 /general/title_font string "JetBrains Mono Bold 9"
xfconf-query -c xfwm4 -p /general/workspace_names -n -t string -s 1 -t string -s 2 -t string -s 3 -t string -s 4 -t string -s 5 2>/dev/null ||
  xfconf-query -c xfwm4 -p /general/workspace_names -s 1 -s 2 -s 3 -s 4 -s 5
xq thunar /misc-symbolic-icons-in-toolbar bool true
xq thunar /shortcuts-icon-size string THUNAR_ICON_SIZE_16
xq thunar /tree-icon-size string THUNAR_ICON_SIZE_16
xq xfce4-notifyd /initial-opacity double 1.0
pkill -x xfce4-notifyd 2>/dev/null || true

# --- terminal ---
say "Terminal: JetBrains Mono 10 + schemat kolorów $MOTYW"
sch() { sed -n "s/^$1=//p" "$SCHEMAT"; }
mkdir -p ~/.local/share/xfce4/terminal/colorschemes
cp config/jade-dark.theme config/amber-dark.theme ~/.local/share/xfce4/terminal/colorschemes/
xq xfce4-terminal /font-use-system bool false
xq xfce4-terminal /font-name string "JetBrains Mono 10"
xq xfce4-terminal /color-use-theme bool false
xq xfce4-terminal /color-background string "$(sch ColorBackground)"
xq xfce4-terminal /color-foreground string "$(sch ColorForeground)"
xq xfce4-terminal /color-cursor string "$(sch ColorCursor)"
xq xfce4-terminal /color-cursor-use-default bool false
xq xfce4-terminal /color-palette string "$(sch ColorPalette)"
xq xfce4-terminal /misc-cursor-shape string TERMINAL_CURSOR_SHAPE_BLOCK
xq xfce4-terminal /misc-cursor-blinks bool true
xq xfce4-terminal /color-bold-use-default bool false
xq xfce4-terminal /color-bold string "$(sch ColorBold)"
xq xfce4-terminal /color-selection string "$(sch ColorSelection)"
xq xfce4-terminal /color-selection-background string "$(sch ColorSelectionBackground)"
xq xfce4-terminal /color-selection-use-default bool false
xq xfce4-terminal /tab-activity-color string "$(sch TabActivityColor)"

# --- tapeta na wszystkich monitorach ---
say "Tapeta: neonowa metropolia"
W="$T/neonowa-metropolia-cyfrowa-1920$DOPISEK.jpg"
mons=$(xfconf-query -c xfce4-desktop -l 2>/dev/null | sed -n 's#^\(/backdrop/screen0/monitor[^/]*/workspace[0-9]*\)/.*#\1#p' | sort -u)
if [ -z "$mons" ] && command -v xrandr >/dev/null; then
  mons=$(xrandr --listmonitors | awk 'NR>1{print "/backdrop/screen0/monitor"$NF"/workspace0"}')
fi
for m in $mons; do
  xq xfce4-desktop "$m/last-image" string "$W"
  xq xfce4-desktop "$m/image-style" int 5
done

# --- panel (przy zatrzymanym panelu) ---
say "Panel w stylu Omarchy"
xfce4-panel --quit 2>/dev/null || true; sleep 2
ids=$(python3 -I config/panel.py)
echo "  wtyczki: $ids"
eval "$ids"
for f in ~/.config/xfce4/panel/docklike-*.rc; do
  [ -f "$f" ] || continue
  # wskaźniki w kolorze z motywu
  if grep -q '^indicatorColorFromTheme=' "$f"; then
    sed -i 's/^indicatorColorFromTheme=.*/indicatorColorFromTheme=true/' "$f"
  else
    sed -i '/^\[user\]/a indicatorColorFromTheme=true' "$f"
  fi
done

# --- styl menu, panelu i Thunara trafia do motywów, żeby zmieniał się razem z nimi ---
G=~/.config/gtk-3.0/gtk.css
mkdir -p ~/.config/gtk-3.0; touch "$G"
# starsze wersje trzymały te style w stylu użytkownika, który przesłaniał motyw
for b in menu panel thunar popup; do
  sed -i "/^\/\* >>> \(xfce-motyw\|jade-horse\): $b >>> \*\/\$/,/^\/\* <<< \(xfce-motyw\|jade-horse\): $b <<< \*\/\$/d" "$G"
done
for para in Jade-dark:gtk.css Amber-dark:gtk-amber.css; do
  sed -e "s/@PAGER@/${PAGER:-0}/g" -e "s/@SYSTRAY@/${SYSTRAY:-0}/g" -e "s/@PULSE@/${PULSE:-0}/g" -e "s/@WEATHER@/${WEATHER:-0}/g" -e "s/@DOCK@/${DOCK:-0}/g" "config/${para#*:}" >> ~/.themes/"${para%%:*}"/gtk-3.0/gtk.css
done

# bez pomniejszania gotowych obrazów ikon, które je rozmywa
T_CSS=~/.config/gtk-3.0/xfce4-panel-tweaks.css
if [ -f "$T_CSS" ]; then
  python3 -I -c 'import re,sys; p=sys.argv[1]; s=open(p).read(); open(p,"w").write(re.sub(r"#(pulseaudio-button|xfce4-power-manager-plugin) \* \{\s*-gtk-icon-transform:\s*scale\([\d.]+\);\s*\}\s*","",s))' "$T_CSS"
fi

(cd ~ && setsid xfce4-panel >/dev/null 2>&1 < /dev/null &)

# --- picom: zaokrąglenia, cień, przygaszanie nieaktywnych okien ---
mkdir -p ~/.config/picom ~/.local/bin
cp config/picom.conf ~/.config/picom/picom.conf
install -m 755 config/zaokraglone-rogi ~/.local/bin/zaokraglone-rogi
if command -v picom >/dev/null; then
  say "Zaokrąglenia, cień i przygaszanie okien (picom)"
  ~/.local/bin/zaokraglone-rogi on || echo "Uwaga: bez picom nie będzie zaokrągleń ani cienia."
fi

# --- LED-y i ciemny tryb wg motywu ---
say "Kolor LED-ów i ciemny tryb programów wg motywu"
mkdir -p ~/.local/bin ~/.config/autostart
install -m 755 config/keyboard-theme-sync ~/.local/bin/keyboard-theme-sync
[ -f ~/.config/keyboard-theme-sync.conf ] || cp config/keyboard-theme-sync.conf ~/.config/keyboard-theme-sync.conf
grep -q "^Amber-dark" ~/.config/keyboard-theme-sync.conf || printf "Amber-dark = #ff8a00\nmysz: Amber-dark = #ff7a00\n" >> ~/.config/keyboard-theme-sync.conf
rm -f ~/.local/bin/motyw-jade  # przełącznik ze starszej wersji paczki
printf '[Desktop Entry]\nType=Application\nName=Kolor LED-ów wg motywu\nExec=%s/.local/bin/keyboard-theme-sync\nTerminal=false\nOnlyShowIn=XFCE;\nX-GNOME-Autostart-enabled=true\n' "$HOME" > ~/.config/autostart/keyboard-theme-sync.desktop
pkill -f '^python3 .*keyboard-theme-sync' 2>/dev/null || true; sleep 1
(cd ~ && setsid ~/.local/bin/keyboard-theme-sync >/dev/null 2>&1 < /dev/null &)

# --- LibreWolf ---
for base in ~/.config/librewolf/librewolf ~/.librewolf; do
  ini="$base/installs.ini"; [ -f "$ini" ] || ini="$base/profiles.ini"
  [ -f "$ini" ] || continue
  prof=$(grep '^Default=' "$ini" | grep -v '=1$' | head -1 | cut -d= -f2)
  [ -n "$prof" ] && [ -d "$base/$prof" ] || continue
  say "LibreWolf: czcionki w profilu $prof"
  if [ -f "$base/$prof/user.js" ]; then
    grep -q 'font.name.sans-serif.x-western' "$base/$prof/user.js" || cat config/librewolf-user.js >> "$base/$prof/user.js"
  else
    cp config/librewolf-user.js "$base/$prof/user.js"
  fi
done

# --- przeładowanie ---
xfdesktop --reload 2>/dev/null || true
echo "Thunar i inne otwarte programy pokażą nowy wygląd po ponownym uruchomieniu."

say "Gotowe! Najlepiej wyloguj się i zaloguj ponownie. Cofnięcie zmian: $K/przywroc.sh"
