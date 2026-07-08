# Tako's Korner — App Spec Notes

## Design Tokens
| Token | Value |
|---|---|
| Primary (red) | `#ec1d23` |
| Secondary (blue) | `#2596be` |
| Background | `#f0f2f5` |
| Surface | `#ffffff` |
| Text | `#1a1a2e` |
| Font (EN/FR) | Poppins |
| Font (AR) | Amiri |
| Icons | Solar Icons via Iconify CDN |
| Images | Unsplash |
| Reels video | Small rotating pool of stock CDN mp4 clips (`REEL_VIDEOS`) |

## Languages
- English (default), French, Arabic (RTL)
- Language stored in `ST.lang`, changes `<html dir>` for RTL
- `T` object (keyed by lang code) covers onboarding/auth screens only. All post-auth screens (home, cart, product, reels, profile, etc.) are hardcoded English — i18n was never retrofitted there and that's an accepted, intentional gap.

## Screens Built
| Screen ID | Description |
|---|---|
| `s-onboard` | 3-slide onboarding with hero image, features, language picker |
| `s-login` / `s-register` / `s-forgot` / `s-reset` | Auth flow |
| `s-home` | Feed: promo carousel, categories, new arrivals, popular, other promotions, "because you liked…" recommendations, restaurants (cards/map) |
| `s-search` | Search screen — now the *only* entry point (bottom-nav Search tab was removed; tapping the Home search bar opens this) |
| `s-see-all` | Generic 2-col product grid screen, reused for "See all" (New Arrivals / Popular) **and** Profile → Favorites |
| `s-product` | Product detail: hero image, tags, price/rating, ingredient customization (selectable, categorized, capped per group), "Without" removal chips, drink/dessert add-ons, reviews, qty + add to cart |
| `s-restaurant` | Restaurant detail with a Menu / Videos / Location segmented control — Videos filters `REELS` by `restaurantId`, Location renders a single-pin mini map |
| `s-reels` | Vertical `<video>` feed (loop/muted/tap-to-unmute, IntersectionObserver autoplay) with like, dislike, comment (real drawer, persisted per reel), share, save, follow, and tap-creator-to-open-restaurant |
| `s-cart` | Cart lines keyed by `lineId` (product + selected customization), independent qty per line, promo code, totals |
| `s-payment` → `s-success` | Payment method select → order confirmation, which now creates a real order (see Orders below) |
| `s-orders` | Active/Past tabs, fully data-driven from `APP.orders` (no longer static markup) |
| `s-profile` | Stats (Orders/Favorites/Reviews — all computed, not hardcoded), Favorites entry (opens `s-see-all`), Order History, Help & Support, Privacy Policy, Terms of Service |
| `s-settings` | Language, delivery zone, notification toggles, Change Password (own screen now) |
| `s-notifications` | Static notification list, opened from the Home bell icon |
| `s-change-password` | Real current/new/confirm form (previously reused the OTP `s-forgot` flow) |
| `s-help` | FAQ + Contact Us stub |
| `s-privacy` / `s-terms` | Placeholder legal screens — reachable from Profile **and** from the Register screen's checkbox links (back button on those two detects logged-in state via `#bottom-nav`'s hidden class to return to the correct place) |

## Product Data Shape
```js
{ id, cat, name, price, rating, reviews, isNew, isFeatured, image, description, ingredients: [name, ...] }
```
`ingredients` is a flat array of strings — these are shown on the product page as **Included** (informational, not togglable). Categories (Protein/Cheese/Sauces/Toppings) are *derived* at render time via `classifyIngredient()` / `ING_CATEGORY_RULES`. Each category also offers a curated, **priced** `EXTRA_INGREDIENTS` pool (e.g. extra bacon, extra cheese) that the user opts into — unselected by default, capped per group via `GROUP_EXTRA_MAX`. The "Without" section still lets you remove any included ingredient. A "Save this combo" button on the product page persists the current extras/without/addons selection to `APP.savedCombos`, resurfaced as quick-apply chips next time that product is opened.

