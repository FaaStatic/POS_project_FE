import 'package:core/core.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

final class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted();
}

final class DraftsChanged extends CheckoutEvent {
  const DraftsChanged(this.drafts);
  final List<Draft> drafts;
}

final class NetworkChanged extends CheckoutEvent {
  const NetworkChanged(this.online);
  final bool online;
}

final class TabSelected extends CheckoutEvent {
  const TabSelected(this.draftId);
  final int draftId;
}

final class NewTabRequested extends CheckoutEvent {
  const NewTabRequested();
}

final class TabClosed extends CheckoutEvent {
  const TabClosed(this.draftId);
  final int draftId;
}

final class ProductAdded extends CheckoutEvent {
  const ProductAdded(this.product);
  final Product product;
}

final class BarcodeSubmitted extends CheckoutEvent {
  const BarcodeSubmitted(this.code);
  final String code;
}

final class QtyChanged extends CheckoutEvent {
  const QtyChanged(this.itemId, this.qty);
  final int itemId;
  final double qty;
}

final class ItemRemoved extends CheckoutEvent {
  const ItemRemoved(this.itemId);
  final int itemId;
}

final class DestinationChanged extends CheckoutEvent {
  const DestinationChanged(this.itemId, this.destination);
  final int itemId;
  final String destination;
}

final class CustomerChanged extends CheckoutEvent {
  const CustomerChanged({this.id, this.name});
  final String? id;
  final String? name;
}

final class MethodChanged extends CheckoutEvent {
  const MethodChanged(this.method);
  final PaymentMethod method;
}

final class VaBankChanged extends CheckoutEvent {
  const VaBankChanged(this.bank);
  final VaBank bank;
}

final class PayRequested extends CheckoutEvent {
  const PayRequested({this.bank = VaBank.bca});
  final VaBank bank;
}

/// Timer tick, FCM payment push, or the "Cek sekarang" button.
final class ChargesPolled extends CheckoutEvent {
  const ChargesPolled({this.orderId});
  final String? orderId;
}
