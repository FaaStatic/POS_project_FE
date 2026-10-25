// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DebtPaymentState {

 bool get loading; Debt? get debt; bool get paying; DebtPaymentReceipt? get receipt; Failure? get failure;
/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtPaymentStateCopyWith<DebtPaymentState> get copyWith => _$DebtPaymentStateCopyWithImpl<DebtPaymentState>(this as DebtPaymentState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DebtPaymentState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtPaymentState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.debt, _this.debt) || other.debt == _this.debt)&&(identical(other.paying, _this.paying) || other.paying == _this.paying)&&(identical(other.receipt, _this.receipt) || other.receipt == _this.receipt)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as DebtPaymentState;
  return Object.hash(runtimeType,_this.loading,_this.debt,_this.paying,_this.receipt,_this.failure);
}

@override
String toString() {
  final _this = this as DebtPaymentState;
  return 'DebtPaymentState(loading: ${_this.loading}, debt: ${_this.debt}, paying: ${_this.paying}, receipt: ${_this.receipt}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $DebtPaymentStateCopyWith<$Res>  {
  factory $DebtPaymentStateCopyWith(DebtPaymentState value, $Res Function(DebtPaymentState) _then) = _$DebtPaymentStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Debt? debt, bool paying, DebtPaymentReceipt? receipt, Failure? failure
});


$DebtCopyWith<$Res>? get debt;$DebtPaymentReceiptCopyWith<$Res>? get receipt;

}
/// @nodoc
class _$DebtPaymentStateCopyWithImpl<$Res>
    implements $DebtPaymentStateCopyWith<$Res> {
  _$DebtPaymentStateCopyWithImpl(this._self, this._then);

  final DebtPaymentState _self;
  final $Res Function(DebtPaymentState) _then;

/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? debt = freezed,Object? paying = null,Object? receipt = freezed,Object? failure = freezed,}) {
  return _then(DebtPaymentState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,debt: freezed == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt?,paying: null == paying ? _self.paying : paying // ignore: cast_nullable_to_non_nullable
as bool,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as DebtPaymentReceipt?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res>? get debt {
    if (_self.debt == null) {
    return null;
  }

  return $DebtCopyWith<$Res>(_self.debt!, (value) {
    return _then(_self.copyWith(debt: value));
  });
}/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtPaymentReceiptCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $DebtPaymentReceiptCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [DebtPaymentState].
extension DebtPaymentStatePatterns on DebtPaymentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtPaymentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtPaymentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtPaymentState value)  $default,){
final _that = this;
switch (_that) {
case _DebtPaymentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtPaymentState value)?  $default,){
final _that = this;
switch (_that) {
case _DebtPaymentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Debt? debt,  bool paying,  DebtPaymentReceipt? receipt,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtPaymentState() when $default != null:
return $default(_that.loading,_that.debt,_that.paying,_that.receipt,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Debt? debt,  bool paying,  DebtPaymentReceipt? receipt,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DebtPaymentState():
return $default(_that.loading,_that.debt,_that.paying,_that.receipt,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Debt? debt,  bool paying,  DebtPaymentReceipt? receipt,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DebtPaymentState() when $default != null:
return $default(_that.loading,_that.debt,_that.paying,_that.receipt,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DebtPaymentState implements DebtPaymentState {
  const _DebtPaymentState({this.loading = true, this.debt, this.paying = false, this.receipt, this.failure});
  

@override@JsonKey() final  bool loading;
@override final  Debt? debt;
@override@JsonKey() final  bool paying;
@override final  DebtPaymentReceipt? receipt;
@override final  Failure? failure;

/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtPaymentStateCopyWith<_DebtPaymentState> get copyWith => __$DebtPaymentStateCopyWithImpl<_DebtPaymentState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtPaymentState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.paying, paying) || other.paying == paying)&&(identical(other.receipt, receipt) || other.receipt == receipt)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,debt,paying,receipt,failure);
}

@override
String toString() {
    return 'DebtPaymentState(loading: $loading, debt: $debt, paying: $paying, receipt: $receipt, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DebtPaymentStateCopyWith<$Res> implements $DebtPaymentStateCopyWith<$Res> {
  factory _$DebtPaymentStateCopyWith(_DebtPaymentState value, $Res Function(_DebtPaymentState) _then) = __$DebtPaymentStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Debt? debt, bool paying, DebtPaymentReceipt? receipt, Failure? failure
});


@override $DebtCopyWith<$Res>? get debt;@override $DebtPaymentReceiptCopyWith<$Res>? get receipt;

}
/// @nodoc
class __$DebtPaymentStateCopyWithImpl<$Res>
    implements _$DebtPaymentStateCopyWith<$Res> {
  __$DebtPaymentStateCopyWithImpl(this._self, this._then);

  final _DebtPaymentState _self;
  final $Res Function(_DebtPaymentState) _then;

/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? debt = freezed,Object? paying = null,Object? receipt = freezed,Object? failure = freezed,}) {
  return _then(_DebtPaymentState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,debt: freezed == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as Debt?,paying: null == paying ? _self.paying : paying // ignore: cast_nullable_to_non_nullable
as bool,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as DebtPaymentReceipt?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtCopyWith<$Res>? get debt {
    if (_self.debt == null) {
    return null;
  }

  return $DebtCopyWith<$Res>(_self.debt!, (value) {
    return _then(_self.copyWith(debt: value));
  });
}/// Create a copy of DebtPaymentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebtPaymentReceiptCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $DebtPaymentReceiptCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}

// dart format on
