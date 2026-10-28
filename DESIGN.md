# Design

Mode: Operate. Both apps are task tools: reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src` (`tokens/colors.dart`, `tokens/spacing.dart`, `tokens/typography.dart`, `theme/app_theme.dart`).

References (owner decision 2026-10-28):

- CMS: "CMS Dashboard Design" by Faysol Ahmed Sozib, <https://dribbble.com/shots/16763871-CMS-Dashboard-Design>
- Kasir: "Mobile App Design for POS (Cashier Management for Small Store)" by Vinz, <https://dribbble.com/shots/27265995-Mobile-App-Design-for-POS-Cashier-Management-for-Small-Store>

Both are credited in the UI (`DesignCredit`): the CMS page footer and login, and the bottom of the kasir "Lainnya" page. Layout and component shapes follow the references; colors are our own (white and mint), and every feature and flow stays as it was.

## Color

White and mint. Mint carries the brand on actions and selection; status hues keep their own meaning. Every text pair below is 4.5:1 or better, input borders 3:1 (checked with the WCAG formula and in widget tests).

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | `#047857` (Mint 700), white text | `#34D399` (Mint 400), `#022C22` text | Main action per screen, + buttons, active transaction tab, selected payment method, focus ring, chart series 1 |
| Brand panel | `#065F46` (Mint 800), white text, `#D1FAE5` secondary text | `#064E3B` (Mint 900), white, `#A7F3D0` | One solid mint block per screen: kasir floating nav, payment total card, CMS login aside, logo tile |
| Selected nav | `#D1FAE5` fill, `#065F46` text | `#064E3B` fill, `#A7F3D0` text | Active sidebar item (plus a 3px primary bar on its left edge), rail indicator, segmented tabs |
| Canvas | `#F4F7F5` | `#0B1210` | Page background behind cards |
| Surface | `#FFFFFF` | `#111A17` | Cards, sidebar, top bar, sheets, inputs |
| Subtle | `#EEF3F0` | `#1A2622` | Secondary buttons, zebra rows, stat tiles |
| Text | `#0B1F17` | `#E8F1ED` | Body and headings |
| Muted text | `#5B6B64` | `#94A39C` | Labels, hints, captions |
| Hairline | `#E2E8E5` | `#23332D` | Card borders (CMS), dividers, table rules |
| Input border | `#7C8D86` | `#647770` | 3:1 against the surface (WCAG 1.4.11) |
| Warning | `#B45309`, badge `#92400E` on `#FEF3C7` | `#FBBF24` on `#451A03` | Stock conflict, not synced, offline |
| Danger | `#B91C1C`, badge `#7F1D1D` on `#FEE2E2` | `#F87171` on `#450A0A` | Errors, cancel, shortfall, destructive |

Neutrals carry a slight green tint so grey sits with the mint instead of against it. Status always ships with a text label (`StatusBadge` is a pill of tinted fill and deeper text of the same hue), never color alone.

Product tiles (kasir) pick one of five pastel pairs by category id, so a shelf reads in groups: mint, orange, blue, rose, violet (`BrandColors.tilesLight/tilesDark`, each 6.7:1 or better). The product name carries the meaning; color only helps scanning.

Chart series (`ChartColors`): light `#047857` + `#2A78D6`, dark `#34D399` + `#3987E5`. The second series is dashed, there is a legend, and a table view.

## Type

Inter, bundled in `packages/ui/fonts` (works offline). Two scales, chosen by density:

|  | CMS (compact) | Kasir (touch) |
|---|---|---|
| Body | 14 | 16 |
| Small / caption | 13 | 14 |
| Button label | 14 / 500 | 16 / 600 |
| Page title | 18 | 20 |
| Display (totals) | 30 | 36 |

Prices and quantities use tabular figures (`.tabular`). Receipts render in monospace because their columns must match the printer.

## Shape, size, and space

Two densities from one palette (`AppTheme.compact` for the CMS, `AppTheme.touch` for the kasir; widgets read `AppSizes.of(context)`):

|  | CMS | Kasir |
|---|---|---|
| Button and input height | 40 | 48 |
| Primary action height | 44 | 56 |
| Control radius | 8 | 12 |
| Card radius | 12 | 20 |
| Card padding | 24 | 16 |
| Card edge | 1px hairline | none (white on canvas) |
| Table row | 48 | 56 |

Spacing steps 4/8/12/16/24/32/48. Pills (full radius) for status badges, category chips, quick-cash chips, and the kasir nav.

Elevation: flat. The tone step between canvas and white card is the depth cue. Only the floating kasir nav and dialogs carry a shadow. No gradients, no glow, no glass.

## Components

shadcn for Flutter (`shadcn_ui` 0.57.3), wrapped in `packages/ui` so both apps share one API:

