# 03 – Admin felület

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

Webes, bejelentkezéssel védett felület a Medimarket tartalomszerkesztői számára. Cél: egy új videó vagy
ismertető hozzáadása, kiegészítő hozzárendelése **10 percen belül**, fejlesztő nélkül.

## 3.1 Szerepkörök

| Szerepkör | Jogok |
|-----------|-------|
| **Adminisztrátor** | Minden; nyelvek, felhasználók, UNAS-szinkron beállításai, témakörök |
| **Szerkesztő** | Készülékek/kiegészítők tartalmainak szerkesztése, videók hozzárendelése, piszkozat mentése, jóváhagyásra küldés |
| **Szakmai jóváhagyó** (Dr. Zátrok Zsolt) | Tartalmak jóváhagyása és publikálása (kötelező a `risks` témakörnél és minden orvosi tartalomnál) |
| **Fordító** | Csak a hozzárendelt nyelv(ek) szöveges mezőinek szerkesztése |
| **Megtekintő** | Olvasás, előnézet (pl. ügyfélszolgálat) |

## 3.2 Fő menüpontok

1. **Irányítópult** – hiányzó tartalmak (eszköz × témakör × nyelv mátrix), jóváhagyásra váró elemek,
   utolsó UNAS-szinkron állapota, hibák, 👍/👎 visszajelzések összesítése.
2. **Készülékek** – lista (UNAS-ból szinkronizált termékek közül a *készülék* típusúak), státusz
   (rejtett / piszkozat / publikált), nyelvi lefedettség %.
3. **Kiegészítők és tartozékok** – ugyanaz kiegészítőkre; kompatibilitási mátrix nézet.
4. **Videók** – YouTube-videótár: beillesztett videók, nyelv, időtartam, hol használjuk; „árva" videók.
5. **Témakörök** – a 7 alap témakör neve nyelvenként, sorrend, ikon; új témakör felvétele.
6. **Nyelvek** – nyelvek listája, engedélyezés, fallback-sorrend, felületi szövegek (UI-stringek) fordítása.
7. **UNAS szinkron** – kézi indítás, napló, mezőleképezés, kategória-szűrő (mely UNAS-kategóriák kerülnek be).
8. **Felhasználók** – meghívás, szerepkör.

## 3.3 Készülék-szerkesztő (a legfontosabb képernyő)

Fejléc: UNAS-ból érkező (csak olvasható) adatok: név, cikkszám, kategóriák, fő kép, rövid leírás, UNAS-URL;
„Frissítés UNAS-ból" gomb. Jelzés, ha az UNAS-ban a termék inaktív/törölt.

Fülek:

### a) Alapadatok (saját mezők)
- Megjelenített név felülírása nyelvenként (opcionális, alapértelmezés az UNAS-név).
- Szinonimák / keresőkulcsszavak nyelvenként („izomstimulátor", „EMS", …).
- Terméktípus: *készülék* / *kiegészítő* / *fogyóanyag* (UNAS-paraméterből javasolt, kézzel felülírható).
- Láthatóság az appban: rejtett / piszkozat / publikált.
- Megjelenő témakörök ki/be kapcsolása ennél az eszköznél.

### b) Kiegészítők (kompatibilitás)
- Táblázat: kiegészítő · típus (alaptartozék / opcionális / fogyóanyag) · funkció-leírás nyelvenként ·
  forrás (UNAS „kapcsolódó termék" / kézi) · sorrend.
- „Hozzáadás UNAS-ból" kereső; az UNAS-ból szinkronizált kapcsolatok *javaslatként* jelennek meg,
  egy kattintással elfogadhatók; a kézi kapcsolatokat a szinkron nem írja felül.

### c) Tartalmak témakörönként
Hét (vagy több) alfül, mindegyikben **rendezhető lista** (drag & drop) a tartalmi elemekről:

| Mező | Leírás |
|------|--------|
| Típus | videó (YouTube) / szöveges ismertető / kép-galéria / PDF / külső link |
| Cím | nyelvenként |
| Videó | YouTube URL beillesztése → azonosító kinyerése, cím/bélyegkép/időtartam automatikus lekérése (oEmbed / Data API), **nyelvenként eltérő videó** megadható |
| Kezdő/záró időpont | opcionális (ugyanazon hosszabb videó egy részlete) |
| Szöveg | formázott szerkesztő (címsor, lista, félkövér, kép), nyelvenként |
| Kiegészítő-hivatkozás | a `device_accessory_use` témakörnél kötelező: melyik kiegészítőre vonatkozik |
| Állapot | piszkozat / jóváhagyásra vár / publikált / archivált |
| Érvényesség | opcionális „érvényes eddig" (pl. firmware-váltás) |

### d) Előnézet
A mobil nézet élethű előnézete nyelvenként (webes rendering ugyanazzal a komponenskönyvtárral).

### e) Napló
Ki, mikor, mit módosított; visszaállítás korábbi verzióra (tartalomverziózás).

## 3.4 Publikálási folyamat

```
piszkozat ──► jóváhagyásra vár ──► publikált ──► archivált
   ▲               │  (elutasítás, megjegyzéssel)
   └───────────────┘
```
- A `risks` témakör és minden ellenjavallatot említő szöveg **csak Szakmai jóváhagyó** által publikálható.
- Publikáláskor a katalógus verziószáma nő; az app a következő indításnál/frissítésnél tölti le a deltát.
- Ütemezett publikálás (dátum/idő) opcionális.

## 3.5 Tömeges műveletek
- CSV/Excel import-export a szöveges mezőkre (fordítóirodának).
- Videó-playlist import: egy YouTube-playlist videóinak tömeges hozzárendelése egy eszközhöz
  (cím-konvenció alapján témakörbe sorolás, lásd 08. fejezet).

## 3.6 Technikai megjegyzés
Az admin a tartalomkezelő (headless CMS) beépített admin felületére épül, egyedi mezőkkel és
nézetekkel (07. fejezet), így a fenti funkciók túlnyomó része konfiguráció, nem egyedi fejlesztés.
