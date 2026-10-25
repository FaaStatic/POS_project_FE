// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncState {

 bool get online; int get pending; bool get syncing; SyncReport? get lastReport; Failure? get failure; int get reportId;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&(identical(other.online, _this.online) || other.online == _this.online)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.syncing, _this.syncing) || other.syncing == _this.syncing)&&(identical(other.lastReport, _this.lastReport) || other.lastReport == _this.lastReport)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.reportId, _this.reportId) || other.reportId == _this.reportId));
}


@override
int get hashCode {
  final _this = this as SyncState;
  return Object.hash(runtimeType,_this.online,_this.pending,_this.syncing,_this.lastReport,_this.failure,_this.reportId);
}

@override
String toString() {
  final _this = this as SyncState;
  return 'SyncState(online: ${_this.online}, pending: ${_this.pending}, syncing: ${_this.syncing}, lastReport: ${_this.lastReport}, failure: ${_this.failure}, reportId: ${_this.reportId})';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 bool online, int pending, bool syncing, SyncReport? lastReport, Failure? failure, int reportId
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? online = null,Object? pending = null,Object? syncing = null,Object? lastReport = freezed,Object? failure = freezed,Object? reportId = null,}) {
  return _then(SyncState(
online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,lastReport: freezed == lastReport ? _self.lastReport : lastReport // ignore: cast_nullable_to_non_nullable
as SyncReport?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool online,  int pending,  bool syncing,  SyncReport? lastReport,  Failure? failure,  int reportId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.online,_that.pending,_that.syncing,_that.lastReport,_that.failure,_that.reportId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool online,  int pending,  bool syncing,  SyncReport? lastReport,  Failure? failure,  int reportId)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.online,_that.pending,_that.syncing,_that.lastReport,_that.failure,_that.reportId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool online,  int pending,  bool syncing,  SyncReport? lastReport,  Failure? failure,  int reportId)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.online,_that.pending,_that.syncing,_that.lastReport,_that.failure,_that.reportId);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState implements SyncState {
  const _SyncState({this.online = true, this.pending = 0, this.syncing = false, this.lastReport, this.failure, this.reportId = 0});
  

@override@JsonKey() final  bool online;
@override@JsonKey() final  int pending;
@override@JsonKey() final  bool syncing;
@override final  SyncReport? lastReport;
@override final  Failure? failure;
@override@JsonKey() final  int reportId;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&(identical(other.online, online) || other.online == online)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.syncing, syncing) || other.syncing == syncing)&&(identical(other.lastReport, lastReport) || other.lastReport == lastReport)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.reportId, reportId) || other.reportId == reportId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,online,pending,syncing,lastReport,failure,reportId);
}

@override
String toString() {
    return 'SyncState(online: $online, pending: $pending, syncing: $syncing, lastReport: $lastReport, failure: $failure, reportId: $reportId)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 bool online, int pending, bool syncing, SyncReport? lastReport, Failure? failure, int reportId
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? online = null,Object? pending = null,Object? syncing = null,Object? lastReport = freezed,Object? failure = freezed,Object? reportId = null,}) {
  return _then(_SyncState(
online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,lastReport: freezed == lastReport ? _self.lastReport : lastReport // ignore: cast_nullable_to_non_nullable
as SyncReport?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
