# 05 – UNAS integráció

> Verzió: 0.4.0 · Dátum: 2026-11-19 · Állapot: **mezőleképezés véglegesítve, teljes terméktörzs letöltve** (437 termék × 5 nyelv, [../data/unas/](../data/unas/README.md); minták: [samples/](samples/))

## 5.1 Cél
A terméktörzs (név, leírás, képek, kategória, alaptartozékok, kapcsolódó termékek, paraméterek)
**egyirányú** átvétele az UNAS webáruházból. Az app soha nem ír vissza az UNAS-ba.

## 5.2 UNAS API – amit használunk
- **Ellenőrzött** (UNAS dokumentáció, 2026-11-19; kivonat: [samples/unas-api-mezok.md](samples/unas-api-mezok.md)).
  Végpont: `https://api.unas.eu/shop/` (XML, POST). Hitelesítés: `login` hívás API-kulccsal → `Token` (2 órán át érvényes),
  a további hívások `Authorization: Bearer <token>` fejléccel. Az API-kulcs az UNAS adminban a
  **Beállítások / Külső kapcsolatok / API kapcsolat** menüben hozható létre, funkciónkénti jogosultsággal (nekünk csak
  olvasó hívások kellenek). Csak PREMIUM/VIP csomagban érhető el; limit 2000 (PREMIUM) / 6000 (VIP) sikeres hívás/óra,
  **sikertelen hívás 5/óra**.
- Hívások:
  - `getCategory` – kategóriafa (Id, Name, Parent, Url, Status).
  - `getProduct` – termékek részletesen; paraméterezhető `ContentType=full`, szűrés `TimeStart` (változott azóta) → **delta-szinkron**, `LimitNum/LimitStart` lapozás.
  - `getProductDB` – teljes termékadatbázis CSV-ben (induló teljes betöltéshez alternatíva).
- A `getProduct` válaszból felhasznált mezők (**valós válaszból ellenőrzött** mezőnevek, 2026-11-19): `Id, Sku, Name, Statuses, Categories.Category(Type, Id, Name),
  Description.Short/Long (+ShortIsHtml/LongIsHtml), Images.Image[], Params.Param[], Url, SefUrl, NotVisibleInLanguage, PackageProduct`, és a kompatibilis
  kiegészítők forrása: **`AdditionalProducts.AdditionalProduct[]` (Id, Sku, Name)**. Nyelv: a kérés `Lang` paramétere
  (ISO 639-1: hu, en, sk, de, nl). Egy termék kérhető `Sku` paraméterrel is. Részletes táblázat: [samples/unas-api-mezok.md](samples/unas-api-mezok.md).
- Valós mintaválaszok (mind az 5 nyelven, ár/készlet nélkül): `samples/unas-getProduct-<termék>.{hu,en,sk,de,nl}.xml`, ahol
  `<termék>` = `zw-luna-plus-kit` (ZenoWell Luna Plus), `dolito` (TENS), `dermadry-total` (iontoforézis), `saltdome` (sóterápia), `perobravo` (szelektív ingeráram);
  a `login` válasz: `samples/unas-login-valasz.xml`; a paraméterdefiníciók: `samples/unas-getProductParameter-kivonat.xml`.

