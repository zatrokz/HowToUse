# Változásnapló

Formátum: [Keep a Changelog](https://keepachangelog.com/hu/1.0.0/), verziózás: [SemVer](https://semver.org/lang/hu/).

## [0.2.1] – 2026-11-19

### Módosítva
- Döntési napló: UNAS API-hozzáférés megvan; a kompatibilis kiegészítők és a kockázat/ellenjavallat adatok
  forrása az UNAS; szakmai jóváhagyó Dr. Zátrok Zsolt.
- UNAS integráció: mezőleképezés bővítve (csatolt termékek, ellenjavallat-szekció), új 5.8 fejezet az API-kulcs kezeléséről.
- Admin felület: jóváhagyó szerepkör nevesítve.
- `CLAUDE.md`: a felhasználó laikus, lépésről lépésre útmutatók.

## [0.2.0] – 2026-11-19

### Hozzáadva
- Kattintható HTML prototípus (`docs/prototype/index.html`): kereső, kategória-csempék, találati lista,
  eszköz-oldal 7 témakörrel, kompatibilis kiegészítők, eszköz × kiegészítő páros nézet, kockázatok,
  gyakori hibák, HU/EN váltás nyelvi fallback-jelzéssel, legutóbbiak, beállítások – mintaadatokkal.
- `.gitignore` az átadási archívumokra.

### Módosítva
- README: projektállapot, prototípus hivatkozás; átadási jegyzet frissítve (a branch a GitHubon van).

## [0.1.0] – 2026-11-19

### Hozzáadva
- Projekt-dokumentáció első változata (tervezési fázis):
  áttekintés, felhasználói felület, admin felület, adatmodell, UNAS integráció,
  többnyelvűség, architektúra, YouTube-videók, megfelelőség, ütemterv, nyitott kérdések.
- README tartalomjegyzékkel, részletes tartalomjegyzék (`docs/TARTALOMJEGYZEK.md`).
- CHANGELOG, átadási jegyzet (`docs/ATADAS.md`), tartalomjegyzék-generáló script (`scripts/toc.sh`).
