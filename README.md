# HowToUse – Medimarket készülékhasználati applikáció

Mobilalkalmazás (iOS / Android), amely a [medimarket.hu](https://www.medimarket.hu) webáruházban kapható
orvostechnikai eszközök **alapszintű, általános, nem személyre szabott** használatát mutatja be
rövid videókkal és ismertetőkkel. A termékadatok forrása az UNAS webáruház-rendszer, a videók a
Medimarket YouTube-csatornájáról kerülnek beágyazásra.

**Projektállapot:** `0.2.0` – tervezési fázis, kattintható prototípussal (lásd [CHANGELOG](CHANGELOG.md)).

---

## Tartalomjegyzék

### Dokumentáció (`docs/`)

| # | Dokumentum | Tartalom |
|---|-----------|----------|
| 01 | [Áttekintés és célok](docs/01-attekintes.md) | Cél, célcsoport, hatókör, nem-célok, sikerkritériumok |
| 02 | [Felhasználói felület és folyamatok](docs/02-felhasznaloi-felulet.md) | Képernyők, kereső, eszköz-oldal 7 témaköre, navigáció |
| 03 | [Admin felület](docs/03-admin-felulet.md) | Készülék-, kiegészítő- és videókezelés, jogosultságok, publikálási folyamat |
| 04 | [Adatmodell](docs/04-adatmodell.md) | Entitások, kapcsolatok, többnyelvű mezők, UNAS-forrású vs. saját adatok |
| 05 | [UNAS integráció](docs/05-unas-integracio.md) | API, szinkronizálási stratégia, mezőleképezés, képek, ellenőrzendő pontok |
| 06 | [Többnyelvűség](docs/06-tobbnyelvuseg.md) | Nyelvkezelés, fallback, fordítási munkafolyamat, videók nyelvenként |
| 07 | [Architektúra és technológia](docs/07-architektura.md) | Rendszerkomponensek, technológiai javaslat, repó-struktúra, környezetek |
| 08 | [Videók – YouTube](docs/08-video-youtube.md) | Beágyazás, csatorna-szervezés, metaadatok, nyelvek, offline viselkedés |
| 09 | [Megfelelőség és biztonság](docs/09-megfeleloseg-biztonsag.md) | Orvostechnikai tartalom szabályai, áruházi irányelvek, GDPR, adatvédelem |
| 10 | [Ütemterv](docs/10-utemterv.md) | Fázisok, mérföldkövek, szállítandók |
| 11 | [Nyitott kérdések és döntések](docs/11-nyitott-kerdesek.md) | Döntési napló, tisztázandó kérdések |

Részletes, fejezetszintű tartalomjegyzék: [docs/TARTALOMJEGYZEK.md](docs/TARTALOMJEGYZEK.md)

### Prototípus

- [docs/prototype/index.html](docs/prototype/index.html) – kattintható mobil prototípus (HU/EN, mintaadatok); élő nézet: https://claude.ai/artifact/QuNj2HQi9tRjwyc4AhyUBM

### Egyéb fájlok

- [CHANGELOG.md](CHANGELOG.md) – verziótörténet
- [docs/TARTALOMJEGYZEK.md](docs/TARTALOMJEGYZEK.md) – részletes tartalomjegyzék
- [docs/ATADAS.md](docs/ATADAS.md) – átadási jegyzet (folytatás Claude Code desktop appban)
- [scripts/toc.sh](scripts/toc.sh) – a részletes tartalomjegyzék újragenerálása

---

## Az alkalmazás egy mondatban

> A felhasználó kiválasztja a készülékét (kategória vagy név alapján), majd videókon és rövid
> ismertetőkön keresztül megismeri a készülék részeit, kiegészítőit, üzembe helyezését, alapvető
> használatát, kockázatait és a tipikus felhasználói hibákat – a saját nyelvén.

## Fő funkciók (összefoglaló)

| Terület | Funkció |
|---------|---------|
| Felhasználói app | Kereső (kategória + terméknév), eszköz-oldal 7 témakörrel, több videó/ismertető témakörönként, nyelvváltás |
| Admin felület | Készülékek, kompatibilis kiegészítők, YouTube-videók és szöveges ismertetők hozzárendelése, többnyelvű szerkesztés, publikálás |
| UNAS szinkron | Terméknév, leírás, képek, kategóriák, alaptartozékok, kapcsolódó termékek automatikus átvétele |
| Többnyelvűség | Magyar + angol induláskor; tetszőleges nyelv felvehető az adminban, fallback-lánccal |
| Videók | YouTube beágyazás, nyelvenkénti videóváltozat, playlist-alapú rendezés |

## Verziókezelés

- Szemantikus verziózás (`MAJOR.MINOR.PATCH`), git tag minden kiadáshoz.
- Minden változás a [CHANGELOG.md](CHANGELOG.md)-ben, a dokumentumok fejlécében verziószám és dátum.
- Fejlesztési ág: `claude/zealous-planck-17h9q9`; fő ág: `main`.

## Licenc / tulajdonjog

Belső Medimarket-projekt. Minden jog fenntartva.
