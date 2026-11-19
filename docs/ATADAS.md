# Átadási jegyzet – folytatás Claude Code desktop appban

> Dátum: 2026-11-19 · Átadó: cloud session (tervezési fázis) · Verzió: 0.2.0

## Hol tartunk
- A **0. (tervezési) fázis kész**: a `docs/01`–`11` dokumentumok tartalmazzák a követelményeket, a felhasználói és admin felület tervét, az adatmodellt, az UNAS-integráció tervét, a többnyelvűség, az architektúra, a YouTube-videók, a megfelelőség tervét, az ütemtervet és a nyitott kérdéseket.
- Kattintható HTML prototípus: `docs/prototype/index.html` (mintaadatok, HU/EN).
- Alkalmazáskód még **nincs**; a technológiai javaslat (Expo + Payload CMS + PostgreSQL + R2/CDN) a `docs/07-architektura.md`-ben, döntésre vár (`docs/11-nyitott-kerdesek.md` #4).
- Minden a `claude/zealous-planck-17h9q9` ágon van, a GitHubra pusholva (`v0.1.0`, `v0.2.0` tag).

## Így folytasd a desktop appban
```bash
git clone https://github.com/zatrokz/HowToUse.git
cd HowToUse
git checkout claude/bold-allen-0eb5rn
```
Majd a Claude Code-nak: *„Olvasd el a README-t és a docs/ATADAS.md-t, válaszolj a docs/11 nyitott kérdéseire velem egyeztetve, aztán indítsd az 1. fázist (monorepo-váz, Payload CMS adatmodell, UNAS-sync váz)."*

## Amit a cloud session nem tudott megtenni
- Az `unas.hu` és a `medimarket.hu` nem volt elérhető a session hálózatából, így az UNAS API mezőnevei és a webáruház aktuális kategórialistája **nincs ellenőrizve** – lásd `docs/05-unas-integracio.md` 5.7. A desktop appból (saját gépen) ezek elérhetők.

## Első teendők (1. fázis)
1. Nyitott kérdések (`docs/11`) megválaszolása, döntési napló frissítése.
2. ~~UNAS API-kulcs, `getProduct` mintaválasz mentése `docs/samples/`-be, mezőleképezés véglegesítése (`docs/05`)~~ – kész (0.3.0).
3. Monorepo-váz: `apps/mobile` (Expo), `apps/cms` (Payload), `packages/shared`; CI.
4. Adatmodell implementálása a CMS-ben a `docs/04` alapján.
5. Minden lépésnél: CHANGELOG-bejegyzés, `scripts/toc.sh`, commit, push.

## Konvenciók
- Dokumentumok fejléce: verzió · dátum · állapot. Nyelv: magyar.
- Conventional Commits (`feat:`, `docs:`, `chore:`…), SemVer, git tag kiadásonként.
- A README tartalomjegyzékét és a `docs/TARTALOMJEGYZEK.md`-t minden dokumentumváltozásnál frissíteni.
