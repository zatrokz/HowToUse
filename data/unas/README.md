# UNAS terméktörzs – teljes letöltés (adatbázis-alap)

> Letöltve: 2026-11-19, UNAS API `getProduct` (`ContentType=full`, `StatusBase=1,2,3`, 100-as lapok) és `getCategory`, mind az 5 nyelven.
> 31 API-hívás (1 login + 5 kategória + 25 terméklap), 3 mp szünetekkel, 0 hiba. **Anonimizált:** ár, készlet, statisztika, marketing-címkék, vonalkód-`Datas` nincs benne.

| Fájl | Tartalom |
|------|----------|
| `products.json` | 437 aktív termék, nyelvenkénti név, rövid leírás, kategória-nevek, URL (nyelvi domainnel), meta; `product_type`, márka, gyártó, kezelési módok, javaslatok, CE/EAN/mpn, útmutató-PDF nyelvenként, letölthetők, cikkajánló, képek, kiegészítő-kapcsolatok (`accessories`, névvel 5 nyelven), nyelvi rejtettség, státusz, szakember-jelölés, SKU-előzmény |
| `descriptions/long.<lang>.json` | SKU → hosszú leírás HTML (dekódolva, `<!HTML KOD>` nélkül), nyelvenként – ebből nyerhető ki a csomagtartalom, ellenjavallat, lépések, GYIK, videók |
| `categories.json` | 159 kategória 5 nyelven: név, útvonal, szülő, URL, menü-láthatóság, aktív termékszám, kép, meta |

Számok: 264 `main`, 156 `accessory`, 17 jelöletlen; 168 terméknél összesen 2888 kiegészítő-kapcsolat; 196 terméknél útmutató-PDF;
rejtett nyelven: de 23, en 9, sk 9, nl 8; 7 termék csak eü. szakembernek.

A prototípus (`docs/prototype/data/products.json`) ebből készül: a „Kezelőeszközök otthonra”, „Rendelői felszerelés”, „Betegség kezelés”
és „Szépségápolás” főkategóriák nem-tartozék termékei (172 készülék), kinyert szekciókkal és a leírásokban beágyazott videókkal.
Frissítés: a `docs/05` 5.4 szerinti delta-szinkron; teljes újratöltés ugyanezzel a 31 hívással.
