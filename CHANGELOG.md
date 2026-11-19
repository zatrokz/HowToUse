# Változásnapló

Formátum: [Keep a Changelog](https://keepachangelog.com/hu/1.0.0/), verziózás: [SemVer](https://semver.org/lang/hu/).

## [0.5.2] – 2026-11-19

### Hozzáadva
- Prototípus 0.4.2: tartozék-képek (137 egyedi tartozék képe az UNAS-ból, `docs/prototype/img/acc/`) a kiegészítő-listában és a
  tartozék-oldalon; 683 tartozék-hivatkozásból 683 képpel, 26-nál nincs kép (az adott tartozék nem aktív termék az UNAS-ban).

## [0.5.1] – 2026-11-19

### Módosítva
- Tulajdonosi döntések: **minden termék minden nyelven megjelenik** (az UNAS nyelvi rejtettségét az app nem veszi át);
  a **felszereltség-változatok nem külön készülékek** – nyirokmasszázs gépeknél 69 tételből 7 fő készülék (Power Q-1000 Plus / Premium,
  Q-2200, Q-8060, PressCare G250 / G280 / G400), a változatok a készülék-oldalon listázva webshop-linkkel. Szabály a `docs/05` 5.7-ben.
- Prototípus 0.4.1: 110 készülék, változat-lista a Bemutatás témakörben, nyelvi szűrés megszüntetve.

## [0.5.0] – 2026-11-19

### Hozzáadva
- **Adatbázis induló töltése** (`data/unas/`): a teljes UNAS-terméktörzs 5 nyelven – 437 aktív termék, 159 kategória, hosszú
  leírások nyelvenként külön fájlban; anonimizálva (ár, készlet, statisztika nélkül). 31 API-hívás, 3 mp szünetekkel, 0 hiba.
- Prototípus 0.4.0: mind a 172 otthoni/rendelői készülék (18 kategóriacsempe), valós képekkel, a leírásokból automatikusan kinyert
  csomagtartalommal, ellenjavallatokkal, lépésekkel, GYIK-kel és 23 beágyazott videóval (YouTube + Vimeo); „Csak eü. szakembernek”
  jelölés; kiegészítő-oldal a kiegészítő saját webshop-linkjével.

### Módosítva
- `docs/05` 0.4.0: teljes betöltés rögzítve; README adat-szekció.

## [0.4.1] – 2026-11-19

### Hozzáadva
- YouTube-csatorna felmérése: a Dr. Zátrok Zsolt csatorna 90 videójának katalógusa (`docs/samples/youtube-csatorna-videok.md/.json`),
  27 videó kézi párosítása az 5 prototípus-készülékhez témakörönként (bemutatás, használat, GYIK, kockázatok), nyelv és forrás
  (UNAS-leírás / csatorna) jelöléssel; forgatási javaslatok a hiányzó videókra.
- Prototípus 0.3.1: videókártyák bélyegképpel a témaköröknél, nyelvi szűréssel (az adott nyelv videói, különben magyar), YouTube- és
  Vimeo-linkkel; bélyegképek a `docs/prototype/img/yt/` alatt.

### Módosítva
- `docs/08`: a csatorna valós adatai (azonosító, feltöltés-lista), felmérés eredménye, szinkron-módszer (lejátszási lista / Data API,
  RSS csak az új videókra), tulajdonosi döntés a felhasználhatóságról.
- Fejlesztői környezet: a `www.youtube.com` és `i.ytimg.com` hosztok engedélyezve (a tulajdonos jóváhagyásával).

## [0.4.0] – 2026-11-19

### Hozzáadva
- Prototípus 0.3.0 (`docs/prototype/`): valós UNAS-tartalommal, 5 készülékkel (ZenoWell Luna Plus, Dolito, DermaDry Total,
  SaltDome, PeroBravo) és mind az 5 nyelven (hu/en/sk/de/nl). Témakörök valós adatból: bemutatás + csomagtartalom + útmutató PDF,
  kompatibilis kiegészítők (UNAS `AdditionalProducts`), használat lépésről lépésre, GYIK, kockázatok (ellenjavallat-szekció és
  orvosi figyelmeztetés). Nyelvi láthatóság (`NotVisibleInLanguage`) és nyelvi fallback kezelve. Élő nézet a README-ben.
- `docs/prototype/data/products.json` (a mintákból generált adat) és `docs/prototype/img/` (termékképek).

### Módosítva
- README: új élő nézet link; a régi mintaadatos változat linkje megmarad összehasonlításhoz.

## [0.3.1] – 2026-11-19

### Hozzáadva
- További 4 készülék valós, anonimizált `getProduct` mintája mind az 5 nyelven (Dolito, DermaDry Total, SaltDome, PeroBravo),
  ütemezett (3 mp szünetes) lekéréssel; összesen 25 mintafájl.

### Módosítva
- UNAS integráció (`docs/05`) 0.3.1: ellenjavallat-kinyerés CSS-osztály alapján (a mikrodata nem következetes), használati
  útmutató nyelvfüggő, `NotVisibleInLanguage` angol nyelvnév, `enummore` paraméterek (`Stimulációs módok`, `Javaslat`, `CE`,
  `EAN`, `mpn`) leképezése, csomagtartalom-szekció változó sorszámmal, hívásszám-fegyelem szabályai.
- `docs/samples/unas-api-mezok.md`, `CLAUDE.md`: a fenti tanulságok és a hívásszám-szabály.

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
