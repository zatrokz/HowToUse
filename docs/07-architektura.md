# 07 – Architektúra és technológia

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet / javaslat

## 7.1 Rendszerkép

```
 UNAS API ──► [UNAS-sync worker] ──► ┌──────────────────────┐
                                     │  Headless CMS + API  │◄── Admin felület (web, böngésző)
 YouTube Data/oEmbed ──────────────► │  (PostgreSQL)        │
                                     └──────────┬───────────┘
                                                │ publikálás
                                                ▼
                                   [Katalógus-generátor] → statikus JSON + képek → CDN / objektumtár
                                                │
                     ┌──────────────────────────┴───────────────────────┐
                     ▼                                                  ▼
              Mobil app (iOS/Android)                          Webes nézet (univerzális link)
              YouTube beágyazott lejátszó
```

## 7.2 Technológiai javaslat (ajánlott opció)

| Réteg | Javaslat | Indok |
|-------|----------|-------|
| Mobil app | **React Native + Expo (TypeScript)** | egy kódbázis iOS/Android/web; OTA frissítés; `react-native-youtube-iframe`; nagy ökoszisztéma |
| Admin + API + tartalomtár | **Payload CMS 3** (Next.js, TypeScript, PostgreSQL) | beépített, testreszabható admin; natív mezőszintű lokalizáció; verziózás, piszkozat/publikált, szerepkörök, hozzáférés-szabályok; REST+GraphQL; saját kód ugyanabban a repóban |
| Adatbázis | PostgreSQL (menedzselt) | |
| Fájlok/képek | S3-kompatibilis tár (pl. Cloudflare R2) + CDN | olcsó, gyors képkiszolgálás |
| UNAS-sync | Node/TS worker (ütemezett job a Payload-ban vagy külön cron) | közös típusok a CMS-sel |
| Katalógus | statikus JSON generálás publikáláskor → R2/CDN | skálázható, olcsó, offline-barát |
| Hosting | Vercel/Fly.io/Render (CMS) + R2 (statikus) | alacsony üzemeltetési teher |
| Analitika | PostHog / Firebase Analytics (anonim, opt-in) | |
| Hibajelentés | Sentry | |

**Alternatívák** (ha a csapat kompetenciája indokolja): Flutter az app oldalon; Strapi vagy Directus CMS-ként;
Supabase + egyedi admin. A döntés a nyitott kérdések közt (11. fejezet).

## 7.3 Repó-struktúra (monorepo)

```
HowToUse/
├── apps/
│   ├── mobile/        # Expo app
│   └── cms/           # Payload CMS: admin + API + sync job + katalógus-generátor
├── packages/
│   ├── shared/        # típusok, katalógus-séma (zod), i18n-kulcsok
│   └── ui/            # közös komponensek (előnézet az adminban + app)
├── docs/              # ez a dokumentáció
├── .github/workflows/ # CI: lint, teszt, build, release
├── CHANGELOG.md
└── README.md
```
Eszközök: pnpm workspaces, Turborepo, ESLint/Prettier, Vitest, Conventional Commits, changesets/semver-tagek.

## 7.4 Környezetek
`dev` (lokális, UNAS tesztkulcs) → `staging` (TestFlight / belső Android teszt, staging CMS) → `prod`.
Titkok (UNAS API-kulcs, YouTube API-kulcs) környezeti változóban, soha a repóban.

## 7.5 App-oldali működés
- Indításnál: manifest-verzió lekérése; ha változott, delta letöltés; teljes katalógus lokális tárban (SQLite/MMKV).
- Keresés lokálisan (Fuse.js). Képek lusta betöltése, gyorsítótár.
- Videó: YouTube IFrame Player API; csak hálózattal; fekvő teljes képernyő.
- Deep link / univerzális link kezelése; megosztás.
- OTA (Expo Updates) a JS-réteg javításaira; natív változás esetén store-kiadás.

## 7.6 Nem-funkcionális követelmények
| Terület | Cél |
|---------|-----|
| Indulási idő | < 2 s meleg, < 4 s hideg indítás |
| Katalógus mérete | < 5 MB JSON (képek külön, lusta) 200 termékig |
| Elérhetőség | statikus katalógus 99,9 % (CDN); a CMS leállása az appot nem érinti |
| Biztonság | admin: SSO/2FA, HTTPS, szerepkör-alapú hozzáférés, audit napló |
| Tesztek | egység (sync-leképezés, fallback-feloldás), E2E (Detox/Maestro) a fő folyamatokra |
