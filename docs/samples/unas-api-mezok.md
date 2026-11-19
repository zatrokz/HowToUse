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
- `getCategory` – kategóriafa (Id, Name, Parent, SefUrl, Status); nyelvparaméter ellenőrizendő.
- `getProductParameter` – paraméterdefiníciók (név, típus, csoport) a `Params` értelmezéséhez.
- `getProductDB` – teljes adatbázis CSV-ben; induló teljes betöltéshez alternatíva.

## Még ellenőrizendő (az első valós lekérésből)
1. Mely mezők nyelvfüggők (a doksiban „nyelv” badge jelöli): várhatóan Name, Description, Url/SefUrl, Params.Value, Images.Alt.
2. `AdditionalProducts` iránya: csak a készüléknél vannak felsorolva a kiegészítők, vagy fordítva is.
3. Az alaptartozékok (dobozban) jelölése: `PackageComponents` vagy a leírás szövege.
4. A használati útmutató PDF helye (`OnlineContent`, `Datas`, vagy a leírásban link).
