// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assign_barcode_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssignBarcodeState {

 bool get saving; Product? get product; Failure? get failure;
/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignBarcodeStateCopyWith<AssignBarcodeState> get copyWith => _$AssignBarcodeStateCopyWithImpl<AssignBarcodeState>(this as AssignBarcodeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssignBarcodeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignBarcodeState&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as AssignBarcodeState;
  return Object.hash(runtimeType,_this.saving,_this.product,_this.failure);
}

@override
String toString() {
  final _this = this as AssignBarcodeState;
  return 'AssignBarcodeState(saving: ${_this.saving}, product: ${_this.product}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $AssignBarcodeStateCopyWith<$Res>  {
  factory $AssignBarcodeStateCopyWith(AssignBarcodeState value, $Res Function(AssignBarcodeState) _then) = _$AssignBarcodeStateCopyWithImpl;
@useResult
$Res call({
 bool saving, Product? product, Failure? failure
});


$ProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$AssignBarcodeStateCopyWithImpl<$Res>
    implements $AssignBarcodeStateCopyWith<$Res> {
  _$AssignBarcodeStateCopyWithImpl(this._self, this._then);

  final AssignBarcodeState _self;
  final $Res Function(AssignBarcodeState) _then;

/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saving = null,Object? product = freezed,Object? failure = freezed,}) {
  return _then(AssignBarcodeState(
saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssignBarcodeState].
extension AssignBarcodeStatePatterns on AssignBarcodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignBarcodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignBarcodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignBarcodeState value)  $default,){
final _that = this;
switch (_that) {
case _AssignBarcodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignBarcodeState value)?  $default,){
final _that = this;
switch (_that) {
case _AssignBarcodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool saving,  Product? product,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignBarcodeState() when $default != null:
return $default(_that.saving,_that.product,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool saving,  Product? product,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AssignBarcodeState():
return $default(_that.saving,_that.product,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool saving,  Product? product,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AssignBarcodeState() when $default != null:
return $default(_that.saving,_that.product,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AssignBarcodeState implements AssignBarcodeState {
  const _AssignBarcodeState({this.saving = false, this.product, this.failure});
  

@override@JsonKey() final  bool saving;
@override final  Product? product;
@override final  Failure? failure;

/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignBarcodeStateCopyWith<_AssignBarcodeState> get copyWith => __$AssignBarcodeStateCopyWithImpl<_AssignBarcodeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignBarcodeState&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.product, product) || other.product == product)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,saving,product,failure);
}

@override
String toString() {
    return 'AssignBarcodeState(saving: $saving, product: $product, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AssignBarcodeStateCopyWith<$Res> implements $AssignBarcodeStateCopyWith<$Res> {
  factory _$AssignBarcodeStateCopyWith(_AssignBarcodeState value, $Res Function(_AssignBarcodeState) _then) = __$AssignBarcodeStateCopyWithImpl;
@override @useResult
$Res call({
 bool saving, Product? product, Failure? failure
});


@override $ProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$AssignBarcodeStateCopyWithImpl<$Res>
    implements _$AssignBarcodeStateCopyWith<$Res> {
  __$AssignBarcodeStateCopyWithImpl(this._self, this._then);

  final _AssignBarcodeState _self;
  final $Res Function(_AssignBarcodeState) _then;

/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saving = null,Object? product = freezed,Object? failure = freezed,}) {
  return _then(_AssignBarcodeState(
saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of AssignBarcodeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
