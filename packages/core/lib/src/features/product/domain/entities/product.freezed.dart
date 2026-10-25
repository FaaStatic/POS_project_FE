// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get sku; String? get barcode; String get name; ProductUnit get unit; ProductType get type; int get purchasePrice; int get sellingPrice; int get sellingPriceDebt; double get stock; String? get categoryId; String get categoryName; String get image; DateTime? get updatedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.sellingPrice, _this.sellingPrice) || other.sellingPrice == _this.sellingPrice)&&(identical(other.sellingPriceDebt, _this.sellingPriceDebt) || other.sellingPriceDebt == _this.sellingPriceDebt)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.sku,_this.barcode,_this.name,_this.unit,_this.type,_this.purchasePrice,_this.sellingPrice,_this.sellingPriceDebt,_this.stock,_this.categoryId,_this.categoryName,_this.image,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, sku: ${_this.sku}, barcode: ${_this.barcode}, name: ${_this.name}, unit: ${_this.unit}, type: ${_this.type}, purchasePrice: ${_this.purchasePrice}, sellingPrice: ${_this.sellingPrice}, sellingPriceDebt: ${_this.sellingPriceDebt}, stock: ${_this.stock}, categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, image: ${_this.image}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String? barcode, String name, ProductUnit unit, ProductType type, int purchasePrice, int sellingPrice, int sellingPriceDebt, double stock, String? categoryId, String categoryName, String image, DateTime? updatedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? barcode = freezed,Object? name = null,Object? unit = null,Object? type = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? sellingPriceDebt = null,Object? stock = null,Object? categoryId = freezed,Object? categoryName = null,Object? image = null,Object? updatedAt = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,sellingPriceDebt: null == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String? barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String? categoryId,  String categoryName,  String image,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.categoryId,_that.categoryName,_that.image,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String? barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String? categoryId,  String categoryName,  String image,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.categoryId,_that.categoryName,_that.image,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String? barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String? categoryId,  String categoryName,  String image,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.categoryId,_that.categoryName,_that.image,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.sku, this.barcode, required this.name, this.unit = ProductUnit.pcs, this.type = ProductType.physical, this.purchasePrice = 0, required this.sellingPrice, required this.sellingPriceDebt, this.stock = 0, this.categoryId, this.categoryName = '', this.image = '', this.updatedAt}): super._();
  

@override final  String id;
@override final  String sku;
@override final  String? barcode;
@override final  String name;
@override@JsonKey() final  ProductUnit unit;
@override@JsonKey() final  ProductType type;
@override@JsonKey() final  int purchasePrice;
@override final  int sellingPrice;
@override final  int sellingPriceDebt;
@override@JsonKey() final  double stock;
@override final  String? categoryId;
@override@JsonKey() final  String categoryName;
@override@JsonKey() final  String image;
@override final  DateTime? updatedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.type, type) || other.type == type)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.sellingPriceDebt, sellingPriceDebt) || other.sellingPriceDebt == sellingPriceDebt)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.image, image) || other.image == image)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,sku,barcode,name,unit,type,purchasePrice,sellingPrice,sellingPriceDebt,stock,categoryId,categoryName,image,updatedAt);
}

@override
String toString() {
    return 'Product(id: $id, sku: $sku, barcode: $barcode, name: $name, unit: $unit, type: $type, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, sellingPriceDebt: $sellingPriceDebt, stock: $stock, categoryId: $categoryId, categoryName: $categoryName, image: $image, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String? barcode, String name, ProductUnit unit, ProductType type, int purchasePrice, int sellingPrice, int sellingPriceDebt, double stock, String? categoryId, String categoryName, String image, DateTime? updatedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? barcode = freezed,Object? name = null,Object? unit = null,Object? type = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? sellingPriceDebt = null,Object? stock = null,Object? categoryId = freezed,Object? categoryName = null,Object? image = null,Object? updatedAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,sellingPriceDebt: null == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ProductPatch {

 String? get sku; String? get barcode; String? get name; ProductUnit? get unit; int? get sellingPrice; int? get sellingPriceDebt; String? get category; String? get image; int? get purchasePrice; ProductType? get type;
/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPatchCopyWith<ProductPatch> get copyWith => _$ProductPatchCopyWithImpl<ProductPatch>(this as ProductPatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductPatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPatch&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.sellingPrice, _this.sellingPrice) || other.sellingPrice == _this.sellingPrice)&&(identical(other.sellingPriceDebt, _this.sellingPriceDebt) || other.sellingPriceDebt == _this.sellingPriceDebt)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.type, _this.type) || other.type == _this.type));
}


