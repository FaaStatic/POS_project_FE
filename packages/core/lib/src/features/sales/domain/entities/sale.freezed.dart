// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaleLine {

 String get productId; String get name; double get qty; int get unitPrice; String? get destination;
/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleLineCopyWith<SaleLine> get copyWith => _$SaleLineCopyWithImpl<SaleLine>(this as SaleLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SaleLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleLine&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.destination, _this.destination) || other.destination == _this.destination));
}


@override
int get hashCode {
  final _this = this as SaleLine;
  return Object.hash(runtimeType,_this.productId,_this.name,_this.qty,_this.unitPrice,_this.destination);
}

@override
String toString() {
  final _this = this as SaleLine;
  return 'SaleLine(productId: ${_this.productId}, name: ${_this.name}, qty: ${_this.qty}, unitPrice: ${_this.unitPrice}, destination: ${_this.destination})';
}


}

/// @nodoc
abstract mixin class $SaleLineCopyWith<$Res>  {
  factory $SaleLineCopyWith(SaleLine value, $Res Function(SaleLine) _then) = _$SaleLineCopyWithImpl;
@useResult
$Res call({
 String productId, String name, double qty, int unitPrice, String? destination
});




}
/// @nodoc
class _$SaleLineCopyWithImpl<$Res>
    implements $SaleLineCopyWith<$Res> {
  _$SaleLineCopyWithImpl(this._self, this._then);

  final SaleLine _self;
  final $Res Function(SaleLine) _then;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? qty = null,Object? unitPrice = null,Object? destination = freezed,}) {
  return _then(SaleLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleLine].
extension SaleLinePatterns on SaleLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleLine value)  $default,){
final _that = this;
switch (_that) {
case _SaleLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleLine value)?  $default,){
final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  double qty,  int unitPrice,  String? destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
return $default(_that.productId,_that.name,_that.qty,_that.unitPrice,_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  double qty,  int unitPrice,  String? destination)  $default,) {final _that = this;
switch (_that) {
case _SaleLine():
return $default(_that.productId,_that.name,_that.qty,_that.unitPrice,_that.destination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  double qty,  int unitPrice,  String? destination)?  $default,) {final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
return $default(_that.productId,_that.name,_that.qty,_that.unitPrice,_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class _SaleLine extends SaleLine {
  const _SaleLine({required this.productId, required this.name, required this.qty, required this.unitPrice, this.destination}): super._();
  

@override final  String productId;
@override final  String name;
@override final  double qty;
@override final  int unitPrice;
@override final  String? destination;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleLineCopyWith<_SaleLine> get copyWith => __$SaleLineCopyWithImpl<_SaleLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,name,qty,unitPrice,destination);
}

@override
String toString() {
    return 'SaleLine(productId: $productId, name: $name, qty: $qty, unitPrice: $unitPrice, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$SaleLineCopyWith<$Res> implements $SaleLineCopyWith<$Res> {
  factory _$SaleLineCopyWith(_SaleLine value, $Res Function(_SaleLine) _then) = __$SaleLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, double qty, int unitPrice, String? destination
});




}
/// @nodoc
class __$SaleLineCopyWithImpl<$Res>
    implements _$SaleLineCopyWith<$Res> {
  __$SaleLineCopyWithImpl(this._self, this._then);

  final _SaleLine _self;
  final $Res Function(_SaleLine) _then;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? qty = null,Object? unitPrice = null,Object? destination = freezed,}) {
  return _then(_SaleLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Sale {

 String get clientRef; String get receiptNumber; DateTime get createdAt; PaymentMethod get method; String? get customerId; String? get customerName; String get cashierName; int get total; List<SaleLine> get lines; SaleStatus get status; String? get error; String? get transactionId; bool get stockConflict; String? get cancelReason;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Sale;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.clientRef, _this.clientRef) || other.clientRef == _this.clientRef)&&(identical(other.receiptNumber, _this.receiptNumber) || other.receiptNumber == _this.receiptNumber)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.cashierName, _this.cashierName) || other.cashierName == _this.cashierName)&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.stockConflict, _this.stockConflict) || other.stockConflict == _this.stockConflict)&&(identical(other.cancelReason, _this.cancelReason) || other.cancelReason == _this.cancelReason));
}


@override
int get hashCode {
  final _this = this as Sale;
  return Object.hash(runtimeType,_this.clientRef,_this.receiptNumber,_this.createdAt,_this.method,_this.customerId,_this.customerName,_this.cashierName,_this.total,const DeepCollectionEquality().hash(_this.lines),_this.status,_this.error,_this.transactionId,_this.stockConflict,_this.cancelReason);
}

