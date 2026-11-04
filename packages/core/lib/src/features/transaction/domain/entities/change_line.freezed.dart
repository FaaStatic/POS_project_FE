// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangeLine {

 ChangeKind get kind;/// Rupiah value of this line.
 int get amount; String? get productId; String get productName; double get qty;/// The product is sold in pieces, so [qty] must be whole.
 bool get wholeOnly;
/// Create a copy of ChangeLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeLineCopyWith<ChangeLine> get copyWith => _$ChangeLineCopyWithImpl<ChangeLine>(this as ChangeLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangeLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeLine&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.wholeOnly, _this.wholeOnly) || other.wholeOnly == _this.wholeOnly));
}


@override
int get hashCode {
  final _this = this as ChangeLine;
  return Object.hash(runtimeType,_this.kind,_this.amount,_this.productId,_this.productName,_this.qty,_this.wholeOnly);
}

@override
String toString() {
  final _this = this as ChangeLine;
  return 'ChangeLine(kind: ${_this.kind}, amount: ${_this.amount}, productId: ${_this.productId}, productName: ${_this.productName}, qty: ${_this.qty}, wholeOnly: ${_this.wholeOnly})';
}


}

/// @nodoc
abstract mixin class $ChangeLineCopyWith<$Res>  {
  factory $ChangeLineCopyWith(ChangeLine value, $Res Function(ChangeLine) _then) = _$ChangeLineCopyWithImpl;
@useResult
$Res call({
 ChangeKind kind, int amount, String? productId, String productName, double qty, bool wholeOnly
});




}
/// @nodoc
class _$ChangeLineCopyWithImpl<$Res>
    implements $ChangeLineCopyWith<$Res> {
  _$ChangeLineCopyWithImpl(this._self, this._then);

  final ChangeLine _self;
  final $Res Function(ChangeLine) _then;

/// Create a copy of ChangeLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? amount = null,Object? productId = freezed,Object? productName = null,Object? qty = null,Object? wholeOnly = null,}) {
  return _then(ChangeLine(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChangeKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,wholeOnly: null == wholeOnly ? _self.wholeOnly : wholeOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeLine].
extension ChangeLinePatterns on ChangeLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeLine value)  $default,){
final _that = this;
switch (_that) {
case _ChangeLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeLine value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChangeKind kind,  int amount,  String? productId,  String productName,  double qty,  bool wholeOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeLine() when $default != null:
return $default(_that.kind,_that.amount,_that.productId,_that.productName,_that.qty,_that.wholeOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChangeKind kind,  int amount,  String? productId,  String productName,  double qty,  bool wholeOnly)  $default,) {final _that = this;
switch (_that) {
case _ChangeLine():
return $default(_that.kind,_that.amount,_that.productId,_that.productName,_that.qty,_that.wholeOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChangeKind kind,  int amount,  String? productId,  String productName,  double qty,  bool wholeOnly)?  $default,) {final _that = this;
switch (_that) {
case _ChangeLine() when $default != null:
return $default(_that.kind,_that.amount,_that.productId,_that.productName,_that.qty,_that.wholeOnly);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeLine extends ChangeLine {
  const _ChangeLine({required this.kind, required this.amount, this.productId, this.productName = '', this.qty = 0, this.wholeOnly = true}): super._();
  

@override final  ChangeKind kind;
/// Rupiah value of this line.
@override final  int amount;
@override final  String? productId;
@override@JsonKey() final  String productName;
@override@JsonKey() final  double qty;
/// The product is sold in pieces, so [qty] must be whole.
@override@JsonKey() final  bool wholeOnly;

/// Create a copy of ChangeLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeLineCopyWith<_ChangeLine> get copyWith => __$ChangeLineCopyWithImpl<_ChangeLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.wholeOnly, wholeOnly) || other.wholeOnly == wholeOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,amount,productId,productName,qty,wholeOnly);
}

@override
String toString() {
    return 'ChangeLine(kind: $kind, amount: $amount, productId: $productId, productName: $productName, qty: $qty, wholeOnly: $wholeOnly)';
}


}

/// @nodoc
abstract mixin class _$ChangeLineCopyWith<$Res> implements $ChangeLineCopyWith<$Res> {
  factory _$ChangeLineCopyWith(_ChangeLine value, $Res Function(_ChangeLine) _then) = __$ChangeLineCopyWithImpl;
@override @useResult
$Res call({
 ChangeKind kind, int amount, String? productId, String productName, double qty, bool wholeOnly
});




}
/// @nodoc
class __$ChangeLineCopyWithImpl<$Res>
    implements _$ChangeLineCopyWith<$Res> {
  __$ChangeLineCopyWithImpl(this._self, this._then);

  final _ChangeLine _self;
  final $Res Function(_ChangeLine) _then;

/// Create a copy of ChangeLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? amount = null,Object? productId = freezed,Object? productName = null,Object? qty = null,Object? wholeOnly = null,}) {
  return _then(_ChangeLine(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChangeKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,wholeOnly: null == wholeOnly ? _self.wholeOnly : wholeOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
