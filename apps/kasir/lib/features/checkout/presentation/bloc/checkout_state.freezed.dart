// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {

 List<Draft> get drafts; int? get activeId; bool get online; bool get loading; bool get paying; PaymentMethod get method; VaBank get vaBank; Map<String, double> get shortfalls; CheckoutNotice? get notice; int get noticeId;
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutStateCopyWith<CheckoutState> get copyWith => _$CheckoutStateCopyWithImpl<CheckoutState>(this as CheckoutState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckoutState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState&&const DeepCollectionEquality().equals(other.drafts, _this.drafts)&&(identical(other.activeId, _this.activeId) || other.activeId == _this.activeId)&&(identical(other.online, _this.online) || other.online == _this.online)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.paying, _this.paying) || other.paying == _this.paying)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.vaBank, _this.vaBank) || other.vaBank == _this.vaBank)&&const DeepCollectionEquality().equals(other.shortfalls, _this.shortfalls)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.noticeId, _this.noticeId) || other.noticeId == _this.noticeId));
}


@override
int get hashCode {
  final _this = this as CheckoutState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.drafts),_this.activeId,_this.online,_this.loading,_this.paying,_this.method,_this.vaBank,const DeepCollectionEquality().hash(_this.shortfalls),_this.notice,_this.noticeId);
}

@override
String toString() {
  final _this = this as CheckoutState;
  return 'CheckoutState(drafts: ${_this.drafts}, activeId: ${_this.activeId}, online: ${_this.online}, loading: ${_this.loading}, paying: ${_this.paying}, method: ${_this.method}, vaBank: ${_this.vaBank}, shortfalls: ${_this.shortfalls}, notice: ${_this.notice}, noticeId: ${_this.noticeId})';
}


}

/// @nodoc
abstract mixin class $CheckoutStateCopyWith<$Res>  {
  factory $CheckoutStateCopyWith(CheckoutState value, $Res Function(CheckoutState) _then) = _$CheckoutStateCopyWithImpl;
@useResult
$Res call({
 List<Draft> drafts, int? activeId, bool online, bool loading, bool paying, PaymentMethod method, VaBank vaBank, Map<String, double> shortfalls, CheckoutNotice? notice, int noticeId
});




}
/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._self, this._then);

  final CheckoutState _self;
  final $Res Function(CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drafts = null,Object? activeId = freezed,Object? online = null,Object? loading = null,Object? paying = null,Object? method = null,Object? vaBank = null,Object? shortfalls = null,Object? notice = freezed,Object? noticeId = null,}) {
  return _then(CheckoutState(
drafts: null == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<Draft>,activeId: freezed == activeId ? _self.activeId : activeId // ignore: cast_nullable_to_non_nullable
as int?,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,paying: null == paying ? _self.paying : paying // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,vaBank: null == vaBank ? _self.vaBank : vaBank // ignore: cast_nullable_to_non_nullable
as VaBank,shortfalls: null == shortfalls ? _self.shortfalls : shortfalls // ignore: cast_nullable_to_non_nullable
as Map<String, double>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as CheckoutNotice?,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutState value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Draft> drafts,  int? activeId,  bool online,  bool loading,  bool paying,  PaymentMethod method,  VaBank vaBank,  Map<String, double> shortfalls,  CheckoutNotice? notice,  int noticeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.drafts,_that.activeId,_that.online,_that.loading,_that.paying,_that.method,_that.vaBank,_that.shortfalls,_that.notice,_that.noticeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Draft> drafts,  int? activeId,  bool online,  bool loading,  bool paying,  PaymentMethod method,  VaBank vaBank,  Map<String, double> shortfalls,  CheckoutNotice? notice,  int noticeId)  $default,) {final _that = this;
switch (_that) {
case _CheckoutState():
return $default(_that.drafts,_that.activeId,_that.online,_that.loading,_that.paying,_that.method,_that.vaBank,_that.shortfalls,_that.notice,_that.noticeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Draft> drafts,  int? activeId,  bool online,  bool loading,  bool paying,  PaymentMethod method,  VaBank vaBank,  Map<String, double> shortfalls,  CheckoutNotice? notice,  int noticeId)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.drafts,_that.activeId,_that.online,_that.loading,_that.paying,_that.method,_that.vaBank,_that.shortfalls,_that.notice,_that.noticeId);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutState extends CheckoutState {
  const _CheckoutState({ List<Draft> drafts = const [], this.activeId, this.online = true, this.loading = false, this.paying = false, this.method = PaymentMethod.cash, this.vaBank = VaBank.bca,  Map<String, double> shortfalls = const <String, double>{}, this.notice, this.noticeId = 0}): _drafts = drafts,_shortfalls = shortfalls,super._();
  

 final  List<Draft> _drafts;
@override@JsonKey() List<Draft> get drafts {
  if (_drafts is EqualUnmodifiableListView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drafts);
}

@override final  int? activeId;
@override@JsonKey() final  bool online;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool paying;
@override@JsonKey() final  PaymentMethod method;
@override@JsonKey() final  VaBank vaBank;
 final  Map<String, double> _shortfalls;
@override@JsonKey() Map<String, double> get shortfalls {
  if (_shortfalls is EqualUnmodifiableMapView) return _shortfalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_shortfalls);
}

@override final  CheckoutNotice? notice;
@override@JsonKey() final  int noticeId;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutStateCopyWith<_CheckoutState> get copyWith => __$CheckoutStateCopyWithImpl<_CheckoutState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutState&&const DeepCollectionEquality().equals(other.drafts, _drafts)&&(identical(other.activeId, activeId) || other.activeId == activeId)&&(identical(other.online, online) || other.online == online)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.paying, paying) || other.paying == paying)&&(identical(other.method, method) || other.method == method)&&(identical(other.vaBank, vaBank) || other.vaBank == vaBank)&&const DeepCollectionEquality().equals(other.shortfalls, _shortfalls)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_drafts),activeId,online,loading,paying,method,vaBank,const DeepCollectionEquality().hash(_shortfalls),notice,noticeId);
}