## 5.3 Mezőleképezés (végleges)
| UNAS mező | HowToUse | Szabály |
|------|----------|---------|
| `Sku` | Product.sku | kulcs a párosításhoz (`Id` másodlagos). A `History.Event` (`Action=modify`, `SkuOld`) jelzi, ha a cikkszám változott → a párosítást `SkuOld` alapján is megpróbáljuk |
| `Name` | Product.name[lang] | nyelvfüggő (de a termékmárka-nevek, pl. „ZenoWell Luna Plus”, minden nyelven azonosak lehetnek) |
| `Description.Short`, `Description.Long` | short_/long_description[lang] | **Dekódolás:** nem magyar nyelven a szöveg `<!HTML KOD>` előtaggal és HTML-entitásként kódolva érkezik (`&lt;p&gt;…`) → előtag levágása + HTML-entitás-visszafejtés, csak ezután tisztítás. A `…IsHtml=1` jelzi, hogy HTML. Engedélyezett tagek a tisztításnál: p, ul, ol, li, strong, em, h2, h3, h4, table, tr, td, th, img, a |
| `Description.Long` → `<section class="pp-contraindication-list">` (benne `<h3>` cím, `<ul><li>` tételek; **ahol van**, `itemtype=…/MedicalDevice` + `<li itemprop="contraindication">`) | ContentItem(topic=risks, kind=article, status=published)[lang] | a Medimarket-leírások ellenjavallat-szekciója, Dr. Zátrok Zsolt által validált; **minden mintán, minden nyelven jelen van a `pp-contraindication-list` szekció**, de a mikrodata nem következetes (Luna Plus: mind az 5 nyelven; DermaDry: csak sk/nl; PeroBravo: csak de; Dolito, SaltDome: nincs) → **a kinyerés a CSS-osztály alapján történik, az `itemprop` csak bónusz**. Emellett sok terméknél külön `pp-medical-warning` szekció is van (orvosi figyelmeztetés) → ugyanide, `kind=warning` |
| `Description.Long` → „A csomag tartalma” / „Mit kapsz a csomagban?” szekció (`<!-- N. CSOMAG TARTALMA -->` komment, táblázat: darabszám + tétel) | Product.package_contents[lang] (alaptartozékok) | **nem strukturált mező**, csak a leírásban van (mind az 5 mintán `PackageProduct` = `no`, `PackageComponents` hiányzik) → importáláskor kinyerjük; a szekció sorszáma termékenként eltér (7., 9., 10., 11.), ezért a kommentek szövegére („CSOMAG TARTALMA”) és a címre illesztünk, nem a sorszámra; az adminban ellenőrizhető/felülírható |
| `Description.Long` → „Így használd … lépésről lépésre” (`pp-steps-container` / `pp-step`) és „Gyakori kérdések” (`pp-faq-item`) szekciók | ContentItem(topic=usage / faq) javaslat | opcionális: a leírás már tartalmazza a lépéseket és a GYIK-et; első körben kézi átvétel, később automatizálható |
| `Images.Image[].Url.Medium` (jpg), `Images.Image[].SefUrl` (webp), `Alt`, `Type` (base/alt) | Product.images[] | a `SefUrl` webp verziót töltjük le; letöltés + tükrözés saját tárhelyre, méretváltozatok. Az `Alt` nem nyelvfüggő (terméknév) |
| `Categories.Category[]` (`Type` base/alt, `Id`, `Name`) | Product.categories[] | `Id` nyelvfüggetlen, `Name` nyelvfüggő, útvonal „Szülő\|Gyerek” formában; csak az adminban „appban látható”-nak jelölt kategória-`Id`-k. Az alt kategóriák adják a betegség/tünet szerinti besorolást (pl. „Tünetek A-Z\|Alvászavar”) |
| `Statuses.Status[Type=base].Value` | Product.unas_status | 1 = aktív; inaktív (0) termék → appban automatikusan `hidden` figyelmeztetéssel |
| `Statuses.Status[Type=plus, Id=2]` („Csak eü. szakember vásárolhatja”) | Product.professional_only | Value=1 esetén az app jelzi, hogy rendelői eszköz |
| `Params.Param[Name=product_type]` (enum: `main` / `accessory`) | Product.product_type | **ez a terméktípus elsődleges forrása**; ahol hiányzik (pl. készletek), a kategória és az `AdditionalProducts` alapján javaslat, admin dönt |
| `Params.Param[Name=user-manual-url]` (és `Letölthető`, link_text: „URL - Felirat”) | Product.manual_url[lang] | a használati útmutató PDF; **nyelvfüggő érték** (DermaDry, SaltDome: 5 külön PDF; Dolito, PeroBravo: hu/en/sk/de külön, nl → angol PDF; Luna Plus: minden nyelven a magyar) → nyelvenként átvesszük, ha hiányzik: fallback hu; az adminban felülírható |
| `Params.Param[Name=Brand]`, `[Name=Gyártó]` | Product.brand, Product.manufacturer | |
| `Params.Param[Name=Stimulációs módok]` (enummore, pl. „TENS, EMS/NMES, ETS, Szelektív ingeráram, Biofeedback”) | Product.therapy_modes[] | vesszővel elválasztott lista; **a listán belüli vesszőt `&comma;` jelöli** (pl. „Tenyér&comma; talp&comma; hónalj”) → split `, ` szerint, utána `&comma;` → `,` |
| `Params.Param[Name=Javaslat]` (enummore) | Product.indications[] (javaslat) | ugyanaz a felbontási szabály; a kategória-alt besorolással együtt a „mire való” kereséshez |
| `Params.Param[Name=CE minősítés]` (enummore), `[Name=EAN kód]`, `[Name=mpn]` | Product.ce_mark, Product.ean, Product.mpn | azonosítók; nem minden terméknél kitöltött (SaltDome-nál nincs CE paraméter) |
| `Params.Param[Name=Mikorra érkezhet?]`, `google_product_feed Export Description` | – | nem használjuk (szállítás, hirdetési feed) |
| `Params.Param[Name=Cikk ajánló]` (link_text) | Product.related_articles[lang] | nyelvenként a megfelelő domain blogcikkére mutat (ez az egyetlen nyelvfüggő paraméter-érték a mintában) |
| `Params.Param[Group=Marketing]`, `google_product_category` | – | nem használjuk (hirdetési címkék) |
| `AdditionalProducts.AdditionalProduct[]` (`Id`, `Sku`, `Name`) | Compatibility(source=unas_related, accepted=true) | **irány: a készüléknél vannak felsorolva a kiegészítők** (pl. Luna Plus → fülcsipesz-elektródák); a tartozéknál nincs visszamutatás. A lista vegyes: tartozék, fogyóanyag (gél, kősó-adalék), elektródák (Dolito: 30 tétel, PeroBravo: 13, SaltDome: 2, DermaDry: 0). Kivétel: elektródáknál keveredik (más elektródák + készülék) → az import mindkét irányban rögzíti, a típus (alaptartozék/opcionális/fogyóanyag) és a funkció-szöveg az adminban egészül ki. A `Name` nyelvfüggő, de a párosítás `Sku` szerint történik |
| `SimilarProducts`, `CrossSale`, `UpSale`, `Variants`, `Prices`, `Stocks`, `Statistics` | – | nem használjuk; a szinkron **el sem tárolja** (ár, készlet, forgalom nem kerül az appba) |
| `Url`, `SefUrl` | Product.unas_url[lang] | **a válaszban minden nyelven a .hu URL jön** → nyelvenként összeállítjuk: `https://www.<domain>/<SefUrl>` (medimarket.com, zdravezitie.sk, lymphpumpe.de, jouwzorgwinkel.nl); a slug minden domainen azonos (ellenőrizve: mind a 4 külföldi URL 200-at ad) |
| `NotVisibleInLanguage.Language[]` | Product.hidden_in_langs[] | ha egy nyelven nem látható, az app sem mutatja ott. **Az érték angol nyelvnév, nem ISO-kód** (pl. `German`; Dolito és PeroBravo németül nem látható) → leképezés: Hungarian→hu, English→en, Slovak→sk, German→de, Dutch→nl. A mező minden nyelvű válaszban ugyanaz |
| `Meta.Title`, `Meta.Description` | Product.seo[lang] (opcionális) | nyelvfüggő; az app megosztási/kereső-előnézetéhez használható |
| `LastModTime` | UnasProductSnapshot.unas_modified_at | delta-szinkron ellenőrzéséhez |

