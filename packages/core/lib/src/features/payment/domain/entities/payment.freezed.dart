// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Charge {

 String get orderId; ChargeMethod get method; PaymentState get state; int get grossAmount; String? get qrString; String? get qrUrl; String? get vaNumber; String? get bank; String? get billKey; String? get billerCode; DateTime? get expiresAt;
/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargeCopyWith<Charge> get copyWith => _$ChargeCopyWithImpl<Charge>(this as Charge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Charge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Charge&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.grossAmount, _this.grossAmount) || other.grossAmount == _this.grossAmount)&&(identical(other.qrString, _this.qrString) || other.qrString == _this.qrString)&&(identical(other.qrUrl, _this.qrUrl) || other.qrUrl == _this.qrUrl)&&(identical(other.vaNumber, _this.vaNumber) || other.vaNumber == _this.vaNumber)&&(identical(other.bank, _this.bank) || other.bank == _this.bank)&&(identical(other.billKey, _this.billKey) || other.billKey == _this.billKey)&&(identical(other.billerCode, _this.billerCode) || other.billerCode == _this.billerCode)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}


@override
int get hashCode {
  final _this = this as Charge;
  return Object.hash(runtimeType,_this.orderId,_this.method,_this.state,_this.grossAmount,_this.qrString,_this.qrUrl,_this.vaNumber,_this.bank,_this.billKey,_this.billerCode,_this.expiresAt);
}