@override
String toString() {
  final _this = this as Sale;
  return 'Sale(clientRef: ${_this.clientRef}, receiptNumber: ${_this.receiptNumber}, createdAt: ${_this.createdAt}, method: ${_this.method}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, cashierName: ${_this.cashierName}, total: ${_this.total}, lines: ${_this.lines}, status: ${_this.status}, error: ${_this.error}, transactionId: ${_this.transactionId}, stockConflict: ${_this.stockConflict}, cancelReason: ${_this.cancelReason})';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String clientRef, String receiptNumber, DateTime createdAt, PaymentMethod method, String? customerId, String? customerName, String cashierName, int total, List<SaleLine> lines, SaleStatus status, String? error, String? transactionId, bool stockConflict, String? cancelReason
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientRef = null,Object? receiptNumber = null,Object? createdAt = null,Object? method = null,Object? customerId = freezed,Object? customerName = freezed,Object? cashierName = null,Object? total = null,Object? lines = null,Object? status = null,Object? error = freezed,Object? transactionId = freezed,Object? stockConflict = null,Object? cancelReason = freezed,}) {
  return _then(Sale(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SaleStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientRef,  String receiptNumber,  DateTime createdAt,  PaymentMethod method,  String? customerId,  String? customerName,  String cashierName,  int total,  List<SaleLine> lines,  SaleStatus status,  String? error,  String? transactionId,  bool stockConflict,  String? cancelReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.clientRef,_that.receiptNumber,_that.createdAt,_that.method,_that.customerId,_that.customerName,_that.cashierName,_that.total,_that.lines,_that.status,_that.error,_that.transactionId,_that.stockConflict,_that.cancelReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientRef,  String receiptNumber,  DateTime createdAt,  PaymentMethod method,  String? customerId,  String? customerName,  String cashierName,  int total,  List<SaleLine> lines,  SaleStatus status,  String? error,  String? transactionId,  bool stockConflict,  String? cancelReason)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.clientRef,_that.receiptNumber,_that.createdAt,_that.method,_that.customerId,_that.customerName,_that.cashierName,_that.total,_that.lines,_that.status,_that.error,_that.transactionId,_that.stockConflict,_that.cancelReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientRef,  String receiptNumber,  DateTime createdAt,  PaymentMethod method,  String? customerId,  String? customerName,  String cashierName,  int total,  List<SaleLine> lines,  SaleStatus status,  String? error,  String? transactionId,  bool stockConflict,  String? cancelReason)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.clientRef,_that.receiptNumber,_that.createdAt,_that.method,_that.customerId,_that.customerName,_that.cashierName,_that.total,_that.lines,_that.status,_that.error,_that.transactionId,_that.stockConflict,_that.cancelReason);case _:
  return null;

}
}

}

/// @nodoc


class _Sale extends Sale {
  const _Sale({required this.clientRef, required this.receiptNumber, required this.createdAt, required this.method, this.customerId, this.customerName, required this.cashierName, required this.total, required  List<SaleLine> lines, this.status = SaleStatus.pending, this.error, this.transactionId, this.stockConflict = false, this.cancelReason}): _lines = lines,super._();
  

@override final  String clientRef;
@override final  String receiptNumber;
@override final  DateTime createdAt;
@override final  PaymentMethod method;
@override final  String? customerId;
@override final  String? customerName;
@override final  String cashierName;
@override final  int total;
 final  List<SaleLine> _lines;
@override List<SaleLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  SaleStatus status;
@override final  String? error;
@override final  String? transactionId;
@override@JsonKey() final  bool stockConflict;
@override final  String? cancelReason;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.clientRef, clientRef) || other.clientRef == clientRef)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.stockConflict, stockConflict) || other.stockConflict == stockConflict)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,clientRef,receiptNumber,createdAt,method,customerId,customerName,cashierName,total,const DeepCollectionEquality().hash(_lines),status,error,transactionId,stockConflict,cancelReason);
}

@override
String toString() {
    return 'Sale(clientRef: $clientRef, receiptNumber: $receiptNumber, createdAt: $createdAt, method: $method, customerId: $customerId, customerName: $customerName, cashierName: $cashierName, total: $total, lines: $lines, status: $status, error: $error, transactionId: $transactionId, stockConflict: $stockConflict, cancelReason: $cancelReason)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String clientRef, String receiptNumber, DateTime createdAt, PaymentMethod method, String? customerId, String? customerName, String cashierName, int total, List<SaleLine> lines, SaleStatus status, String? error, String? transactionId, bool stockConflict, String? cancelReason
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientRef = null,Object? receiptNumber = null,Object? createdAt = null,Object? method = null,Object? customerId = freezed,Object? customerName = freezed,Object? cashierName = null,Object? total = null,Object? lines = null,Object? status = null,Object? error = freezed,Object? transactionId = freezed,Object? stockConflict = null,Object? cancelReason = freezed,}) {
  return _then(_Sale(
clientRef: null == clientRef ? _self.clientRef : clientRef // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SaleStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,stockConflict: null == stockConflict ? _self.stockConflict : stockConflict // ignore: cast_nullable_to_non_nullable
as bool,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