**Nyelvfüggő mezők (a 5 nyelvű mintából):** `Name` (ahol fordítva van), `Description.Short/Long`, `Categories.Category.Name`,
`Statuses.Status[plus].Name`, `AdditionalProduct.Name`, `Meta.*`, `Params.Param[Cikk ajánló].Value`, `Params.Param[user-manual-url / Letölthető].Value`.
**Nyelvfüggetlen:** `Id`, `Sku`, minden `Id`, `Url/SefUrl`, `Images.*` (Alt is), `Params.Param.Name/Group` (a paraméter-nevek magyarul jönnek minden nyelven),
`Brand`, `Gyártó`, `NotVisibleInLanguage`, `Stimulációs módok`/`Javaslat` értékei (magyarul jönnek minden nyelven → az app fordítja a kódlistát).

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
A szinkron ezért nyelvenként kéri le a terméktörzset (a `getProduct` `Lang` paraméterével: hu, en, sk, de, nl), és a `Product.name/short_description/long_description[lang]`,
valamint a kockázat-szekció mind az 5 nyelven az UNAS-ból töltődik (ellenőrizve a mintán: a MedicalDevice mikrodata és a 10 ellenjavallat mind az 5 nyelven megvan).
A termék `unas_url` mezője nyelvenként a megfelelő domain termékoldalára mutat – ezt a szinkron állítja össze a `SefUrl`-ből, mert az API minden nyelven a .hu címet adja (5.3).
A nem magyar leírások `<!HTML KOD>` előtaggal, kódolt HTML-ként érkeznek; a dekódolás a szinkron feladata (5.3). Az adminban csak az app-specifikus szövegek fordítása marad (06. fejezet).