@override
int get hashCode {
  final _this = this as ProductPatch;
  return Object.hash(runtimeType,_this.sku,_this.barcode,_this.name,_this.unit,_this.sellingPrice,_this.sellingPriceDebt,_this.category,_this.image,_this.purchasePrice,_this.type);
}

@override
String toString() {
  final _this = this as ProductPatch;
  return 'ProductPatch(sku: ${_this.sku}, barcode: ${_this.barcode}, name: ${_this.name}, unit: ${_this.unit}, sellingPrice: ${_this.sellingPrice}, sellingPriceDebt: ${_this.sellingPriceDebt}, category: ${_this.category}, image: ${_this.image}, purchasePrice: ${_this.purchasePrice}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $ProductPatchCopyWith<$Res>  {
  factory $ProductPatchCopyWith(ProductPatch value, $Res Function(ProductPatch) _then) = _$ProductPatchCopyWithImpl;
@useResult
$Res call({
 String? sku, String? barcode, String? name, ProductUnit? unit, int? sellingPrice, int? sellingPriceDebt, String? category, String? image, int? purchasePrice, ProductType? type
});




}
/// @nodoc
class _$ProductPatchCopyWithImpl<$Res>
    implements $ProductPatchCopyWith<$Res> {
  _$ProductPatchCopyWithImpl(this._self, this._then);

  final ProductPatch _self;
  final $Res Function(ProductPatch) _then;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = freezed,Object? barcode = freezed,Object? name = freezed,Object? unit = freezed,Object? sellingPrice = freezed,Object? sellingPriceDebt = freezed,Object? category = freezed,Object? image = freezed,Object? purchasePrice = freezed,Object? type = freezed,}) {
  return _then(ProductPatch(
sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit?,sellingPrice: freezed == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int?,sellingPriceDebt: freezed == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductPatch].
extension ProductPatchPatterns on ProductPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPatch value)  $default,){
final _that = this;
switch (_that) {
case _ProductPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPatch value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sku,  String? barcode,  String? name,  ProductUnit? unit,  int? sellingPrice,  int? sellingPriceDebt,  String? category,  String? image,  int? purchasePrice,  ProductType? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.sellingPrice,_that.sellingPriceDebt,_that.category,_that.image,_that.purchasePrice,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sku,  String? barcode,  String? name,  ProductUnit? unit,  int? sellingPrice,  int? sellingPriceDebt,  String? category,  String? image,  int? purchasePrice,  ProductType? type)  $default,) {final _that = this;
switch (_that) {
case _ProductPatch():
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.sellingPrice,_that.sellingPriceDebt,_that.category,_that.image,_that.purchasePrice,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sku,  String? barcode,  String? name,  ProductUnit? unit,  int? sellingPrice,  int? sellingPriceDebt,  String? category,  String? image,  int? purchasePrice,  ProductType? type)?  $default,) {final _that = this;
switch (_that) {
case _ProductPatch() when $default != null:
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.sellingPrice,_that.sellingPriceDebt,_that.category,_that.image,_that.purchasePrice,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _ProductPatch implements ProductPatch {
  const _ProductPatch({this.sku, this.barcode, this.name, this.unit, this.sellingPrice, this.sellingPriceDebt, this.category, this.image, this.purchasePrice, this.type});
  

@override final  String? sku;
@override final  String? barcode;
@override final  String? name;
@override final  ProductUnit? unit;
@override final  int? sellingPrice;
@override final  int? sellingPriceDebt;
@override final  String? category;
@override final  String? image;
@override final  int? purchasePrice;
@override final  ProductType? type;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPatchCopyWith<_ProductPatch> get copyWith => __$ProductPatchCopyWithImpl<_ProductPatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPatch&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.sellingPriceDebt, sellingPriceDebt) || other.sellingPriceDebt == sellingPriceDebt)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sku,barcode,name,unit,sellingPrice,sellingPriceDebt,category,image,purchasePrice,type);
}

