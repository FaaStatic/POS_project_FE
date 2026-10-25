// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardDay {

 DateTime get date; int get transactions; int get revenue; int get grossProfit;
/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDayCopyWith<DashboardDay> get copyWith => _$DashboardDayCopyWithImpl<DashboardDay>(this as DashboardDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.transactions, _this.transactions) || other.transactions == _this.transactions)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.grossProfit, _this.grossProfit) || other.grossProfit == _this.grossProfit));
}


@override
int get hashCode {
  final _this = this as DashboardDay;
  return Object.hash(runtimeType,_this.date,_this.transactions,_this.revenue,_this.grossProfit);
}

@override
String toString() {
  final _this = this as DashboardDay;
  return 'DashboardDay(date: ${_this.date}, transactions: ${_this.transactions}, revenue: ${_this.revenue}, grossProfit: ${_this.grossProfit})';
}


}

/// @nodoc
abstract mixin class $DashboardDayCopyWith<$Res>  {
  factory $DashboardDayCopyWith(DashboardDay value, $Res Function(DashboardDay) _then) = _$DashboardDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, int transactions, int revenue, int grossProfit
});




}
/// @nodoc
class _$DashboardDayCopyWithImpl<$Res>
    implements $DashboardDayCopyWith<$Res> {
  _$DashboardDayCopyWithImpl(this._self, this._then);

  final DashboardDay _self;
  final $Res Function(DashboardDay) _then;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? transactions = null,Object? revenue = null,Object? grossProfit = null,}) {
  return _then(DashboardDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardDay].
extension DashboardDayPatterns on DashboardDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardDay value)  $default,){
final _that = this;
switch (_that) {
case _DashboardDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardDay value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int transactions,  int revenue,  int grossProfit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
return $default(_that.date,_that.transactions,_that.revenue,_that.grossProfit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int transactions,  int revenue,  int grossProfit)  $default,) {final _that = this;
switch (_that) {
case _DashboardDay():
return $default(_that.date,_that.transactions,_that.revenue,_that.grossProfit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int transactions,  int revenue,  int grossProfit)?  $default,) {final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
return $default(_that.date,_that.transactions,_that.revenue,_that.grossProfit);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardDay implements DashboardDay {
  const _DashboardDay({required this.date, required this.transactions, required this.revenue, required this.grossProfit});
  

@override final  DateTime date;
@override final  int transactions;
@override final  int revenue;
@override final  int grossProfit;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDayCopyWith<_DashboardDay> get copyWith => __$DashboardDayCopyWithImpl<_DashboardDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardDay&&(identical(other.date, date) || other.date == date)&&(identical(other.transactions, transactions) || other.transactions == transactions)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.grossProfit, grossProfit) || other.grossProfit == grossProfit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,transactions,revenue,grossProfit);
}

@override
String toString() {
    return 'DashboardDay(date: $date, transactions: $transactions, revenue: $revenue, grossProfit: $grossProfit)';
}


}

/// @nodoc
abstract mixin class _$DashboardDayCopyWith<$Res> implements $DashboardDayCopyWith<$Res> {
  factory _$DashboardDayCopyWith(_DashboardDay value, $Res Function(_DashboardDay) _then) = __$DashboardDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int transactions, int revenue, int grossProfit
});




}
/// @nodoc
class __$DashboardDayCopyWithImpl<$Res>
    implements _$DashboardDayCopyWith<$Res> {
  __$DashboardDayCopyWithImpl(this._self, this._then);

  final _DashboardDay _self;
  final $Res Function(_DashboardDay) _then;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? transactions = null,Object? revenue = null,Object? grossProfit = null,}) {
  return _then(_DashboardDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DashboardSummary {

 DateTime get start; DateTime get end; int get transactions; int get revenue; int get grossProfit; int get debtOutstanding; int get debtNew; int get debtPaid; int get openStockConflicts; List<DashboardDay> get daily; List<({String name, double qty, int total,})> get topProducts; List<({int count, String method, int total,})> get paymentMethods; List<({int count, String platform,})> get devicesOnline;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.transactions, _this.transactions) || other.transactions == _this.transactions)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.grossProfit, _this.grossProfit) || other.grossProfit == _this.grossProfit)&&(identical(other.debtOutstanding, _this.debtOutstanding) || other.debtOutstanding == _this.debtOutstanding)&&(identical(other.debtNew, _this.debtNew) || other.debtNew == _this.debtNew)&&(identical(other.debtPaid, _this.debtPaid) || other.debtPaid == _this.debtPaid)&&(identical(other.openStockConflicts, _this.openStockConflicts) || other.openStockConflicts == _this.openStockConflicts)&&const DeepCollectionEquality().equals(other.daily, _this.daily)&&const DeepCollectionEquality().equals(other.topProducts, _this.topProducts)&&const DeepCollectionEquality().equals(other.paymentMethods, _this.paymentMethods)&&const DeepCollectionEquality().equals(other.devicesOnline, _this.devicesOnline));
}


