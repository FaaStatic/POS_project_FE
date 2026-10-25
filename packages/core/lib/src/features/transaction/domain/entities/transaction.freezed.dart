// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionItem {

 String get productId; String get name; int get price; double get qty; int get subtotal;
/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemCopyWith<TransactionItem> get copyWith => _$TransactionItemCopyWithImpl<TransactionItem>(this as TransactionItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItem&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal));
}


@override
int get hashCode {
  final _this = this as TransactionItem;
  return Object.hash(runtimeType,_this.productId,_this.name,_this.price,_this.qty,_this.subtotal);
}

@override
String toString() {
  final _this = this as TransactionItem;
  return 'TransactionItem(productId: ${_this.productId}, name: ${_this.name}, price: ${_this.price}, qty: ${_this.qty}, subtotal: ${_this.subtotal})';
}


}

/// @nodoc
abstract mixin class $TransactionItemCopyWith<$Res>  {
  factory $TransactionItemCopyWith(TransactionItem value, $Res Function(TransactionItem) _then) = _$TransactionItemCopyWithImpl;
@useResult
$Res call({
 String productId, String name, int price, double qty, int subtotal
});




}
/// @nodoc
class _$TransactionItemCopyWithImpl<$Res>
    implements $TransactionItemCopyWith<$Res> {
  _$TransactionItemCopyWithImpl(this._self, this._then);

  final TransactionItem _self;
  final $Res Function(TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? price = null,Object? qty = null,Object? subtotal = null,}) {
  return _then(TransactionItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItem].
extension TransactionItemPatterns on TransactionItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItem value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  int price,  double qty,  int subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.productId,_that.name,_that.price,_that.qty,_that.subtotal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  int price,  double qty,  int subtotal)  $default,) {final _that = this;
switch (_that) {
case _TransactionItem():
return $default(_that.productId,_that.name,_that.price,_that.qty,_that.subtotal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  int price,  double qty,  int subtotal)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.productId,_that.name,_that.price,_that.qty,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionItem implements TransactionItem {
  const _TransactionItem({required this.productId, required this.name, required this.price, required this.qty, required this.subtotal});
  

@override final  String productId;
@override final  String name;
@override final  int price;
@override final  double qty;
@override final  int subtotal;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemCopyWith<_TransactionItem> get copyWith => __$TransactionItemCopyWithImpl<_TransactionItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,name,price,qty,subtotal);
}

@override
String toString() {
    return 'TransactionItem(productId: $productId, name: $name, price: $price, qty: $qty, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemCopyWith<$Res> implements $TransactionItemCopyWith<$Res> {
  factory _$TransactionItemCopyWith(_TransactionItem value, $Res Function(_TransactionItem) _then) = __$TransactionItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, int price, double qty, int subtotal
});




}
/// @nodoc
class __$TransactionItemCopyWithImpl<$Res>
    implements _$TransactionItemCopyWith<$Res> {
  __$TransactionItemCopyWithImpl(this._self, this._then);

  final _TransactionItem _self;
  final $Res Function(_TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? price = null,Object? qty = null,Object? subtotal = null,}) {
  return _then(_TransactionItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Transaction {

 String get id; String get invoice; PaymentMethod get method; int get total; int get profit; bool get stockConflict; bool get conflictReviewed; DateTime? get createdAt; List<TransactionItem> get items;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Transaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.invoice, _this.invoice) || other.invoice == _this.invoice)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.profit, _this.profit) || other.profit == _this.profit)&&(identical(other.stockConflict, _this.stockConflict) || other.stockConflict == _this.stockConflict)&&(identical(other.conflictReviewed, _this.conflictReviewed) || other.conflictReviewed == _this.conflictReviewed)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Transaction;
  return Object.hash(runtimeType,_this.id,_this.invoice,_this.method,_this.total,_this.profit,_this.stockConflict,_this.conflictReviewed,_this.createdAt,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Transaction;
  return 'Transaction(id: ${_this.id}, invoice: ${_this.invoice}, method: ${_this.method}, total: ${_this.total}, profit: ${_this.profit}, stockConflict: ${_this.stockConflict}, conflictReviewed: ${_this.conflictReviewed}, createdAt: ${_this.createdAt}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, String invoice, PaymentMethod method, int total, int profit, bool stockConflict, bool conflictReviewed, DateTime? createdAt, List<TransactionItem> items
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoice = null,Object? method = null,Object? total = null,Object? profit = null,Object? stockConflict = null,Object? conflictReviewed = null,Object? createdAt = freezed,Object? items = null,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as int,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,conflictReviewed: null == conflictReviewed ? _self.conflictReviewed : conflictReviewed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String invoice,  PaymentMethod method,  int total,  int profit,  bool stockConflict,  bool conflictReviewed,  DateTime? createdAt,  List<TransactionItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.invoice,_that.method,_that.total,_that.profit,_that.stockConflict,_that.conflictReviewed,_that.createdAt,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String invoice,  PaymentMethod method,  int total,  int profit,  bool stockConflict,  bool conflictReviewed,  DateTime? createdAt,  List<TransactionItem> items)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.invoice,_that.method,_that.total,_that.profit,_that.stockConflict,_that.conflictReviewed,_that.createdAt,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String invoice,  PaymentMethod method,  int total,  int profit,  bool stockConflict,  bool conflictReviewed,  DateTime? createdAt,  List<TransactionItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.invoice,_that.method,_that.total,_that.profit,_that.stockConflict,_that.conflictReviewed,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.invoice, required this.method, required this.total, this.profit = 0, this.stockConflict = false, this.conflictReviewed = false, this.createdAt,  List<TransactionItem> items = const []}): _items = items;
  