@override
String toString() {
    return 'ProductPatch(sku: $sku, barcode: $barcode, name: $name, unit: $unit, sellingPrice: $sellingPrice, sellingPriceDebt: $sellingPriceDebt, category: $category, image: $image, purchasePrice: $purchasePrice, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ProductPatchCopyWith<$Res> implements $ProductPatchCopyWith<$Res> {
  factory _$ProductPatchCopyWith(_ProductPatch value, $Res Function(_ProductPatch) _then) = __$ProductPatchCopyWithImpl;
@override @useResult
$Res call({
 String? sku, String? barcode, String? name, ProductUnit? unit, int? sellingPrice, int? sellingPriceDebt, String? category, String? image, int? purchasePrice, ProductType? type
});




}
/// @nodoc
class __$ProductPatchCopyWithImpl<$Res>
    implements _$ProductPatchCopyWith<$Res> {
  __$ProductPatchCopyWithImpl(this._self, this._then);

  final _ProductPatch _self;
  final $Res Function(_ProductPatch) _then;

/// Create a copy of ProductPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = freezed,Object? barcode = freezed,Object? name = freezed,Object? unit = freezed,Object? sellingPrice = freezed,Object? sellingPriceDebt = freezed,Object? category = freezed,Object? image = freezed,Object? purchasePrice = freezed,Object? type = freezed,}) {
  return _then(_ProductPatch(
sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit?,sellingPrice: freezed == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int?,sellingPriceDebt: freezed == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType?,
  ));
}


}

/// @nodoc
mixin _$NewProduct {

 String get sku; String get barcode; String get name; ProductUnit get unit; ProductType get type; int get purchasePrice; int get sellingPrice; int get sellingPriceDebt; double get stock; String get category; String get image;
/// Create a copy of NewProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewProductCopyWith<NewProduct> get copyWith => _$NewProductCopyWithImpl<NewProduct>(this as NewProduct, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NewProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewProduct&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.sellingPrice, _this.sellingPrice) || other.sellingPrice == _this.sellingPrice)&&(identical(other.sellingPriceDebt, _this.sellingPriceDebt) || other.sellingPriceDebt == _this.sellingPriceDebt)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.image, _this.image) || other.image == _this.image));
}


@override
int get hashCode {
  final _this = this as NewProduct;
  return Object.hash(runtimeType,_this.sku,_this.barcode,_this.name,_this.unit,_this.type,_this.purchasePrice,_this.sellingPrice,_this.sellingPriceDebt,_this.stock,_this.category,_this.image);
}

@override
String toString() {
  final _this = this as NewProduct;
  return 'NewProduct(sku: ${_this.sku}, barcode: ${_this.barcode}, name: ${_this.name}, unit: ${_this.unit}, type: ${_this.type}, purchasePrice: ${_this.purchasePrice}, sellingPrice: ${_this.sellingPrice}, sellingPriceDebt: ${_this.sellingPriceDebt}, stock: ${_this.stock}, category: ${_this.category}, image: ${_this.image})';
}


}

