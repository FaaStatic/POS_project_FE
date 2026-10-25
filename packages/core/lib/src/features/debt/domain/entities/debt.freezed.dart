// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Debt {

 String get id; String get customerId; String get customerName; int get total; int get remaining; bool get paid; DateTime? get date;
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCopyWith<Debt> get copyWith => _$DebtCopyWithImpl<Debt>(this as Debt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Debt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.date, _this.date) || other.date == _this.date));
}


@override
int get hashCode {
  final _this = this as Debt;
  return Object.hash(runtimeType,_this.id,_this.customerId,_this.customerName,_this.total,_this.remaining,_this.paid,_this.date);
}

@override
String toString() {
  final _this = this as Debt;
  return 'Debt(id: ${_this.id}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, total: ${_this.total}, remaining: ${_this.remaining}, paid: ${_this.paid}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $DebtCopyWith<$Res>  {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) _then) = _$DebtCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String customerName, int total, int remaining, bool paid, DateTime? date
});




}
/// @nodoc
class _$DebtCopyWithImpl<$Res>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._self, this._then);

  final Debt _self;
  final $Res Function(Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? customerName = null,Object? total = null,Object? remaining = null,Object? paid = null,Object? date = freezed,}) {
  return _then(Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Debt].
extension DebtPatterns on Debt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debt value)  $default,){
final _that = this;
switch (_that) {
case _Debt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debt value)?  $default,){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String customerName,  int total,  int remaining,  bool paid,  DateTime? date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.customerId,_that.customerName,_that.total,_that.remaining,_that.paid,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String customerName,  int total,  int remaining,  bool paid,  DateTime? date)  $default,) {final _that = this;
switch (_that) {
case _Debt():
return $default(_that.id,_that.customerId,_that.customerName,_that.total,_that.remaining,_that.paid,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String customerName,  int total,  int remaining,  bool paid,  DateTime? date)?  $default,) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.customerId,_that.customerName,_that.total,_that.remaining,_that.paid,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _Debt extends Debt {
  const _Debt({required this.id, required this.customerId, this.customerName = '', required this.total, required this.remaining, required this.paid, this.date}): super._();
  

@override final  String id;
@override final  String customerId;
@override@JsonKey() final  String customerName;
@override final  int total;
@override final  int remaining;
@override final  bool paid;
@override final  DateTime? date;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtCopyWith<_Debt> get copyWith => __$DebtCopyWithImpl<_Debt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.total, total) || other.total == total)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,customerId,customerName,total,remaining,paid,date);
}