@override
int get hashCode {
  final _this = this as DashboardSummary;
  return Object.hash(runtimeType,_this.start,_this.end,_this.transactions,_this.revenue,_this.grossProfit,_this.debtOutstanding,_this.debtNew,_this.debtPaid,_this.openStockConflicts,const DeepCollectionEquality().hash(_this.daily),const DeepCollectionEquality().hash(_this.topProducts),const DeepCollectionEquality().hash(_this.paymentMethods),const DeepCollectionEquality().hash(_this.devicesOnline));
}

@override
String toString() {
  final _this = this as DashboardSummary;
  return 'DashboardSummary(start: ${_this.start}, end: ${_this.end}, transactions: ${_this.transactions}, revenue: ${_this.revenue}, grossProfit: ${_this.grossProfit}, debtOutstanding: ${_this.debtOutstanding}, debtNew: ${_this.debtNew}, debtPaid: ${_this.debtPaid}, openStockConflicts: ${_this.openStockConflicts}, daily: ${_this.daily}, topProducts: ${_this.topProducts}, paymentMethods: ${_this.paymentMethods}, devicesOnline: ${_this.devicesOnline})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end, int transactions, int revenue, int grossProfit, int debtOutstanding, int debtNew, int debtPaid, int openStockConflicts, List<DashboardDay> daily, List<({String name, double qty, int total,})> topProducts, List<({int count, String method, int total,})> paymentMethods, List<({int count, String platform,})> devicesOnline
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? transactions = null,Object? revenue = null,Object? grossProfit = null,Object? debtOutstanding = null,Object? debtNew = null,Object? debtPaid = null,Object? openStockConflicts = null,Object? daily = null,Object? topProducts = null,Object? paymentMethods = null,Object? devicesOnline = null,}) {
  return _then(DashboardSummary(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as int,debtOutstanding: null == debtOutstanding ? _self.debtOutstanding : debtOutstanding // ignore: cast_nullable_to_non_nullable
as int,debtNew: null == debtNew ? _self.debtNew : debtNew // ignore: cast_nullable_to_non_nullable
as int,debtPaid: null == debtPaid ? _self.debtPaid : debtPaid // ignore: cast_nullable_to_non_nullable
as int,openStockConflicts: null == openStockConflicts ? _self.openStockConflicts : openStockConflicts // ignore: cast_nullable_to_non_nullable
as int,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DashboardDay>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<({String name, double qty, int total,})>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<({int count, String method, int total,})>,devicesOnline: null == devicesOnline ? _self.devicesOnline : devicesOnline // ignore: cast_nullable_to_non_nullable
as List<({int count, String platform,})>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  int transactions,  int revenue,  int grossProfit,  int debtOutstanding,  int debtNew,  int debtPaid,  int openStockConflicts,  List<DashboardDay> daily,  List<({String name, double qty, int total,})> topProducts,  List<({int count, String method, int total,})> paymentMethods,  List<({int count, String platform,})> devicesOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.start,_that.end,_that.transactions,_that.revenue,_that.grossProfit,_that.debtOutstanding,_that.debtNew,_that.debtPaid,_that.openStockConflicts,_that.daily,_that.topProducts,_that.paymentMethods,_that.devicesOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  int transactions,  int revenue,  int grossProfit,  int debtOutstanding,  int debtNew,  int debtPaid,  int openStockConflicts,  List<DashboardDay> daily,  List<({String name, double qty, int total,})> topProducts,  List<({int count, String method, int total,})> paymentMethods,  List<({int count, String platform,})> devicesOnline)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.start,_that.end,_that.transactions,_that.revenue,_that.grossProfit,_that.debtOutstanding,_that.debtNew,_that.debtPaid,_that.openStockConflicts,_that.daily,_that.topProducts,_that.paymentMethods,_that.devicesOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end,  int transactions,  int revenue,  int grossProfit,  int debtOutstanding,  int debtNew,  int debtPaid,  int openStockConflicts,  List<DashboardDay> daily,  List<({String name, double qty, int total,})> topProducts,  List<({int count, String method, int total,})> paymentMethods,  List<({int count, String platform,})> devicesOnline)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.start,_that.end,_that.transactions,_that.revenue,_that.grossProfit,_that.debtOutstanding,_that.debtNew,_that.debtPaid,_that.openStockConflicts,_that.daily,_that.topProducts,_that.paymentMethods,_that.devicesOnline);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.start, required this.end, required this.transactions, required this.revenue, required this.grossProfit, required this.debtOutstanding, required this.debtNew, required this.debtPaid, required this.openStockConflicts,  List<DashboardDay> daily = const [],  List<({String name, double qty, int total,})> topProducts = const [],  List<({int count, String method, int total,})> paymentMethods = const [],  List<({int count, String platform,})> devicesOnline = const []}): _daily = daily,_topProducts = topProducts,_paymentMethods = paymentMethods,_devicesOnline = devicesOnline;
  

