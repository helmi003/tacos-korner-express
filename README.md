# Tako's Korner — Food Ordering App

Tako's Korner is a mobile food-ordering application (restaurants, delivery tracking, and a short-video "Reels" discovery feed). The repository currently ships as a Flutter project scaffold whose UI/UX has been fully prototyped as a single interactive HTML file, used as the functional and visual reference for the native Flutter build.

- **Interactive prototype:** [`docs/app.html`](docs/app.html) — open directly in a browser
- **Prototype technical notes:** [`docs/readme.md`](docs/readme.md) — screen IDs, data shapes, state, known gaps
- **Cahier des charges (FR):** [`docs/specifications.html`](docs/specifications.html) — full functional spec, roadmap, and time/cost estimate
- **Flutter app source:** [`lib/`](lib/) — currently the default Flutter scaffold; native implementation not yet started

## Status

| Layer | Status |
|---|---|
| UX/UI prototype (`docs/app.html`) | ✅ Done — 20+ screens, fully interactive, no backend |
| Design system | ✅ Defined (colors, type, icons) |
| Flutter app (`lib/`) | ⛔ Not started — default `flutter create` scaffold only |
| Backend API | ⛔ Not started |

## Features (as prototyped)

### Onboarding & Authentication
- 3-slide onboarding (hero, feature highlights, language picker)
- Email/password login + Google/Apple social login buttons
- Registration with validation
- Forgot password → email-sent state → OTP verification → new password with strength meter

### Home & Discovery
- Promo carousel, category shortcuts
- New Arrivals and Popular rails, each with a "See all" grid screen
- "Because you liked…" favorites-based recommendation rail
- Restaurant list (cards) and map view
- Search screen (single entry point via the Home search bar)

### Product & Customization
- Product detail: hero image, tags, price, rating, reviews
- Ingredient customization: included ingredients (informational), categorized priced extras (capped per group), "Without" removal chips, drink/dessert add-ons
- "Save this combo" — persists a selection as a quick-apply preset

### Cart & Checkout
- Cart lines keyed by product + customization (`lineId`) — identical customizations merge, different ones stay independent
- Promo codes (`TAKO10`, `NEWUSER`, `SAVE5`)
- Payment method selection → order confirmation

### Orders
- Active/Past order tabs, driven by live app state
- Cosmetic status ladder (`confirmed → preparing → onway → delivered`) with a pulsing "Live" badge on Home
- Reorder from order history

### Reels (social/video discovery)
- Vertical video feed (autoplay on scroll, tap-to-unmute, loop)
- Like/dislike (mutually exclusive), comments (with per-comment like/dislike), follow, save, share
- Tap creator to open the linked restaurant; restaurant detail has a matching Videos tab
- Reusable share sheet (real Facebook/WhatsApp web-intents, Instagram copy-link fallback)

### Restaurant Profiles
- Menu / Videos / Location segmented detail view
- Mini map with a single pin for location

### Profile & Settings
- Computed stats (orders/favorites/reviews), Favorites, Order History
- Language, delivery zone, notification toggles
- Change password, Help/FAQ, Notifications, Privacy Policy, Terms of Service

### Internationalization
- English, French, Arabic — with RTL layout switching for Arabic
- Currently covers onboarding/auth screens only; post-auth screens are English-only by design (see `docs/readme.md`)

## Design System

| Token | Value |
|---|---|
| Primary (red) | `#ec1d23` |
| Secondary (blue) | `#2596be` |
| Background | `#f0f2f5` |
| Surface | `#ffffff` |
| Text | `#1a1a2e` |
| Font (EN/FR) | Poppins |
| Font (AR) | Amiri |
| Icons | Solar Icons (via Iconify CDN) |
| Reference frame | 390×844px phone frame (mobile-first) |

## Repository Structure

```
docs/
  app.html            Interactive HTML/CSS/JS prototype (design + UX reference)
  readme.md           Prototype implementation notes (screens, state, data shapes)
  specifications.html Cahier des charges — functional spec, roadmap, estimates (FR)
lib/                   Flutter app source (scaffold only, not yet implemented)
android/ ios/ web/
linux/ macos/ windows/ Flutter platform folders (generated)
pubspec.yaml           Flutter project manifest
```

---

## Building the Real App in Flutter

This section is for the developer(s) picking up native implementation. The HTML prototype (`docs/app.html`) is the source of truth for screens, flows, and copy — build against it, not against this document, for pixel-level details.

### Prerequisites

