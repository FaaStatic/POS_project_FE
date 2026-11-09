# Design

Mode: Operate. Both apps are task tools: reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src` (`tokens/colors.dart`, `tokens/spacing.dart`, `tokens/typography.dart`, `theme/app_theme.dart`).

References (owner decision 2026-10-28):

- CMS: "CMS Dashboard Design" by Faysol Ahmed Sozib, <https://dribbble.com/shots/16763871-CMS-Dashboard-Design>
- Kasir: "Mobile App Design for POS (Cashier Management for Small Store)" by Vinz, <https://dribbble.com/shots/27265995-Mobile-App-Design-for-POS-Cashier-Management-for-Small-Store>

Both are credited in the UI (`DesignCredit`): the CMS page footer and login, and the bottom of the kasir "Lainnya" page. Layout and component shapes follow the references; colors are our own (white cards on a warm grey canvas, blue brand), and every feature and flow stays as it was. Component rules follow shadcn/ui (radii, border plus a small shadow on cards, dialogs).

## Color

White and blue on a warm canvas. Azure carries the brand on actions and selection; status hues keep their own meaning. Text pairs are 4.5:1 or better, input borders 3:1 (WCAG formula, checked in widget tests). Dynamic Color is not used.

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | `#0A66C2` (Azure 700), white text (5.7:1) | `#71B7FB` (Azure 400), `#0A2037` text (7.7:1) | Main action per screen, + buttons, active transaction tab, selected payment method, focus ring, chart series 1 |
| Brand panel | `#004182` (Azure 800), white text (10.1:1), `#E8F3FF` secondary text (9.0:1) | `#053059` (Azure 900), white, `#AAD6FF` (8.8:1) | One solid blue block per screen: kasir floating nav, payment total card, CMS login aside, logo tile |
| Selected nav | `#E8F3FF` (Azure 100) fill, `#004182` text (9.0:1) | `#053059` fill, `#AAD6FF` text | Active sidebar item (plus a 3px primary bar on its left edge), segmented tabs, selected rows in lists |
| Canvas | `#F4F2EE` | `#0B1118` | Page background behind cards |
| Surface | `#FFFFFF` | `#121A24` | Cards, sidebar, top bar, sheets, inputs |
| Subtle | `#ECE9E4` | `#1B2532` | Secondary buttons, zebra rows, stat tiles |
| Text | `#1A1A1A` | `#E9EEF4` | Body and headings |
| Muted text | `#666666` (5.7:1 on white) | `#9DAABA` | Labels, hints, captions |
| Hairline | `#E2E0DC` | `#2A3644` | Card borders, dividers, table rules |
| Input border | `#858585` | `#6E7E90` | 3:1 against the surface (WCAG 1.4.11) |
| Success | `#01754F`, badge fill `#E1F3EA` | `#4FD1A1` on `#0B3A2A` | Paid, synced, settled debt, successful transaction |
| Warning | `#915907`, badge fill `#FDF0DE` | `#F9C982` on `#402B0C` | Stock conflict, not synced, offline, unpaid debt |
| Danger | `#CB112D`, badge fill `#FDE8EB` | `#F58A9B` on `#45101A` | Errors, cancelled transaction, shortfall, destructive |

Light neutrals are warm, dark neutrals carry a slight blue tint, so grey sits with the blue instead of against it. Status always ships with a text label (`StatusBadge` is a pill of tinted fill and deeper text of the same hue), never color alone. Transaction status in the CMS: "Sukses" green, "Batal" red, with "Konflik stok" in amber beside it when it applies. Debt status: "Lunas" green, "Belum lunas" amber.

Product tiles (kasir) pick one of five pastel pairs by category id, so a shelf reads in groups: blue, amber, green, rose, olive (`BrandColors.tilesLight/tilesDark`, each 6.7:1 or better). The product name carries the meaning; color only helps scanning.

Chart series (`ChartColors`): light `#0A66C2` + `#C37D16`, dark `#71B7FB` + `#F9C982`. The second series is dashed, there is a legend, and a table view.

## Type

Inter, bundled in `packages/ui/fonts` (works offline). Two scales, chosen by density:

|  | CMS (compact) | Kasir (touch) |
|---|---|---|
| Body | 14 (large body 15) | 16 |
| Small / caption | 13 | 14 |
| Button label | 14 / 600 | 16 / 600 |
| Page title | 18 | 20 |
| Headline | 24 / 20 | 28 / 24 |
| Display (totals) | 30 | 36 |