## Icon toggling — important gotcha
Iconify's runtime (`iconify.min.js`) converts `<span class="iconify" data-icon="...">` placeholders into inline SVG once; calling `.setAttribute('data-icon', ...)` on an already-converted element does **not** reliably re-render the shape (only inherited `color` still updates). Every toggle button that swaps an icon must go through the `setIcon(el, iconName)` helper (near `toast()`), which replaces the node with a fresh placeholder so Iconify picks it up again. The Iconify `<script>` tag itself also has `defer` — without it, a slow/blocked fetch of that script delays the page's own inline script (and therefore every onclick handler) from running at all.

## Restaurant Data Shape
```js
{ id, name, cuisine, rating, reviews, time, dist, zone, isOpen, fee, image }
```
Products have no restaurant FK — `renderRestaurantMenu()` still filters the global `PRODUCTS` catalog by category, not real restaurant inventory. `REELS` items do carry a `restaurantId` FK now.

## Cart Line Shape
```js
{ lineId, id, product, qty, selections: {groupId: [names]}, without: [names], addons: [{id,name,price}], unitPrice }
```
`lineId` is a deterministic key (`buildLineKey()`) over product id + selections + without + addons — identical customizations merge (qty++), different customizations of the same product become independent lines. `quickAddToCart()` uses the default (fully-included) customization.

## Orders
- `APP.orders` — created by `confirmOrder()` from a cart snapshot, status ladder `confirmed → preparing → onway → delivered` auto-advances on timers (`scheduleOrderProgress`/`advanceOrderStatus`) — cosmetic demo timing only.
- Home shows a pulsing "Live" badge (`renderLiveBadge()`) whenever any order isn't yet `delivered`; tapping it opens My Orders/Active.
- Reorder (Past tab) re-adds items with *default* customization — the lightweight order snapshot doesn't retain full selection objects.

## Share Widget
- One reusable sheet (`openShareSheet({url,title})`) used from Product detail and Reels.
- Facebook/WhatsApp open real web-intent URLs; Instagram has no web-share URL so it copies the link and toasts "paste it in Instagram".

## Reels
- `REELS` items: `{id, creator, handle, desc, hashtags, likes, comments, shares, product, restaurantId, image, video}`. `video` URLs come from a small verified-live pool (`REEL_VIDEOS`) — the original `commondatastorage.googleapis.com/gtv-videos-bucket` sample set now 404s/403s, so don't reuse those old URLs.
- Per-reel state (`APP.reelState[id]`: liked/disliked/saved/following/comments/commentCount) persists across navigation. Like/Dislike are mutually exclusive across two separate buttons (`reel-like-btn-{id}`/`reel-dislike-btn-{id}`) kept in sync via `syncReelLikeButtons()` — always resync both, since only updating the tapped button leaves the other stale.
- Each comment (`{id, reelId, name, text, liked, disliked}`) can itself be liked/disliked (`toggleCommentLike`/`toggleCommentDislike`). Profile → Activity surfaces "Liked Comments" / "Liked Reels" / "My Comments" (`showLikedComments()`/`showLikedReels()`/`showMyComments()`), and the Reels top bar has a bookmark icon for "Saved Reels" (`showSavedReels()`) — all reuse the generic `openListScreen(title, html, 'list')` list-mode.

## Navigation
- `showScreen(id, goBack?)` — router, animates slide-in or back. No screen-history stack; back navigation uses `APP.previousTab` (one level of memory) via `goBack()`.
- Bottom nav: **Home, Reels, Cart, Profile** (Search tab removed — Home's search bar opens `s-search` directly via `showSearch()`).
- `goTab(tab)` activates a bottom nav tab and its screen.

## File Location
`docs/app.html` — single self-contained HTML file with all CSS and JS inline. Never rewritten from scratch; each session appends/extends.
External CDN: Google Fonts (Poppins + Amiri), Iconify (Solar icons), Unsplash images, a small pool of stock mp4 clips for Reels.