@override
String toString() {
  final _this = this as Charge;
  return 'Charge(orderId: ${_this.orderId}, method: ${_this.method}, state: ${_this.state}, grossAmount: ${_this.grossAmount}, qrString: ${_this.qrString}, qrUrl: ${_this.qrUrl}, vaNumber: ${_this.vaNumber}, bank: ${_this.bank}, billKey: ${_this.billKey}, billerCode: ${_this.billerCode}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $ChargeCopyWith<$Res>  {
  factory $ChargeCopyWith(Charge value, $Res Function(Charge) _then) = _$ChargeCopyWithImpl;
@useResult
$Res call({
 String orderId, ChargeMethod method, PaymentState state, int grossAmount, String? qrString, String? qrUrl, String? vaNumber, String? bank, String? billKey, String? billerCode, DateTime? expiresAt
});




}
/// @nodoc
class _$ChargeCopyWithImpl<$Res>
    implements $ChargeCopyWith<$Res> {
  _$ChargeCopyWithImpl(this._self, this._then);

  final Charge _self;
  final $Res Function(Charge) _then;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? method = null,Object? state = null,Object? grossAmount = null,Object? qrString = freezed,Object? qrUrl = freezed,Object? vaNumber = freezed,Object? bank = freezed,Object? billKey = freezed,Object? billerCode = freezed,Object? expiresAt = freezed,}) {
  return _then(Charge(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ChargeMethod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,qrString: freezed == qrString ? _self.qrString : qrString // ignore: cast_nullable_to_non_nullable
as String?,qrUrl: freezed == qrUrl ? _self.qrUrl : qrUrl // ignore: cast_nullable_to_non_nullable
as String?,vaNumber: freezed == vaNumber ? _self.vaNumber : vaNumber // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,billKey: freezed == billKey ? _self.billKey : billKey // ignore: cast_nullable_to_non_nullable
as String?,billerCode: freezed == billerCode ? _self.billerCode : billerCode // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Charge].
extension ChargePatterns on Charge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Charge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Charge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Charge value)  $default,){
final _that = this;
switch (_that) {
case _Charge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Charge value)?  $default,){
final _that = this;
switch (_that) {
case _Charge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  String? qrString,  String? qrUrl,  String? vaNumber,  String? bank,  String? billKey,  String? billerCode,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Charge() when $default != null:
return $default(_that.orderId,_that.method,_that.state,_that.grossAmount,_that.qrString,_that.qrUrl,_that.vaNumber,_that.bank,_that.billKey,_that.billerCode,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  String? qrString,  String? qrUrl,  String? vaNumber,  String? bank,  String? billKey,  String? billerCode,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Charge():
return $default(_that.orderId,_that.method,_that.state,_that.grossAmount,_that.qrString,_that.qrUrl,_that.vaNumber,_that.bank,_that.billKey,_that.billerCode,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  String? qrString,  String? qrUrl,  String? vaNumber,  String? bank,  String? billKey,  String? billerCode,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Charge() when $default != null:
return $default(_that.orderId,_that.method,_that.state,_that.grossAmount,_that.qrString,_that.qrUrl,_that.vaNumber,_that.bank,_that.billKey,_that.billerCode,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _Charge implements Charge {
  const _Charge({required this.orderId, required this.method, required this.state, required this.grossAmount, this.qrString, this.qrUrl, this.vaNumber, this.bank, this.billKey, this.billerCode, this.expiresAt});
  

@override final  String orderId;
@override final  ChargeMethod method;
@override final  PaymentState state;
@override final  int grossAmount;
@override final  String? qrString;
@override final  String? qrUrl;
@override final  String? vaNumber;
@override final  String? bank;
@override final  String? billKey;
@override final  String? billerCode;
@override final  DateTime? expiresAt;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChargeCopyWith<_Charge> get copyWith => __$ChargeCopyWithImpl<_Charge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Charge&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.method, method) || other.method == method)&&(identical(other.state, state) || other.state == state)&&(identical(other.grossAmount, grossAmount) || other.grossAmount == grossAmount)&&(identical(other.qrString, qrString) || other.qrString == qrString)&&(identical(other.qrUrl, qrUrl) || other.qrUrl == qrUrl)&&(identical(other.vaNumber, vaNumber) || other.vaNumber == vaNumber)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.billKey, billKey) || other.billKey == billKey)&&(identical(other.billerCode, billerCode) || other.billerCode == billerCode)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,orderId,method,state,grossAmount,qrString,qrUrl,vaNumber,bank,billKey,billerCode,expiresAt);
}

@override
String toString() {
    return 'Charge(orderId: $orderId, method: $method, state: $state, grossAmount: $grossAmount, qrString: $qrString, qrUrl: $qrUrl, vaNumber: $vaNumber, bank: $bank, billKey: $billKey, billerCode: $billerCode, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ChargeCopyWith<$Res> implements $ChargeCopyWith<$Res> {
  factory _$ChargeCopyWith(_Charge value, $Res Function(_Charge) _then) = __$ChargeCopyWithImpl;
@override @useResult
$Res call({
 String orderId, ChargeMethod method, PaymentState state, int grossAmount, String? qrString, String? qrUrl, String? vaNumber, String? bank, String? billKey, String? billerCode, DateTime? expiresAt
});




}
/// @nodoc
class __$ChargeCopyWithImpl<$Res>
    implements _$ChargeCopyWith<$Res> {
  __$ChargeCopyWithImpl(this._self, this._then);

  final _Charge _self;
  final $Res Function(_Charge) _then;

/// Create a copy of Charge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? method = null,Object? state = null,Object? grossAmount = null,Object? qrString = freezed,Object? qrUrl = freezed,Object? vaNumber = freezed,Object? bank = freezed,Object? billKey = freezed,Object? billerCode = freezed,Object? expiresAt = freezed,}) {
  return _then(_Charge(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ChargeMethod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,qrString: freezed == qrString ? _self.qrString : qrString // ignore: cast_nullable_to_non_nullable
as String?,qrUrl: freezed == qrUrl ? _self.qrUrl : qrUrl // ignore: cast_nullable_to_non_nullable
as String?,vaNumber: freezed == vaNumber ? _self.vaNumber : vaNumber // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,billKey: freezed == billKey ? _self.billKey : billKey // ignore: cast_nullable_to_non_nullable
as String?,billerCode: freezed == billerCode ? _self.billerCode : billerCode // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ChargeStatus {

 String get orderId; PaymentState get state; int get grossAmount; String? get transactionId; DateTime? get paidAt;
/// Create a copy of ChargeStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargeStatusCopyWith<ChargeStatus> get copyWith => _$ChargeStatusCopyWithImpl<ChargeStatus>(this as ChargeStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChargeStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChargeStatus&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.grossAmount, _this.grossAmount) || other.grossAmount == _this.grossAmount)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt));
}


@override
int get hashCode {
  final _this = this as ChargeStatus;
  return Object.hash(runtimeType,_this.orderId,_this.state,_this.grossAmount,_this.transactionId,_this.paidAt);
}

@override
String toString() {
  final _this = this as ChargeStatus;
  return 'ChargeStatus(orderId: ${_this.orderId}, state: ${_this.state}, grossAmount: ${_this.grossAmount}, transactionId: ${_this.transactionId}, paidAt: ${_this.paidAt})';
}


}

/// @nodoc
abstract mixin class $ChargeStatusCopyWith<$Res>  {
  factory $ChargeStatusCopyWith(ChargeStatus value, $Res Function(ChargeStatus) _then) = _$ChargeStatusCopyWithImpl;
@useResult
$Res call({
 String orderId, PaymentState state, int grossAmount, String? transactionId, DateTime? paidAt
});




}
/// @nodoc
class _$ChargeStatusCopyWithImpl<$Res>
    implements $ChargeStatusCopyWith<$Res> {
  _$ChargeStatusCopyWithImpl(this._self, this._then);

  final ChargeStatus _self;
  final $Res Function(ChargeStatus) _then;

/// Create a copy of ChargeStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? state = null,Object? grossAmount = null,Object? transactionId = freezed,Object? paidAt = freezed,}) {
  return _then(ChargeStatus(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChargeStatus].
extension ChargeStatusPatterns on ChargeStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChargeStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChargeStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChargeStatus value)  $default,){
final _that = this;
switch (_that) {
case _ChargeStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChargeStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ChargeStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  PaymentState state,  int grossAmount,  String? transactionId,  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChargeStatus() when $default != null:
return $default(_that.orderId,_that.state,_that.grossAmount,_that.transactionId,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  PaymentState state,  int grossAmount,  String? transactionId,  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _ChargeStatus():
return $default(_that.orderId,_that.state,_that.grossAmount,_that.transactionId,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  PaymentState state,  int grossAmount,  String? transactionId,  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _ChargeStatus() when $default != null:
return $default(_that.orderId,_that.state,_that.grossAmount,_that.transactionId,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc


class _ChargeStatus implements ChargeStatus {
  const _ChargeStatus({required this.orderId, required this.state, required this.grossAmount, this.transactionId, this.paidAt});
  

@override final  String orderId;
@override final  PaymentState state;
@override final  int grossAmount;
@override final  String? transactionId;
@override final  DateTime? paidAt;

/// Create a copy of ChargeStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChargeStatusCopyWith<_ChargeStatus> get copyWith => __$ChargeStatusCopyWithImpl<_ChargeStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChargeStatus&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.state, state) || other.state == state)&&(identical(other.grossAmount, grossAmount) || other.grossAmount == grossAmount)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,orderId,state,grossAmount,transactionId,paidAt);
}

@override
String toString() {
    return 'ChargeStatus(orderId: $orderId, state: $state, grossAmount: $grossAmount, transactionId: $transactionId, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$ChargeStatusCopyWith<$Res> implements $ChargeStatusCopyWith<$Res> {
  factory _$ChargeStatusCopyWith(_ChargeStatus value, $Res Function(_ChargeStatus) _then) = __$ChargeStatusCopyWithImpl;
@override @useResult
$Res call({
 String orderId, PaymentState state, int grossAmount, String? transactionId, DateTime? paidAt
});




}
/// @nodoc
class __$ChargeStatusCopyWithImpl<$Res>
    implements _$ChargeStatusCopyWith<$Res> {
  __$ChargeStatusCopyWithImpl(this._self, this._then);

  final _ChargeStatus _self;
  final $Res Function(_ChargeStatus) _then;

/// Create a copy of ChargeStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? state = null,Object? grossAmount = null,Object? transactionId = freezed,Object? paidAt = freezed,}) {
  return _then(_ChargeStatus(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$PaymentRecord {

 String get id; String get orderId; ChargeMethod get method; PaymentState get state; int get grossAmount; int get feeAmount; String? get midtransStatus; String? get vaBank; String? get vaNumber; String? get transactionId; DateTime? get expiresAt; DateTime? get paidAt; DateTime? get createdAt;
/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRecordCopyWith<PaymentRecord> get copyWith => _$PaymentRecordCopyWithImpl<PaymentRecord>(this as PaymentRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.grossAmount, _this.grossAmount) || other.grossAmount == _this.grossAmount)&&(identical(other.feeAmount, _this.feeAmount) || other.feeAmount == _this.feeAmount)&&(identical(other.midtransStatus, _this.midtransStatus) || other.midtransStatus == _this.midtransStatus)&&(identical(other.vaBank, _this.vaBank) || other.vaBank == _this.vaBank)&&(identical(other.vaNumber, _this.vaNumber) || other.vaNumber == _this.vaNumber)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as PaymentRecord;
  return Object.hash(runtimeType,_this.id,_this.orderId,_this.method,_this.state,_this.grossAmount,_this.feeAmount,_this.midtransStatus,_this.vaBank,_this.vaNumber,_this.transactionId,_this.expiresAt,_this.paidAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as PaymentRecord;
  return 'PaymentRecord(id: ${_this.id}, orderId: ${_this.orderId}, method: ${_this.method}, state: ${_this.state}, grossAmount: ${_this.grossAmount}, feeAmount: ${_this.feeAmount}, midtransStatus: ${_this.midtransStatus}, vaBank: ${_this.vaBank}, vaNumber: ${_this.vaNumber}, transactionId: ${_this.transactionId}, expiresAt: ${_this.expiresAt}, paidAt: ${_this.paidAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PaymentRecordCopyWith<$Res>  {
  factory $PaymentRecordCopyWith(PaymentRecord value, $Res Function(PaymentRecord) _then) = _$PaymentRecordCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, ChargeMethod method, PaymentState state, int grossAmount, int feeAmount, String? midtransStatus, String? vaBank, String? vaNumber, String? transactionId, DateTime? expiresAt, DateTime? paidAt, DateTime? createdAt
});




}
/// @nodoc
class _$PaymentRecordCopyWithImpl<$Res>
    implements $PaymentRecordCopyWith<$Res> {
  _$PaymentRecordCopyWithImpl(this._self, this._then);

  final PaymentRecord _self;
  final $Res Function(PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? method = null,Object? state = null,Object? grossAmount = null,Object? feeAmount = null,Object? midtransStatus = freezed,Object? vaBank = freezed,Object? vaNumber = freezed,Object? transactionId = freezed,Object? expiresAt = freezed,Object? paidAt = freezed,Object? createdAt = freezed,}) {
  return _then(PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ChargeMethod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,feeAmount: null == feeAmount ? _self.feeAmount : feeAmount // ignore: cast_nullable_to_non_nullable
as int,midtransStatus: freezed == midtransStatus ? _self.midtransStatus : midtransStatus // ignore: cast_nullable_to_non_nullable
as String?,vaBank: freezed == vaBank ? _self.vaBank : vaBank // ignore: cast_nullable_to_non_nullable
as String?,vaNumber: freezed == vaNumber ? _self.vaNumber : vaNumber // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentRecord].
extension PaymentRecordPatterns on PaymentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRecord value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  int feeAmount,  String? midtransStatus,  String? vaBank,  String? vaNumber,  String? transactionId,  DateTime? expiresAt,  DateTime? paidAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.orderId,_that.method,_that.state,_that.grossAmount,_that.feeAmount,_that.midtransStatus,_that.vaBank,_that.vaNumber,_that.transactionId,_that.expiresAt,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  int feeAmount,  String? midtransStatus,  String? vaBank,  String? vaNumber,  String? transactionId,  DateTime? expiresAt,  DateTime? paidAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord():
return $default(_that.id,_that.orderId,_that.method,_that.state,_that.grossAmount,_that.feeAmount,_that.midtransStatus,_that.vaBank,_that.vaNumber,_that.transactionId,_that.expiresAt,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  ChargeMethod method,  PaymentState state,  int grossAmount,  int feeAmount,  String? midtransStatus,  String? vaBank,  String? vaNumber,  String? transactionId,  DateTime? expiresAt,  DateTime? paidAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.orderId,_that.method,_that.state,_that.grossAmount,_that.feeAmount,_that.midtransStatus,_that.vaBank,_that.vaNumber,_that.transactionId,_that.expiresAt,_that.paidAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentRecord implements PaymentRecord {
  const _PaymentRecord({required this.id, required this.orderId, required this.method, required this.state, required this.grossAmount, this.feeAmount = 0, this.midtransStatus, this.vaBank, this.vaNumber, this.transactionId, this.expiresAt, this.paidAt, this.createdAt});
  

@override final  String id;
@override final  String orderId;
@override final  ChargeMethod method;
@override final  PaymentState state;
@override final  int grossAmount;
@override@JsonKey() final  int feeAmount;
@override final  String? midtransStatus;
@override final  String? vaBank;
@override final  String? vaNumber;
@override final  String? transactionId;
@override final  DateTime? expiresAt;
@override final  DateTime? paidAt;
@override final  DateTime? createdAt;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRecordCopyWith<_PaymentRecord> get copyWith => __$PaymentRecordCopyWithImpl<_PaymentRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.method, method) || other.method == method)&&(identical(other.state, state) || other.state == state)&&(identical(other.grossAmount, grossAmount) || other.grossAmount == grossAmount)&&(identical(other.feeAmount, feeAmount) || other.feeAmount == feeAmount)&&(identical(other.midtransStatus, midtransStatus) || other.midtransStatus == midtransStatus)&&(identical(other.vaBank, vaBank) || other.vaBank == vaBank)&&(identical(other.vaNumber, vaNumber) || other.vaNumber == vaNumber)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,orderId,method,state,grossAmount,feeAmount,midtransStatus,vaBank,vaNumber,transactionId,expiresAt,paidAt,createdAt);
}

@override
String toString() {
    return 'PaymentRecord(id: $id, orderId: $orderId, method: $method, state: $state, grossAmount: $grossAmount, feeAmount: $feeAmount, midtransStatus: $midtransStatus, vaBank: $vaBank, vaNumber: $vaNumber, transactionId: $transactionId, expiresAt: $expiresAt, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentRecordCopyWith<$Res> implements $PaymentRecordCopyWith<$Res> {
  factory _$PaymentRecordCopyWith(_PaymentRecord value, $Res Function(_PaymentRecord) _then) = __$PaymentRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, ChargeMethod method, PaymentState state, int grossAmount, int feeAmount, String? midtransStatus, String? vaBank, String? vaNumber, String? transactionId, DateTime? expiresAt, DateTime? paidAt, DateTime? createdAt
});




}
/// @nodoc
class __$PaymentRecordCopyWithImpl<$Res>
    implements _$PaymentRecordCopyWith<$Res> {
  __$PaymentRecordCopyWithImpl(this._self, this._then);

  final _PaymentRecord _self;
  final $Res Function(_PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? method = null,Object? state = null,Object? grossAmount = null,Object? feeAmount = null,Object? midtransStatus = freezed,Object? vaBank = freezed,Object? vaNumber = freezed,Object? transactionId = freezed,Object? expiresAt = freezed,Object? paidAt = freezed,Object? createdAt = freezed,}) {
  return _then(_PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ChargeMethod,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PaymentState,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as int,feeAmount: null == feeAmount ? _self.feeAmount : feeAmount // ignore: cast_nullable_to_non_nullable
as int,midtransStatus: freezed == midtransStatus ? _self.midtransStatus : midtransStatus // ignore: cast_nullable_to_non_nullable
as String?,vaBank: freezed == vaBank ? _self.vaBank : vaBank // ignore: cast_nullable_to_non_nullable
as String?,vaNumber: freezed == vaNumber ? _self.vaNumber : vaNumber // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
