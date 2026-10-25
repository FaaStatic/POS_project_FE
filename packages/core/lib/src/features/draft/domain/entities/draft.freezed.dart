// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftItem {

 int get id; String get productId; String get name; int get unitPrice; int get debtPrice; double get qty; int get unit; bool get isDigital; String? get destination;
/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftItemCopyWith<DraftItem> get copyWith => _$DraftItemCopyWithImpl<DraftItem>(this as DraftItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DraftItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.debtPrice, _this.debtPrice) || other.debtPrice == _this.debtPrice)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.isDigital, _this.isDigital) || other.isDigital == _this.isDigital)&&(identical(other.destination, _this.destination) || other.destination == _this.destination));
}


@override
int get hashCode {
  final _this = this as DraftItem;
  return Object.hash(runtimeType,_this.id,_this.productId,_this.name,_this.unitPrice,_this.debtPrice,_this.qty,_this.unit,_this.isDigital,_this.destination);
}

@override
String toString() {
  final _this = this as DraftItem;
  return 'DraftItem(id: ${_this.id}, productId: ${_this.productId}, name: ${_this.name}, unitPrice: ${_this.unitPrice}, debtPrice: ${_this.debtPrice}, qty: ${_this.qty}, unit: ${_this.unit}, isDigital: ${_this.isDigital}, destination: ${_this.destination})';
}


}

/// @nodoc
abstract mixin class $DraftItemCopyWith<$Res>  {
  factory $DraftItemCopyWith(DraftItem value, $Res Function(DraftItem) _then) = _$DraftItemCopyWithImpl;
@useResult
$Res call({
 int id, String productId, String name, int unitPrice, int debtPrice, double qty, int unit, bool isDigital, String? destination
});




}
/// @nodoc
class _$DraftItemCopyWithImpl<$Res>
    implements $DraftItemCopyWith<$Res> {
  _$DraftItemCopyWithImpl(this._self, this._then);

  final DraftItem _self;
  final $Res Function(DraftItem) _then;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? name = null,Object? unitPrice = null,Object? debtPrice = null,Object? qty = null,Object? unit = null,Object? isDigital = null,Object? destination = freezed,}) {
  return _then(DraftItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,debtPrice: null == debtPrice ? _self.debtPrice : debtPrice // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as int,isDigital: null == isDigital ? _self.isDigital : isDigital // ignore: cast_nullable_to_non_nullable
as bool,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftItem].
extension DraftItemPatterns on DraftItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftItem value)  $default,){
final _that = this;
switch (_that) {
case _DraftItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftItem value)?  $default,){
final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String productId,  String name,  int unitPrice,  int debtPrice,  double qty,  int unit,  bool isDigital,  String? destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.unitPrice,_that.debtPrice,_that.qty,_that.unit,_that.isDigital,_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String productId,  String name,  int unitPrice,  int debtPrice,  double qty,  int unit,  bool isDigital,  String? destination)  $default,) {final _that = this;
switch (_that) {
case _DraftItem():
return $default(_that.id,_that.productId,_that.name,_that.unitPrice,_that.debtPrice,_that.qty,_that.unit,_that.isDigital,_that.destination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String productId,  String name,  int unitPrice,  int debtPrice,  double qty,  int unit,  bool isDigital,  String? destination)?  $default,) {final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.unitPrice,_that.debtPrice,_that.qty,_that.unit,_that.isDigital,_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class _DraftItem extends DraftItem {
  const _DraftItem({required this.id, required this.productId, required this.name, required this.unitPrice, required this.debtPrice, required this.qty, this.unit = 0, this.isDigital = false, this.destination}): super._();
  

@override final  int id;
@override final  String productId;
@override final  String name;
@override final  int unitPrice;
@override final  int debtPrice;
@override final  double qty;
@override@JsonKey() final  int unit;
@override@JsonKey() final  bool isDigital;
@override final  String? destination;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftItemCopyWith<_DraftItem> get copyWith => __$DraftItemCopyWithImpl<_DraftItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.debtPrice, debtPrice) || other.debtPrice == debtPrice)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.isDigital, isDigital) || other.isDigital == isDigital)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,productId,name,unitPrice,debtPrice,qty,unit,isDigital,destination);
}

