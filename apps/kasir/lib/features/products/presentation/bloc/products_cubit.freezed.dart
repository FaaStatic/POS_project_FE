// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEditState {

 bool get loading; Product? get product; bool get saving; bool get saved; Failure? get failure;
/// Create a copy of ProductEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEditStateCopyWith<ProductEditState> get copyWith => _$ProductEditStateCopyWithImpl<ProductEditState>(this as ProductEditState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductEditState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEditState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ProductEditState;
  return Object.hash(runtimeType,_this.loading,_this.product,_this.saving,_this.saved,_this.failure);
}

@override
String toString() {
  final _this = this as ProductEditState;
  return 'ProductEditState(loading: ${_this.loading}, product: ${_this.product}, saving: ${_this.saving}, saved: ${_this.saved}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ProductEditStateCopyWith<$Res>  {
  factory $ProductEditStateCopyWith(ProductEditState value, $Res Function(ProductEditState) _then) = _$ProductEditStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Product? product, bool saving, bool saved, Failure? failure
});


$ProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$ProductEditStateCopyWithImpl<$Res>
    implements $ProductEditStateCopyWith<$Res> {
  _$ProductEditStateCopyWithImpl(this._self, this._then);

  final ProductEditState _self;
  final $Res Function(ProductEditState) _then;

/// Create a copy of ProductEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? product = freezed,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(ProductEditState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ProductEditState
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


/// Adds pattern-matching-related methods to [ProductEditState].
extension ProductEditStatePatterns on ProductEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEditState value)  $default,){
final _that = this;
switch (_that) {
case _ProductEditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEditState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Product? product,  bool saving,  bool saved,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEditState() when $default != null:
return $default(_that.loading,_that.product,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Product? product,  bool saving,  bool saved,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ProductEditState():
return $default(_that.loading,_that.product,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Product? product,  bool saving,  bool saved,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ProductEditState() when $default != null:
return $default(_that.loading,_that.product,_that.saving,_that.saved,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ProductEditState implements ProductEditState {
  const _ProductEditState({this.loading = true, this.product, this.saving = false, this.saved = false, this.failure});
  

@override@JsonKey() final  bool loading;
@override final  Product? product;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override final  Failure? failure;

/// Create a copy of ProductEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEditStateCopyWith<_ProductEditState> get copyWith => __$ProductEditStateCopyWithImpl<_ProductEditState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEditState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.product, product) || other.product == product)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,product,saving,saved,failure);
}

@override
String toString() {
    return 'ProductEditState(loading: $loading, product: $product, saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ProductEditStateCopyWith<$Res> implements $ProductEditStateCopyWith<$Res> {
  factory _$ProductEditStateCopyWith(_ProductEditState value, $Res Function(_ProductEditState) _then) = __$ProductEditStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Product? product, bool saving, bool saved, Failure? failure
});


@override $ProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$ProductEditStateCopyWithImpl<$Res>
    implements _$ProductEditStateCopyWith<$Res> {
  __$ProductEditStateCopyWithImpl(this._self, this._then);

  final _ProductEditState _self;
  final $Res Function(_ProductEditState) _then;

/// Create a copy of ProductEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? product = freezed,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_ProductEditState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ProductEditState
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