Prices and quantities use tabular figures (`.tabular`). Receipts render in monospace because their columns must match the printer. On the kasir preview the store name is 28, the address 8, the number/date/cashier/customer rows 12, items and totals 15, the footer 12 (`ReceiptView`); the printed slip is plain text and ignores these sizes. On tablets (720 wide and up) the preview scales up to fill its paper, keeping its proportions.

## Shape, size, and space

Two densities from one palette (`AppTheme.compact` for the CMS, `AppTheme.touch` for the kasir; widgets read `AppSizes.of(context)`):

|  | CMS | Kasir |
|---|---|---|
| Button and input height | 40 | 48 |
| Primary action height | 44 | 56 |
| Control radius | 8 | 8 |
| Card and dialog radius | 12 | 12 |
| Card padding | 24 | 16 |
| Card edge | 1px hairline + small shadow | 1px hairline + small shadow |
| Table row | 48 | 56 |

Only the touch targets differ between the apps; radii follow shadcn (8 for controls, 12 for cards and dialogs). Spacing steps 4/8/12/16/24/32/48. Pills (full radius) for status badges, category chips, quick-cash chips; the kasir nav is a rounded panel (24).

Elevation: cards carry the shadcn `sm` shadow (black at 10%) with a hairline border; the floating kasir nav carries `md`; dialogs and menus carry their own. List rows in the kasir product list are flat (border only, pressed color) so scrolling stays cheap. No gradients, no glow, no glass.

## Components

shadcn for Flutter (`shadcn_ui` 0.57.3), wrapped in `packages/ui` so both apps share one API:

- `AppButton` (ShadButton): primary, secondary, outline, ghost, destructive, destructiveGhost. Grows with large text instead of clipping.
- `IconAction` (ShadIconButton ghost + tooltip): a row action drawn as an icon alone, sized to the density. Used for table row actions (CMS debts: add debt, receive payment; customer detail: add debt, download receipt).
- `AppTextField` (ShadInputFormField), `SearchField` (ShadInput), `AppSelect` (ShadSelect), `AppAutocomplete` and `AppSearchSelect` (text field with a dropdown; the second fills its list from a search callback and reports the picked value), `AppTabs` (ShadTabs as a segmented filter), `DateRangeField` (ShadDatePicker popover), `SurfaceCard` (ShadCard), `StatusBadge` (ShadBadge), dialogs (`showShadDialog`; alert and primary dialogs share the card radius and shadow).
- `ResponsiveTable`: table above 600 wide (zebra rows, hairline header, "Aksi" column), cards below.
- `TransactionTabStrip`: "Transaksi N" and "Hutang N" tabs (the open tab carries a 48dp close button unless it waits on QRIS/VA or is the only empty sale tab; a tab with items asks first), "Pembeli baru" and "Bayar hutang" actions (labelled when wide, icon with tooltip when narrow), "Semua (N)" (a cart icon with the count when narrow), the list of open carts. The kasir Transaksi tab uses the calculator icon, so the cart icon only means carts.
- Material stays where shadcn has no equivalent: list tiles, category chips, the account and row menus, navigation bar. The qty stepper stays a Material icon button because it keeps a 48dp hit area around a 32dp square. Dropdown panels (`OptionsPanel`) share a tap-region group with their field so a press on an option does not count as a tap outside.
- Product images: base64 or URL through `storedImageFor`, decoded once and cached; network images are cached on disk on mobile (`cached_network_image`).

Icons: Iconsax linear (the `_copy` names in `iconsax_flutter`; the plain names are the bold set). Thin outline glyphs match both references.

## Touch and text size

Kasir tap targets ≥ 48dp, primary actions 56dp. CMS controls are 40 (pointer input; WCAG 2.5.8 asks for 24). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap or scroll instead of shrinking text; amounts sit under names rather than trailing them so long values cannot crowd a name out.

## Layout

