// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptSettings {

 String get storeName; String get storeAddress; String get footer; PaperWidth get paper; bool get autoPrint; String? get printerAddress; String? get printerName;
/// Create a copy of ReceiptSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptSettingsCopyWith<ReceiptSettings> get copyWith => _$ReceiptSettingsCopyWithImpl<ReceiptSettings>(this as ReceiptSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptSettings&&(identical(other.storeName, _this.storeName) || other.storeName == _this.storeName)&&(identical(other.storeAddress, _this.storeAddress) || other.storeAddress == _this.storeAddress)&&(identical(other.footer, _this.footer) || other.footer == _this.footer)&&(identical(other.paper, _this.paper) || other.paper == _this.paper)&&(identical(other.autoPrint, _this.autoPrint) || other.autoPrint == _this.autoPrint)&&(identical(other.printerAddress, _this.printerAddress) || other.printerAddress == _this.printerAddress)&&(identical(other.printerName, _this.printerName) || other.printerName == _this.printerName));
}


@override
int get hashCode {
  final _this = this as ReceiptSettings;
  return Object.hash(runtimeType,_this.storeName,_this.storeAddress,_this.footer,_this.paper,_this.autoPrint,_this.printerAddress,_this.printerName);
}

@override
String toString() {
  final _this = this as ReceiptSettings;
  return 'ReceiptSettings(storeName: ${_this.storeName}, storeAddress: ${_this.storeAddress}, footer: ${_this.footer}, paper: ${_this.paper}, autoPrint: ${_this.autoPrint}, printerAddress: ${_this.printerAddress}, printerName: ${_this.printerName})';
}


}

/// @nodoc
abstract mixin class $ReceiptSettingsCopyWith<$Res>  {
  factory $ReceiptSettingsCopyWith(ReceiptSettings value, $Res Function(ReceiptSettings) _then) = _$ReceiptSettingsCopyWithImpl;
@useResult
$Res call({
 String storeName, String storeAddress, String footer, PaperWidth paper, bool autoPrint, String? printerAddress, String? printerName
});




}
/// @nodoc
class _$ReceiptSettingsCopyWithImpl<$Res>
    implements $ReceiptSettingsCopyWith<$Res> {
  _$ReceiptSettingsCopyWithImpl(this._self, this._then);

  final ReceiptSettings _self;
  final $Res Function(ReceiptSettings) _then;

/// Create a copy of ReceiptSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = null,Object? storeAddress = null,Object? footer = null,Object? paper = null,Object? autoPrint = null,Object? printerAddress = freezed,Object? printerName = freezed,}) {
  return _then(ReceiptSettings(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeAddress: null == storeAddress ? _self.storeAddress : storeAddress // ignore: cast_nullable_to_non_nullable
as String,footer: null == footer ? _self.footer : footer // ignore: cast_nullable_to_non_nullable
as String,paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as PaperWidth,autoPrint: null == autoPrint ? _self.autoPrint : autoPrint // ignore: cast_nullable_to_non_nullable
as bool,printerAddress: freezed == printerAddress ? _self.printerAddress : printerAddress // ignore: cast_nullable_to_non_nullable
as String?,printerName: freezed == printerName ? _self.printerName : printerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptSettings].
extension ReceiptSettingsPatterns on ReceiptSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptSettings value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeName,  String storeAddress,  String footer,  PaperWidth paper,  bool autoPrint,  String? printerAddress,  String? printerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptSettings() when $default != null:
return $default(_that.storeName,_that.storeAddress,_that.footer,_that.paper,_that.autoPrint,_that.printerAddress,_that.printerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeName,  String storeAddress,  String footer,  PaperWidth paper,  bool autoPrint,  String? printerAddress,  String? printerName)  $default,) {final _that = this;
switch (_that) {
case _ReceiptSettings():
return $default(_that.storeName,_that.storeAddress,_that.footer,_that.paper,_that.autoPrint,_that.printerAddress,_that.printerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeName,  String storeAddress,  String footer,  PaperWidth paper,  bool autoPrint,  String? printerAddress,  String? printerName)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptSettings() when $default != null:
return $default(_that.storeName,_that.storeAddress,_that.footer,_that.paper,_that.autoPrint,_that.printerAddress,_that.printerName);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptSettings implements ReceiptSettings {
  const _ReceiptSettings({this.storeName = '', this.storeAddress = '', this.footer = '', this.paper = PaperWidth.mm58, this.autoPrint = false, this.printerAddress, this.printerName});
  

@override@JsonKey() final  String storeName;
@override@JsonKey() final  String storeAddress;
@override@JsonKey() final  String footer;
@override@JsonKey() final  PaperWidth paper;
@override@JsonKey() final  bool autoPrint;
@override final  String? printerAddress;
@override final  String? printerName;

/// Create a copy of ReceiptSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptSettingsCopyWith<_ReceiptSettings> get copyWith => __$ReceiptSettingsCopyWithImpl<_ReceiptSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptSettings&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeAddress, storeAddress) || other.storeAddress == storeAddress)&&(identical(other.footer, footer) || other.footer == footer)&&(identical(other.paper, paper) || other.paper == paper)&&(identical(other.autoPrint, autoPrint) || other.autoPrint == autoPrint)&&(identical(other.printerAddress, printerAddress) || other.printerAddress == printerAddress)&&(identical(other.printerName, printerName) || other.printerName == printerName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,storeName,storeAddress,footer,paper,autoPrint,printerAddress,printerName);
}

@override
String toString() {
    return 'ReceiptSettings(storeName: $storeName, storeAddress: $storeAddress, footer: $footer, paper: $paper, autoPrint: $autoPrint, printerAddress: $printerAddress, printerName: $printerName)';
}


}

/// @nodoc
abstract mixin class _$ReceiptSettingsCopyWith<$Res> implements $ReceiptSettingsCopyWith<$Res> {
  factory _$ReceiptSettingsCopyWith(_ReceiptSettings value, $Res Function(_ReceiptSettings) _then) = __$ReceiptSettingsCopyWithImpl;
@override @useResult
$Res call({
 String storeName, String storeAddress, String footer, PaperWidth paper, bool autoPrint, String? printerAddress, String? printerName
});




}
/// @nodoc
class __$ReceiptSettingsCopyWithImpl<$Res>
    implements _$ReceiptSettingsCopyWith<$Res> {
  __$ReceiptSettingsCopyWithImpl(this._self, this._then);

  final _ReceiptSettings _self;
  final $Res Function(_ReceiptSettings) _then;

/// Create a copy of ReceiptSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = null,Object? storeAddress = null,Object? footer = null,Object? paper = null,Object? autoPrint = null,Object? printerAddress = freezed,Object? printerName = freezed,}) {
  return _then(_ReceiptSettings(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeAddress: null == storeAddress ? _self.storeAddress : storeAddress // ignore: cast_nullable_to_non_nullable
as String,footer: null == footer ? _self.footer : footer // ignore: cast_nullable_to_non_nullable
as String,paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as PaperWidth,autoPrint: null == autoPrint ? _self.autoPrint : autoPrint // ignore: cast_nullable_to_non_nullable
as bool,printerAddress: freezed == printerAddress ? _self.printerAddress : printerAddress // ignore: cast_nullable_to_non_nullable
as String?,printerName: freezed == printerName ? _self.printerName : printerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
