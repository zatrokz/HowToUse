# 05 – UNAS integráció

> Verzió: 0.2.1 · Dátum: 2026-11-19 · Állapot: tervezet – API-hozzáférés megvan, **mezőnevek a mintaválaszból véglegesítendők** (5.7)

## 5.1 Cél
A terméktörzs (név, leírás, képek, kategória, alaptartozékok, kapcsolódó termékek, paraméterek)
**egyirányú** átvétele az UNAS webáruházból. Az app soha nem ír vissza az UNAS-ba.

## 5.2 UNAS API – amit használunk
- Végpont: `https://api.unas.eu/shop/` (XML, POST). Hitelesítés: `login` hívás API-kulccsal → token
  (időkorlátos), minden további hívás a tokennel. Az API-kulcs az UNAS adminban (Beállítások → Külső kapcsolatok → API) generálható, **csak Premium/VIP csomagban** érhető el – ellenőrizni kell az előfizetést.
- Hívások:
  - `getCategory` – kategóriafa (Id, Name, Parent, Url, Status).
  - `getProduct` – termékek részletesen; paraméterezhető `ContentType=full`, szűrés `TimeStart` (változott azóta) → **delta-szinkron**, `LimitNum/LimitStart` lapozás.
  - `getProductDB` – teljes termékadatbázis CSV-ben (induló teljes betöltéshez alternatíva).
- A `getProduct` válaszból felhasznált mezők (várható struktúra, ellenőrzendő):
  `Id, Sku, Name, Unit, Statuses, Categories/Category(Id,Name,Type=base|alt), Description/Short, Description/Long,
  Images/Default(Url,Alt), Images/Alternates/Image(Url,Alt), Params/Param(Name,Group,Value), Url, Variants`,
  valamint a **kapcsolódó / hozzárendelt termékek** mezője (lásd 5.7).

## 5.3 Mezőleképezés
| UNAS | HowToUse | Szabály |
|------|----------|---------|
| Sku | Product.sku | kulcs a párosításhoz (Id másodlagos) |
| Name | Product.name[hu] | |
| Description/Short, Long | short_/long_description[hu] | HTML tisztítás (engedélyezett tagek: p, ul, ol, li, strong, em, h3, h4, img) |
| Images | Product.images[] | letöltés + tükrözés saját tárhelyre, méretváltozatok |
| Categories (base + alt) | Product.categories[] | csak az adminban „appban látható"-nak jelölt kategóriák |
| Statuses / aktív | Product.unas_status | inaktív termék → appban automatikusan `hidden` figyelmeztetéssel |
| Params („Terméktípus", „Kompatibilis készülék", …) | product_type javaslat, Compatibility(source=unas_param) | paraméter-névleképezés konfigurálható az adminban |
| Csatolt / kapcsolódó termékek (kompatibilis kiegészítők) | Compatibility(source=unas_related, accepted=true) | az UNAS-ban karbantartott kapcsolat az irányadó; az adminban a funkció-szöveg és a típus (alaptartozék/opcionális/fogyóanyag) egészül ki |
| Leírás „Kockázatok / Ellenjavallatok” szekciója (MedicalContraindication mikrodata) | ContentItem(topic=risks, kind=article, status=published) | a Medimarket-leírásokban strukturált, Dr. Zátrok Zsolt által validált tartalom; importáláskor kinyerjük, forrás-megjelöléssel |
| Url | Product.unas_url | |

## 5.4 Szinkron-stratégia
- **Ütemezett delta** (pl. óránként): `getProduct` `TimeStart` = utolsó sikeres futás. Éjjel egyszer teljes
  összevetés (törlések észlelésére). Kézi indítás az adminból.
- Idempotens: pillanatkép (`UnasProductSnapshot`) diffelése; csak változott mező ír.
- Konfliktus: UNAS-mező mindig felülír; saját override megmarad; ha a leírás változott és van publikált
  tartalom, `manual_review_required = true` jelzés.
- Hiba- és rate-limit kezelés: újrapróbálás exponenciális várakozással; a futás naplója az adminban.

## 5.5 Képek
Az UNAS-képeket nem hotlinkeljük: letöltés, saját tárhelyre (S3-kompatibilis) mentés, WebP méretváltozatok,
CDN. Így az app gyors és nem függ az UNAS CDN-től; az eredeti URL megőrzött.

## 5.6 Többnyelvű UNAS-tartalom
A Medimarket UNAS-rendszere **egy adatbázisra épülő, 5 domaines, 5 nyelvű** áruház:
medimarket.hu (hu), medimarket.com (en), zdravezitie.sk (sk), lymphpumpe.de (de), jouwzorgwinkel.nl (nl).
A szinkron ezért nyelvenként kéri le a terméktörzset (az UNAS API nyelvparaméterével / nyelvi változat szerint –
a pontos mód a mintaválaszból véglegesítendő), és a `Product.name/short_description/long_description[lang]`,
valamint a kockázat-szekció mind az 5 nyelven az UNAS-ból töltődik. A termék `unas_url` mezője nyelvenként a megfelelő
domain termékoldalára mutat. Az adminban csak az app-specifikus szövegek fordítása marad (06. fejezet).

## 5.7 Ellenőrzendő pontok (a fejlesztés első hetében)
1. ~~Van-e API-hozzáférés~~ – van; a tulajdonos generálja a kulcsot (lásd 5.8).
2. A `getProduct` tényleges XML-sémája (mezőnevek), különösen: **kapcsolódó/hozzárendelt termékek** – ha az API nem adja vissza, alternatíva: dedikált UNAS-paraméter („Kompatibilis készülék: SKU-lista") vagy kézi kapcsolás az adminban.
3. Alaptartozékok forrása: szerepelnek-e strukturáltan (paraméter / kapcsolódó termék) vagy csak a leírás szövegében → ha csak szövegben, az adminban kézi lista.
4. Hívásszám-korlát és a `TimeStart` delta pontos viselkedése.
5. Többnyelvű mezők lekérésének módja az API-ban (nyelvparaméter vs. nyelvi változat), mind az 5 nyelvre.

## 5.8 Az API-kulcs kezelése
- A kulcs **titok**: soha nem kerül a repóba, chatüzenetbe vagy dokumentumba. Tárolás: a fejlesztői felhő-környezet
  beállításaiban környezeti változóként (`UNAS_API_KEY`), éles üzemben a szerver titokkezelőjében.
- Az UNAS-nál a kulcsot a `login` hívás XML-törzsében küldjük, a válasz egy időkorlátos token; a többi hívás a tokent használja.
- Ajánlott külön kulcs tesztre és élesre; a kulcs az UNAS adminban bármikor visszavonható és újragenerálható.
- Első használat: `getProduct` mintaválasz lementése `docs/samples/` alá **anonimizálva** (ár, készlet nélkül), ebből
  véglegesítjük az 5.3 mezőleképezést.