@override final  DateTime start;
@override final  DateTime end;
@override final  int transactions;
@override final  int revenue;
@override final  int grossProfit;
@override final  int debtOutstanding;
@override final  int debtNew;
@override final  int debtPaid;
@override final  int openStockConflicts;
 final  List<DashboardDay> _daily;
@override@JsonKey() List<DashboardDay> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

 final  List<({String name, double qty, int total,})> _topProducts;
@override@JsonKey() List<({String name, double qty, int total,})> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}

 final  List<({int count, String method, int total,})> _paymentMethods;
@override@JsonKey() List<({int count, String method, int total,})> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}

 final  List<({int count, String platform,})> _devicesOnline;
@override@JsonKey() List<({int count, String platform,})> get devicesOnline {
  if (_devicesOnline is EqualUnmodifiableListView) return _devicesOnline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devicesOnline);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.transactions, transactions) || other.transactions == transactions)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.grossProfit, grossProfit) || other.grossProfit == grossProfit)&&(identical(other.debtOutstanding, debtOutstanding) || other.debtOutstanding == debtOutstanding)&&(identical(other.debtNew, debtNew) || other.debtNew == debtNew)&&(identical(other.debtPaid, debtPaid) || other.debtPaid == debtPaid)&&(identical(other.openStockConflicts, openStockConflicts) || other.openStockConflicts == openStockConflicts)&&const DeepCollectionEquality().equals(other.daily, _daily)&&const DeepCollectionEquality().equals(other.topProducts, _topProducts)&&const DeepCollectionEquality().equals(other.paymentMethods, _paymentMethods)&&const DeepCollectionEquality().equals(other.devicesOnline, _devicesOnline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,start,end,transactions,revenue,grossProfit,debtOutstanding,debtNew,debtPaid,openStockConflicts,const DeepCollectionEquality().hash(_daily),const DeepCollectionEquality().hash(_topProducts),const DeepCollectionEquality().hash(_paymentMethods),const DeepCollectionEquality().hash(_devicesOnline));
}

@override
String toString() {
    return 'DashboardSummary(start: $start, end: $end, transactions: $transactions, revenue: $revenue, grossProfit: $grossProfit, debtOutstanding: $debtOutstanding, debtNew: $debtNew, debtPaid: $debtPaid, openStockConflicts: $openStockConflicts, daily: $daily, topProducts: $topProducts, paymentMethods: $paymentMethods, devicesOnline: $devicesOnline)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end, int transactions, int revenue, int grossProfit, int debtOutstanding, int debtNew, int debtPaid, int openStockConflicts, List<DashboardDay> daily, List<({String name, double qty, int total,})> topProducts, List<({int count, String method, int total,})> paymentMethods, List<({int count, String platform,})> devicesOnline
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? transactions = null,Object? revenue = null,Object? grossProfit = null,Object? debtOutstanding = null,Object? debtNew = null,Object? debtPaid = null,Object? openStockConflicts = null,Object? daily = null,Object? topProducts = null,Object? paymentMethods = null,Object? devicesOnline = null,}) {
  return _then(_DashboardSummary(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as int,debtOutstanding: null == debtOutstanding ? _self.debtOutstanding : debtOutstanding // ignore: cast_nullable_to_non_nullable
as int,debtNew: null == debtNew ? _self.debtNew : debtNew // ignore: cast_nullable_to_non_nullable
as int,debtPaid: null == debtPaid ? _self.debtPaid : debtPaid // ignore: cast_nullable_to_non_nullable
as int,openStockConflicts: null == openStockConflicts ? _self.openStockConflicts : openStockConflicts // ignore: cast_nullable_to_non_nullable
as int,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DashboardDay>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<({String name, double qty, int total,})>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<({int count, String method, int total,})>,devicesOnline: null == devicesOnline ? _self._devicesOnline : devicesOnline // ignore: cast_nullable_to_non_nullable
as List<({int count, String platform,})>,
  ));
}


}

// dart format on
