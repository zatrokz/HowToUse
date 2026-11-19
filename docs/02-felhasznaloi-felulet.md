# 02 – Felhasználói felület és folyamatok

> Verzió: 0.2.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 2.1 Navigációs térkép

```
[Indítás / nyelvválasztás első indításnál]
        │
        ▼
[1. Kereső (kezdőképernyő)]
   ├── Kategória-csempék  ──► [2. Kategória: eszközlista]
   ├── Terméknév-kereső   ──► [2'. Találati lista]
   ├── Legutóbb megnyitott eszközök
   └── (később) QR-kód olvasás a dobozról
        │
        ▼
[3. Eszköz-oldal]  (fejléc: kép, név, kategória, UNAS-link)
   ├── 3.1 Bemutatás – részek és alaptartozékok
   ├── 3.2 Kompatibilis kiegészítők – lista + funkció ──► [4. Kiegészítő-oldal]
   ├── 3.3 Üzembe helyezés
   ├── 3.4 Készülék + kiegészítő alap használata ──► [5. Páros-oldal: eszköz × kiegészítő]
   ├── 3.5 Használat – általános alkalmazási mód
   ├── 3.6 Kockázatok – tiltott / óvatosságot igénylő állapotok
   └── 3.7 Gyakori hibák
        │
        ▼
[6. Tartalom-nézet]  (videólejátszó + szöveg; "következő" a témakör listáján belül)

[Beállítások]: nyelv, videóminőség/adatforgalom, impresszum, adatvédelem, verzió
```

## 2.2 Képernyők részletesen

### 1. Kereső (kezdőképernyő)

- Felül: keresőmező (terméknév, típusszám, kiegészítő neve, szinonima – pl. „myolito", „EMS", „izomstimulátor").
  Keresés **helyben**, a letöltött katalóguson, írás közben szűkül (prefix + fuzzy).
- Alatta **kategória-csempék** ikonnal (pl. Lézerterápia, Mágnesterápia, Elektroterápia / TENS-EMS,
  Pneumatikus kompresszió, Inhalátorok, Izzadásgátló (iontoforézis), …). A kategória-lista az
  UNAS kategóriafából származik, de az adminban kijelölhető, mely kategóriák jelenjenek meg, milyen
  néven és sorrendben.
- „Legutóbb megnyitott" sor (lokálisan tárolva, max. 5).
- Találati lista elem: kép, név, kategória, „X videó" jelző, nyelvi lefedettség-jelző (ha az adott nyelven
  nincs tartalom, kis jelzés: „angol tartalom").

### 2. Kategória / találati lista

- Rács vagy lista váltó, ábécé- vagy népszerűségi sorrend.
- Szűrő: csak készülékek / csak kiegészítők (alapértelmezés: készülékek).

### 3. Eszköz-oldal

Fejléc: fő kép (UNAS), név, rövid leírás (UNAS, első 1–2 mondat), kategória címke, gomb:
„Megnézem a webshopban" (UNAS termékoldal URL, deep link). Alatta a **7 témakör kártyaként**,
mindegyiken a tartalmak száma (pl. „3 videó · 1 ismertető") és az első videó bélyegképe.

A 7 témakör **fix, kódolt sorrendű** (az adminban átnevezhető nyelvenként, ki/be kapcsolható eszközönként,
de új témakör felvétele adminból is lehetséges – lásd 04. fejezet, `Topic` entitás):

| Kód | Témakör | Mit tartalmaz |
|-----|---------|---------------|
| `intro` | Bemutatás | A készülék részei, kezelőszervek, alaptartozékok a dobozban |
| `accessories` | Kompatibilis kiegészítők | Lista + mindegyik funkciója; innen nyílik a kiegészítő-oldal |
| `setup` | Üzembe helyezés | Kicsomagolás, töltés, első bekapcsolás, csatlakoztatás, párosítás |
| `device_accessory_use` | Készülék + kiegészítő használata | Páros szintű tartalom: pl. „Mire valók a színes kábelek? Mire a szürke?" |
| `general_use` | Használat – általános alkalmazás | Általános, nem személyre szabott alkalmazási mód; menü, programok, időzítés |
| `risks` | Kockázatok | Állapotok, amikor a használat tilos vagy odafigyelést igényel |
| `common_mistakes` | Gyakori hibák | Tipikus felhasználói hibák, amelyek a működést akadályozzák, és elhárításuk |

Ha egy témakörhöz az adott eszköznél nincs tartalom, a kártya szürkén jelenik meg „Hamarosan" felirattal
(adminból eszközönként elrejthető is).

### 3.2 → 4. Kiegészítő-oldal

- Kép, név, rövid leírás (UNAS), **funkció ezzel a készülékkel** (a kapcsolat szintjén szerkesztett szöveg),
  típus: *alaptartozék (dobozban)* / *opcionális kiegészítő* / *fogyóanyag*.
- A kiegészítő saját tartalmai (pl. elektróda felhelyezése, tisztítás, csere).
- „Mely készülékekkel kompatibilis még" lista.
- Webshop-link.

### 3.4 → 5. Páros-oldal (eszköz × kiegészítő)

A felhasználó a listából kiválaszt egy kiegészítőt vagy tartozékot, és a hozzá tartozó, **erre a párosra**
rögzített videók/ismertetők jelennek meg. Ha a párosnak nincs saját tartalma, a kiegészítő általános
tartalma jelenik meg jelzéssel.

### 6. Tartalom-nézet

- YouTube beágyazott lejátszó (fekvő módban teljes képernyő), alatta cím, szöveges ismertető
  (formázott: lista, kiemelés, kép), kapcsolódó tartalmak a témakörben („Következő").
- „Hasznos volt?" 👍/👎 visszajelzés (anonim) – a szerkesztőknek jelzés a hiányos tartalmakról.
- Megosztás: web-link a tartalomra (univerzális link, ami appba vagy webes nézetbe nyit).

## 2.3 Nyelvváltás a felületen

- Első indításnál a készülék nyelve alapján ajánl; bármikor váltható a beállításokban.
- A **felület szövegei** és a **tartalmak** is a választott nyelven jelennek meg; ha egy tartalom nem
  létezik az adott nyelven, a fallback-lánc szerinti nyelven jelenik meg, jelzéssel (06. fejezet).

## 2.4 Állapotok és hibák

- Nincs hálózat: a katalógus (nevek, képek, szövegek) gyorsítótárból megjelenik; a videó helyén
  „Videó lejátszásához internet szükséges" + bélyegkép.
- Üres találat: javaslat kategóriák böngészésére, „nem találom a készülékemet" → ügyfélszolgálati link.
- Visszavont/elrejtett tartalom: az app a következő katalógus-frissítésnél eltünteti.

## 2.5 Hozzáférhetőség

- Nagy, jól olvasható tipográfia (idősebb felhasználók), min. 44 pt érintési célok.
- Videókhoz felirat (YouTube CC) ajánlott, szöveges összefoglaló mindig legyen.
- Képernyőolvasó-címkék, kontraszt WCAG AA.

## 2.6 Kattintható prototípus

A fejezet képernyőit a `docs/prototype/index.html` kattintható prototípus mutatja be mintaadatokkal
(HU/EN váltás, fallback-jelzés, 7 témakör, páros nézet). Megnyitható böngészőben, vagy élőben:
https://claude.ai/artifact/QuNj2HQi9tRjwyc4AhyUBM. A végleges vizuális terv (Figma) erre épül.
Rácsrendszer: 1 oszlop telefonon, 2 oszlop táblagépen; alsó tabsor: *Kereső · Legutóbbiak · Beállítások*.
