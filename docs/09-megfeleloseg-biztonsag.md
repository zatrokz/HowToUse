# 09 – Megfelelőség és biztonság

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 9.1 Orvostechnikai tartalom szabályai
- Az app **nem orvostechnikai eszköz** (nem diagnosztizál, nem terápiás paramétert javasol személyre),
  edukációs/használati segédlet. Ezt a célmeghatározást rögzítjük (MDR 2017/745 besorolási indoklás) és a
  felületen, az áruházi leírásban következetesen kommunikáljuk.
- Minden eszköz-oldalon állandó figyelmeztetés: *„A gyártó használati útmutatója az irányadó; az app annak
  kiegészítője."* + link az IFU-ra (PDF, UNAS-ból vagy adminból).
- A `risks` témakör tartalma csak **szakmai jóváhagyó** által publikálható; a kontraindikációk forrása a gyártói IFU;
  a szöveg felsorolja az állapotokat, de nem ad egyéni döntést („kérdezze meg kezelőorvosát").
- Tiltott: gyógyulási ígéret, dózis/protokoll személyre szabása, betegségek kezelésének garantálása.
  (Összhang a Medimarket meglévő tartalmi/hirdetési policy-jével – a `cikkiro`/`leiras-keszito` szabályrendszer.)
- Verziózott tartalom: minden publikált elemnél látszik a „frissítve" dátum és a jóváhagyó.

## 9.2 Áruházi irányelvek (App Store / Google Play)
- Apple 1.4.1 / Google egészségügyi szabályok: egyértelmű, hogy nem orvosi tanács; forrásmegjelölés; nincs
  félrevezető állítás. Kiadói fiók: Medimarket (jogi entitás).
- Adatvédelmi címke: csak anonim használati statisztika (opt-in), nincs fiók, nincs egészségügyi adat.

## 9.3 GDPR
- Nem gyűjtünk személyes adatot a felhasználói appban; analitika anonim és kikapcsolható.
- Admin: felhasználói fiókok (név, e-mail), audit napló – adatkezelési tájékoztató belső használatra.
- YouTube-beágyazás: `youtube-nocookie`, a lejátszás a felhasználó érintésére indul (nem automatikus betöltés).

## 9.4 Technikai biztonság
- Admin: HTTPS, erős jelszó + 2FA / SSO, szerepkör-alapú hozzáférés, munkamenet-lejárat.
- API-kulcsok (UNAS, YouTube) titokkezelőben; a publikus katalógus csak olvasható, nem tartalmaz titkot.
- Függőségek automatikus sebezhetőség-ellenőrzése (Dependabot), aláírt kiadások.

## 9.5 Tartalmi szerzői jog
Csak saját (Medimarket) vagy gyártótól engedélyezett videó és kép; gyártói anyagoknál az engedély a Video/Product rekordban rögzítve.
