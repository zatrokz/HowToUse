# Változásnapló

Formátum: [Keep a Changelog](https://keepachangelog.com/hu/1.0.0/), verziózás: [SemVer](https://semver.org/lang/hu/).

## [0.3.0] – 2026-11-19

### Hozzáadva
- Valós UNAS `getProduct` mintaválasz (ZenoWell Luna Plus) mind az 5 nyelven, anonimizálva (ár, készlet, statisztika,
  marketing-címkék nélkül): `docs/samples/unas-getProduct-zw-luna-plus-kit.{hu,en,sk,de,nl}.xml`; `login` válasz token nélkül;
  `getProductParameter` kivonat.
- `CLAUDE.md`: UNAS API kezelési szabályok (kulcs, hívásszám, kódolt leírás).

### Módosítva
- UNAS integráció (`docs/05`) 0.3.0: mezőleképezés **véglegesítve** a valós válaszból – `<!HTML KOD>` dekódolás, nyelvi URL
  összeállítása `SefUrl`-ből, `AdditionalProducts` iránya (készülék → kiegészítő), alaptartozékok a leírás „A csomag tartalma”
  szekciójából, használati útmutató a `user-manual-url` paraméterből, `product_type` enum, nyelvfüggő/nyelvfüggetlen mezők listája.
  5.7 ellenőrzendő pontok lezárva (egy nyitott: `TimeStart` delta).
- `docs/samples/unas-api-mezok.md`: az első valós lekérés tanulságai.
- Fejlesztési ág mostantól `claude/bold-allen-0eb5rn` (CLAUDE.md, ATADAS.md).

## [0.2.1] – 2026-11-19

### Módosítva
- Döntési napló: UNAS API-hozzáférés megvan; a kompatibilis kiegészítők és a kockázat/ellenjavallat adatok
  forrása az UNAS; szakmai jóváhagyó Dr. Zátrok Zsolt.
- UNAS integráció: mezőleképezés bővítve (csatolt termékek, ellenjavallat-szekció), új 5.8 fejezet az API-kulcs kezeléséről.
- Admin felület: jóváhagyó szerepkör nevesítve.
- UNAS integráció: az API dokumentációból ellenőrzött hitelesítés, limitek, `Lang` paraméter és mezőnevek (`AdditionalProducts` = kompatibilis kiegészítők); kivonat `docs/samples/unas-api-mezok.md`.
- Felhasználói felület: a medimarket.hu valós főkategóriái és app-relevanciájuk; YouTube-csatorna hivatkozás.
- Többnyelvűség: induló nyelvek hu, en, sk, de, nl az UNAS 5 nyelvi domainje szerint; a terméktörzs nyelvi változatai az UNAS-ból.
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
