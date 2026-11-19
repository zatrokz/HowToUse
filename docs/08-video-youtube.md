# 08 – Videók: YouTube

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 8.1 Miért YouTube-beágyazás
Ingyenes tárolás és adaptív streaming, meglévő Medimarket-csatorna, feliratozás, statisztika; a videók
a webshop termékoldalain is felhasználhatók. Hátrány: hálózat kell, reklám/ajánló megjelenhet → **nem listázott**
(unlisted) videók és `rel=0`, `modestbranding`, lehetőleg YouTube-fiókhoz kötött „embed only" beállítások.

## 8.2 Csatorna-szervezés
A Medimarket csatornája: https://www.youtube.com/c/drzatrokzsolt (a webáruház lábléce hivatkozik rá).
- Playlist készülékenként: `[Készülék neve] – Használati útmutató`.
- Cím-konvenció a tömeges importhoz: `Készülék · Témakör · Cím` – pl. `Myolito · Üzembe helyezés · Akkumulátor töltése`.
  Az import a második tagot témakör-kódra képezi.
- Rövid (1–3 perces), egy témát lefedő videók; hosszabb videóból időpont-részlet (`start/end`) is hivatkozható.
- Nyelv: külön videó nyelvenként, vagy közös videó feliratsávval; a Video entitás mindkettőt kezeli.

## 8.3 Beillesztés az adminban
URL vagy azonosító beillesztése → oEmbed (`https://www.youtube.com/oembed?url=…`) kulcs nélkül: cím, bélyegkép;
YouTube Data API v3 (kulccsal): időtartam, feliratok, elérhetőség. Napi ellenőrzés: törölt/privát videó → admin figyelmeztetés.

## 8.4 Megjelenítés az appban
- `react-native-youtube-iframe` (IFrame Player API), bélyegkép-előnézet, érintésre indul (adatforgalom-barát).
- Fekvő teljes képernyő, lejátszás-pozíció megjegyzése elemenként.
- Hálózat nélkül: bélyegkép + magyarázat, a szöveges ismertető elérhető.
- Gyermekvédelmi/adatvédelmi mód: `youtube-nocookie.com` domain használata.

## 8.5 Metaadatok és SEO (webes nézet)
A webes nézetben `VideoObject` strukturált adat, a videó és az ismertető együtt – a webshop termékoldaláról
linkelve a Medimarket-tartalomstratégiába illeszkedik.