- `AppButton` (ShadButton): primary, secondary, outline, ghost, destructive, destructiveGhost. Grows with large text instead of clipping.
- `AppTextField` (ShadInputFormField), `SearchField` (ShadInput), `AppSelect` (ShadSelect), `AppTabs` (ShadTabs as a segmented filter), `DateRangeField` (ShadDatePicker popover), `SurfaceCard` (ShadCard), `StatusBadge` (ShadBadge), dialogs (`showShadDialog`).
- `ResponsiveTable`: table above 600 wide (zebra rows, hairline header, "Aksi" column), cards below.
- Material stays where shadcn has no equivalent: list tiles, category chips, autocomplete, the account and row menus, navigation rail and bar. The qty stepper stays a Material icon button because it keeps a 48dp hit area around a 32dp square.

Icons: Iconsax linear (the `_copy` names in `iconsax_flutter`; the plain names are the bold set). Thin outline glyphs match both references.

## Touch and text size

Kasir tap targets ≥ 48dp, primary actions 56dp. CMS controls are 40 (pointer input; WCAG 2.5.8 asks for 24). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap or scroll instead of shrinking text.

## Layout

- CMS shell: drawer < 600, white rail 600–1024, white sidebar > 1024 (248 wide). The sidebar shows the logo tile and name, Dashboard, then foldable sections in branch order: Penjualan (Transaksi, Pembayaran, Hutang), Katalog (Produk, Kategori), Pengguna (Customer, Staff, Device), Lainnya (Laporan, Pengaturan). The open page's section never folds. Top bar white with a hairline: page title, language toggle (ID/EN), account avatar menu (signed-in name, settings, sign-out). No global search. Page actions sit in a row under the bar; the design credit is a thin footer under every page.
- Dashboard: "Ringkasan" panel with a range button and four stat tiles, the chart panel beside "Perlu tindakan", then recent transactions beside top products. Trends come from real previous-period data.
- Kasir shell: floating mint pill nav below 600 (Transaksi, Riwayat, Customer, Lainnya), white rail above. Produk and settings live under Lainnya.
- Kasir checkout (Vinz layout, our flow): header with store and cashier in small print; transaction tabs with the active one in mint; search and Scan; category pills; product cards (pastel initial tile, name, stock line, price, mint +). Cart: item cards with − qty + and subtotal, total, "Lanjut ke pembayaran". Payment: mint total card, method cards (selected one solid mint with a check), VA bank chips, cash chips with "Uang pas", green change or red shortfall. Bayar stays disabled while cash is short. Phones keep the cart in a sheet; landscape tablets show it on the right.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Row actions use a visible "Aksi" button. Icon-only buttons (product +, phone tab actions, clear search) carry tooltips and semantic labels.
- Snackbars for short feedback. Dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab color, section chevron, 150–250 ms ease-out).

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".

## Logo

Brief for the logo. The current mark is a placeholder: a white "S" on a Mint 800 rounded square (CMS sidebar 32px, radius 8).

**What the product is.** Point of sale for a small Indonesian shop (warung, toko kelontong): a cashier app that works offline on a phone or tablet, and a web back office for the owner. Users are shop owners and cashiers, not tech people.

**Character.** Calm, trustworthy, quick to read. Closer to a well-kept ledger than to a startup. Friendly without being cute.

**Color.**

| Use | Value |
| --- | --- |
| Mark fill | Mint 800 `#065F46` |
| Mark on the fill | White `#FFFFFF` (7.7:1) |
| Lighter accent, if the mark needs a second tone | Mint 100 `#D1FAE5` (6.8:1 on Mint 800) |
| Mark on white backgrounds, one color | Mint 700 `#047857` (5.5:1 on white) |
| Mark on dark backgrounds | Mint 400 `#34D399` on `#0B1210`, or the white-on-Mint-900 tile |
| Wordmark text | `#0B1F17` on light, `#E8F1ED` on dark |

Two colors at most. It must also work in one flat color (receipt printers are black only, so the receipt header uses a monochrome version).

**Shape.** Rounded square container with a radius about 25% of its side, matching the UI's rounded cards and buttons. Geometric, solid strokes; no thin hairlines that disappear at 16px. Letterforms, if any, set in Inter Bold or drawn to match it.

**Sizes it has to survive.**

| Where | Size |
| --- | --- |
| Favicon (CMS web) | 16 and 32 px |
| CMS sidebar and rail | 32 px |
| Android adaptive icon | 108 dp canvas, keep the mark inside the central 66 dp safe zone (foreground and background layers) |
| iOS app icon | 1024 × 1024, no transparency; iOS applies its own corner mask |
| Receipt header | monochrome, around 200 px wide on 58 mm paper |

**Avoid.** Gradients, glow, drop shadows, glassy or 3D effects, sparkles or AI symbols, generic cart or barcode clip art used alone, more than two colors, and text that becomes unreadable below 32 px.