@override
String toString() {
    return 'DraftItem(id: $id, productId: $productId, name: $name, unitPrice: $unitPrice, debtPrice: $debtPrice, qty: $qty, unit: $unit, isDigital: $isDigital, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$DraftItemCopyWith<$Res> implements $DraftItemCopyWith<$Res> {
  factory _$DraftItemCopyWith(_DraftItem value, $Res Function(_DraftItem) _then) = __$DraftItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String productId, String name, int unitPrice, int debtPrice, double qty, int unit, bool isDigital, String? destination
});




}
/// @nodoc
class __$DraftItemCopyWithImpl<$Res>
    implements _$DraftItemCopyWith<$Res> {
  __$DraftItemCopyWithImpl(this._self, this._then);

  final _DraftItem _self;
  final $Res Function(_DraftItem) _then;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? name = null,Object? unitPrice = null,Object? debtPrice = null,Object? qty = null,Object? unit = null,Object? isDigital = null,Object? destination = freezed,}) {
  return _then(_DraftItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,debtPrice: null == debtPrice ? _self.debtPrice : debtPrice // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as int,isDigital: null == isDigital ? _self.isDigital : isDigital // ignore: cast_nullable_to_non_nullable
as bool,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Draft {

 int get id; int get number; String? get customerId; String? get customerName; DateTime get createdAt; DateTime get updatedAt; DraftStatus get status; Charge? get charge; String? get paidSaleRef; List<DraftItem> get items;
/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftCopyWith<Draft> get copyWith => _$DraftCopyWithImpl<Draft>(this as Draft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Draft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Draft&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.charge, _this.charge) || other.charge == _this.charge)&&(identical(other.paidSaleRef, _this.paidSaleRef) || other.paidSaleRef == _this.paidSaleRef)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Draft;
  return Object.hash(runtimeType,_this.id,_this.number,_this.customerId,_this.customerName,_this.createdAt,_this.updatedAt,_this.status,_this.charge,_this.paidSaleRef,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Draft;
  return 'Draft(id: ${_this.id}, number: ${_this.number}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, status: ${_this.status}, charge: ${_this.charge}, paidSaleRef: ${_this.paidSaleRef}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $DraftCopyWith<$Res>  {
  factory $DraftCopyWith(Draft value, $Res Function(Draft) _then) = _$DraftCopyWithImpl;
@useResult
$Res call({
 int id, int number, String? customerId, String? customerName, DateTime createdAt, DateTime updatedAt, DraftStatus status, Charge? charge, String? paidSaleRef, List<DraftItem> items
});


$ChargeCopyWith<$Res>? get charge;

}
/// @nodoc
class _$DraftCopyWithImpl<$Res>
    implements $DraftCopyWith<$Res> {
  _$DraftCopyWithImpl(this._self, this._then);

  final Draft _self;
  final $Res Function(Draft) _then;

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? customerId = freezed,Object? customerName = freezed,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? charge = freezed,Object? paidSaleRef = freezed,Object? items = null,}) {
  return _then(Draft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,charge: freezed == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as Charge?,paidSaleRef: freezed == paidSaleRef ? _self.paidSaleRef : paidSaleRef // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DraftItem>,
  ));
}
/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChargeCopyWith<$Res>? get charge {
    if (_self.charge == null) {
    return null;
  }

  return $ChargeCopyWith<$Res>(_self.charge!, (value) {
    return _then(_self.copyWith(charge: value));
  });
}
}


/// Adds pattern-matching-related methods to [Draft].
extension DraftPatterns on Draft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Draft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Draft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Draft value)  $default,){
final _that = this;
switch (_that) {
case _Draft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Draft value)?  $default,){
final _that = this;
switch (_that) {
case _Draft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int number,  String? customerId,  String? customerName,  DateTime createdAt,  DateTime updatedAt,  DraftStatus status,  Charge? charge,  String? paidSaleRef,  List<DraftItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that.id,_that.number,_that.customerId,_that.customerName,_that.createdAt,_that.updatedAt,_that.status,_that.charge,_that.paidSaleRef,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int number,  String? customerId,  String? customerName,  DateTime createdAt,  DateTime updatedAt,  DraftStatus status,  Charge? charge,  String? paidSaleRef,  List<DraftItem> items)  $default,) {final _that = this;
switch (_that) {
case _Draft():
return $default(_that.id,_that.number,_that.customerId,_that.customerName,_that.createdAt,_that.updatedAt,_that.status,_that.charge,_that.paidSaleRef,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int number,  String? customerId,  String? customerName,  DateTime createdAt,  DateTime updatedAt,  DraftStatus status,  Charge? charge,  String? paidSaleRef,  List<DraftItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that.id,_that.number,_that.customerId,_that.customerName,_that.createdAt,_that.updatedAt,_that.status,_that.charge,_that.paidSaleRef,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Draft extends Draft {
  const _Draft({required this.id, required this.number, this.customerId, this.customerName, required this.createdAt, required this.updatedAt, this.status = DraftStatus.open, this.charge, this.paidSaleRef,  List<DraftItem> items = const []}): _items = items,super._();
  

@override final  int id;
@override final  int number;
@override final  String? customerId;
@override final  String? customerName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  DraftStatus status;
@override final  Charge? charge;
@override final  String? paidSaleRef;
 final  List<DraftItem> _items;
@override@JsonKey() List<DraftItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftCopyWith<_Draft> get copyWith => __$DraftCopyWithImpl<_Draft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Draft&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.charge, charge) || other.charge == charge)&&(identical(other.paidSaleRef, paidSaleRef) || other.paidSaleRef == paidSaleRef)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,number,customerId,customerName,createdAt,updatedAt,status,charge,paidSaleRef,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Draft(id: $id, number: $number, customerId: $customerId, customerName: $customerName, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, charge: $charge, paidSaleRef: $paidSaleRef, items: $items)';
}


}

/// @nodoc
abstract mixin class _$DraftCopyWith<$Res> implements $DraftCopyWith<$Res> {
  factory _$DraftCopyWith(_Draft value, $Res Function(_Draft) _then) = __$DraftCopyWithImpl;
@override @useResult
$Res call({
 int id, int number, String? customerId, String? customerName, DateTime createdAt, DateTime updatedAt, DraftStatus status, Charge? charge, String? paidSaleRef, List<DraftItem> items
});


@override $ChargeCopyWith<$Res>? get charge;

}
/// @nodoc
class __$DraftCopyWithImpl<$Res>
    implements _$DraftCopyWith<$Res> {
  __$DraftCopyWithImpl(this._self, this._then);

  final _Draft _self;
  final $Res Function(_Draft) _then;

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? customerId = freezed,Object? customerName = freezed,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? charge = freezed,Object? paidSaleRef = freezed,Object? items = null,}) {
  return _then(_Draft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,charge: freezed == charge ? _self.charge : charge // ignore: cast_nullable_to_non_nullable
as Charge?,paidSaleRef: freezed == paidSaleRef ? _self.paidSaleRef : paidSaleRef // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DraftItem>,
  ));
}

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChargeCopyWith<$Res>? get charge {
    if (_self.charge == null) {
    return null;
  }

  return $ChargeCopyWith<$Res>(_self.charge!, (value) {
    return _then(_self.copyWith(charge: value));
  });
}
}

// dart format on
