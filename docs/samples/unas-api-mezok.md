# UNAS API – ellenőrzött tények és a számunkra fontos mezők

> Forrás: https://unas.hu/tudastar/api (letöltve 2026-11-19). Ez a kivonat a HowToUse-nak fontos részeket tartalmazza.

## Azonosítás
- Végpont: `https://api.unas.eu/shop/` – minden funkció **POST**, XML kérés és XML válasz.
- Csak **PREMIUM** és **VIP** előfizetéssel használható.
- API-kulcs létrehozása az áruház adminjában: **Beállítások / Külső kapcsolatok / API kapcsolat**. A kulcsnál beállítható, mely API funkciók érhetők el vele (nekünk elég: `getProduct`, `getCategory`, `getProductParameter`, `getStorage` opcionális).
- `login` kérés: `<Params><ApiKey>…</ApiKey></Params>` → válasz: `Token` (2 órán át érvényes), `Expire`, `Permissions`, `ShopId`, `Subscription`.
- A tokent a további hívásoknál `Authorization: Bearer <token>` HTTP-fejlécben küldjük; nem kell minden hívás előtt újra belépni.
- Limitek: sikeres hívás 2000/óra (PREMIUM), 6000/óra (VIP); **sikertelen hívás 5/óra** – ezért a kulcsot gondosan kell kezelni.

## getProduct kérés – használt paraméterek
| Paraméter | Érték nálunk | Megjegyzés |
|-----------|--------------|------------|
| `StatusBase` | `1,2,3` | aktív termékek (inaktív = 0 külön futásban, elrejtéshez) |
| `State` | `live` / `deleted` | törlések észleléséhez a `deleted` is lekérendő |
| `CategoryId` | adminban kijelölt kategóriák | csak elsődleges kategóriára szűr |
| `TimeStart` | utolsó sikeres szinkron ideje | delta-szinkron |
| `ContentType` | `full` | kell az `AdditionalProducts`, `Params`, `Images` miatt |
| `Lang` | `hu`, `en`, `sk`, `de`, `nl` | ISO 639-1; nyelvenként külön lekérés |
| `LimitNum` / `LimitStart` | lapozás | |

## getProduct válasz – felhasznált mezők (ContentType=full)
| UNAS mező | HowToUse | Megjegyzés |
|-----------|----------|------------|
| `Id`, `Sku` | unas_product_id, sku | `Sku` a stabil kulcs |
| `Name` | name[lang] | nyelvfüggő |
| `Statuses.Status`, `Explicit` | unas_status | |
| `Description.Short`, `Description.Long` (+ `…IsHtml`) | short/long_description[lang] | a Long HTML-ből nyerjük ki a „Kockázatok / Ellenjavallatok” szekciót (MedicalContraindication mikrodata) |
| `Categories.Category` (`Type` base/alt, `Id`, `Name`) | categories[] | |
| `Url`, `SefUrl` | unas_url[lang] | nyelvenként a megfelelő domain |
| `Images.DefaultFilename`, `Images.DefaultAlt`, `Images.Image[]` (`Filename`, `Alt`, `Type`, `SefUrl`) | images[] | letöltés és tükrözés |
| `Params.Param[]` (`Id`, `Type`, `Name`, `Group`, `Value`) | params{} | terméktípus-javaslat, egyéb jelölők |
| **`AdditionalProducts.AdditionalProduct[]`** (`Id`, `Sku`, `Name`) | **Compatibility** (kiegészítő termékek) | ez az UNAS „kiegészítő termék” kapcsolata – a kompatibilis kiegészítők forrása |
| `SimilarProducts.SimilarProduct[]`, `CrossSale` | nem használjuk (hasonló/keresztértékesítés) | |
| `PackageProduct`, `PackageComponents.Component[]` (`Sku`, `Qty`) | alaptartozékok csomagtermék esetén | ha a készülék csomagként van rögzítve |
| `NotVisibleInLanguage.Language[]` | nyelvi láthatóság | ha egy nyelven nem látható, az app sem mutatja ott |
| `Variants.Variant[]` | nem használjuk (méret/szín változatok) | |
| `OnlineContent.Url/Filename`, `Datas.Data` | letölthető tartalom (pl. használati útmutató PDF) | ellenőrizendő a tényleges tartalom |

