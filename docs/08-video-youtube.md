# 08 – Videók: YouTube

> Verzió: 0.2.0 · Dátum: 2026-11-19 · Állapot: tervezet – a csatorna felmérve, 90 videó katalogizálva ([samples/youtube-csatorna-videok.md](samples/youtube-csatorna-videok.md))

## 8.1 Miért YouTube-beágyazás
Ingyenes tárolás és adaptív streaming, meglévő Medimarket-csatorna, feliratozás, statisztika; a videók
a webshop termékoldalain is felhasználhatók. Hátrány: hálózat kell, reklám/ajánló megjelenhet → **nem listázott**
(unlisted) videók és `rel=0`, `modestbranding`, lehetőleg YouTube-fiókhoz kötött „embed only" beállítások.

## 8.2 Csatorna-szervezés
A Medimarket csatornája: **Dr. Zátrok Zsolt** („Dr.Zatrok.com”), https://www.youtube.com/channel/UCssJJmDAbJZl4gaW4IOEwZw
(csatorna-azonosító `UCssJJmDAbJZl4gaW4IOEwZw`, feltöltések lejátszási listája `UUssJJmDAbJZl4gaW4IOEwZw`). A tulajdonos döntése (2026-11-19):
**a csatorna videói felhasználhatók a termékbemutatásokban**, az app videós tartalma ide kerül.

Felmérés (2026-11-19): 90 videó, zömmel magyar, néhány angol (DermaDry, sóterápia, nyiroködéma). Készülék-specifikus használati
videó van a Dolitóhoz, a DermaDry-hoz (3 terület × hu/en), a SaltDome-hoz, a Globus-stimulátorokhoz (4 részes sorozat), a DuoBravo/SineBravo/Rehalito
készülékekhez, az M-Sonic ultrahangokhoz, a Power Q-1000 nyirokmasszázs géphez; sok általános edukációs videó (TENS alapjai, elektróda-felhelyezés,
ultrahang-sorozat, nyiroködéma). Hiányzik: PeroBravo és ZenoWell Luna Plus saját videó, valamint a „Gyakori hibák” típusú rövid videók.
A webshop termékleírásaiba már beágyazott videók (`pp-video-row` szekció az UNAS `Description.Long`-ban) importáláskor automatikusan a
termékhez köthetők; a Luna Plus két videója a gyártó Vimeo-csatornáján van, ezért a Video entitás a Vimeo forrást is kezeli.
- Playlist készülékenként: `[Készülék neve] – Használati útmutató`.
- Cím-konvenció a tömeges importhoz: `Készülék · Témakör · Cím` – pl. `Myolito · Üzembe helyezés · Akkumulátor töltése`.
  Az import a második tagot témakör-kódra képezi.
- Rövid (1–3 perces), egy témát lefedő videók; hosszabb videóból időpont-részlet (`start/end`) is hivatkozható.
- Nyelv: külön videó nyelvenként, vagy közös videó feliratsávval; a Video entitás mindkettőt kezeli.

### Szinkron a csatornával
- Teljes lista: a feltöltések lejátszási lista oldala (`playlist?list=UU…`) vagy a YouTube Data API `playlistItems` hívása; az RSS
  (`feeds/videos.xml?channel_id=…`) csak a legfrissebb 15-öt adja → új videók észlelésére jó, teljes betöltésre nem.
- Bélyegkép: `https://i.ytimg.com/vi/<id>/mqdefault.jpg` (320×180) – az app saját tárhelyére tükrözve, mint a termékképek.
- A prototípus 0.3.1 a katalógusból kézzel párosított 27 videót mutat az 5 készüléknél (javaslat, az adminban hagyandó jóvá).

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
