// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryState {

 bool get loading; List<Sale> get sales;
/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStateCopyWith<HistoryState> get copyWith => _$HistoryStateCopyWithImpl<HistoryState>(this as HistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.sales, _this.sales));
}


@override
int get hashCode {
  final _this = this as HistoryState;
  return Object.hash(runtimeType,_this.loading,const DeepCollectionEquality().hash(_this.sales));
}

@override
String toString() {
  final _this = this as HistoryState;
  return 'HistoryState(loading: ${_this.loading}, sales: ${_this.sales})';
}


}

/// @nodoc
abstract mixin class $HistoryStateCopyWith<$Res>  {
  factory $HistoryStateCopyWith(HistoryState value, $Res Function(HistoryState) _then) = _$HistoryStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Sale> sales
});




}
/// @nodoc
class _$HistoryStateCopyWithImpl<$Res>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._self, this._then);

  final HistoryState _self;
  final $Res Function(HistoryState) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? sales = null,}) {
  return _then(HistoryState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as List<Sale>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryState value)  $default,){
final _that = this;
switch (_that) {
case _HistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Sale> sales)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
return $default(_that.loading,_that.sales);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Sale> sales)  $default,) {final _that = this;
switch (_that) {
case _HistoryState():
return $default(_that.loading,_that.sales);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Sale> sales)?  $default,) {final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
return $default(_that.loading,_that.sales);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryState implements HistoryState {
  const _HistoryState({this.loading = true,  List<Sale> sales = const []}): _sales = sales;
  

@override@JsonKey() final  bool loading;
 final  List<Sale> _sales;
@override@JsonKey() List<Sale> get sales {
  if (_sales is EqualUnmodifiableListView) return _sales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sales);
}


/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStateCopyWith<_HistoryState> get copyWith => __$HistoryStateCopyWithImpl<_HistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.sales, _sales));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_sales));
}

@override
String toString() {
    return 'HistoryState(loading: $loading, sales: $sales)';
}


}

/// @nodoc
abstract mixin class _$HistoryStateCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory _$HistoryStateCopyWith(_HistoryState value, $Res Function(_HistoryState) _then) = __$HistoryStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Sale> sales
});




}
/// @nodoc
class __$HistoryStateCopyWithImpl<$Res>
    implements _$HistoryStateCopyWith<$Res> {
  __$HistoryStateCopyWithImpl(this._self, this._then);

  final _HistoryState _self;
  final $Res Function(_HistoryState) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? sales = null,}) {
  return _then(_HistoryState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,sales: null == sales ? _self._sales : sales // ignore: cast_nullable_to_non_nullable
as List<Sale>,
  ));
}


}

/// @nodoc
mixin _$SaleDetailState {

 bool get loading; Sale? get sale; bool get working; Failure? get failure; bool get cancelled; bool get printed; int get eventId;
/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleDetailStateCopyWith<SaleDetailState> get copyWith => _$SaleDetailStateCopyWithImpl<SaleDetailState>(this as SaleDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SaleDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDetailState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.sale, _this.sale) || other.sale == _this.sale)&&(identical(other.working, _this.working) || other.working == _this.working)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.cancelled, _this.cancelled) || other.cancelled == _this.cancelled)&&(identical(other.printed, _this.printed) || other.printed == _this.printed)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId));
}


@override
int get hashCode {
  final _this = this as SaleDetailState;
  return Object.hash(runtimeType,_this.loading,_this.sale,_this.working,_this.failure,_this.cancelled,_this.printed,_this.eventId);
}

@override
String toString() {
  final _this = this as SaleDetailState;
  return 'SaleDetailState(loading: ${_this.loading}, sale: ${_this.sale}, working: ${_this.working}, failure: ${_this.failure}, cancelled: ${_this.cancelled}, printed: ${_this.printed}, eventId: ${_this.eventId})';
}


}

/// @nodoc
abstract mixin class $SaleDetailStateCopyWith<$Res>  {
  factory $SaleDetailStateCopyWith(SaleDetailState value, $Res Function(SaleDetailState) _then) = _$SaleDetailStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Sale? sale, bool working, Failure? failure, bool cancelled, bool printed, int eventId
});