## Egyéb hívások
- `getCategory` – kategóriafa (Id, Name, Url, SefUrl, Parent.Id/Tree, Display, Products.Active, Texts, Meta); `Lang` paraméter működik.
- `getProductParameter` – paraméterdefiníciók (név, típus, csoport) a `Params` értelmezéséhez.
- `getProductDB` – teljes adatbázis CSV-ben; induló teljes betöltéshez alternatíva.

## Az első valós lekérésekből ellenőrizve (2026-11-19, 5 készülék × 5 nyelv)
Minták ebben a mappában: `unas-getProduct-{zw-luna-plus-kit,dolito,dermadry-total,saltdome,perobravo}.{hu,en,sk,de,nl}.xml` (anonimizált: ár, készlet, statisztika, marketing-címkék nélkül),
`unas-login-valasz.xml`, `unas-getProductParameter-kivonat.xml`.

1. **Nyelvfüggő mezők:** `Name`, `Description.Short/Long`, `Categories.Category.Name`, `Statuses.Status[plus].Name`, `AdditionalProduct.Name`, `Meta.*`, és a `Cikk ajánló` paraméter értéke. **Nem nyelvfüggő:** `Url/SefUrl` (mindig .hu), `Images.Alt`, `Params.Param.Name/Group`, `user-manual-url`.
2. **`AdditionalProducts` iránya:** a készüléknél vannak a kiegészítők (Luna Plus → bal/jobb fülcsipesz-elektróda; PhysioLaser → optika); a tartozéknál nincs visszamutatás. Elektródáknál kevert (más méretű elektródák + egy készülék).
3. **Alaptartozékok:** nincs `PackageComponents` (`PackageProduct=no`); a lista a leírás „A csomag tartalma” táblázatában van (`<!-- 11. CSOMAG TARTALMA -->`), mind az 5 nyelven.
4. **Használati útmutató PDF:** `Params.Param[Name=user-manual-url]` (text) és `[Name=Letölthető]` (link_text, „URL - Felirat”); az érték nyelvfüggő (külön PDF nyelvenként, ahol van; Luna Plus-nál még mindenhol a magyar).
5. **Kódolt leírás:** nem magyar nyelven `Description.Short/Long` `<!HTML KOD>` előtaggal és HTML-entitásként kódolva jön → dekódolni kell.
6. **Terméktípus:** `Params.Param[Name=product_type]` enum (`main` / `accessory`), de nem minden terméknél kitöltött.
7. **Ellenjavallatok:** `<section class="pp-contraindication-list">` a leírásban minden mintán, minden nyelven; a MedicalDevice/`itemprop="contraindication"` mikrodata csak egyes termékek egyes nyelvein → a szekció CSS-osztályára illesztünk.
10. **`NotVisibleInLanguage.Language`** értéke angol nyelvnév (`German`), nem ISO-kód.
11. **`enummore` paraméterek** (`Stimulációs módok`, `Javaslat`, `CE minősítés`): `, ` elválasztó, a belső vessző `&comma;`.
12. **Terméktörzs mérete:** 438 aktív termék (StatusBase 1,2,3), 5 lap 100-as `LimitNum`-mal; `LimitStart` lapozás működik.
8. **`getProductParameter`:** csak `hu` nyelvű definíciókat ad (54 db); `Display`, `Usable`, `EnumOptions` mezőkkel.
9. **`getCategory`:** `Id, Name, Url, SefUrl, Parent(Id, Tree), Display, Products(Active), Texts(Top/Bottom), Meta, Image` – 159 kategória; a `Lang` paraméter működik.

Nyitva maradt: a `TimeStart` delta viselkedése (első ütemezett futásnál tesztelendő).
