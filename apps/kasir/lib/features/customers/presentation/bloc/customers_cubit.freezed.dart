// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customers_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerFormState {

 bool get saving; Customer? get saved; Failure? get failure;
/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerFormStateCopyWith<CustomerFormState> get copyWith => _$CustomerFormStateCopyWithImpl<CustomerFormState>(this as CustomerFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerFormState&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as CustomerFormState;
  return Object.hash(runtimeType,_this.saving,_this.saved,_this.failure);
}

@override
String toString() {
  final _this = this as CustomerFormState;
  return 'CustomerFormState(saving: ${_this.saving}, saved: ${_this.saved}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $CustomerFormStateCopyWith<$Res>  {
  factory $CustomerFormStateCopyWith(CustomerFormState value, $Res Function(CustomerFormState) _then) = _$CustomerFormStateCopyWithImpl;
@useResult
$Res call({
 bool saving, Customer? saved, Failure? failure
});


$CustomerCopyWith<$Res>? get saved;

}
/// @nodoc
class _$CustomerFormStateCopyWithImpl<$Res>
    implements $CustomerFormStateCopyWith<$Res> {
  _$CustomerFormStateCopyWithImpl(this._self, this._then);

  final CustomerFormState _self;
  final $Res Function(CustomerFormState) _then;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saving = null,Object? saved = freezed,Object? failure = freezed,}) {
  return _then(CustomerFormState(
saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as Customer?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerFormState].
extension CustomerFormStatePatterns on CustomerFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerFormState value)  $default,){
final _that = this;
switch (_that) {
case _CustomerFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool saving,  Customer? saved,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
return $default(_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool saving,  Customer? saved,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _CustomerFormState():
return $default(_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool saving,  Customer? saved,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
return $default(_that.saving,_that.saved,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerFormState implements CustomerFormState {
  const _CustomerFormState({this.saving = false, this.saved, this.failure});
  

@override@JsonKey() final  bool saving;
@override final  Customer? saved;
@override final  Failure? failure;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerFormStateCopyWith<_CustomerFormState> get copyWith => __$CustomerFormStateCopyWithImpl<_CustomerFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerFormState&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,saving,saved,failure);
}

@override
String toString() {
    return 'CustomerFormState(saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$CustomerFormStateCopyWith<$Res> implements $CustomerFormStateCopyWith<$Res> {
  factory _$CustomerFormStateCopyWith(_CustomerFormState value, $Res Function(_CustomerFormState) _then) = __$CustomerFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool saving, Customer? saved, Failure? failure
});


@override $CustomerCopyWith<$Res>? get saved;

}
/// @nodoc
class __$CustomerFormStateCopyWithImpl<$Res>
    implements _$CustomerFormStateCopyWith<$Res> {
  __$CustomerFormStateCopyWithImpl(this._self, this._then);

  final _CustomerFormState _self;
  final $Res Function(_CustomerFormState) _then;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saving = null,Object? saved = freezed,Object? failure = freezed,}) {
  return _then(_CustomerFormState(
saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as Customer?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}

/// @nodoc
mixin _$CustomerDetailState {

 bool get loading; Customer? get customer; Failure? get failure;
/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDetailStateCopyWith<CustomerDetailState> get copyWith => _$CustomerDetailStateCopyWithImpl<CustomerDetailState>(this as CustomerDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerDetailState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as CustomerDetailState;
  return Object.hash(runtimeType,_this.loading,_this.customer,_this.failure);
}

@override
String toString() {
  final _this = this as CustomerDetailState;
  return 'CustomerDetailState(loading: ${_this.loading}, customer: ${_this.customer}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $CustomerDetailStateCopyWith<$Res>  {
  factory $CustomerDetailStateCopyWith(CustomerDetailState value, $Res Function(CustomerDetailState) _then) = _$CustomerDetailStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Customer? customer, Failure? failure
});


$CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$CustomerDetailStateCopyWithImpl<$Res>
    implements $CustomerDetailStateCopyWith<$Res> {
  _$CustomerDetailStateCopyWithImpl(this._self, this._then);

  final CustomerDetailState _self;
  final $Res Function(CustomerDetailState) _then;

/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? customer = freezed,Object? failure = freezed,}) {
  return _then(CustomerDetailState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerDetailState].
extension CustomerDetailStatePatterns on CustomerDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerDetailState value)  $default,){
final _that = this;
switch (_that) {
case _CustomerDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Customer? customer,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerDetailState() when $default != null:
return $default(_that.loading,_that.customer,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Customer? customer,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _CustomerDetailState():
return $default(_that.loading,_that.customer,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Customer? customer,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _CustomerDetailState() when $default != null:
return $default(_that.loading,_that.customer,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerDetailState implements CustomerDetailState {
  const _CustomerDetailState({this.loading = true, this.customer, this.failure});
  

@override@JsonKey() final  bool loading;
@override final  Customer? customer;
@override final  Failure? failure;

/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDetailStateCopyWith<_CustomerDetailState> get copyWith => __$CustomerDetailStateCopyWithImpl<_CustomerDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerDetailState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,customer,failure);
}

@override
String toString() {
    return 'CustomerDetailState(loading: $loading, customer: $customer, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$CustomerDetailStateCopyWith<$Res> implements $CustomerDetailStateCopyWith<$Res> {
  factory _$CustomerDetailStateCopyWith(_CustomerDetailState value, $Res Function(_CustomerDetailState) _then) = __$CustomerDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Customer? customer, Failure? failure
});


@override $CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$CustomerDetailStateCopyWithImpl<$Res>
    implements _$CustomerDetailStateCopyWith<$Res> {
  __$CustomerDetailStateCopyWithImpl(this._self, this._then);

  final _CustomerDetailState _self;
  final $Res Function(_CustomerDetailState) _then;

/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? customer = freezed,Object? failure = freezed,}) {
  return _then(_CustomerDetailState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of CustomerDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