/// @nodoc
abstract mixin class $NewProductCopyWith<$Res>  {
  factory $NewProductCopyWith(NewProduct value, $Res Function(NewProduct) _then) = _$NewProductCopyWithImpl;
@useResult
$Res call({
 String sku, String barcode, String name, ProductUnit unit, ProductType type, int purchasePrice, int sellingPrice, int sellingPriceDebt, double stock, String category, String image
});




}
/// @nodoc
class _$NewProductCopyWithImpl<$Res>
    implements $NewProductCopyWith<$Res> {
  _$NewProductCopyWithImpl(this._self, this._then);

  final NewProduct _self;
  final $Res Function(NewProduct) _then;

/// Create a copy of NewProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? barcode = null,Object? name = null,Object? unit = null,Object? type = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? sellingPriceDebt = null,Object? stock = null,Object? category = null,Object? image = null,}) {
  return _then(NewProduct(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,sellingPriceDebt: null == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NewProduct].
extension NewProductPatterns on NewProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewProduct value)  $default,){
final _that = this;
switch (_that) {
case _NewProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewProduct value)?  $default,){
final _that = this;
switch (_that) {
case _NewProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String category,  String image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewProduct() when $default != null:
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.category,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String category,  String image)  $default,) {final _that = this;
switch (_that) {
case _NewProduct():
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.category,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String barcode,  String name,  ProductUnit unit,  ProductType type,  int purchasePrice,  int sellingPrice,  int sellingPriceDebt,  double stock,  String category,  String image)?  $default,) {final _that = this;
switch (_that) {
case _NewProduct() when $default != null:
return $default(_that.sku,_that.barcode,_that.name,_that.unit,_that.type,_that.purchasePrice,_that.sellingPrice,_that.sellingPriceDebt,_that.stock,_that.category,_that.image);case _:
  return null;

}
}

}

/// @nodoc


class _NewProduct implements NewProduct {
  const _NewProduct({required this.sku, this.barcode = '', required this.name, this.unit = ProductUnit.pcs, this.type = ProductType.physical, required this.purchasePrice, required this.sellingPrice, required this.sellingPriceDebt, required this.stock, required this.category, this.image = ''});
  

@override final  String sku;
@override@JsonKey() final  String barcode;
@override final  String name;
@override@JsonKey() final  ProductUnit unit;
@override@JsonKey() final  ProductType type;
@override final  int purchasePrice;
@override final  int sellingPrice;
@override final  int sellingPriceDebt;
@override final  double stock;
@override final  String category;
@override@JsonKey() final  String image;

/// Create a copy of NewProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewProductCopyWith<_NewProduct> get copyWith => __$NewProductCopyWithImpl<_NewProduct>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewProduct&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.type, type) || other.type == type)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.sellingPriceDebt, sellingPriceDebt) || other.sellingPriceDebt == sellingPriceDebt)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sku,barcode,name,unit,type,purchasePrice,sellingPrice,sellingPriceDebt,stock,category,image);
}

@override
String toString() {
    return 'NewProduct(sku: $sku, barcode: $barcode, name: $name, unit: $unit, type: $type, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, sellingPriceDebt: $sellingPriceDebt, stock: $stock, category: $category, image: $image)';
}


}

/// @nodoc
abstract mixin class _$NewProductCopyWith<$Res> implements $NewProductCopyWith<$Res> {
  factory _$NewProductCopyWith(_NewProduct value, $Res Function(_NewProduct) _then) = __$NewProductCopyWithImpl;
@override @useResult
$Res call({
 String sku, String barcode, String name, ProductUnit unit, ProductType type, int purchasePrice, int sellingPrice, int sellingPriceDebt, double stock, String category, String image
});




}
/// @nodoc
class __$NewProductCopyWithImpl<$Res>
    implements _$NewProductCopyWith<$Res> {
  __$NewProductCopyWithImpl(this._self, this._then);

  final _NewProduct _self;
  final $Res Function(_NewProduct) _then;

/// Create a copy of NewProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? barcode = null,Object? name = null,Object? unit = null,Object? type = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? sellingPriceDebt = null,Object? stock = null,Object? category = null,Object? image = null,}) {
  return _then(_NewProduct(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ProductUnit,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,sellingPriceDebt: null == sellingPriceDebt ? _self.sellingPriceDebt : sellingPriceDebt // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
