# Design

Mode: Operate. Both apps are task tools; reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src`.

## Color

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | `#15803D` | `#22C55E` (on-primary `#052E16`) | Main action per screen (Bayar, Simpan), active tab, success |
| Shell (forest) | `#0F3D2E`, raised `#16523E` | `#0C241B` | CMS sidebar/rail/drawer, kasir header and tablet rail, cart pill, revenue card. White text 12:1 |
| Indicator on forest | `#C8F2D8` (text `#0F3D2E`) | `#4ADE80` (text `#052E16`) | Selected nav item, active tab underline, cart pill button |
| Canvas | `#F2F7F4` (mint) | `#0A100D` | Page background behind cards |
| Surface | `#FFFFFF` | `#121A16` | Cards, sheets, inputs |
| Neutrals | zinc 50–950 | zinc 50–950 | Text, borders, containers |
| Input border (`outline`) | zinc 500 | zinc 500 | 3:1 against the surface (WCAG 1.4.11) |
| Divider (`outlineVariant`) | zinc 200 | zinc 800 | Decorative only |
| Warning | `#B45309` / container `#FEF3C7` | `#FBBF24` / `#451A03` | Stock conflict, not synced, offline |
| Danger | `#B91C1C` / `#FEE2E2` | `#F87171` / `#450A0A` | Errors, cancel, destructive |

Status always ships with a label and a dot or icon, never color alone (`StatusBadge`). Green is not used for decoration.

Chart series (`ChartColors`, validated with the dataviz checker): light `#15803D` + `#2A78D6`, dark `#16A34A` + `#3987E5`. The second series is dashed, there is a legend, and a table view.

## Type

Inter, bundled in `packages/ui/fonts` (works offline). Body 16, small 14, labels 16/600 on buttons, headline 24–36. Prices and quantities use tabular figures (`.tabular`). Receipts render in monospace because their columns must match the printer.

## Shape and space

Radius: 6 (inputs, badges), 12 (cards, dialogs, sheets, product avatars), full for chips, add buttons, the qty stepper, and people avatars. Spacing steps 4/8/12/16/24/32/48.

Elevation: white cards on the mint canvas carry a soft green-tinted shadow and no border (one depth cue, not both). Grouped content lives in one card; cards are never nested. Lists of products, sales, and customers are cards with a gap instead of rows split by dividers.

Avatars: initials (letters only, so "Aqua 600ml" is AQ) on the brand mint, or the product image when its URL loads. One color for every item; color is not used to tell categories apart.

## Touch and text size

Tap targets ≥ 48dp, primary actions 56dp (`AppButton(large: true)`). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap (`Wrap`) or scroll with their content (slivers) instead of shrinking text.

## Layout

- CMS: drawer < 600, navigation rail 600–1024, sidebar > 1024 (`CmsShell`), all on forest. Tables sit in one white card and become cards below 600, dropping secondary columns below 1024 (`ResponsiveTable`). Forms open as full pages on phones and dialogs elsewhere (`showFormSurface`). Page actions sit in a row under the title; on phones the row scrolls sideways. Login is a forest panel beside the form on wide windows.
- Kasir: white navigation bar on narrow windows, forest rail on wide ones. The transaction tab strip is the forest header. Products are a list of cards on phones and a grid of cards (initials or image, price, Tambah) on tablets; a badge shows how many are already in the active tab. The cart is a floating forest pill on phones and a side panel from 720. The Bayar button is pinned at the bottom of the cart, apart from the product list. At large text the Tambah button moves under the product name.
- Dashboard: needs action first, then revenue as the forest hero card with three smaller white cards, then the chart card, then detail cards in two columns. No up/down comparisons without a named period.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Row actions use a visible "Aksi" menu button.
- Snackbars for short feedback (scan added, saved, synced). Dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab underline, 150–250 ms ease-out).
- Icons: Iconsax for navigation and objects; plain Material glyphs (`add_rounded`, `remove_rounded`, `search_rounded`) for +, −, and search, because the Iconsax versions are boxed and read heavy inside buttons.

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. Backend error text is shown as-is in v1. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".