- **Flutter SDK** matching `environment.sdk: ^3.12.2` in `pubspec.yaml` (install via [flutter.dev](https://docs.flutter.dev/get-started/install))
- **Dart** ships with Flutter — no separate install
- **Android Studio** (Android SDK + emulator) and/or **Xcode** (iOS builds/simulator, macOS only)
- **VS Code** or **IntelliJ/Android Studio** with the Flutter/Dart plugins
- A **backend API** (see `docs/specifications.html`, §4) — the app has no server today; plan to build against a mocked/staging API first
- Accounts/keys before wiring real integrations: Google Sign-In, Apple Sign-In, a payment gateway (sandbox), Firebase (push notifications/analytics), a maps provider

### Recommended Package Set (by feature)

| Feature area | Suggested packages |
|---|---|
| State management | `riverpod` or `bloc`/`flutter_bloc` (pick one, be consistent) |
| Networking | `dio` (interceptors, retries) or `http` |
| Local persistence | `shared_preferences` (simple flags), `flutter_secure_storage` (tokens), `hive`/`drift` (offline cart/cache) |
| Routing | `go_router` (deep links, nested nav for tabs) |
| i18n / RTL | `flutter_localizations` + `intl`, ARB files per locale (en/fr/ar) |
| Images | `cached_network_image` |
| Fonts/Icons | `google_fonts` (Poppins/Amiri), an Iconify-compatible icon set or a bundled icon font matching Solar Icons |
| Video (Reels) | `video_player` + `visibility_detector` (or `preload_page_view`) for autoplay-on-scroll |
| Auth | `google_sign_in`, `sign_in_with_apple` |
| Maps | `google_maps_flutter` or `flutter_map` (OSM) for restaurant location/mini-map |
| Payments | SDK for the chosen gateway (e.g. `flutter_stripe`) — never roll custom card handling |
| Push notifications | `firebase_messaging` + `flutter_local_notifications` |
| Sharing | `share_plus`, `url_launcher` (Facebook/WhatsApp web-intents, matching the prototype's share sheet) |
| Forms/validation | `form_validator` or hand-rolled validators matching the prototype's rules |
| Testing | `flutter_test` (already included), `mocktail`, `integration_test` |

### Suggested Project Structure

```
lib/
  main.dart
  app.dart                 MaterialApp/router setup, theme, locale
  core/
    theme/                 Colors, text styles, spacing (mirror the design tokens above)
    network/               API client, interceptors, error handling
    storage/               Secure storage, local cache
    localization/           ARB files, locale delegate
  features/
    onboarding/
    auth/                   login, register, forgot/reset password
    home/
    search/
    product/                detail + customization
    cart/
    checkout/               payment method + confirmation
    orders/                  tracking, history
    reels/                   video feed, comments, follow/save/share
    restaurant/
    profile/
    settings/
    notifications/
  shared/
    widgets/                buttons, cards, sheets, chips — one implementation per component, reused everywhere
    models/
```
Each `features/*` folder should mirror one or more screen IDs from `docs/readme.md` (e.g. `s-product` → `features/product/`), which keeps the mapping from prototype to code traceable during review.

### Getting Started

```bash
flutter --version              # confirm SDK matches pubspec.yaml
flutter pub get
flutter devices                # confirm a simulator/emulator/device is available
flutter run
```

Open `docs/app.html` in a browser side-by-side while implementing each screen — it is interactive, so flows (add-to-cart, customization, Reels gestures, promo codes) can be exercised directly rather than inferred from static mockups.

### Before Writing Business Logic

1. Read `docs/readme.md` fully — it documents exact data shapes (`Product`, `Cart line`, `Order`, `Reel`) and non-obvious behavior (e.g. the Iconify re-render gotcha, `lineId` merge rules, reel like/dislike mutual exclusivity) that the Flutter code must reproduce.
2. Confirm the backend API contract (endpoints, auth flow, websocket/push strategy for live order status) before building screens that depend on it — several screens (Home's "Live" badge, Orders, Reels comments) assume real-time or near-real-time data.
3. Decide the i18n scope up front: the prototype only localizes onboarding/auth; extending translation to every screen is a product decision, not just an implementation detail — flag it if in scope.

### Out of Scope of the Prototype (needs product decisions before building)

- Real payment gateway integration and PCI-relevant flows
- Real-time order tracking transport (polling vs. websockets vs. push)
- Backend-driven search/recommendation ranking (the prototype's rails are static/heuristic)
- Restaurant ↔ product relationship (today every restaurant shares one global product catalog)
- Moderation for Reels comments/videos

See `docs/specifications.html` for the full functional specification, non-functional requirements, future roadmap, and a professional time/cost estimate for a 1 backend + 1 frontend developer team.
