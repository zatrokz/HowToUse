# 01 – Áttekintés és célok

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 1.1 Mi ez az alkalmazás?

A **HowToUse** egy mobilalkalmazás, amely a medimarket.hu-n kapható orvostechnikai eszközök
(pl. lézerterápiás, mágnesterápiás, elektroterápiás, pneumatikus kompressziós készülékek)
**alapszintű, általános használatát** mutatja be. Nem kezelési protokollt ad, nem személyre szabott
tanácsot nyújt: azt mutatja meg, *hogyan kell a készüléket kézbe venni, összerakni, bekapcsolni,
a tartozékokat csatlakoztatni, és mire kell figyelni*.

A tartalom gerince a rövid videó, amelyet szöveges ismertető (és szükség esetén kép, PDF) egészít ki.

## 1.2 Miért készül?

| Probléma ma | Megoldás az appban |
|-------------|--------------------|
| A vevők a kézikönyvet nem olvassák el, telefonon kérdeznek az ügyfélszolgálattól | Minden gyakori kérdésre videós válasz, egy helyen |
| A tartozékok (kábelek, elektródák, applikátorok) funkciója nem egyértelmű | Készülék + tartozék páros szintű bemutatás |
| Visszaküldések, reklamációk tipikus kezelési hibákból | "Gyakori hibák" és "Üzembe helyezés" témakör minden eszköznél |
| Külföldi vevők, több nyelvű piac | Többnyelvű felület és tartalom indulástól |
| A terméktartalom már megvan az UNAS-ban, ne legyen duplikálva | UNAS-szinkron: név, leírás, kép, alaptartozék, kapcsolódó termék automatikusan |

## 1.3 Célcsoport

1. **Elsődleges:** a készüléket megvásárló magánszemély (otthoni használó), a vásárlás utáni első
   napokban és a tartozékok bővítésekor.
2. **Másodlagos:** terapeuták, gyógytornászok, rendelők, akik több készüléket használnak és a
   tartozék-kompatibilitást keresik.
3. **Belső:** Medimarket ügyfélszolgálat (gyors linkküldés egy témakörre), tartalomszerkesztők (admin).

## 1.4 Hatókör (MVP)

**Benne van**
- Kereső: termék-kategória és terméknév szerint.
- Eszköz-oldal 7 fix témakörrel (lásd 02. fejezet), témakörönként **több** tartalmi elem.
- Kompatibilis kiegészítők listája és funkciója, eszköz + kiegészítő páros bemutatása.
- YouTube-videók beágyazása; szöveges ismertetők; képek.
- Admin felület: készülékek, kiegészítők, kompatibilitás, tartalmak, videók, nyelvek, publikálás.
- UNAS-szinkron a terméktörzs-adatokra.
- Öt nyelv indulástól (magyar, angol, szlovák, német, holland – az UNAS 5 nyelvi domainje szerint), bővíthető nyelvlista.
- iOS és Android (egy kódbázis), opcionálisan webes nézet (link az UNAS termékoldalról).

**Nincs benne (MVP-n kívül, lásd 10. fejezet)**
- Felhasználói fiók, kezelési napló, személyre szabott kezelési terv.
- Vásárlás, kosár, ár megjelenítés (link az UNAS termékoldalra elegendő).
- Push értesítés, offline videó.
- Chat / ügyfélszolgálati integráció.

## 1.5 Nem-célok és korlátok (szándékosan)

- **Nem orvosi eszköz az app**, nem diagnosztizál, nem ajánl dózist/protokollt. Minden tartalom a
  gyártói használati útmutató (IFU) kiegészítője, nem helyettesítője. (Részletek: 09. fejezet.)
- Nem helyettesíti az UNAS termékoldalt; a terméktörzs **forrása az UNAS marad**, az app nem ír vissza.

## 1.6 Sikerkritériumok

| Mutató | Cél az első 6 hónapban |
|--------|------------------------|
| Lefedett készülékek | A top 20 forgalmú készülék mind a 7 témakörrel feltöltve |
| Ügyfélszolgálati "hogyan kell…" hívások | –30 % a lefedett készülékeknél |
| Videó-megtekintés / telepítés | ≥ 3 videó / aktív felhasználó |
| Nyelvek | HU + EN 100 % lefedettség a publikált tartalmakon |
| Tartalomfrissítés átfutása | Új videó publikálása az adminból < 10 perc, app-frissítés nélkül |

## 1.7 Alapelvek a tervezéshez

1. **Tartalom = adat, nem kód.** Minden szöveg, videó, kapcsolat az adminból szerkeszthető,
   app store-frissítés nélkül megjelenik.
2. **UNAS a terméktörzs gazdája, az app a "hogyan használd" tudás gazdája.** A két adathalmaz
   világosan elválik (04. fejezet).
3. **Minden tartalmi pont lista.** Egy témakörhöz 0..n videó/szöveg/kép tartozhat, sorrendezhetően.
4. **Nyelv = dimenzió, nem másolat.** Minden szerkeszthető szöveg nyelvenként tárolódik, fallback-kel.
5. **Publikálási kapu.** Orvosi relevanciájú tartalom (kockázatok) csak szakmai jóváhagyás után élesedik.