@override final  String id;
@override final  String invoice;
@override final  PaymentMethod method;
@override final  int total;
@override@JsonKey() final  int profit;
@override@JsonKey() final  bool stockConflict;
@override@JsonKey() final  bool conflictReviewed;
@override final  DateTime? createdAt;
 final  List<TransactionItem> _items;
@override@JsonKey() List<TransactionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.invoice, invoice) || other.invoice == invoice)&&(identical(other.method, method) || other.method == method)&&(identical(other.total, total) || other.total == total)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.stockConflict, stockConflict) || other.stockConflict == stockConflict)&&(identical(other.conflictReviewed, conflictReviewed) || other.conflictReviewed == conflictReviewed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,invoice,method,total,profit,stockConflict,conflictReviewed,createdAt,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Transaction(id: $id, invoice: $invoice, method: $method, total: $total, profit: $profit, stockConflict: $stockConflict, conflictReviewed: $conflictReviewed, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String invoice, PaymentMethod method, int total, int profit, bool stockConflict, bool conflictReviewed, DateTime? createdAt, List<TransactionItem> items
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoice = null,Object? method = null,Object? total = null,Object? profit = null,Object? stockConflict = null,Object? conflictReviewed = null,Object? createdAt = freezed,Object? items = null,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as int,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,conflictReviewed: null == conflictReviewed ? _self.conflictReviewed : conflictReviewed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}


}

/// @nodoc
mixin _$CheckoutLine {

 String get productId; double get qty;/// Server-priced online; the snapshot is only sent for offline sync.
 int get unitPrice; String? get destination;
/// Create a copy of CheckoutLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutLineCopyWith<CheckoutLine> get copyWith => _$CheckoutLineCopyWithImpl<CheckoutLine>(this as CheckoutLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckoutLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutLine&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.destination, _this.destination) || other.destination == _this.destination));
}


@override
int get hashCode {
  final _this = this as CheckoutLine;
  return Object.hash(runtimeType,_this.productId,_this.qty,_this.unitPrice,_this.destination);
}

@override
String toString() {
  final _this = this as CheckoutLine;
  return 'CheckoutLine(productId: ${_this.productId}, qty: ${_this.qty}, unitPrice: ${_this.unitPrice}, destination: ${_this.destination})';
}


}