## 5.7 Ellenőrzött pontok (lezárva 2026-11-19 a valós mintaválasz alapján)
1. ~~Van-e API-hozzáférés~~ – van; VIP csomag, a kulcs jogai: `getProduct`, `getProductParameter`, `getCategory`, `getPage` (lásd `samples/unas-login-valasz.xml`).
2. ~~Mezőnevek~~ – valós válaszból ellenőrizve (5.3). Kiegészítők iránya: készülék → kiegészítők. Nyelvfüggő mezők köre: 5.3 végén.
3. ~~Alaptartozékok forrása~~ – **csak a leírás szövegében** („A csomag tartalma” táblázat); strukturált `PackageComponents` nincs → kinyerés a leírásból + admin ellenőrzés.
4. ~~Hívásszám-korlát~~ – ismert (5.2); a teljes letöltés 31 hívás volt, 0 hiba (lásd `data/unas/README.md`). A `TimeStart` delta pontos viselkedése az első ütemezett futásnál tesztelendő (**egyetlen nyitott pont**).
5. ~~Többnyelvű lekérés módja~~ – `Lang` paraméter; nyelvenként külön hívás mind az 5 nyelvre, működik.
6. ~~Használati útmutató PDF helye~~ – `Params.Param[Name=user-manual-url]`; nyelvenként külön PDF, ahol van (fallback hu).
8. ~~Ellenjavallat-szekció következetessége~~ – 5 készülék × 5 nyelv: a `pp-contraindication-list` szekció mindenhol megvan, a mikrodata nem → osztály alapú kinyerés (5.3).
7. ~~Nyelvi URL~~ – az API .hu URL-t ad; a `SefUrl` minden domainen azonos, a nyelvi URL összeállítható.

Új teendő a fejlesztésnek: `<!HTML KOD>` dekódoló, „A csomag tartalma” és ellenjavallat-szekció kinyerő (HTML-parser, a `pp-*` CSS-osztályok alapján), `enummore` paraméter-felbontó (`&comma;`), nyelvnév→ISO leképezés.

**Teljes betöltés (2026-11-19):** `data/unas/` – 437 termék, 159 kategória, 5 nyelv, anonimizálva; ez az app adatbázisának induló töltése.

**Hívásszám-fegyelem (a tulajdonos kérése):** a blokkolási szintet soha nem közelítjük meg. Szabály: hívások között legalább 3 mp szünet, egy futásban max. 300 hívás, új paraméter-kombinációt először egyetlen `LimitNum=1` hívással próbálunk; a szinkron számolja a sikeres/sikertelen hívásokat és 3 sikertelen után leáll. A teljes aktív terméktörzs 438 termék (2026-11-19) → 5 nyelv × 5 lap (100/lap) = 25 hívás egy teljes szinkronhoz.

## 5.8 Az API-kulcs kezelése
- A kulcs **titok**: soha nem kerül a repóba, chatüzenetbe vagy dokumentumba. Tárolás: a fejlesztői felhő-környezet
  beállításaiban környezeti változóként (`UNAS_API_KEY`), éles üzemben a szerver titokkezelőjében.
- Az UNAS-nál a kulcsot a `login` hívás XML-törzsében küldjük, a válasz egy időkorlátos token; a többi hívás a tokent használja.
- Ajánlott külön kulcs tesztre és élesre; a kulcs az UNAS adminban bármikor visszavonható és újragenerálható.
- ~~Első használat: `getProduct` mintaválasz lementése `docs/samples/` alá anonimizálva~~ – megtörtént (2026-11-19), az 5.3 mezőleképezés ebből véglegesítve.
- A kulcs 2027-11-19-ig érvényes (`ApiKeyExpire` a login válaszban) → naptárba: megújítás 2027 októberében.
