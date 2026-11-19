# 11 – Nyitott kérdések és döntési napló

> Verzió: 0.1.0 · Dátum: 2026-11-19

## 11.1 Tisztázandó kérdések

| # | Kérdés | Javaslat | Állapot |
|---|--------|----------|---------|
| 1 | Van-e UNAS API-hozzáférés (Premium/VIP)? Ki generálja a kulcsot? | a tulajdonos generálja az UNAS fiókban | **lezárva** – van hozzáférés |
| 2 | Az UNAS API visszaadja-e a „kapcsolódó termékek"-et és az alaptartozékokat strukturáltan? | a csatolt (kompatibilis) kiegészítők az UNAS-ban megvannak; a pontos API-mező a mintaválaszból derül ki | részben lezárva – adat van, mező ellenőrzendő |
| 3 | Az UNAS áruház többnyelvű-e? | 5 nyelv (hu, en, sk, de, nl) egy adatbázisban, 5 domainen | **lezárva** |
| 4 | Technológia: React Native/Expo + Payload CMS (javasolt) vagy Flutter / más CMS? | javaslat elfogadása | nyitott |
| 5 | Kell-e webes nézet az MVP-ben (univerzális link a webshopról)? | igen, olcsó az Expo web-buildből / Next.js | nyitott |
| 6 | Ki a szakmai jóváhagyó a `risks` témakörhöz? | Dr. Zátrok Zsolt | **lezárva** |
| 7 | A 7 témakör végleges-e, kell-e eszközönként egyedi témakör? | 7 rendszer-témakör + bővíthető `Topic` | javasolt |
| 8 | Videók nyelvi stratégiája: külön angol videó vagy magyar + felirat? | indulásnál magyar + angol felirat | javasolt |
| 9 | Kiadói fiókok (Apple Developer, Google Play) léteznek-e a Medimarketnél? | ellenőrzés, igénylés | nyitott |
| 10 | Hol fusson a CMS (hosting, költségkeret)? | menedzselt szolgáltatás, ~30–60 €/hó | nyitott |
| 11 | Kell-e QR-kód a dobozra/matricára már az első kiadásban? | 6. fázis | javasolt |
| 12 | Analitika igen/nem, és milyen szinten? | anonim, opt-in, PostHog | javasolt |

## 11.2 Döntési napló

| Dátum | Döntés | Indok |
|-------|--------|-------|
| 2026-11-19 | UNAS a terméktörzs egyedüli gazdája; az app nem ír vissza | duplikáció és inkonzisztencia elkerülése |
| 2026-11-19 | Minden témakör 0..n tartalmi elemet tartalmaz (lista) | követelmény: egy ponthoz több videó/ismertető |
| 2026-11-19 | Nyelv adatként kezelve, fallback-lánccal; HU+EN induláskor | követelmény: tetszőleges nyelv felvehető |
| 2026-11-19 | Videók YouTube-ról beágyazva (unlisted, nocookie) | követelmény + költség |
| 2026-11-19 | Publikus katalógus statikus JSON-ként generálva | sebesség, költség, offline, CMS-függetlenség |
| 2026-11-19 | UNAS API-kulcsot a tulajdonos generál; a termékinformációk, a csatolt (kompatibilis) kiegészítők és a kockázat/ellenjavallat adatok forrása az UNAS | az adat már az UNAS-ban van, nem duplikáljuk |
| 2026-11-19 | A `risks` témakör és minden orvosi tartalom szakmai jóváhagyója Dr. Zátrok Zsolt; az UNAS-ból átvett kockázat-szövegek már validáltak, importáláskor `published` státuszt kaphatnak, kézi módosítás után újra jóváhagyás kell | minden Medimarket-tartalmat ő validált |
| 2026-11-19 | Induló nyelvek: hu, en, sk, de, nl – az UNAS 5 nyelvi domainje szerint; a terméktörzs nyelvi változatai az UNAS-ból jönnek | egységes UNAS-adatbázis 5 domainnel |