- CMS shell: drawer < 600, white rail 600–1024, white sidebar > 1024 (248 wide). The sidebar shows the logo tile and name, Dashboard, then foldable sections in branch order: Penjualan (Transaksi, Pembayaran, Hutang), Katalog (Produk, Kategori), Pengguna (Customer, Staff, Device), Lainnya (Laporan, Pengaturan). The open page's section never folds. Top bar white with a hairline: page title, language toggle (ID/EN), account avatar menu (signed-in name, settings, sign-out). No global search. Page actions sit in a row under the bar; the design credit is a thin footer under every page.
- Dashboard: "Ringkasan" panel with a range button and four stat tiles, the chart panel beside "Perlu tindakan", then recent transactions beside top products. Trends come from real previous-period data.
- CMS lists: Hutang rows end in icon actions. Transaksi has a Status column (success or cancelled, plus stock conflict) and a status filter that defaults to all. Customer detail is three blocks with the same header rhythm (title, hairline, optional action): Hutang (remaining amount large, total and date, status), Pembayaran hutang (date and cashier or "CMS" on the left, paid and balance left on the right, receipt download), Transaksi. Laporan has one period picker above two reports: the monthly report and the debt payments recap (one table for all customers).
- Kasir shell: a floating blue pill nav at every width (Transaksi, Riwayat, Customer, Lainnya): full width on phones, 60% of the width between 360 and 560 on tablets, centered, with a border and the `md` shadow. There is no rail. On the Transaksi tab of a tablet (from 900 wide, or from 720 when the short side is at least 600, so a phone turned sideways keeps the sheet) the order panel (320, 380 from 900, 420 from 1100) runs the full height on the right and the pill floats under the catalog column only, sized the same way against that column's width. Panel and catalog are separated by a firmer edge than a card hairline plus a soft shadow to the left. Other tabs keep the centered pill, and it glides there in 200 ms when the tab changes. The pill hides while the keyboard is open. Produk and settings live under Lainnya.
- Kasir checkout (Vinz layout, our flow): header with store and cashier in small print; transaction tabs with the active one in blue; search, Scan, and category pills stay pinned while only the product list scrolls; product cards (pastel initial tile, name, stock line, price, blue +). Cart: item cards with − qty + and subtotal, total, "Lanjut ke pembayaran". Payment: blue total card, method cards (selected one solid blue with a check), VA bank chips, cash chips with "Uang pas", green change or red shortfall. Choosing Hutang prices the cart at the credit prices, the total card reads "Total hutang", and the button reads "Tambah hutang Rp X" instead of "Bayar Rp X". Bayar stays disabled while cash is short. Phones keep the cart in a sheet; tablets show it on the right (see the shell rule above).
- Kasir "Bayar hutang" tab: the product list is replaced by customers who owe (name, remaining, of total), search by name. The cart side shows the debt, the amount paid now (starts at the full debt, can be lowered), cash received, change, and what is left; cash only. The receipt has the slip title, paid now, total paid, still owed, and a LUNAS or BELUM LUNAS mark.
- Kasir history: two tabs, Penjualan and Pembayaran hutang. The receipt page puts the slip on the left and status and actions on the right from 720 wide.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Icon-only buttons (product +, row actions, phone tab actions, clear search) carry tooltips and semantic labels.
- Feedback: the kasir shows results in info dialogs, the CMS in short toasts. Confirm dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab color, section chevron, 150–250 ms ease-out). Pressed rows change color; there is no ripple on the product list.

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".

## Logo

Brief for the logo. The current mark is a placeholder: a white "S" on an Azure 800 rounded square (CMS sidebar 32px, radius 8).

**What the product is.** Point of sale for a small Indonesian shop (warung, toko kelontong): a cashier app that works offline on a phone or tablet, and a web back office for the owner. Users are shop owners and cashiers, not tech people.

**Character.** Calm, trustworthy, quick to read. Closer to a well-kept ledger than to a startup. Friendly without being cute.

**Color.**

| Use | Value |
| --- | --- |
| Mark fill | Azure 800 `#004182` |
| Mark on the fill | White `#FFFFFF` (10.1:1) |
| Lighter accent, if the mark needs a second tone | Azure 100 `#E8F3FF` (9.0:1 on Azure 800) |
| Mark on white backgrounds, one color | Azure 700 `#0A66C2` (5.7:1 on white) |
| Mark on dark backgrounds | Azure 400 `#71B7FB` on `#0B1118` (8.9:1), or the white-on-Azure-900 tile |
| Wordmark text | `#1A1A1A` on light, `#E9EEF4` on dark |

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
