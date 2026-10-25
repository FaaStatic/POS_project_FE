# Design

Mode: Operate. Both apps are task tools; reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src`.

## Color

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | `#15803D` | `#22C55E` (on-primary `#052E16`) | Main action per screen (Bayar, Simpan), active tab, success |
| Shell (forest) | `#0F3D2E`, raised `#16523E` | `#0C241B` | CMS sidebar/rail/drawer, kasir floating nav and tablet rail, active transaction tab, payment total card. White text 12:1 |
| Selected on forest | `#16523E` pill, white text | forest pill, white text | Selected item in the CMS sidebar and the kasir nav |
| Canvas | zinc 100 | zinc 950 | Page background behind cards (shadcn neutral) |
| Surface | `#FFFFFF` | zinc 900, raised zinc 800 | Cards, sheets, inputs |
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

Radius: 6 (inputs, badges), 10 (qty stepper buttons), 14 (cards, stat tiles), 20 (dashboard summary panel), full for chips, transaction tabs, add buttons, and people avatars. Spacing steps 4/8/12/16/24/32/48.

Elevation: shadcn style. White cards on the zinc canvas carry a 1px `outlineVariant` border plus shadow-sm (elevation 1, 8% black). Floating elements (kasir nav, cart bar) use elevation 6. Grouped content lives in one card; cards are never nested, except stat tiles, which are flat `surfaceContainerLow` blocks inside the summary panel. Lists of products, sales, and customers are cards with a gap instead of rows split by dividers.

Avatars: initials (letters only, so "Aqua 600ml" is AQ) on the brand mint, or the product image when its URL loads. One color for every item; color is not used to tell categories apart.

## Touch and text size

Tap targets ≥ 48dp, primary actions 56dp (`AppButton(large: true)`). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap (`Wrap`) or scroll with their content (slivers) instead of shrinking text.

## Layout

- CMS: drawer < 600, navigation rail 600–1024, sidebar > 1024 (`CmsShell`), all on forest. Tables sit in one white card and become cards below 600, dropping secondary columns below 1024 (`ResponsiveTable`). Forms open as full pages on phones and dialogs elsewhere (`showFormSurface`). Page actions sit in a row under the title; on phones the row scrolls sideways. Login is a forest panel beside the form on wide windows.
- Kasir (reference: Dribbble 27265995, POS cashier for a small store, restyled to shadcn): floating forest navigation bar on narrow windows, forest rail on wide ones. Header shows the store name, the cashier, and the title "Transaksi". Transaction tabs are pills (active forest, inactive white bordered); "Pembeli baru" and "Semua" sit at the right from 520, below the pills otherwise. Products are a list of cards on phones and a grid on tablets; a badge shows how many are already in the active tab. The cart is a white bar above the nav on phones (opens a sheet) and a side panel from 720. Checkout has two steps: cart (customer, items, total, "Lanjut ke pembayaran") then payment (forest total card, method cards, VA bank chips, cash received with "Uang pas" and rounded-note chips, change or shortfall). Bayar stays disabled while cash is short.
- CMS top bar: white with a bottom border, page title, language toggle (ID/EN), and an account avatar menu (name, Pengaturan, Keluar).
- Dashboard (reference: Dribbble 27017971, POS billing/inventory dashboard): one "Ringkasan" panel with a range menu and four equal-height stat tiles (mint icon tile, label, value, trend vs the previous period of the same length), then the chart card beside "Perlu tindakan", then recent transactions beside the detail cards. On phones "Perlu tindakan" comes first. Trends are computed from real previous-period data; receivables have no trend. No up/down comparison without a named period.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Row actions use a visible "Aksi" menu button.
- Snackbars for short feedback (scan added, saved, synced). Dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab underline, 150–250 ms ease-out).
- Icons: Iconsax for navigation and objects; plain Material glyphs (`add_rounded`, `remove_rounded`, `search_rounded`) for +, −, and search, because the Iconsax versions are boxed and read heavy inside buttons.

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. Backend error text is shown as-is in v1. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".
