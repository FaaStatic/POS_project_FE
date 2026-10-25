# Design

Mode: Operate. Both apps are task tools; reading numbers fast and consistency come before expression. Source of truth for values is `packages/ui/lib/src`.

## Color

| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | `#15803D` | `#22C55E` (on-primary `#052E16`) | Main action per screen (Bayar, Simpan), active tab, success |
| Surface | `#FFFFFF` | `#09090B` | Page background |
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

Radius: 6 (inputs, buttons, badges), 10 (cards, dialogs, sheets), full only for avatars. Spacing steps 4/8/12/16/24/32/48. Shadows only on dialogs, sheets, menus; everything else is flat with 1px borders.

## Touch and text size

Tap targets ≥ 48dp, primary actions 56dp (`AppButton(large: true)`). Every screen is tested at 200% text scale and in dark theme. Layouts that would squeeze at large text wrap (`Wrap`) or scroll with their content (slivers) instead of shrinking text.

## Layout

- CMS: drawer < 600, navigation rail 600–1024, sidebar > 1024 (`CmsShell`). Tables become cards below 600 and drop secondary columns below 1024 (`ResponsiveTable`). Forms open as full pages on phones and dialogs elsewhere (`showFormSurface`). Page actions sit in a wrapping row under the title.
- Kasir: navigation bar on narrow windows, rail on wide ones. Checkout is products + cart sheet on phones, side by side from 720. The Bayar button is pinned at the bottom of the cart, apart from the product list. The tab strip moves its actions to a second row below 520.
- Dashboard: needs action first, then revenue as the one large number with three smaller supporting figures, then the chart, then details. No equal-size stat cards and no up/down comparisons without a named period.

## Interaction

- Important actions are labelled buttons; nothing lives only behind long-press or swipe. Row actions use a visible "Aksi" menu button.
- Snackbars for short feedback (scan added, saved, synced). Dialogs only for decisions that stop the flow: close a tab with items, cancel a sale (reason required), permanent delete (type the name).
- Motion is limited to state changes (tab underline, 150–250 ms ease-out).

## Copy

Indonesian first, English second (ARB in each app and in `ui`). Errors say what failed and how to recover. Backend error text is shown as-is in v1. No invented numbers or store names; a missing store name prints "Nama toko belum diatur".
