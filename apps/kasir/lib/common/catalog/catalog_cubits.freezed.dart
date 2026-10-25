// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_cubits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsState {

 bool get loading; List<Product> get products; List<Category> get categories; String get query; String? get categoryId;
/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsStateCopyWith<ProductsState> get copyWith => _$ProductsStateCopyWithImpl<ProductsState>(this as ProductsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}


@override
int get hashCode {
  final _this = this as ProductsState;
  return Object.hash(runtimeType,_this.loading,const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.categories),_this.query,_this.categoryId);
}

@override
String toString() {
  final _this = this as ProductsState;
  return 'ProductsState(loading: ${_this.loading}, products: ${_this.products}, categories: ${_this.categories}, query: ${_this.query}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $ProductsStateCopyWith<$Res>  {
  factory $ProductsStateCopyWith(ProductsState value, $Res Function(ProductsState) _then) = _$ProductsStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Product> products, List<Category> categories, String query, String? categoryId
});




}
/// @nodoc
class _$ProductsStateCopyWithImpl<$Res>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._self, this._then);

  final ProductsState _self;
  final $Res Function(ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? products = null,Object? categories = null,Object? query = null,Object? categoryId = freezed,}) {
  return _then(ProductsState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductsState].
extension ProductsStatePatterns on ProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductsState value)  $default,){
final _that = this;
switch (_that) {
case _ProductsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Product> products,  List<Category> categories,  String query,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.loading,_that.products,_that.categories,_that.query,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Product> products,  List<Category> categories,  String query,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _ProductsState():
return $default(_that.loading,_that.products,_that.categories,_that.query,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Product> products,  List<Category> categories,  String query,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.loading,_that.products,_that.categories,_that.query,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _ProductsState implements ProductsState {
  const _ProductsState({this.loading = true,  List<Product> products = const [],  List<Category> categories = const [], this.query = '', this.categoryId}): _products = products,_categories = categories;
  

@override@JsonKey() final  bool loading;
 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  String query;
@override final  String? categoryId;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductsStateCopyWith<_ProductsState> get copyWith => __$ProductsStateCopyWithImpl<_ProductsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductsState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.products, _products)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.query, query) || other.query == query)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_categories),query,categoryId);
}

@override
String toString() {
    return 'ProductsState(loading: $loading, products: $products, categories: $categories, query: $query, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ProductsStateCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory _$ProductsStateCopyWith(_ProductsState value, $Res Function(_ProductsState) _then) = __$ProductsStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Product> products, List<Category> categories, String query, String? categoryId
});




}
/// @nodoc
class __$ProductsStateCopyWithImpl<$Res>
    implements _$ProductsStateCopyWith<$Res> {
  __$ProductsStateCopyWithImpl(this._self, this._then);

  final _ProductsState _self;
  final $Res Function(_ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? products = null,Object? categories = null,Object? query = null,Object? categoryId = freezed,}) {
  return _then(_ProductsState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CustomersState {

 bool get loading; List<Customer> get customers; String get query;
/// Create a copy of CustomersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomersStateCopyWith<CustomersState> get copyWith => _$CustomersStateCopyWithImpl<CustomersState>(this as CustomersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomersState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.customers, _this.customers)&&(identical(other.query, _this.query) || other.query == _this.query));
}


@override
int get hashCode {
  final _this = this as CustomersState;
  return Object.hash(runtimeType,_this.loading,const DeepCollectionEquality().hash(_this.customers),_this.query);
}

@override
String toString() {
  final _this = this as CustomersState;
  return 'CustomersState(loading: ${_this.loading}, customers: ${_this.customers}, query: ${_this.query})';
}


}

/// @nodoc
abstract mixin class $CustomersStateCopyWith<$Res>  {
  factory $CustomersStateCopyWith(CustomersState value, $Res Function(CustomersState) _then) = _$CustomersStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Customer> customers, String query
});




}
/// @nodoc
class _$CustomersStateCopyWithImpl<$Res>
    implements $CustomersStateCopyWith<$Res> {
  _$CustomersStateCopyWithImpl(this._self, this._then);

  final CustomersState _self;
  final $Res Function(CustomersState) _then;

/// Create a copy of CustomersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? customers = null,Object? query = null,}) {
  return _then(CustomersState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,customers: null == customers ? _self.customers : customers // ignore: cast_nullable_to_non_nullable
as List<Customer>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomersState].
extension CustomersStatePatterns on CustomersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomersState value)  $default,){
final _that = this;
switch (_that) {
case _CustomersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomersState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Customer> customers,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomersState() when $default != null:
return $default(_that.loading,_that.customers,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Customer> customers,  String query)  $default,) {final _that = this;
switch (_that) {
case _CustomersState():
return $default(_that.loading,_that.customers,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Customer> customers,  String query)?  $default,) {final _that = this;
switch (_that) {
case _CustomersState() when $default != null:
return $default(_that.loading,_that.customers,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _CustomersState implements CustomersState {
  const _CustomersState({this.loading = true,  List<Customer> customers = const [], this.query = ''}): _customers = customers;
  

@override@JsonKey() final  bool loading;
 final  List<Customer> _customers;
@override@JsonKey() List<Customer> get customers {
  if (_customers is EqualUnmodifiableListView) return _customers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customers);
}

@override@JsonKey() final  String query;

/// Create a copy of CustomersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomersStateCopyWith<_CustomersState> get copyWith => __$CustomersStateCopyWithImpl<_CustomersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomersState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.customers, _customers)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_customers),query);
}

@override
String toString() {
    return 'CustomersState(loading: $loading, customers: $customers, query: $query)';
}


}

/// @nodoc
abstract mixin class _$CustomersStateCopyWith<$Res> implements $CustomersStateCopyWith<$Res> {
  factory _$CustomersStateCopyWith(_CustomersState value, $Res Function(_CustomersState) _then) = __$CustomersStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Customer> customers, String query
});




}
/// @nodoc
class __$CustomersStateCopyWithImpl<$Res>
    implements _$CustomersStateCopyWith<$Res> {
  __$CustomersStateCopyWithImpl(this._self, this._then);

  final _CustomersState _self;
  final $Res Function(_CustomersState) _then;

/// Create a copy of CustomersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? customers = null,Object? query = null,}) {
  return _then(_CustomersState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,customers: null == customers ? _self._customers : customers // ignore: cast_nullable_to_non_nullable
as List<Customer>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
