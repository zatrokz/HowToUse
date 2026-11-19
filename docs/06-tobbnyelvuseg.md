# 06 – Többnyelvűség

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 6.1 Elvek
- Nyelv **adat, nem kód**: új nyelv felvétele az adminban (kód, név, fallback), sémaváltozás és app-kiadás nélkül.
- Három réteg, mind lokalizált: **felületi szövegek** (gombok, címkék), **tartalom** (cím, ismertető, kompatibilitás-funkció), **videó** (nyelvenként eltérő YouTube-azonosító vagy közös videó felirattal).
- Induló nyelvek: `hu` (alapértelmezett, forrásnyelv), `en`. Fallback-lánc: `xx → en → hu`.

## 6.2 Felületi szövegek
- Kulcs-alapú i18n (`i18next`/ICU formátum, többes szám, dátum). A fordítások a CMS-ben szerkeszthetők és a
  katalógussal együtt töltődnek le (`/catalog/ui/{locale}.json`); az appba beégetett `hu`/`en` csak végső fallback.
- Fordítás-hiányjelentés az adminban (kulcs × nyelv mátrix).

## 6.3 Tartalmi fordítás munkafolyamata
1. Szerkesztő elkészíti `hu`-n → státusz `draft`.
2. „Fordítás-javaslat" gomb: gépi fordítás (DeepL/LLM) a célnyelvekre, `machine_translated=true` jelöléssel.
3. Fordító szerepkör átnézi, javít → `reviewed`. Gépi, át nem nézett szöveg **nem publikálható** a `risks` témakörben.
4. Export/import CSV fordítóirodának.

## 6.4 Videók nyelvenként
- Egy `Video` több lokalizációt tarthat (`lang → youtube_id`). Ha nincs célnyelvi videó, a fallback-videó
  jelenik meg „🇭🇺 magyar hangsáv, angol felirat" jelzéssel, ha a YouTube-on van felirat (`has_captions`).
- Ajánlott gyártási sor: magyar videó + angol felirat (gyors), később szinkronizált/újraforgatott változat.

## 6.5 Nyelvspecifikus részletek
- Mértékegységek, dátum, számformátum locale szerint; RTL nyelvek támogatása a komponenskönyvtárban (jövőbeli).
- Slug nyelvfüggetlen; a univerzális linkben a locale előtag hordozza a nyelvet.
- Keresés nyelvfüggetlen: a találat a terméknév **bármely** nyelvi változatára és a szinonimákra illeszkedik.
