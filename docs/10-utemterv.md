# 10 – Ütemterv

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

| Fázis | Tartalom | Szállítandó | Becslés |
|-------|----------|-------------|---------|
| **0. Tervezés** (ez) | Követelmények, adatmodell, architektúra, nyitott kérdések | `docs/` 01–11, README, CHANGELOG | kész (0.1.0) |
| **1. Alapok és UNAS** | Monorepo, CMS telepítés, adatmodell implementálása, UNAS-sync (teszt API-kulccsal), kép-tükrözés | admin bejelentkezés, termékek látszanak UNAS-ból | 2–3 hét |
| **2. Admin tartalomkezelés** | Témakörök, tartalmi elemek, videó-beillesztés, kompatibilitás, nyelvek, publikálási folyamat, katalógus-generátor | első 3 készülék teljes tartalommal feltöltve HU/EN | 3–4 hét |
| **3. Mobil app MVP** | Kereső, kategória, eszköz-oldal, 7 témakör, kiegészítő- és páros-oldal, videólejátszó, nyelvváltás, offline katalógus | TestFlight / belső Android teszt | 4–5 hét |
| **4. Tartalomfeltöltés** | Top 20 készülék videói és ismertetői, fordítás EN, szakmai jóváhagyás | 20 publikált készülék | párhuzamosan 2–4. fázissal |
| **5. Kiadás** | Store-anyagok, adatvédelmi tájékoztató, webes nézet, univerzális linkek, UNAS termékoldalak linkelése | App Store + Google Play élesben, v1.0.0 | 2 hét |
| **6. Bővítés** | QR-kód a dobozról, visszajelzések elemzése, további nyelvek, push, offline videó-cache, ügyfélszolgálati megosztó-linkek | v1.x | folyamatos |

Mérföldkő-feltételek: minden fázis végén demó, CHANGELOG-bejegyzés, git tag.

## Következő konkrét lépések (1. fázis indítása)
1. Döntés a technológiáról (07. fejezet javaslata) és a 11. fejezet nyitott kérdéseiről.
2. UNAS API-kulcs beszerzése, `getProduct` minta-válasz mentése a repóba (`docs/samples/`), mezők véglegesítése.
3. YouTube-csatorna playlist-struktúra és cím-konvenció bevezetése.
4. Wireframe-ek (Figma vagy HTML prototípus) a 02. fejezet alapján.
5. Monorepo-váz létrehozása, CI.