@override
String toString() {
    return 'CheckoutState(drafts: $drafts, activeId: $activeId, online: $online, loading: $loading, paying: $paying, method: $method, vaBank: $vaBank, shortfalls: $shortfalls, notice: $notice, noticeId: $noticeId)';
}


}

/// @nodoc
abstract mixin class _$CheckoutStateCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutStateCopyWith(_CheckoutState value, $Res Function(_CheckoutState) _then) = __$CheckoutStateCopyWithImpl;
@override @useResult
$Res call({
 List<Draft> drafts, int? activeId, bool online, bool loading, bool paying, PaymentMethod method, VaBank vaBank, Map<String, double> shortfalls, CheckoutNotice? notice, int noticeId
});




}
/// @nodoc
class __$CheckoutStateCopyWithImpl<$Res>
    implements _$CheckoutStateCopyWith<$Res> {
  __$CheckoutStateCopyWithImpl(this._self, this._then);

  final _CheckoutState _self;
  final $Res Function(_CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drafts = null,Object? activeId = freezed,Object? online = null,Object? loading = null,Object? paying = null,Object? method = null,Object? vaBank = null,Object? shortfalls = null,Object? notice = freezed,Object? noticeId = null,}) {
  return _then(_CheckoutState(
drafts: null == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<Draft>,activeId: freezed == activeId ? _self.activeId : activeId // ignore: cast_nullable_to_non_nullable
as int?,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,paying: null == paying ? _self.paying : paying // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,vaBank: null == vaBank ? _self.vaBank : vaBank // ignore: cast_nullable_to_non_nullable
as VaBank,shortfalls: null == shortfalls ? _self._shortfalls : shortfalls // ignore: cast_nullable_to_non_nullable
as Map<String, double>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as CheckoutNotice?,noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