/// @nodoc
abstract mixin class $CheckoutLineCopyWith<$Res>  {
  factory $CheckoutLineCopyWith(CheckoutLine value, $Res Function(CheckoutLine) _then) = _$CheckoutLineCopyWithImpl;
@useResult
$Res call({
 String productId, double qty, int unitPrice, String? destination
});




}
/// @nodoc
class _$CheckoutLineCopyWithImpl<$Res>
    implements $CheckoutLineCopyWith<$Res> {
  _$CheckoutLineCopyWithImpl(this._self, this._then);

  final CheckoutLine _self;
  final $Res Function(CheckoutLine) _then;

/// Create a copy of CheckoutLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? qty = null,Object? unitPrice = null,Object? destination = freezed,}) {
  return _then(CheckoutLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutLine].
extension CheckoutLinePatterns on CheckoutLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutLine value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutLine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutLine value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  double qty,  int unitPrice,  String? destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutLine() when $default != null:
return $default(_that.productId,_that.qty,_that.unitPrice,_that.destination);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  double qty,  int unitPrice,  String? destination)  $default,) {final _that = this;
switch (_that) {
case _CheckoutLine():
return $default(_that.productId,_that.qty,_that.unitPrice,_that.destination);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  double qty,  int unitPrice,  String? destination)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutLine() when $default != null:
return $default(_that.productId,_that.qty,_that.unitPrice,_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutLine implements CheckoutLine {
  const _CheckoutLine({required this.productId, required this.qty, required this.unitPrice, this.destination});
  

@override final  String productId;
@override final  double qty;
/// Server-priced online; the snapshot is only sent for offline sync.
@override final  int unitPrice;
@override final  String? destination;

/// Create a copy of CheckoutLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutLineCopyWith<_CheckoutLine> get copyWith => __$CheckoutLineCopyWithImpl<_CheckoutLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,qty,unitPrice,destination);
}

@override
String toString() {
    return 'CheckoutLine(productId: $productId, qty: $qty, unitPrice: $unitPrice, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$CheckoutLineCopyWith<$Res> implements $CheckoutLineCopyWith<$Res> {
  factory _$CheckoutLineCopyWith(_CheckoutLine value, $Res Function(_CheckoutLine) _then) = __$CheckoutLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, double qty, int unitPrice, String? destination
});




}
/// @nodoc
class __$CheckoutLineCopyWithImpl<$Res>
    implements _$CheckoutLineCopyWith<$Res> {
  __$CheckoutLineCopyWithImpl(this._self, this._then);

  final _CheckoutLine _self;
  final $Res Function(_CheckoutLine) _then;

/// Create a copy of CheckoutLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? qty = null,Object? unitPrice = null,Object? destination = freezed,}) {
  return _then(_CheckoutLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CheckoutRequest {

 String get userId; PaymentMethod get method; String? get customerId; List<CheckoutLine> get lines;
/// Create a copy of CheckoutRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutRequestCopyWith<CheckoutRequest> get copyWith => _$CheckoutRequestCopyWithImpl<CheckoutRequest>(this as CheckoutRequest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckoutRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutRequest&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}


@override
int get hashCode {
  final _this = this as CheckoutRequest;
  return Object.hash(runtimeType,_this.userId,_this.method,_this.customerId,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as CheckoutRequest;
  return 'CheckoutRequest(userId: ${_this.userId}, method: ${_this.method}, customerId: ${_this.customerId}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $CheckoutRequestCopyWith<$Res>  {
  factory $CheckoutRequestCopyWith(CheckoutRequest value, $Res Function(CheckoutRequest) _then) = _$CheckoutRequestCopyWithImpl;
@useResult
$Res call({
 String userId, PaymentMethod method, String? customerId, List<CheckoutLine> lines
});




}
/// @nodoc
class _$CheckoutRequestCopyWithImpl<$Res>
    implements $CheckoutRequestCopyWith<$Res> {
  _$CheckoutRequestCopyWithImpl(this._self, this._then);

  final CheckoutRequest _self;
  final $Res Function(CheckoutRequest) _then;

/// Create a copy of CheckoutRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? method = null,Object? customerId = freezed,Object? lines = null,}) {
  return _then(CheckoutRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CheckoutLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutRequest].
extension CheckoutRequestPatterns on CheckoutRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutRequest value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutRequest() when $default != null:
return $default(_that.userId,_that.method,_that.customerId,_that.lines);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)  $default,) {final _that = this;
switch (_that) {
case _CheckoutRequest():
return $default(_that.userId,_that.method,_that.customerId,_that.lines);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutRequest() when $default != null:
return $default(_that.userId,_that.method,_that.customerId,_that.lines);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutRequest implements CheckoutRequest {
  const _CheckoutRequest({required this.userId, required this.method, this.customerId, required  List<CheckoutLine> lines}): _lines = lines;
  

@override final  String userId;
@override final  PaymentMethod method;
@override final  String? customerId;
 final  List<CheckoutLine> _lines;
@override List<CheckoutLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of CheckoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutRequestCopyWith<_CheckoutRequest> get copyWith => __$CheckoutRequestCopyWithImpl<_CheckoutRequest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.method, method) || other.method == method)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.lines, _lines));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,method,customerId,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'CheckoutRequest(userId: $userId, method: $method, customerId: $customerId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$CheckoutRequestCopyWith<$Res> implements $CheckoutRequestCopyWith<$Res> {
  factory _$CheckoutRequestCopyWith(_CheckoutRequest value, $Res Function(_CheckoutRequest) _then) = __$CheckoutRequestCopyWithImpl;
@override @useResult
$Res call({
 String userId, PaymentMethod method, String? customerId, List<CheckoutLine> lines
});




}
/// @nodoc
class __$CheckoutRequestCopyWithImpl<$Res>
    implements _$CheckoutRequestCopyWith<$Res> {
  __$CheckoutRequestCopyWithImpl(this._self, this._then);

  final _CheckoutRequest _self;
  final $Res Function(_CheckoutRequest) _then;

/// Create a copy of CheckoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? method = null,Object? customerId = freezed,Object? lines = null,}) {
  return _then(_CheckoutRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CheckoutLine>,
  ));
}


}

