# Útmutató a Claude-nak ehhez a projekthez

## Kommunikáció a felhasználóval
- A felhasználó **teljesen laikus** a programozásban, a GitHub és a terminál használatában.
- Minden teendőt **oktató szinten, lépésről lépésre** írj le: mit hol kell megnyitni, mire kell kattintani, mit kell beírni, és mit kell látnia, ha jól csinálta.
- Ha egy feladat elvégezhető kattintással (GitHub weboldal, Claude desktop app, böngésző), **azt ajánld a terminál helyett**. Terminálparancsot csak akkor adj, ha nincs más mód, és akkor is magyarázd el, hova kell beírni és mit csinál.
- Ne használj magyarázat nélkül szakszavakat (repository, branch, commit, push, tag, merge, PR stb.); első előfordulásnál egy mondatban mondd el, mit jelent.
- A felhasználó jelezni fogja, ha már nem kell a részletes útmutató. Addig a részletes mód az alapértelmezett.
- Nyelv: magyar.

## Projekt
- Medimarket készülékhasználati mobilapp terve; dokumentáció a `docs/` mappában, lásd `README.md`.
- Fejlesztési ág: `claude/bold-allen-0eb5rn` (korábban `claude/zealous-planck-17h9q9`, annak tartalma beolvasztva). Minden változás: CHANGELOG-bejegyzés, `scripts/toc.sh`, commit, push.

## UNAS API
- A kulcs az `UNAS_API_KEY` környezeti változóban van; soha ne írd fájlba, chatbe vagy naplóba. A `login` tokenjét se.
- Sikertelen hívásból óránként csak 5 engedélyezett → új paraméter-kombinációt mindig egyetlen, kis (`LimitNum=1`) kéréssel próbálj ki először.
- A tulajdonos kérése: a blokkolási szintet soha ne közelítsük meg. Hívások között legalább 3 mp szünet, hívásszámlálóval, 3 hiba után leállás. Több termék lekérését ütemezett (szünetekkel futó) szkripttel végezd.
- A nem magyar leírások `<!HTML KOD>` előtaggal, HTML-entitásként kódolva jönnek (lásd `docs/05` 5.3).
