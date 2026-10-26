# Design

Mode: Operate. Both apps are task tools; reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src`.

## Color

Ink and white, shadcn default, after the two references (owner decision 2026-10-26). Green is an accent that always means something.

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary (ink) | zinc 900, white text | zinc 50, zinc 900 text | Main action per screen (Bayar, Simpan), + buttons, active tab, selected method and chips, stat icon tiles |
| Shell | zinc 900, selected zinc 800 | zinc 900, selected zinc 800 | CMS sidebar/rail/drawer, kasir floating nav and tablet rail, payment total card |
| Green accent | `#15803D` (success) | `#4ADE80` on ink | Change due, upward trend, "di keranjang", paid/synced status, logo mark, chart series 1 |
| Canvas | zinc 100 | zinc 950 | Page background behind cards |
| Surface | `#FFFFFF` | zinc 900 | Cards, sheets, inputs |
| Neutrals | zinc 50–950 | zinc 50–950 | Text, containers, grey pills (`surfaceContainer`) |
| Input border (`outline`) | zinc 500 | zinc 500 | 3:1 against the surface (WCAG 1.4.11) |
| Divider (`outlineVariant`) | zinc 200 | zinc 800 | Decorative only, outline buttons |
| Warning | `#B45309` / container `#FEF3C7` | `#FBBF24` / `#451A03` | Stock conflict, not synced, offline |
| Danger | `#B91C1C` / `#FEE2E2` | `#F87171` / `#450A0A` | Errors, cancel, shortfall, destructive |

Selected states use `primary`/`onPrimary`, never the shell color: in dark mode the shell equals the card surface. Status always ships with a label and a dot or icon, never color alone (`StatusBadge`).

Chart series (`ChartColors`, validated with the dataviz checker): light `#15803D` + `#2A78D6`, dark `#16A34A` + `#3987E5`. The second series is dashed, there is a legend, and a table view.

## Type

Inter, bundled in `packages/ui/fonts` (works offline). Body 16, small 14, labels 16/600 on buttons, headline 24–36. Prices and quantities use tabular figures (`.tabular`). Receipts render in monospace because their columns must match the printer.

## Shape and space

Radius: 6 (badges), 10 (qty stepper and + buttons), 12 (buttons, inputs, icon tiles, menus), 16 (cards, stat tiles), 24 (panels: `SurfaceCard`, summary panel, payment total card), full for chips, the range pill, and people avatars. Spacing steps 4/8/12/16/24/32/48.

Elevation: flat. White cards sit on the zinc canvas with no border and no shadow; the tone step is the depth cue. Only the floating kasir nav carries a shadow. The cart paints the canvas behind its cards so they read inside the white sheet. Stat tiles are flat `surfaceContainerLow` blocks inside the summary panel.

Inputs: label above the field (shadcn), merged with the field for screen readers. The kasir product search is the one borderless field (white on canvas, identified by its icon and hint; focus still draws the ring).

Avatars: initials (letters only, so "Aqua 600ml" is AQ) on a neutral tile, or the product image when its URL loads. Color is not used to tell categories apart.

## Touch and text size

Tap targets ≥ 48dp, primary actions 56dp (`AppButton(large: true)`). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap (`Wrap`) or scroll with their content (slivers) instead of shrinking text.

## Layout

- CMS (reference: Dribbble 27017971, Panze POS dashboard): drawer < 600, navigation rail 600–1024, sidebar > 1024 (`CmsShell`), all on ink with a lighter selected pill. Top bar white with a bottom border, page title in medium weight, language toggle (ID/EN), account avatar menu. Tables sit in one white panel and become cards below 600 (`ResponsiveTable`). Forms open as full pages on phones and dialogs elsewhere (`showFormSurface`). Page actions sit in a row under the title; on phones the row scrolls sideways. Login is an ink panel beside the form on wide windows.
- Dashboard: one "Ringkasan" panel with a grey range pill and four equal-height stat tiles (ink icon tile, label, value, trend vs the previous period of the same length), then the chart panel beside "Perlu tindakan", then recent transactions beside the details. On phones "Perlu tindakan" comes first. Trends come from real previous-period data; receivables have no trend.
- Kasir (reference: Dribbble 27265995, Vinz POS cashier): header with store and cashier in small print, title "Transaksi", and on phones a cart button with the item count. Transaction tabs: active ink, others white; "Pembeli baru" and "Semua (N)" are pinned at the end of the same row (icon squares with tooltips below 520, labelled buttons above). Search and Scan on white, category chips (active ink). Products: cards with initials, name, stock line, price, and a small ink + (the whole card also adds); a list on phones, a grid on tablets whose tile height follows the text scale.
- Kasir sizes: phone and portrait tablet (< 900 content width) keep the cart in a sheet; landscape tablets show the order full height on the right (380, 420 from 1100) behind a hairline. Floating ink nav below 600, ink rail above.
- Checkout has two steps: cart (customer, item cards with − qty + and subtotal on the right, total, "Lanjut ke pembayaran") then payment (ink total card with a green dot line, method cards with the selected one in ink, VA bank chips, cash card with "Uang pas" and rounded-note chips, input, green change or red shortfall). Bayar stays disabled while cash is short.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Row actions use a visible "Aksi" menu button. Exceptions taken from the kasir reference: the product + and the phone tab actions are icon buttons with tooltips and semantic labels ("Tambah Indomie Goreng"), and the product card itself is the large labelled target.
- Snackbars for short feedback (scan added, saved, synced). Dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab color, 150–250 ms ease-out).
- Icons: Iconsax for navigation and objects; plain Material glyphs (`add_rounded`, `remove_rounded`, `search_rounded`) for +, −, and search, because the Iconsax versions are boxed and read heavy inside buttons.

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. Backend error text is shown as-is in v1. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".