/// @nodoc
mixin _$CheckoutResult {

 String get transactionId; String get invoice; int get total; PaymentMethod get method; bool get stockConflict; int? get debtRemaining;
/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutResultCopyWith<CheckoutResult> get copyWith => _$CheckoutResultCopyWithImpl<CheckoutResult>(this as CheckoutResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckoutResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutResult&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.invoice, _this.invoice) || other.invoice == _this.invoice)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.stockConflict, _this.stockConflict) || other.stockConflict == _this.stockConflict)&&(identical(other.debtRemaining, _this.debtRemaining) || other.debtRemaining == _this.debtRemaining));
}


@override
int get hashCode {
  final _this = this as CheckoutResult;
  return Object.hash(runtimeType,_this.transactionId,_this.invoice,_this.total,_this.method,_this.stockConflict,_this.debtRemaining);
}

@override
String toString() {
  final _this = this as CheckoutResult;
  return 'CheckoutResult(transactionId: ${_this.transactionId}, invoice: ${_this.invoice}, total: ${_this.total}, method: ${_this.method}, stockConflict: ${_this.stockConflict}, debtRemaining: ${_this.debtRemaining})';
}


}

/// @nodoc
abstract mixin class $CheckoutResultCopyWith<$Res>  {
  factory $CheckoutResultCopyWith(CheckoutResult value, $Res Function(CheckoutResult) _then) = _$CheckoutResultCopyWithImpl;
@useResult
$Res call({
 String transactionId, String invoice, int total, PaymentMethod method, bool stockConflict, int? debtRemaining
});




}
/// @nodoc
class _$CheckoutResultCopyWithImpl<$Res>
    implements $CheckoutResultCopyWith<$Res> {
  _$CheckoutResultCopyWithImpl(this._self, this._then);

  final CheckoutResult _self;
  final $Res Function(CheckoutResult) _then;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? invoice = null,Object? total = null,Object? method = null,Object? stockConflict = null,Object? debtRemaining = freezed,}) {
  return _then(CheckoutResult(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,debtRemaining: freezed == debtRemaining ? _self.debtRemaining : debtRemaining // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutResult].
extension CheckoutResultPatterns on CheckoutResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutResult value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutResult value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transactionId,  String invoice,  int total,  PaymentMethod method,  bool stockConflict,  int? debtRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that.transactionId,_that.invoice,_that.total,_that.method,_that.stockConflict,_that.debtRemaining);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transactionId,  String invoice,  int total,  PaymentMethod method,  bool stockConflict,  int? debtRemaining)  $default,) {final _that = this;
switch (_that) {
case _CheckoutResult():
return $default(_that.transactionId,_that.invoice,_that.total,_that.method,_that.stockConflict,_that.debtRemaining);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transactionId,  String invoice,  int total,  PaymentMethod method,  bool stockConflict,  int? debtRemaining)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that.transactionId,_that.invoice,_that.total,_that.method,_that.stockConflict,_that.debtRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutResult implements CheckoutResult {
  const _CheckoutResult({required this.transactionId, required this.invoice, required this.total, required this.method, this.stockConflict = false, this.debtRemaining});
  

@override final  String transactionId;
@override final  String invoice;
@override final  int total;
@override final  PaymentMethod method;
@override@JsonKey() final  bool stockConflict;
@override final  int? debtRemaining;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutResultCopyWith<_CheckoutResult> get copyWith => __$CheckoutResultCopyWithImpl<_CheckoutResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutResult&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.invoice, invoice) || other.invoice == invoice)&&(identical(other.total, total) || other.total == total)&&(identical(other.method, method) || other.method == method)&&(identical(other.stockConflict, stockConflict) || other.stockConflict == stockConflict)&&(identical(other.debtRemaining, debtRemaining) || other.debtRemaining == debtRemaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transactionId,invoice,total,method,stockConflict,debtRemaining);
}

