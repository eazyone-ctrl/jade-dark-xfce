# Jade-dark dla XFCE

Wygląd XFCE w stylu motywu **Jade Horse** z [Omarchy](https://github.com/basecamp/omarchy):
ciemna jadeitowa zieleń, miętowe akcenty i tapety w tych kolorach.

## Co zawiera

- **Kolory:** paleta Jade Horse z Omarchy, z tłami dopasowanymi do MX Narzędzi, w oknach, menu, panelu i terminalu.
- **Czcionka:** JetBrains Mono wszędzie. Tekst w programach i menu ma 9 pt, tytuły okien 9 pt pogrubione,
  a terminal 10 pt. W zestawie jest też Inter (bez wariantu Display), której używa LibreWolf.
- **Ikony:** Colloid w wariancie Teal Everforest Dark. Nakładka `Jade-Colloid` dodaje jednokolorowe ikony menu i okna Ustawień oraz małe ikony paska Thunara, a brakujące bierze z Yaru-sage-dark (pakiet `yaru-theme-icon`).
- **Foldery:** wypełnione we wszystkich rozmiarach, także w widoku listy, a symbol zawartości (nuta, obrazek, strzałka…) jest ciemniejszy niż w Colloid, żeby był czytelny.
- **Symbole plików (emblematy):** jednokolorowe, w kolorze nakładki i w jednej wielkości, zamiast kolorowej mieszanki z Colloid, Yaru i gnome.
- **Tapety:** ustawiana jest „Neonowa metropolia” w kolorach motywu, w wersji komputerowej (siatka, linie ekranu, kolumny danych).
  W zestawie są też jej wersja bez efektów i oryginał oraz bursztynowe wersje.
- **Panel:** cienki górny pasek, jak w Omarchy, z lekko przezroczystym tłem (krycie 70%). Ikony mają 16 px. Po lewej są menu, numery pulpitów i otwarte programy,
  na środku zegar z datą („wt 17.11  17:45”) i pogoda z konturowymi ikonami `jade-outline`, a po prawej dźwięk i ikony systemowe.
- **Okna:** motyw `Jade-dark-compact` z belką 28 px, rogami 10 px i ramką 2 px.
  Aktywne okno ma nasyconą zieloną ramkę `#2cb083`, nieaktywne przygaszoną `#1a2b25`. Przyciski i tytuł mają stonowany kolor `#86948c`, po najechaniu pojawia się okrąg w tym samym kolorze, a przyciski i tytuł są wyśrodkowane na belce. Przyciski są w zwykłej kolejności: minimalizuj, maksymalizuj, zamknij.
- **Ciemny tryb:** ciemny tryb programów zależy od koloru tła motywu.
- **Powiadomienia i okienko głośności:** zwarte, nieprzezroczyste, z zieloną ramką i wyraźnym paskiem.
- **Okno kończenia sesji:** małe przyciski z samym tekstem, bez ikon. Obrazy na przyciskach i w menu są wyłączone.
- **Tekst:** stonowany `#9fb0a7` zamiast bieli, a wyróżniony `#b2c5bb`, żeby nie męczył oczu.
- **Ramki w oknach:** obszary wyróżnia jaśniejsze tło zamiast linii.
- **Zakładki i tło okien:** ciemniejsze tło okien, a aktywna zakładka z pogrubionym tekstem zlewa się z obszarem pod nią.
- **Terminal:** schemat kolorów `Jade-dark` (też do wyboru w Preferencjach terminala), kursor blokowy, JetBrains Mono 10.
- **Zaokrąglenia:** pola tekstowe, listy wyboru, przyciski i podświetlenie pozycji w menu w formie pill; okna, menu i podpowiedzi 10 px; listy i ramki 6 px;
  pola wyboru delikatnie zaokrąglone. Pole wielowierszowe ma odstęp tekstu od ramki.
- **Pola wyboru i opcje w menu:** we wszystkich menu takie jak w menu Thunara (zielony kwadrat z białym znacznikiem, 13 px).
  Pola tekstowe i listy wyboru mają ramkę w kolorze przycisków i nie zmieniają wysokości po najechaniu.
- **Menu programów (Whisker Menu):** przycisk z logo MX w kolorze akcentu (`mx-menu`), lista programów z ikonami 24 px i większymi odstępami, kategorie z nazwami po lewej, niskie pole wyszukiwania u góry i ramka 2 px w kolorze aktywnego okna. Kategorie i przyciski ustawień, blokady oraz wylogowania (ikona zasilania) mają jednokolorowe ikony; „Wszystkie programy” ma siatkę kafelków, a „Inne” własną ikonę (`config/xfce-other.directory`).
- **Thunar:** konturowe ikony paska narzędzi, także ołówek edycji ścieżki i akcje użytkownika (Otwórz tutaj terminal, Otwórz jako root, Szukaj tutaj, Utwórz dowiązanie), które ustawia `config/uca-ikony.py`.
- **Cień (picom):** zwykły czarny cień wokół okien. Nieaktywne okna są przygaszone o 25%.
  Podpowiedzi, panel i menu nie mają cienia, a menu GTK nie mają przezroczystej ramki wokół siebie.
- **LED-y:** klawiatura Keychron V1 8K, mysz Corsair M75 i wentylatory na kontrolerze ASUS AURA świecą kolorem motywu (szczegóły niżej).
- **LibreWolf:** Inter i JetBrains Mono jako domyślne czcionki stron.

## Warianty kolorów

W paczce są dwa warianty: `Jade-dark` (zielony) i `Amber-dark` (bursztynowy). Domyślnie instaluje się Jade-dark, a `./instaluj.sh amber` ustawia od razu bursztyn. Po instalacji każdy element zmieniasz osobno, bez żadnego skryptu, i możesz je dowolnie łączyć:

| Element | Gdzie | Jade | Amber |
|---|---|---|---|
| Okna programów, panel, menu, dok | *Wygląd → Styl* | `Jade-dark` | `Amber-dark` |
| Ikony | *Wygląd → Ikony* | `Jade-Colloid` | `Amber-Colloid` |
| Belki okien | *Menedżer okien → Wygląd → Styl* | `Jade-dark-compact` | `Amber-dark-compact` |
| Tapeta | *Pulpit → Tło* | bez dopisku | z dopiskiem `-amber` |
| Kolory terminala | *Terminal → Preferencje → Kolory → Profile* | `Jade-dark` | `Amber-dark` |

Sama zmiana motywu przełącza tylko LED-y i pilnuje ciemnego trybu programów.

Style menu, panelu i Thunara są w plikach `gtk.css` motywów (`~/.themes/*/gtk-3.0/`), a instalator wpisuje do nich numery wtyczek z Twojego panelu.

## Instalacja

```bash
tar xf Jade-dark.tar.xz
cd Jade-dark
./instaluj.sh
```

Uruchom skrypt **bez sudo**. Hasło będzie potrzebne tylko wtedy, gdy trzeba doinstalować `picom`
albo `yaru-theme-icon`. W trakcie instalacji panel na chwilę zniknie. Otwarte programy, także Thunar, pokażą nowy wygląd
po ponownym uruchomieniu.
Po instalacji najlepiej wyloguj się i zaloguj ponownie.

Skrypt sam znajduje wtyczki w panelu, więc działa także przy innym układzie panelu niż oryginalny.
Wtyczki, których nie masz (np. pogoda), pomija, a pozostałe przesuwa na koniec panelu.

## Ekran logowania i inne konta

Instalator ustawia wygląd tylko dla Ciebie (`~/.themes`, `~/.local/share/icons`, `~/.local/share/fonts`).
Ekran logowania LightDM i inne konta korzystają z katalogów systemowych, więc żeby też miały ten wygląd, skopiuj motywy, ikony i czcionki:

```bash
sudo cp -r ~/.themes/Jade-dark ~/.themes/Amber-dark ~/.themes/Jade-dark-compact ~/.themes/Amber-dark-compact /usr/share/themes/
sudo cp -r ~/.local/share/icons/{Jade-Colloid,Amber-Colloid,Colloid-Teal-Everforest-Dark,Colloid-Teal-Everforest-Light} /usr/share/icons/
sudo install -Dm644 -t /usr/local/share/fonts/jetbrains-mono ~/.local/share/fonts/JetBrainsMono*-*.ttf && sudo fc-cache -f
```

Potem w *Ustawienia → LightDM GTK Greeter* wybierz motyw, ikony, czcionkę `JetBrains Mono` i tapetę
skopiowaną do `/usr/share/backgrounds` (ekran logowania nie widzi plików z katalogu domowego).
Po każdej zmianie motywu kopiuj pliki jeszcze raz.

## Ciemne strony w LibreWolf (Dark Reader)

Strony internetowe przyciemnia dodatek [Dark Reader](https://addons.mozilla.org/firefox/addon/darkreader/).
Instalator go nie instaluje, bo przy instalacji trzeba w przeglądarce zaakceptować uprawnienia dodatku.

Po zainstalowaniu dodatku wczytaj kolory Jade Horse z pliku `config/darkreader-jade-horse.json`:
ikona Dark Reader → **Ustawienia** → **Zaawansowane** → **Importuj ustawienia**.

## LED-y w kolorze motywu

Usługa `~/.local/bin/keyboard-theme-sync` startuje przy logowaniu i przy zmianie motywu ustawia kolor LED-ów. Obsługuje urządzenia:

- klawiatura Keychron V1 8K (QMK/VIA), z jednolitym efektem zamiast zapisanego w klawiaturze,
- mysz Corsair M75 (`1b1c:1bf0`),
- wentylatory i LED-y płyty na kontrolerze ASUS AURA USB (`0b05:19af`), 32 LED-y na złącze.

Urządzenia, których nie ma, są pomijane. Nic nie jest zapisywane w ich pamięci, więc przed zalogowaniem działają ich własne efekty.
Do dostępu bez sudo potrzebne są reguły udev, których instalator nie dodaje: dla tych urządzeń działają np. reguły OpenRGB (`60-openrgb.rules`), a dla klawiatury własna reguła z `TAG+="uaccess"`.

Własne kolory ustawisz w `~/.config/keyboard-theme-sync.conf`:

```
Jade-dark = #00ff33
mysz: Jade-dark = #00ff6a
```

Po zmianie uruchom `~/.local/bin/keyboard-theme-sync --once`. Podgląd kolorów wszystkich motywów: `--list`.

## Kompozytor

Zaokrąglenia, cień i przygaszanie okien robi picom. Nie włączaj kompozytora xfwm4 ani nie zmieniaj kompozytora
w MX Tweak, bo picom wtedy nie wystartuje. Żeby go przywrócić, uruchom `~/.local/bin/zaokraglone-rogi on`.

## Cofnięcie zmian

Przed zmianami skrypt zapisuje kopię ustawień w `~/.config/xfce4/kopia-przed-jade-horse-DATA/`.
Żeby przywrócić poprzedni wygląd, uruchom znajdujący się tam plik `przywroc.sh`, a potem wyloguj się
i zaloguj ponownie.

## Dostosowanie

- **Cień i przygaszanie:** `~/.config/picom/picom.conf` (`shadow-color`, `shadow-radius` na górze pliku, `dim` w regułach). Po zmianie przeładuj picom: `~/.local/bin/zaokraglone-rogi on`.
  Po każdym przeładowaniu picom uruchom ponownie LibreWolf, bo inaczej jego menu mają czarne rogi.
- **Inna tapeta:** *Ustawienia → Pulpit*, tapety leżą w `~/Obrazy/Tapety/cyberpunk`.
- **Liczba pulpitów:** *Ustawienia → Obszary robocze*. Numery 1–5 są już przygotowane.

## Wymagania

Potrzebne są XFCE 4.18 lub nowsze, picom 12 lub nowszy, python3 oraz Debian, MX Linux, Ubuntu
lub inna dystrybucja z apt.

## Licencje

Czcionki Inter i JetBrains Mono są na licencji SIL OFL (szczegóły w `fonts/licencje`).
Motyw mx-ease jest na licencji GPL (szczegóły w `themes/Jade-dark/COPYING`).
Ikony Colloid (vinceliuice/Colloid-icon-theme, commit ceac660) są na licencji GPL-3.0 (szczegóły w `ikony/LICENSE-Colloid`).
Paleta Jade Horse pochodzi z projektu Omarchy (basecamp/omarchy).
Zdjęcie „Neonowa metropolia”: Francois Hoang, Unsplash (unsplash.com/photos/MFYlCoSm-0o), licencja Unsplash.
