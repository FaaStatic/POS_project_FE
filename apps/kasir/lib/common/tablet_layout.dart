import 'dart:ui' show Size;

/// Two panes side by side (the checkout's order beside the catalog, a list beside its detail) on landscape
/// tablets and, from 720 wide, on portrait tablets. A phone turned sideways keeps the single column and the cart sheet.
bool splitPaneFits(Size window) =>
    window.width >= 900 || (window.width >= 720 && window.shortestSide >= 600);

/// Order panel width. The shell uses the same value to keep the nav pill under the catalog column.
double checkoutPanelWidth(double windowWidth) => windowWidth >= 1100
    ? 420
    : windowWidth >= 900
    ? 380
    : 320;