@override
String toString() {
    return 'CheckoutResult(transactionId: $transactionId, invoice: $invoice, total: $total, method: $method, stockConflict: $stockConflict, debtRemaining: $debtRemaining)';
}


}

/// @nodoc
abstract mixin class _$CheckoutResultCopyWith<$Res> implements $CheckoutResultCopyWith<$Res> {
  factory _$CheckoutResultCopyWith(_CheckoutResult value, $Res Function(_CheckoutResult) _then) = __$CheckoutResultCopyWithImpl;
@override @useResult
$Res call({
 String transactionId, String invoice, int total, PaymentMethod method, bool stockConflict, int? debtRemaining
});




}
/// @nodoc
class __$CheckoutResultCopyWithImpl<$Res>
    implements _$CheckoutResultCopyWith<$Res> {
  __$CheckoutResultCopyWithImpl(this._self, this._then);

  final _CheckoutResult _self;
  final $Res Function(_CheckoutResult) _then;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? invoice = null,Object? total = null,Object? method = null,Object? stockConflict = null,Object? debtRemaining = freezed,}) {
  return _then(_CheckoutResult(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,debtRemaining: freezed == debtRemaining ? _self.debtRemaining : debtRemaining // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$OfflineSale {

 String get clientRef; DateTime get createdAt; PaymentMethod get method; String? get customerId; List<CheckoutLine> get lines;
/// Create a copy of OfflineSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflineSaleCopyWith<OfflineSale> get copyWith => _$OfflineSaleCopyWithImpl<OfflineSale>(this as OfflineSale, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OfflineSale;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSale&&(identical(other.clientRef, _this.clientRef) || other.clientRef == _this.clientRef)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}


@override
int get hashCode {
  final _this = this as OfflineSale;
  return Object.hash(runtimeType,_this.clientRef,_this.createdAt,_this.method,_this.customerId,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as OfflineSale;
  return 'OfflineSale(clientRef: ${_this.clientRef}, createdAt: ${_this.createdAt}, method: ${_this.method}, customerId: ${_this.customerId}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $OfflineSaleCopyWith<$Res>  {
  factory $OfflineSaleCopyWith(OfflineSale value, $Res Function(OfflineSale) _then) = _$OfflineSaleCopyWithImpl;
@useResult
$Res call({
 String clientRef, DateTime createdAt, PaymentMethod method, String? customerId, List<CheckoutLine> lines
});




}
/// @nodoc
class _$OfflineSaleCopyWithImpl<$Res>
    implements $OfflineSaleCopyWith<$Res> {
  _$OfflineSaleCopyWithImpl(this._self, this._then);

  final OfflineSale _self;
  final $Res Function(OfflineSale) _then;

/// Create a copy of OfflineSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientRef = null,Object? createdAt = null,Object? method = null,Object? customerId = freezed,Object? lines = null,}) {
  return _then(OfflineSale(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CheckoutLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [OfflineSale].
extension OfflineSalePatterns on OfflineSale {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfflineSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfflineSale() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfflineSale value)  $default,){
final _that = this;
switch (_that) {
case _OfflineSale():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfflineSale value)?  $default,){
final _that = this;
switch (_that) {
case _OfflineSale() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientRef,  DateTime createdAt,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfflineSale() when $default != null:
return $default(_that.clientRef,_that.createdAt,_that.method,_that.customerId,_that.lines);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientRef,  DateTime createdAt,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)  $default,) {final _that = this;
switch (_that) {
case _OfflineSale():
return $default(_that.clientRef,_that.createdAt,_that.method,_that.customerId,_that.lines);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientRef,  DateTime createdAt,  PaymentMethod method,  String? customerId,  List<CheckoutLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _OfflineSale() when $default != null:
return $default(_that.clientRef,_that.createdAt,_that.method,_that.customerId,_that.lines);case _:
  return null;

}
}

}

/// @nodoc


class _OfflineSale implements OfflineSale {
  const _OfflineSale({required this.clientRef, required this.createdAt, required this.method, this.customerId, required  List<CheckoutLine> lines}): _lines = lines;
  

@override final  String clientRef;
@override final  DateTime createdAt;
@override final  PaymentMethod method;
@override final  String? customerId;
 final  List<CheckoutLine> _lines;
@override List<CheckoutLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of OfflineSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfflineSaleCopyWith<_OfflineSale> get copyWith => __$OfflineSaleCopyWithImpl<_OfflineSale>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfflineSale&&(identical(other.clientRef, clientRef) || other.clientRef == clientRef)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.lines, _lines));
}


@override
int get hashCode {
    return Object.hash(runtimeType,clientRef,createdAt,method,customerId,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'OfflineSale(clientRef: $clientRef, createdAt: $createdAt, method: $method, customerId: $customerId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$OfflineSaleCopyWith<$Res> implements $OfflineSaleCopyWith<$Res> {
  factory _$OfflineSaleCopyWith(_OfflineSale value, $Res Function(_OfflineSale) _then) = __$OfflineSaleCopyWithImpl;
@override @useResult
$Res call({
 String clientRef, DateTime createdAt, PaymentMethod method, String? customerId, List<CheckoutLine> lines
});




}
/// @nodoc
class __$OfflineSaleCopyWithImpl<$Res>
    implements _$OfflineSaleCopyWith<$Res> {
  __$OfflineSaleCopyWithImpl(this._self, this._then);

  final _OfflineSale _self;
  final $Res Function(_OfflineSale) _then;

/// Create a copy of OfflineSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientRef = null,Object? createdAt = null,Object? method = null,Object? customerId = freezed,Object? lines = null,}) {
  return _then(_OfflineSale(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CheckoutLine>,
  ));
}


}

/// @nodoc
mixin _$SyncResult {

 String get clientRef; SyncStatus get status; String? get transactionId; String? get invoice; bool get stockConflict; bool get retryable; String? get error;
/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResultCopyWith<SyncResult> get copyWith => _$SyncResultCopyWithImpl<SyncResult>(this as SyncResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResult&&(identical(other.clientRef, _this.clientRef) || other.clientRef == _this.clientRef)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.invoice, _this.invoice) || other.invoice == _this.invoice)&&(identical(other.stockConflict, _this.stockConflict) || other.stockConflict == _this.stockConflict)&&(identical(other.retryable, _this.retryable) || other.retryable == _this.retryable)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as SyncResult;
  return Object.hash(runtimeType,_this.clientRef,_this.status,_this.transactionId,_this.invoice,_this.stockConflict,_this.retryable,_this.error);
}

@override
String toString() {
  final _this = this as SyncResult;
  return 'SyncResult(clientRef: ${_this.clientRef}, status: ${_this.status}, transactionId: ${_this.transactionId}, invoice: ${_this.invoice}, stockConflict: ${_this.stockConflict}, retryable: ${_this.retryable}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SyncResultCopyWith<$Res>  {
  factory $SyncResultCopyWith(SyncResult value, $Res Function(SyncResult) _then) = _$SyncResultCopyWithImpl;
@useResult
$Res call({
 String clientRef, SyncStatus status, String? transactionId, String? invoice, bool stockConflict, bool retryable, String? error
});




}
/// @nodoc
class _$SyncResultCopyWithImpl<$Res>
    implements $SyncResultCopyWith<$Res> {
  _$SyncResultCopyWithImpl(this._self, this._then);

  final SyncResult _self;
  final $Res Function(SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientRef = null,Object? status = null,Object? transactionId = freezed,Object? invoice = freezed,Object? stockConflict = null,Object? retryable = null,Object? error = freezed,}) {
  return _then(SyncResult(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,invoice: freezed == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String?,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResult].
extension SyncResultPatterns on SyncResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResult value)  $default,){
final _that = this;
switch (_that) {
case _SyncResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResult value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientRef,  SyncStatus status,  String? transactionId,  String? invoice,  bool stockConflict,  bool retryable,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.clientRef,_that.status,_that.transactionId,_that.invoice,_that.stockConflict,_that.retryable,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientRef,  SyncStatus status,  String? transactionId,  String? invoice,  bool stockConflict,  bool retryable,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SyncResult():
return $default(_that.clientRef,_that.status,_that.transactionId,_that.invoice,_that.stockConflict,_that.retryable,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientRef,  SyncStatus status,  String? transactionId,  String? invoice,  bool stockConflict,  bool retryable,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.clientRef,_that.status,_that.transactionId,_that.invoice,_that.stockConflict,_that.retryable,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SyncResult extends SyncResult {
  const _SyncResult({required this.clientRef, required this.status, this.transactionId, this.invoice, this.stockConflict = false, this.retryable = false, this.error}): super._();
  

@override final  String clientRef;
@override final  SyncStatus status;
@override final  String? transactionId;
@override final  String? invoice;
@override@JsonKey() final  bool stockConflict;
@override@JsonKey() final  bool retryable;
@override final  String? error;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResultCopyWith<_SyncResult> get copyWith => __$SyncResultCopyWithImpl<_SyncResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResult&&(identical(other.clientRef, clientRef) || other.clientRef == clientRef)&&(identical(other.status, status) || other.status == status)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.invoice, invoice) || other.invoice == invoice)&&(identical(other.stockConflict, stockConflict) || other.stockConflict == stockConflict)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,clientRef,status,transactionId,invoice,stockConflict,retryable,error);
}

@override
String toString() {
    return 'SyncResult(clientRef: $clientRef, status: $status, transactionId: $transactionId, invoice: $invoice, stockConflict: $stockConflict, retryable: $retryable, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SyncResultCopyWith<$Res> implements $SyncResultCopyWith<$Res> {
  factory _$SyncResultCopyWith(_SyncResult value, $Res Function(_SyncResult) _then) = __$SyncResultCopyWithImpl;
@override @useResult
$Res call({
 String clientRef, SyncStatus status, String? transactionId, String? invoice, bool stockConflict, bool retryable, String? error
});




}
/// @nodoc
class __$SyncResultCopyWithImpl<$Res>
    implements _$SyncResultCopyWith<$Res> {
  __$SyncResultCopyWithImpl(this._self, this._then);

  final _SyncResult _self;
  final $Res Function(_SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientRef = null,Object? status = null,Object? transactionId = freezed,Object? invoice = freezed,Object? stockConflict = null,Object? retryable = null,Object? error = freezed,}) {
  return _then(_SyncResult(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,invoice: freezed == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as String?,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