$SaleCopyWith<$Res>? get sale;

}
/// @nodoc
class _$SaleDetailStateCopyWithImpl<$Res>
    implements $SaleDetailStateCopyWith<$Res> {
  _$SaleDetailStateCopyWithImpl(this._self, this._then);

  final SaleDetailState _self;
  final $Res Function(SaleDetailState) _then;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? sale = freezed,Object? working = null,Object? failure = freezed,Object? cancelled = null,Object? printed = null,Object? eventId = null,}) {
  return _then(SaleDetailState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,sale: freezed == sale ? _self.sale : sale // ignore: cast_nullable_to_non_nullable
as Sale?,working: null == working ? _self.working : working // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,printed: null == printed ? _self.printed : printed // ignore: cast_nullable_to_non_nullable
as bool,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleCopyWith<$Res>? get sale {
    if (_self.sale == null) {
    return null;
  }

  return $SaleCopyWith<$Res>(_self.sale!, (value) {
    return _then(_self.copyWith(sale: value));
  });
}
}


/// Adds pattern-matching-related methods to [SaleDetailState].
extension SaleDetailStatePatterns on SaleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleDetailState value)  $default,){
final _that = this;
switch (_that) {
case _SaleDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _SaleDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Sale? sale,  bool working,  Failure? failure,  bool cancelled,  bool printed,  int eventId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleDetailState() when $default != null:
return $default(_that.loading,_that.sale,_that.working,_that.failure,_that.cancelled,_that.printed,_that.eventId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Sale? sale,  bool working,  Failure? failure,  bool cancelled,  bool printed,  int eventId)  $default,) {final _that = this;
switch (_that) {
case _SaleDetailState():
return $default(_that.loading,_that.sale,_that.working,_that.failure,_that.cancelled,_that.printed,_that.eventId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Sale? sale,  bool working,  Failure? failure,  bool cancelled,  bool printed,  int eventId)?  $default,) {final _that = this;
switch (_that) {
case _SaleDetailState() when $default != null:
return $default(_that.loading,_that.sale,_that.working,_that.failure,_that.cancelled,_that.printed,_that.eventId);case _:
  return null;

}
}

}

/// @nodoc


class _SaleDetailState implements SaleDetailState {
  const _SaleDetailState({this.loading = true, this.sale, this.working = false, this.failure, this.cancelled = false, this.printed = false, this.eventId = 0});
  

@override@JsonKey() final  bool loading;
@override final  Sale? sale;
@override@JsonKey() final  bool working;
@override final  Failure? failure;
@override@JsonKey() final  bool cancelled;
@override@JsonKey() final  bool printed;
@override@JsonKey() final  int eventId;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleDetailStateCopyWith<_SaleDetailState> get copyWith => __$SaleDetailStateCopyWithImpl<_SaleDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleDetailState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.sale, sale) || other.sale == sale)&&(identical(other.working, working) || other.working == working)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.printed, printed) || other.printed == printed)&&(identical(other.eventId, eventId) || other.eventId == eventId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,sale,working,failure,cancelled,printed,eventId);
}

@override
String toString() {
    return 'SaleDetailState(loading: $loading, sale: $sale, working: $working, failure: $failure, cancelled: $cancelled, printed: $printed, eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class _$SaleDetailStateCopyWith<$Res> implements $SaleDetailStateCopyWith<$Res> {
  factory _$SaleDetailStateCopyWith(_SaleDetailState value, $Res Function(_SaleDetailState) _then) = __$SaleDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Sale? sale, bool working, Failure? failure, bool cancelled, bool printed, int eventId
});


@override $SaleCopyWith<$Res>? get sale;

}
/// @nodoc
class __$SaleDetailStateCopyWithImpl<$Res>
    implements _$SaleDetailStateCopyWith<$Res> {
  __$SaleDetailStateCopyWithImpl(this._self, this._then);

  final _SaleDetailState _self;
  final $Res Function(_SaleDetailState) _then;

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? sale = freezed,Object? working = null,Object? failure = freezed,Object? cancelled = null,Object? printed = null,Object? eventId = null,}) {
  return _then(_SaleDetailState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,sale: freezed == sale ? _self.sale : sale // ignore: cast_nullable_to_non_nullable
as Sale?,working: null == working ? _self.working : working // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,printed: null == printed ? _self.printed : printed // ignore: cast_nullable_to_non_nullable
as bool,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SaleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleCopyWith<$Res>? get sale {
    if (_self.sale == null) {
    return null;
  }

  return $SaleCopyWith<$Res>(_self.sale!, (value) {
    return _then(_self.copyWith(sale: value));
  });
}
}

// dart format on
