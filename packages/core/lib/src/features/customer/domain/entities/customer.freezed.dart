// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Customer {

 String get id; String get name; String get phone; String get address; bool get active; List<Debt> get debts;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Customer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.active, _this.active) || other.active == _this.active)&&const DeepCollectionEquality().equals(other.debts, _this.debts));
}


@override
int get hashCode {
  final _this = this as Customer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.address,_this.active,const DeepCollectionEquality().hash(_this.debts));
}

@override
String toString() {
  final _this = this as Customer;
  return 'Customer(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, address: ${_this.address}, active: ${_this.active}, debts: ${_this.debts})';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String address, bool active, List<Debt> debts
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? address = null,Object? active = null,Object? debts = null,}) {
  return _then(Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,debts: null == debts ? _self.debts : debts // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String address,  bool active,  List<Debt> debts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.address,_that.active,_that.debts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String address,  bool active,  List<Debt> debts)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.phone,_that.address,_that.active,_that.debts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String address,  bool active,  List<Debt> debts)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.address,_that.active,_that.debts);case _:
  return null;

}
}

}

/// @nodoc


class _Customer extends Customer {
  const _Customer({required this.id, required this.name, this.phone = '', this.address = '', this.active = true,  List<Debt> debts = const []}): _debts = debts,super._();
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;
@override@JsonKey() final  bool active;
 final  List<Debt> _debts;
@override@JsonKey() List<Debt> get debts {
  if (_debts is EqualUnmodifiableListView) return _debts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debts);
}


/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.active, active) || other.active == active)&&const DeepCollectionEquality().equals(other.debts, _debts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,address,active,const DeepCollectionEquality().hash(_debts));
}

@override
String toString() {
    return 'Customer(id: $id, name: $name, phone: $phone, address: $address, active: $active, debts: $debts)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String address, bool active, List<Debt> debts
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? address = null,Object? active = null,Object? debts = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,debts: null == debts ? _self._debts : debts // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}


}

/// @nodoc
mixin _$CustomerInput {

 String get name; String get phone; String get address;
/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInputCopyWith<CustomerInput> get copyWith => _$CustomerInputCopyWithImpl<CustomerInput>(this as CustomerInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as CustomerInput;
  return Object.hash(runtimeType,_this.name,_this.phone,_this.address);
}

@override
String toString() {
  final _this = this as CustomerInput;
  return 'CustomerInput(name: ${_this.name}, phone: ${_this.phone}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $CustomerInputCopyWith<$Res>  {
  factory $CustomerInputCopyWith(CustomerInput value, $Res Function(CustomerInput) _then) = _$CustomerInputCopyWithImpl;
@useResult
$Res call({
 String name, String phone, String address
});




}
/// @nodoc
class _$CustomerInputCopyWithImpl<$Res>
    implements $CustomerInputCopyWith<$Res> {
  _$CustomerInputCopyWithImpl(this._self, this._then);

  final CustomerInput _self;
  final $Res Function(CustomerInput) _then;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,Object? address = null,}) {
  return _then(CustomerInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerInput].
extension CustomerInputPatterns on CustomerInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInput value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInput value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
return $default(_that.name,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone,  String address)  $default,) {final _that = this;
switch (_that) {
case _CustomerInput():
return $default(_that.name,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone,  String address)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInput() when $default != null:
return $default(_that.name,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerInput implements CustomerInput {
  const _CustomerInput({required this.name, this.phone = '', this.address = ''});
  

@override final  String name;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInputCopyWith<_CustomerInput> get copyWith => __$CustomerInputCopyWithImpl<_CustomerInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInput&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,phone,address);
}

@override
String toString() {
    return 'CustomerInput(name: $name, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$CustomerInputCopyWith<$Res> implements $CustomerInputCopyWith<$Res> {
  factory _$CustomerInputCopyWith(_CustomerInput value, $Res Function(_CustomerInput) _then) = __$CustomerInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone, String address
});




}
/// @nodoc
class __$CustomerInputCopyWithImpl<$Res>
    implements _$CustomerInputCopyWith<$Res> {
  __$CustomerInputCopyWithImpl(this._self, this._then);

  final _CustomerInput _self;
  final $Res Function(_CustomerInput) _then;

/// Create a copy of CustomerInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? address = null,}) {
  return _then(_CustomerInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