@override
String toString() {
    return 'Debt(id: $id, customerId: $customerId, customerName: $customerName, total: $total, remaining: $remaining, paid: $paid, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DebtCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$DebtCopyWith(_Debt value, $Res Function(_Debt) _then) = __$DebtCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String customerName, int total, int remaining, bool paid, DateTime? date
});




}
/// @nodoc
class __$DebtCopyWithImpl<$Res>
    implements _$DebtCopyWith<$Res> {
  __$DebtCopyWithImpl(this._self, this._then);

  final _Debt _self;
  final $Res Function(_Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? customerName = null,Object? total = null,Object? remaining = null,Object? paid = null,Object? date = freezed,}) {
  return _then(_Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$DebtPaymentReceipt {

 String get debtId; String get customerName; int get amount; int get previousRemaining; int get remaining; bool get paid; DateTime? get paidAt;
/// Create a copy of DebtPaymentReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtPaymentReceiptCopyWith<DebtPaymentReceipt> get copyWith => _$DebtPaymentReceiptCopyWithImpl<DebtPaymentReceipt>(this as DebtPaymentReceipt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DebtPaymentReceipt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtPaymentReceipt&&(identical(other.debtId, _this.debtId) || other.debtId == _this.debtId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.previousRemaining, _this.previousRemaining) || other.previousRemaining == _this.previousRemaining)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt));
}


@override
int get hashCode {
  final _this = this as DebtPaymentReceipt;
  return Object.hash(runtimeType,_this.debtId,_this.customerName,_this.amount,_this.previousRemaining,_this.remaining,_this.paid,_this.paidAt);
}

@override
String toString() {
  final _this = this as DebtPaymentReceipt;
  return 'DebtPaymentReceipt(debtId: ${_this.debtId}, customerName: ${_this.customerName}, amount: ${_this.amount}, previousRemaining: ${_this.previousRemaining}, remaining: ${_this.remaining}, paid: ${_this.paid}, paidAt: ${_this.paidAt})';
}


}

/// @nodoc
abstract mixin class $DebtPaymentReceiptCopyWith<$Res>  {
  factory $DebtPaymentReceiptCopyWith(DebtPaymentReceipt value, $Res Function(DebtPaymentReceipt) _then) = _$DebtPaymentReceiptCopyWithImpl;
@useResult
$Res call({
 String debtId, String customerName, int amount, int previousRemaining, int remaining, bool paid, DateTime? paidAt
});




}
/// @nodoc
class _$DebtPaymentReceiptCopyWithImpl<$Res>
    implements $DebtPaymentReceiptCopyWith<$Res> {
  _$DebtPaymentReceiptCopyWithImpl(this._self, this._then);

  final DebtPaymentReceipt _self;
  final $Res Function(DebtPaymentReceipt) _then;

/// Create a copy of DebtPaymentReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debtId = null,Object? customerName = null,Object? amount = null,Object? previousRemaining = null,Object? remaining = null,Object? paid = null,Object? paidAt = freezed,}) {
  return _then(DebtPaymentReceipt(
debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,previousRemaining: null == previousRemaining ? _self.previousRemaining : previousRemaining // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtPaymentReceipt].
extension DebtPaymentReceiptPatterns on DebtPaymentReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtPaymentReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtPaymentReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtPaymentReceipt value)  $default,){
final _that = this;
switch (_that) {
case _DebtPaymentReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtPaymentReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _DebtPaymentReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String debtId,  String customerName,  int amount,  int previousRemaining,  int remaining,  bool paid,  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtPaymentReceipt() when $default != null:
return $default(_that.debtId,_that.customerName,_that.amount,_that.previousRemaining,_that.remaining,_that.paid,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String debtId,  String customerName,  int amount,  int previousRemaining,  int remaining,  bool paid,  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _DebtPaymentReceipt():
return $default(_that.debtId,_that.customerName,_that.amount,_that.previousRemaining,_that.remaining,_that.paid,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String debtId,  String customerName,  int amount,  int previousRemaining,  int remaining,  bool paid,  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _DebtPaymentReceipt() when $default != null:
return $default(_that.debtId,_that.customerName,_that.amount,_that.previousRemaining,_that.remaining,_that.paid,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc


class _DebtPaymentReceipt implements DebtPaymentReceipt {
  const _DebtPaymentReceipt({required this.debtId, required this.customerName, required this.amount, required this.previousRemaining, required this.remaining, required this.paid, this.paidAt});
  

@override final  String debtId;
@override final  String customerName;
@override final  int amount;
@override final  int previousRemaining;
@override final  int remaining;
@override final  bool paid;
@override final  DateTime? paidAt;

/// Create a copy of DebtPaymentReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtPaymentReceiptCopyWith<_DebtPaymentReceipt> get copyWith => __$DebtPaymentReceiptCopyWithImpl<_DebtPaymentReceipt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtPaymentReceipt&&(identical(other.debtId, debtId) || other.debtId == debtId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.previousRemaining, previousRemaining) || other.previousRemaining == previousRemaining)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,debtId,customerName,amount,previousRemaining,remaining,paid,paidAt);
}

@override
String toString() {
    return 'DebtPaymentReceipt(debtId: $debtId, customerName: $customerName, amount: $amount, previousRemaining: $previousRemaining, remaining: $remaining, paid: $paid, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$DebtPaymentReceiptCopyWith<$Res> implements $DebtPaymentReceiptCopyWith<$Res> {
  factory _$DebtPaymentReceiptCopyWith(_DebtPaymentReceipt value, $Res Function(_DebtPaymentReceipt) _then) = __$DebtPaymentReceiptCopyWithImpl;
@override @useResult
$Res call({
 String debtId, String customerName, int amount, int previousRemaining, int remaining, bool paid, DateTime? paidAt
});




}
/// @nodoc
class __$DebtPaymentReceiptCopyWithImpl<$Res>
    implements _$DebtPaymentReceiptCopyWith<$Res> {
  __$DebtPaymentReceiptCopyWithImpl(this._self, this._then);

  final _DebtPaymentReceipt _self;
  final $Res Function(_DebtPaymentReceipt) _then;

/// Create a copy of DebtPaymentReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debtId = null,Object? customerName = null,Object? amount = null,Object? previousRemaining = null,Object? remaining = null,Object? paid = null,Object? paidAt = freezed,}) {
  return _then(_DebtPaymentReceipt(
debtId: null == debtId ? _self.debtId : debtId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,previousRemaining: null == previousRemaining ? _self.previousRemaining : previousRemaining // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
