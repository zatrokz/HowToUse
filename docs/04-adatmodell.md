# 04 – Adatmodell

> Verzió: 0.1.0 · Dátum: 2026-11-19 · Állapot: tervezet

## 4.1 Alapelv: két adatgazda

| Adatkör | Gazda | Írás | Példa |
|---------|-------|------|-------|
| **Terméktörzs** | UNAS | csak szinkron írja | név, cikkszám, leírás, képek, kategória, kapcsolódó termékek, paraméterek |
| **Használati tudás** | HowToUse admin | szerkesztők írják | témakörök, videók, ismertetők, kompatibilitás-funkció, szinonimák, láthatóság |

Az UNAS-ból érkező mezők az adminban **csak olvashatók**, és minden szinkron felülírja őket; saját
mezővel *felülírhatók* (override), de az eredeti megmarad.

## 4.2 Entitás-kapcsolati diagram

```
Language 1──n LocalizedText (minden i18n mező mögött: entity, field, lang, value)

Category ──n Product
   │                 │ 1
   │                 │
   │                 n
   │           Compatibility  (device ⇄ accessory, role, function[i18n], source)
   │
Topic 1──n ContentItem n──1 Product (device)
                 │  n──0..1 Product (accessory)   ← a device_accessory_use témakörnél
                 │  n──0..1 Video  (nyelvenként lehet eltérő)
                 └─ ContentBlock[] (szöveg, kép, pdf, link)

Video (YouTube) ─ VideoLocalization (lang → youtube_id, title)

UnasSyncRun 1──n UnasSyncLogEntry
UnasProductSnapshot (nyers XML/JSON pillanatkép termékenként)

User n──n Role ; AuditLog ; ContentVersion
```

## 4.3 Entitások

### Language
| Mező | Típus | Megjegyzés |
|------|-------|------------|
| code | string (BCP-47, pl. `hu`, `en`, `de`) | kulcs |
| name_native | string | „Magyar", „English" |
| enabled | bool | megjelenik-e az appban |
| fallback_order | int[] / string[] | pl. `en → hu` |
| is_default | bool | pontosan egy |

### Category
| Mező | Forrás |
|------|--------|
| id, unas_category_id | UNAS |
| name[i18n] | UNAS (hu) + admin fordítás |
| slug, icon, sort_order, visible_in_app | admin |
| parent_id | UNAS (fa) |

### Product (készülék és kiegészítő is)
| Mező | Forrás | Megjegyzés |
|------|--------|------------|
| id (belső), unas_product_id, sku | UNAS | sku a stabil azonosító szinkronhoz |
| name[i18n], short_description[i18n], long_description[i18n] | UNAS (hu) + fordítás | long_description HTML → tisztított |
| images[] (url, alt, sort) | UNAS | saját tárhelyre tükrözve (05. fejezet) |
| categories[] | UNAS | több kategória lehet |
| unas_url | UNAS | webshop-link |
| unas_status | UNAS | aktív / inaktív / törölt |
| params{} | UNAS | paraméterek nyers formában (pl. „Típus: készülék") |
| product_type | admin (UNAS-javaslat) | `device` / `accessory` / `consumable` |
| display_name_override[i18n] | admin | opcionális |
| search_keywords[i18n] | admin | szinonimák |
| visibility | admin | `hidden` / `draft` / `published` |
| enabled_topics[] | admin | mely témakörök látszanak |
| manual_review_required | admin | jelzés, ha UNAS-ban változott a leírás |

### Compatibility (eszköz ⇄ kiegészítő)
| Mező | Megjegyzés |
|------|------------|
| device_id, accessory_id | Product-ok |
| role | `standard` (alaptartozék, dobozban) / `optional` / `consumable` |
| function[i18n] | „Mire való ezzel a készülékkel" |
| source | `unas_related` / `unas_param` / `manual` |
| accepted | bool – UNAS-javaslat elfogadva-e |
| sort_order | int |

### Topic (témakör)
| Mező | Megjegyzés |
|------|------------|
| code | `intro`, `accessories`, `setup`, `device_accessory_use`, `general_use`, `risks`, `common_mistakes` + egyedi |
| name[i18n], description[i18n], icon, sort_order | |
| requires_professional_approval | bool (`risks` = true) |
| requires_accessory_ref | bool (`device_accessory_use` = true) |
| is_system | bool – a 7 alap nem törölhető |

### ContentItem (tartalmi elem – egy témakörhöz **több** tartozhat)
| Mező | Megjegyzés |
|------|------------|
| device_id, topic_id | kötelező |
| accessory_id | opcionális, a páros-tartalmakhoz |
| kind | `video` / `article` / `gallery` / `pdf` / `link` |
| title[i18n] | |
| video_id | → Video (opcionális) |
| video_start_sec, video_end_sec | opcionális részlet |
| blocks[i18n] | formázott tartalom (portable text / rich text JSON) |
| status | `draft` / `in_review` / `published` / `archived` |
| valid_until | opcionális |
| sort_order | |
| created_by, updated_by, approved_by, approved_at | |

### Video
| Mező | Megjegyzés |
|------|------------|
| id | belső |
| localizations[] | `{lang, youtube_id, title, duration_sec, thumbnail_url, has_captions}` |
| default_lang | melyik változat a fallback |
| playlist_id | opcionális |
| last_checked_at, availability | YouTube-on él-e még (periodikus ellenőrzés) |

### UnasSyncRun / UnasProductSnapshot
- Futás: időbélyeg, típus (teljes / delta), feldolgozott termékek száma, hibák.
- Pillanatkép: termékenként az utolsó nyers válasz, diffeléshez és hibakereséshez.

### User, Role, AuditLog, ContentVersion
- Standard CMS-funkciók; minden ContentItem-mentés új verziót hoz létre.

## 4.4 Többnyelvű mezők tárolása

A CMS natív lokalizációját használjuk: a lokalizált mezők `{ hu: "...", en: "..." }` struktúrában
tárolódnak, nyelv hozzáadásakor nincs sémaváltozás. Az API nyelvparaméterrel kér (`?locale=en`),
és a fallback-láncot a szerver oldja fel, a válaszban jelölve a *ténylegesen* visszaadott nyelvet
(`resolved_locale`), hogy az app jelezni tudja.

## 4.5 Publikus katalógus (amit az app letölt)

Az app nem a nyers CMS-t kéri, hanem egy **generált, publikált katalógust**:

```
GET /catalog/{locale}/manifest.json       → version, generated_at, languages[], categories[], products[] (könnyű lista)
GET /catalog/{locale}/products/{slug}.json → teljes eszköz: témakörök, tartalmak, kompatibilitás, videók
GET /catalog/ui/{locale}.json              → felületi szövegek (i18n)
```
- Minden publikálás új `version`-t generál; az app ETag/verzió alapján csak a változást tölti.
- A katalógus statikusan kiszolgálható (CDN), gyors és olcsó; a CMS-nek nem kell a publikus terhelést viselnie.
- A fallback a generálásnál oldódik fel: az `en` katalógus az angolul hiányzó elemeknél a `hu` tartalmat
  tartalmazza `resolved_locale: "hu"` jelöléssel.

## 4.6 Azonosítók és URL-ek
- Publikus azonosító: `slug` (nyelvfüggetlen, az UNAS-névből generált, adminból módosítható, régi slug átirányítva).
- Univerzális link: `https://howto.medimarket.hu/{locale}/{product-slug}/{topic-code}[/{content-id}]`
  – megnyitja az appot, ha telepítve van, egyébként a webes nézetet.
