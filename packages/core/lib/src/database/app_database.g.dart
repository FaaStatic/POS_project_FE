// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<int> unit = GeneratedColumn<int>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<int> sellingPrice = GeneratedColumn<int>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellingPriceDebtMeta = const VerificationMeta(
    'sellingPriceDebt',
  );
  @override
  late final GeneratedColumn<int> sellingPriceDebt = GeneratedColumn<int>(
    'selling_price_debt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _soldCountMeta = const VerificationMeta(
    'soldCount',
  );
  @override
  late final GeneratedColumn<int> soldCount = GeneratedColumn<int>(
    'sold_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sku,
    barcode,
    name,
    unit,
    type,
    purchasePrice,
    sellingPrice,
    sellingPriceDebt,
    stock,
    categoryId,
    categoryName,
    image,
    soldCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('selling_price_debt')) {
      context.handle(
        _sellingPriceDebtMeta,
        sellingPriceDebt.isAcceptableOrUnknown(
          data['selling_price_debt']!,
          _sellingPriceDebtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceDebtMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('sold_count')) {
      context.handle(
        _soldCountMeta,
        soldCount.isAcceptableOrUnknown(data['sold_count']!, _soldCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price'],
      )!,
      sellingPriceDebt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_debt'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      soldCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sold_count'],
      )!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final String id;
  final String sku;
  final String? barcode;
  final String name;
  final int unit;
  final int type;
  final int purchasePrice;
  final int sellingPrice;
  final int sellingPriceDebt;
  final double stock;
  final String? categoryId;
  final String categoryName;
  final String image;

  /// Local sales count; drives "most sold first" ordering. Survives cache refresh.
  final int soldCount;
  const CachedProduct({
    required this.id,
    required this.sku,
    this.barcode,
    required this.name,
    required this.unit,
    required this.type,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.sellingPriceDebt,
    required this.stock,
    this.categoryId,
    required this.categoryName,
    required this.image,
    required this.soldCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sku'] = Variable<String>(sku);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<int>(unit);
    map['type'] = Variable<int>(type);
    map['purchase_price'] = Variable<int>(purchasePrice);
    map['selling_price'] = Variable<int>(sellingPrice);
    map['selling_price_debt'] = Variable<int>(sellingPriceDebt);
    map['stock'] = Variable<double>(stock);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['category_name'] = Variable<String>(categoryName);
    map['image'] = Variable<String>(image);
    map['sold_count'] = Variable<int>(soldCount);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      id: Value(id),
      sku: Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      name: Value(name),
      unit: Value(unit),
      type: Value(type),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      sellingPriceDebt: Value(sellingPriceDebt),
      stock: Value(stock),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categoryName: Value(categoryName),
      image: Value(image),
      soldCount: Value(soldCount),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      id: serializer.fromJson<String>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<int>(json['unit']),
      type: serializer.fromJson<int>(json['type']),
      purchasePrice: serializer.fromJson<int>(json['purchasePrice']),
      sellingPrice: serializer.fromJson<int>(json['sellingPrice']),
      sellingPriceDebt: serializer.fromJson<int>(json['sellingPriceDebt']),
      stock: serializer.fromJson<double>(json['stock']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      image: serializer.fromJson<String>(json['image']),
      soldCount: serializer.fromJson<int>(json['soldCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sku': serializer.toJson<String>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<int>(unit),
      'type': serializer.toJson<int>(type),
      'purchasePrice': serializer.toJson<int>(purchasePrice),
      'sellingPrice': serializer.toJson<int>(sellingPrice),
      'sellingPriceDebt': serializer.toJson<int>(sellingPriceDebt),
      'stock': serializer.toJson<double>(stock),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'image': serializer.toJson<String>(image),
      'soldCount': serializer.toJson<int>(soldCount),
    };
  }

  CachedProduct copyWith({
    String? id,
    String? sku,
    Value<String?> barcode = const Value.absent(),
    String? name,
    int? unit,
    int? type,
    int? purchasePrice,
    int? sellingPrice,
    int? sellingPriceDebt,
    double? stock,
    Value<String?> categoryId = const Value.absent(),
    String? categoryName,
    String? image,
    int? soldCount,
  }) => CachedProduct(
    id: id ?? this.id,
    sku: sku ?? this.sku,
    barcode: barcode.present ? barcode.value : this.barcode,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    type: type ?? this.type,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    sellingPriceDebt: sellingPriceDebt ?? this.sellingPriceDebt,
    stock: stock ?? this.stock,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    image: image ?? this.image,
    soldCount: soldCount ?? this.soldCount,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      type: data.type.present ? data.type.value : this.type,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      sellingPriceDebt: data.sellingPriceDebt.present
          ? data.sellingPriceDebt.value
          : this.sellingPriceDebt,
      stock: data.stock.present ? data.stock.value : this.stock,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      image: data.image.present ? data.image.value : this.image,
      soldCount: data.soldCount.present ? data.soldCount.value : this.soldCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('type: $type, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('sellingPriceDebt: $sellingPriceDebt, ')
          ..write('stock: $stock, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('image: $image, ')
          ..write('soldCount: $soldCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sku,
    barcode,
    name,
    unit,
    type,
    purchasePrice,
    sellingPrice,
    sellingPriceDebt,
    stock,
    categoryId,
    categoryName,
    image,
    soldCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.type == this.type &&
          other.purchasePrice == this.purchasePrice &&
          other.sellingPrice == this.sellingPrice &&
          other.sellingPriceDebt == this.sellingPriceDebt &&
          other.stock == this.stock &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.image == this.image &&
          other.soldCount == this.soldCount);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<String> id;
  final Value<String> sku;
  final Value<String?> barcode;
  final Value<String> name;
  final Value<int> unit;
  final Value<int> type;
  final Value<int> purchasePrice;
  final Value<int> sellingPrice;
  final Value<int> sellingPriceDebt;
  final Value<double> stock;
  final Value<String?> categoryId;
  final Value<String> categoryName;
  final Value<String> image;
  final Value<int> soldCount;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.type = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.sellingPriceDebt = const Value.absent(),
    this.stock = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.image = const Value.absent(),
    this.soldCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String id,
    required String sku,
    this.barcode = const Value.absent(),
    required String name,
    this.unit = const Value.absent(),
    this.type = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    required int sellingPrice,
    required int sellingPriceDebt,
    this.stock = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.image = const Value.absent(),
    this.soldCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sku = Value(sku),
       name = Value(name),
       sellingPrice = Value(sellingPrice),
       sellingPriceDebt = Value(sellingPriceDebt);
  static Insertable<CachedProduct> custom({
    Expression<String>? id,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<int>? unit,
    Expression<int>? type,
    Expression<int>? purchasePrice,
    Expression<int>? sellingPrice,
    Expression<int>? sellingPriceDebt,
    Expression<double>? stock,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? image,
    Expression<int>? soldCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (type != null) 'type': type,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (sellingPriceDebt != null) 'selling_price_debt': sellingPriceDebt,
      if (stock != null) 'stock': stock,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (image != null) 'image': image,
      if (soldCount != null) 'sold_count': soldCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? sku,
    Value<String?>? barcode,
    Value<String>? name,
    Value<int>? unit,
    Value<int>? type,
    Value<int>? purchasePrice,
    Value<int>? sellingPrice,
    Value<int>? sellingPriceDebt,
    Value<double>? stock,
    Value<String?>? categoryId,
    Value<String>? categoryName,
    Value<String>? image,
    Value<int>? soldCount,
    Value<int>? rowid,
  }) {
    return CachedProductsCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      type: type ?? this.type,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      sellingPriceDebt: sellingPriceDebt ?? this.sellingPriceDebt,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      image: image ?? this.image,
      soldCount: soldCount ?? this.soldCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<int>(sellingPrice.value);
    }
    if (sellingPriceDebt.present) {
      map['selling_price_debt'] = Variable<int>(sellingPriceDebt.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (soldCount.present) {
      map['sold_count'] = Variable<int>(soldCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('type: $type, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('sellingPriceDebt: $sellingPriceDebt, ')
          ..write('stock: $stock, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('image: $image, ')
          ..write('soldCount: $soldCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCategoriesTable extends CachedCategories
    with TableInfo<$CachedCategoriesTable, CachedCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCountMeta = const VerificationMeta(
    'productCount',
  );
  @override
  late final GeneratedColumn<int> productCount = GeneratedColumn<int>(
    'product_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, productCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('product_count')) {
      context.handle(
        _productCountMeta,
        productCount.isAcceptableOrUnknown(
          data['product_count']!,
          _productCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      productCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_count'],
      )!,
    );
  }

  @override
  $CachedCategoriesTable createAlias(String alias) {
    return $CachedCategoriesTable(attachedDatabase, alias);
  }
}

class CachedCategory extends DataClass implements Insertable<CachedCategory> {
  final String id;
  final String name;
  final int productCount;
  const CachedCategory({
    required this.id,
    required this.name,
    required this.productCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['product_count'] = Variable<int>(productCount);
    return map;
  }

  CachedCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CachedCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      productCount: Value(productCount),
    );
  }

  factory CachedCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      productCount: serializer.fromJson<int>(json['productCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'productCount': serializer.toJson<int>(productCount),
    };
  }

  CachedCategory copyWith({String? id, String? name, int? productCount}) =>
      CachedCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        productCount: productCount ?? this.productCount,
      );
  CachedCategory copyWithCompanion(CachedCategoriesCompanion data) {
    return CachedCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      productCount: data.productCount.present
          ? data.productCount.value
          : this.productCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('productCount: $productCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, productCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.productCount == this.productCount);
}

class CachedCategoriesCompanion extends UpdateCompanion<CachedCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> productCount;
  final Value<int> rowid;
  const CachedCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.productCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCategoriesCompanion.insert({
    required String id,
    required String name,
    this.productCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CachedCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? productCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (productCount != null) 'product_count': productCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? productCount,
    Value<int>? rowid,
  }) {
    return CachedCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      productCount: productCount ?? this.productCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (productCount.present) {
      map['product_count'] = Variable<int>(productCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('productCount: $productCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCustomersTable extends CachedCustomers
    with TableInfo<$CachedCustomersTable, CachedCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outstandingDebtMeta = const VerificationMeta(
    'outstandingDebt',
  );
  @override
  late final GeneratedColumn<int> outstandingDebt = GeneratedColumn<int>(
    'outstanding_debt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    outstandingDebt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('outstanding_debt')) {
      context.handle(
        _outstandingDebtMeta,
        outstandingDebt.isAcceptableOrUnknown(
          data['outstanding_debt']!,
          _outstandingDebtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      outstandingDebt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outstanding_debt'],
      )!,
    );
  }

  @override
  $CachedCustomersTable createAlias(String alias) {
    return $CachedCustomersTable(attachedDatabase, alias);
  }
}

class CachedCustomer extends DataClass implements Insertable<CachedCustomer> {
  final String id;
  final String name;
  final String phone;
  final String address;
  final int outstandingDebt;
  const CachedCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.outstandingDebt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['outstanding_debt'] = Variable<int>(outstandingDebt);
    return map;
  }

  CachedCustomersCompanion toCompanion(bool nullToAbsent) {
    return CachedCustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      outstandingDebt: Value(outstandingDebt),
    );
  }

  factory CachedCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCustomer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      outstandingDebt: serializer.fromJson<int>(json['outstandingDebt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'outstandingDebt': serializer.toJson<int>(outstandingDebt),
    };
  }

  CachedCustomer copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    int? outstandingDebt,
  }) => CachedCustomer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    outstandingDebt: outstandingDebt ?? this.outstandingDebt,
  );
  CachedCustomer copyWithCompanion(CachedCustomersCompanion data) {
    return CachedCustomer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      outstandingDebt: data.outstandingDebt.present
          ? data.outstandingDebt.value
          : this.outstandingDebt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('outstandingDebt: $outstandingDebt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, address, outstandingDebt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCustomer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.outstandingDebt == this.outstandingDebt);
}

class CachedCustomersCompanion extends UpdateCompanion<CachedCustomer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<int> outstandingDebt;
  final Value<int> rowid;
  const CachedCustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.outstandingDebt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCustomersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.outstandingDebt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CachedCustomer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? outstandingDebt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (outstandingDebt != null) 'outstanding_debt': outstandingDebt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<int>? outstandingDebt,
    Value<int>? rowid,
  }) {
    return CachedCustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      outstandingDebt: outstandingDebt ?? this.outstandingDebt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (outstandingDebt.present) {
      map['outstanding_debt'] = Variable<int>(outstandingDebt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('outstandingDebt: $outstandingDebt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, SaleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientRefMeta = const VerificationMeta(
    'clientRef',
  );
  @override
  late final GeneratedColumn<String> clientRef = GeneratedColumn<String>(
    'client_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<int> method = GeneratedColumn<int>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashierNameMeta = const VerificationMeta(
    'cashierName',
  );
  @override
  late final GeneratedColumn<String> cashierName = GeneratedColumn<String>(
    'cashier_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linesJsonMeta = const VerificationMeta(
    'linesJson',
  );
  @override
  late final GeneratedColumn<String> linesJson = GeneratedColumn<String>(
    'lines_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockConflictMeta = const VerificationMeta(
    'stockConflict',
  );
  @override
  late final GeneratedColumn<bool> stockConflict = GeneratedColumn<bool>(
    'stock_conflict',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stock_conflict" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientRef,
    receiptNumber,
    createdAt,
    method,
    customerId,
    customerName,
    cashierName,
    total,
    linesJson,
    status,
    error,
    transactionId,
    stockConflict,
    cancelReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_ref')) {
      context.handle(
        _clientRefMeta,
        clientRef.isAcceptableOrUnknown(data['client_ref']!, _clientRefMeta),
      );
    } else if (isInserting) {
      context.missing(_clientRefMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('cashier_name')) {
      context.handle(
        _cashierNameMeta,
        cashierName.isAcceptableOrUnknown(
          data['cashier_name']!,
          _cashierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cashierNameMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('lines_json')) {
      context.handle(
        _linesJsonMeta,
        linesJson.isAcceptableOrUnknown(data['lines_json']!, _linesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_linesJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('stock_conflict')) {
      context.handle(
        _stockConflictMeta,
        stockConflict.isAcceptableOrUnknown(
          data['stock_conflict']!,
          _stockConflictMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientRef};
  @override
  SaleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleRow(
      clientRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_ref'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}method'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      cashierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_name'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      linesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lines_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      stockConflict: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stock_conflict'],
      )!,
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class SaleRow extends DataClass implements Insertable<SaleRow> {
  final String clientRef;

  /// `OFF-<device>-<seq>` until synced, then the server invoice.
  final String receiptNumber;
  final DateTime createdAt;
  final int method;
  final String? customerId;
  final String? customerName;
  final String cashierName;
  final int total;

  /// JSON list of sale lines (product, name, qty, unit price, destination).
  final String linesJson;

  /// 0 pending, 1 synced, 2 failed (not retryable), 3 cancelled.
  final int status;
  final String? error;
  final String? transactionId;
  final bool stockConflict;
  final String? cancelReason;
  const SaleRow({
    required this.clientRef,
    required this.receiptNumber,
    required this.createdAt,
    required this.method,
    this.customerId,
    this.customerName,
    required this.cashierName,
    required this.total,
    required this.linesJson,
    required this.status,
    this.error,
    this.transactionId,
    required this.stockConflict,
    this.cancelReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_ref'] = Variable<String>(clientRef);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['method'] = Variable<int>(method);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['cashier_name'] = Variable<String>(cashierName);
    map['total'] = Variable<int>(total);
    map['lines_json'] = Variable<String>(linesJson);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['stock_conflict'] = Variable<bool>(stockConflict);
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      clientRef: Value(clientRef),
      receiptNumber: Value(receiptNumber),
      createdAt: Value(createdAt),
      method: Value(method),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      cashierName: Value(cashierName),
      total: Value(total),
      linesJson: Value(linesJson),
      status: Value(status),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      stockConflict: Value(stockConflict),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
    );
  }

  factory SaleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleRow(
      clientRef: serializer.fromJson<String>(json['clientRef']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      method: serializer.fromJson<int>(json['method']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      cashierName: serializer.fromJson<String>(json['cashierName']),
      total: serializer.fromJson<int>(json['total']),
      linesJson: serializer.fromJson<String>(json['linesJson']),
      status: serializer.fromJson<int>(json['status']),
      error: serializer.fromJson<String?>(json['error']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      stockConflict: serializer.fromJson<bool>(json['stockConflict']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientRef': serializer.toJson<String>(clientRef),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'method': serializer.toJson<int>(method),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String?>(customerName),
      'cashierName': serializer.toJson<String>(cashierName),
      'total': serializer.toJson<int>(total),
      'linesJson': serializer.toJson<String>(linesJson),
      'status': serializer.toJson<int>(status),
      'error': serializer.toJson<String?>(error),
      'transactionId': serializer.toJson<String?>(transactionId),
      'stockConflict': serializer.toJson<bool>(stockConflict),
      'cancelReason': serializer.toJson<String?>(cancelReason),
    };
  }

  SaleRow copyWith({
    String? clientRef,
    String? receiptNumber,
    DateTime? createdAt,
    int? method,
    Value<String?> customerId = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    String? cashierName,
    int? total,
    String? linesJson,
    int? status,
    Value<String?> error = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
    bool? stockConflict,
    Value<String?> cancelReason = const Value.absent(),
  }) => SaleRow(
    clientRef: clientRef ?? this.clientRef,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    createdAt: createdAt ?? this.createdAt,
    method: method ?? this.method,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName.present ? customerName.value : this.customerName,
    cashierName: cashierName ?? this.cashierName,
    total: total ?? this.total,
    linesJson: linesJson ?? this.linesJson,
    status: status ?? this.status,
    error: error.present ? error.value : this.error,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    stockConflict: stockConflict ?? this.stockConflict,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
  );
  SaleRow copyWithCompanion(SalesCompanion data) {
    return SaleRow(
      clientRef: data.clientRef.present ? data.clientRef.value : this.clientRef,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      method: data.method.present ? data.method.value : this.method,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      cashierName: data.cashierName.present
          ? data.cashierName.value
          : this.cashierName,
      total: data.total.present ? data.total.value : this.total,
      linesJson: data.linesJson.present ? data.linesJson.value : this.linesJson,
      status: data.status.present ? data.status.value : this.status,
      error: data.error.present ? data.error.value : this.error,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      stockConflict: data.stockConflict.present
          ? data.stockConflict.value
          : this.stockConflict,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleRow(')
          ..write('clientRef: $clientRef, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('method: $method, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('cashierName: $cashierName, ')
          ..write('total: $total, ')
          ..write('linesJson: $linesJson, ')
          ..write('status: $status, ')
          ..write('error: $error, ')
          ..write('transactionId: $transactionId, ')
          ..write('stockConflict: $stockConflict, ')
          ..write('cancelReason: $cancelReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientRef,
    receiptNumber,
    createdAt,
    method,
    customerId,
    customerName,
    cashierName,
    total,
    linesJson,
    status,
    error,
    transactionId,
    stockConflict,
    cancelReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleRow &&
          other.clientRef == this.clientRef &&
          other.receiptNumber == this.receiptNumber &&
          other.createdAt == this.createdAt &&
          other.method == this.method &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.cashierName == this.cashierName &&
          other.total == this.total &&
          other.linesJson == this.linesJson &&
          other.status == this.status &&
          other.error == this.error &&
          other.transactionId == this.transactionId &&
          other.stockConflict == this.stockConflict &&
          other.cancelReason == this.cancelReason);
}

class SalesCompanion extends UpdateCompanion<SaleRow> {
  final Value<String> clientRef;
  final Value<String> receiptNumber;
  final Value<DateTime> createdAt;
  final Value<int> method;
  final Value<String?> customerId;
  final Value<String?> customerName;
  final Value<String> cashierName;
  final Value<int> total;
  final Value<String> linesJson;
  final Value<int> status;
  final Value<String?> error;
  final Value<String?> transactionId;
  final Value<bool> stockConflict;
  final Value<String?> cancelReason;
  final Value<int> rowid;
  const SalesCompanion({
    this.clientRef = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.method = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.cashierName = const Value.absent(),
    this.total = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.error = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.stockConflict = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String clientRef,
    required String receiptNumber,
    required DateTime createdAt,
    required int method,
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    required String cashierName,
    required int total,
    required String linesJson,
    this.status = const Value.absent(),
    this.error = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.stockConflict = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientRef = Value(clientRef),
       receiptNumber = Value(receiptNumber),
       createdAt = Value(createdAt),
       method = Value(method),
       cashierName = Value(cashierName),
       total = Value(total),
       linesJson = Value(linesJson);
  static Insertable<SaleRow> custom({
    Expression<String>? clientRef,
    Expression<String>? receiptNumber,
    Expression<DateTime>? createdAt,
    Expression<int>? method,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? cashierName,
    Expression<int>? total,
    Expression<String>? linesJson,
    Expression<int>? status,
    Expression<String>? error,
    Expression<String>? transactionId,
    Expression<bool>? stockConflict,
    Expression<String>? cancelReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientRef != null) 'client_ref': clientRef,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (method != null) 'method': method,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (cashierName != null) 'cashier_name': cashierName,
      if (total != null) 'total': total,
      if (linesJson != null) 'lines_json': linesJson,
      if (status != null) 'status': status,
      if (error != null) 'error': error,
      if (transactionId != null) 'transaction_id': transactionId,
      if (stockConflict != null) 'stock_conflict': stockConflict,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? clientRef,
    Value<String>? receiptNumber,
    Value<DateTime>? createdAt,
    Value<int>? method,
    Value<String?>? customerId,
    Value<String?>? customerName,
    Value<String>? cashierName,
    Value<int>? total,
    Value<String>? linesJson,
    Value<int>? status,
    Value<String?>? error,
    Value<String?>? transactionId,
    Value<bool>? stockConflict,
    Value<String?>? cancelReason,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      clientRef: clientRef ?? this.clientRef,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdAt: createdAt ?? this.createdAt,
      method: method ?? this.method,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      cashierName: cashierName ?? this.cashierName,
      total: total ?? this.total,
      linesJson: linesJson ?? this.linesJson,
      status: status ?? this.status,
      error: error ?? this.error,
      transactionId: transactionId ?? this.transactionId,
      stockConflict: stockConflict ?? this.stockConflict,
      cancelReason: cancelReason ?? this.cancelReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientRef.present) {
      map['client_ref'] = Variable<String>(clientRef.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (method.present) {
      map['method'] = Variable<int>(method.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (cashierName.present) {
      map['cashier_name'] = Variable<String>(cashierName.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (linesJson.present) {
      map['lines_json'] = Variable<String>(linesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (stockConflict.present) {
      map['stock_conflict'] = Variable<bool>(stockConflict.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('clientRef: $clientRef, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('method: $method, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('cashierName: $cashierName, ')
          ..write('total: $total, ')
          ..write('linesJson: $linesJson, ')
          ..write('status: $status, ')
          ..write('error: $error, ')
          ..write('transactionId: $transactionId, ')
          ..write('stockConflict: $stockConflict, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DraftCartsTable extends DraftCarts
    with TableInfo<$DraftCartsTable, DraftCart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftCartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _chargeJsonMeta = const VerificationMeta(
    'chargeJson',
  );
  @override
  late final GeneratedColumn<String> chargeJson = GeneratedColumn<String>(
    'charge_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidSaleRefMeta = const VerificationMeta(
    'paidSaleRef',
  );
  @override
  late final GeneratedColumn<String> paidSaleRef = GeneratedColumn<String>(
    'paid_sale_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    customerId,
    customerName,
    createdAt,
    updatedAt,
    status,
    chargeJson,
    paidSaleRef,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_carts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftCart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('charge_json')) {
      context.handle(
        _chargeJsonMeta,
        chargeJson.isAcceptableOrUnknown(data['charge_json']!, _chargeJsonMeta),
      );
    }
    if (data.containsKey('paid_sale_ref')) {
      context.handle(
        _paidSaleRefMeta,
        paidSaleRef.isAcceptableOrUnknown(
          data['paid_sale_ref']!,
          _paidSaleRefMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftCart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftCart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      chargeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}charge_json'],
      ),
      paidSaleRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_sale_ref'],
      ),
    );
  }

  @override
  $DraftCartsTable createAlias(String alias) {
    return $DraftCartsTable(attachedDatabase, alias);
  }
}

class DraftCart extends DataClass implements Insertable<DraftCart> {
  final int id;
  final int number;
  final String? customerId;
  final String? customerName;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// 0 open, 1 awaiting QRIS/VA, 2 paid (receipt not yet dismissed).
  final int status;

  /// JSON of the pending charge (order id, method, QR/VA data, amount).
  final String? chargeJson;

  /// Sale created when the charge settled; shown as receipt on return.
  final String? paidSaleRef;
  const DraftCart({
    required this.id,
    required this.number,
    this.customerId,
    this.customerName,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.chargeJson,
    this.paidSaleRef,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || chargeJson != null) {
      map['charge_json'] = Variable<String>(chargeJson);
    }
    if (!nullToAbsent || paidSaleRef != null) {
      map['paid_sale_ref'] = Variable<String>(paidSaleRef);
    }
    return map;
  }

  DraftCartsCompanion toCompanion(bool nullToAbsent) {
    return DraftCartsCompanion(
      id: Value(id),
      number: Value(number),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      status: Value(status),
      chargeJson: chargeJson == null && nullToAbsent
          ? const Value.absent()
          : Value(chargeJson),
      paidSaleRef: paidSaleRef == null && nullToAbsent
          ? const Value.absent()
          : Value(paidSaleRef),
    );
  }

  factory DraftCart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftCart(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      status: serializer.fromJson<int>(json['status']),
      chargeJson: serializer.fromJson<String?>(json['chargeJson']),
      paidSaleRef: serializer.fromJson<String?>(json['paidSaleRef']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String?>(customerName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'status': serializer.toJson<int>(status),
      'chargeJson': serializer.toJson<String?>(chargeJson),
      'paidSaleRef': serializer.toJson<String?>(paidSaleRef),
    };
  }

  DraftCart copyWith({
    int? id,
    int? number,
    Value<String?> customerId = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? status,
    Value<String?> chargeJson = const Value.absent(),
    Value<String?> paidSaleRef = const Value.absent(),
  }) => DraftCart(
    id: id ?? this.id,
    number: number ?? this.number,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName.present ? customerName.value : this.customerName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    status: status ?? this.status,
    chargeJson: chargeJson.present ? chargeJson.value : this.chargeJson,
    paidSaleRef: paidSaleRef.present ? paidSaleRef.value : this.paidSaleRef,
  );
  DraftCart copyWithCompanion(DraftCartsCompanion data) {
    return DraftCart(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      status: data.status.present ? data.status.value : this.status,
      chargeJson: data.chargeJson.present
          ? data.chargeJson.value
          : this.chargeJson,
      paidSaleRef: data.paidSaleRef.present
          ? data.paidSaleRef.value
          : this.paidSaleRef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftCart(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('chargeJson: $chargeJson, ')
          ..write('paidSaleRef: $paidSaleRef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    customerId,
    customerName,
    createdAt,
    updatedAt,
    status,
    chargeJson,
    paidSaleRef,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftCart &&
          other.id == this.id &&
          other.number == this.number &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.status == this.status &&
          other.chargeJson == this.chargeJson &&
          other.paidSaleRef == this.paidSaleRef);
}

class DraftCartsCompanion extends UpdateCompanion<DraftCart> {
  final Value<int> id;
  final Value<int> number;
  final Value<String?> customerId;
  final Value<String?> customerName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> status;
  final Value<String?> chargeJson;
  final Value<String?> paidSaleRef;
  const DraftCartsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.chargeJson = const Value.absent(),
    this.paidSaleRef = const Value.absent(),
  });
  DraftCartsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.status = const Value.absent(),
    this.chargeJson = const Value.absent(),
    this.paidSaleRef = const Value.absent(),
  }) : number = Value(number),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DraftCart> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? status,
    Expression<String>? chargeJson,
    Expression<String>? paidSaleRef,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (status != null) 'status': status,
      if (chargeJson != null) 'charge_json': chargeJson,
      if (paidSaleRef != null) 'paid_sale_ref': paidSaleRef,
    });
  }

  DraftCartsCompanion copyWith({
    Value<int>? id,
    Value<int>? number,
    Value<String?>? customerId,
    Value<String?>? customerName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? status,
    Value<String?>? chargeJson,
    Value<String?>? paidSaleRef,
  }) {
    return DraftCartsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      chargeJson: chargeJson ?? this.chargeJson,
      paidSaleRef: paidSaleRef ?? this.paidSaleRef,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (chargeJson.present) {
      map['charge_json'] = Variable<String>(chargeJson.value);
    }
    if (paidSaleRef.present) {
      map['paid_sale_ref'] = Variable<String>(paidSaleRef.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftCartsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status, ')
          ..write('chargeJson: $chargeJson, ')
          ..write('paidSaleRef: $paidSaleRef')
          ..write(')'))
        .toString();
  }
}

class $DraftCartItemsTable extends DraftCartItems
    with TableInfo<$DraftCartItemsTable, DraftCartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftCartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _draftIdMeta = const VerificationMeta(
    'draftId',
  );
  @override
  late final GeneratedColumn<int> draftId = GeneratedColumn<int>(
    'draft_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES draft_carts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debtPriceMeta = const VerificationMeta(
    'debtPrice',
  );
  @override
  late final GeneratedColumn<int> debtPrice = GeneratedColumn<int>(
    'debt_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<int> unit = GeneratedColumn<int>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDigitalMeta = const VerificationMeta(
    'isDigital',
  );
  @override
  late final GeneratedColumn<bool> isDigital = GeneratedColumn<bool>(
    'is_digital',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_digital" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    draftId,
    productId,
    name,
    unitPrice,
    debtPrice,
    qty,
    unit,
    isDigital,
    destination,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftCartItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(
        _draftIdMeta,
        draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_draftIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('debt_price')) {
      context.handle(
        _debtPriceMeta,
        debtPrice.isAcceptableOrUnknown(data['debt_price']!, _debtPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_debtPriceMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_digital')) {
      context.handle(
        _isDigitalMeta,
        isDigital.isAcceptableOrUnknown(data['is_digital']!, _isDigitalMeta),
      );
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftCartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftCartItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      draftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}draft_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      debtPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_price'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit'],
      )!,
      isDigital: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_digital'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $DraftCartItemsTable createAlias(String alias) {
    return $DraftCartItemsTable(attachedDatabase, alias);
  }
}

class DraftCartItem extends DataClass implements Insertable<DraftCartItem> {
  final int id;
  final int draftId;
  final String productId;
  final String name;
  final int unitPrice;
  final int debtPrice;
  final double qty;
  final int unit;
  final bool isDigital;
  final String? destination;
  final int position;
  const DraftCartItem({
    required this.id,
    required this.draftId,
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.debtPrice,
    required this.qty,
    required this.unit,
    required this.isDigital,
    this.destination,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['draft_id'] = Variable<int>(draftId);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    map['unit_price'] = Variable<int>(unitPrice);
    map['debt_price'] = Variable<int>(debtPrice);
    map['qty'] = Variable<double>(qty);
    map['unit'] = Variable<int>(unit);
    map['is_digital'] = Variable<bool>(isDigital);
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  DraftCartItemsCompanion toCompanion(bool nullToAbsent) {
    return DraftCartItemsCompanion(
      id: Value(id),
      draftId: Value(draftId),
      productId: Value(productId),
      name: Value(name),
      unitPrice: Value(unitPrice),
      debtPrice: Value(debtPrice),
      qty: Value(qty),
      unit: Value(unit),
      isDigital: Value(isDigital),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      position: Value(position),
    );
  }

  factory DraftCartItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftCartItem(
      id: serializer.fromJson<int>(json['id']),
      draftId: serializer.fromJson<int>(json['draftId']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      debtPrice: serializer.fromJson<int>(json['debtPrice']),
      qty: serializer.fromJson<double>(json['qty']),
      unit: serializer.fromJson<int>(json['unit']),
      isDigital: serializer.fromJson<bool>(json['isDigital']),
      destination: serializer.fromJson<String?>(json['destination']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftId': serializer.toJson<int>(draftId),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'debtPrice': serializer.toJson<int>(debtPrice),
      'qty': serializer.toJson<double>(qty),
      'unit': serializer.toJson<int>(unit),
      'isDigital': serializer.toJson<bool>(isDigital),
      'destination': serializer.toJson<String?>(destination),
      'position': serializer.toJson<int>(position),
    };
  }

  DraftCartItem copyWith({
    int? id,
    int? draftId,
    String? productId,
    String? name,
    int? unitPrice,
    int? debtPrice,
    double? qty,
    int? unit,
    bool? isDigital,
    Value<String?> destination = const Value.absent(),
    int? position,
  }) => DraftCartItem(
    id: id ?? this.id,
    draftId: draftId ?? this.draftId,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    unitPrice: unitPrice ?? this.unitPrice,
    debtPrice: debtPrice ?? this.debtPrice,
    qty: qty ?? this.qty,
    unit: unit ?? this.unit,
    isDigital: isDigital ?? this.isDigital,
    destination: destination.present ? destination.value : this.destination,
    position: position ?? this.position,
  );
  DraftCartItem copyWithCompanion(DraftCartItemsCompanion data) {
    return DraftCartItem(
      id: data.id.present ? data.id.value : this.id,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      debtPrice: data.debtPrice.present ? data.debtPrice.value : this.debtPrice,
      qty: data.qty.present ? data.qty.value : this.qty,
      unit: data.unit.present ? data.unit.value : this.unit,
      isDigital: data.isDigital.present ? data.isDigital.value : this.isDigital,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftCartItem(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('debtPrice: $debtPrice, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('isDigital: $isDigital, ')
          ..write('destination: $destination, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    draftId,
    productId,
    name,
    unitPrice,
    debtPrice,
    qty,
    unit,
    isDigital,
    destination,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftCartItem &&
          other.id == this.id &&
          other.draftId == this.draftId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.unitPrice == this.unitPrice &&
          other.debtPrice == this.debtPrice &&
          other.qty == this.qty &&
          other.unit == this.unit &&
          other.isDigital == this.isDigital &&
          other.destination == this.destination &&
          other.position == this.position);
}

class DraftCartItemsCompanion extends UpdateCompanion<DraftCartItem> {
  final Value<int> id;
  final Value<int> draftId;
  final Value<String> productId;
  final Value<String> name;
  final Value<int> unitPrice;
  final Value<int> debtPrice;
  final Value<double> qty;
  final Value<int> unit;
  final Value<bool> isDigital;
  final Value<String?> destination;
  final Value<int> position;
  const DraftCartItemsCompanion({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.debtPrice = const Value.absent(),
    this.qty = const Value.absent(),
    this.unit = const Value.absent(),
    this.isDigital = const Value.absent(),
    this.destination = const Value.absent(),
    this.position = const Value.absent(),
  });
  DraftCartItemsCompanion.insert({
    this.id = const Value.absent(),
    required int draftId,
    required String productId,
    required String name,
    required int unitPrice,
    required int debtPrice,
    required double qty,
    this.unit = const Value.absent(),
    this.isDigital = const Value.absent(),
    this.destination = const Value.absent(),
    required int position,
  }) : draftId = Value(draftId),
       productId = Value(productId),
       name = Value(name),
       unitPrice = Value(unitPrice),
       debtPrice = Value(debtPrice),
       qty = Value(qty),
       position = Value(position);
  static Insertable<DraftCartItem> custom({
    Expression<int>? id,
    Expression<int>? draftId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<int>? unitPrice,
    Expression<int>? debtPrice,
    Expression<double>? qty,
    Expression<int>? unit,
    Expression<bool>? isDigital,
    Expression<String>? destination,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftId != null) 'draft_id': draftId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (debtPrice != null) 'debt_price': debtPrice,
      if (qty != null) 'qty': qty,
      if (unit != null) 'unit': unit,
      if (isDigital != null) 'is_digital': isDigital,
      if (destination != null) 'destination': destination,
      if (position != null) 'position': position,
    });
  }

  DraftCartItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? draftId,
    Value<String>? productId,
    Value<String>? name,
    Value<int>? unitPrice,
    Value<int>? debtPrice,
    Value<double>? qty,
    Value<int>? unit,
    Value<bool>? isDigital,
    Value<String?>? destination,
    Value<int>? position,
  }) {
    return DraftCartItemsCompanion(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      debtPrice: debtPrice ?? this.debtPrice,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      isDigital: isDigital ?? this.isDigital,
      destination: destination ?? this.destination,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<int>(draftId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (debtPrice.present) {
      map['debt_price'] = Variable<int>(debtPrice.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    if (isDigital.present) {
      map['is_digital'] = Variable<bool>(isDigital.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftCartItemsCompanion(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('debtPrice: $debtPrice, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('isDigital: $isDigital, ')
          ..write('destination: $destination, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $CachedCategoriesTable cachedCategories = $CachedCategoriesTable(
    this,
  );
  late final $CachedCustomersTable cachedCustomers = $CachedCustomersTable(
    this,
  );
  late final $SalesTable sales = $SalesTable(this);
  late final $DraftCartsTable draftCarts = $DraftCartsTable(this);
  late final $DraftCartItemsTable draftCartItems = $DraftCartItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedProducts,
    cachedCategories,
    cachedCustomers,
    sales,
    draftCarts,
    draftCartItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'draft_carts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('draft_cart_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      required String id,
      required String sku,
      Value<String?> barcode,
      required String name,
      Value<int> unit,
      Value<int> type,
      Value<int> purchasePrice,
      required int sellingPrice,
      required int sellingPriceDebt,
      Value<double> stock,
      Value<String?> categoryId,
      Value<String> categoryName,
      Value<String> image,
      Value<int> soldCount,
      Value<int> rowid,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<String> id,
      Value<String> sku,
      Value<String?> barcode,
      Value<String> name,
      Value<int> unit,
      Value<int> type,
      Value<int> purchasePrice,
      Value<int> sellingPrice,
      Value<int> sellingPriceDebt,
      Value<double> stock,
      Value<String?> categoryId,
      Value<String> categoryName,
      Value<String> image,
      Value<int> soldCount,
      Value<int> rowid,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceDebt => $composableBuilder(
    column: $table.sellingPriceDebt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get soldCount => $composableBuilder(
    column: $table.soldCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceDebt => $composableBuilder(
    column: $table.sellingPriceDebt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get soldCount => $composableBuilder(
    column: $table.soldCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPriceDebt => $composableBuilder(
    column: $table.sellingPriceDebt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get soldCount =>
      $composableBuilder(column: $table.soldCount, builder: (column) => column);
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$AppDatabase db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> unit = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> purchasePrice = const Value.absent(),
                Value<int> sellingPrice = const Value.absent(),
                Value<int> sellingPriceDebt = const Value.absent(),
                Value<double> stock = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<int> soldCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion(
                id: id,
                sku: sku,
                barcode: barcode,
                name: name,
                unit: unit,
                type: type,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
                sellingPriceDebt: sellingPriceDebt,
                stock: stock,
                categoryId: categoryId,
                categoryName: categoryName,
                image: image,
                soldCount: soldCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sku,
                Value<String?> barcode = const Value.absent(),
                required String name,
                Value<int> unit = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> purchasePrice = const Value.absent(),
                required int sellingPrice,
                required int sellingPriceDebt,
                Value<double> stock = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<int> soldCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion.insert(
                id: id,
                sku: sku,
                barcode: barcode,
                name: name,
                unit: unit,
                type: type,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
                sellingPriceDebt: sellingPriceDebt,
                stock: stock,
                categoryId: categoryId,
                categoryName: categoryName,
                image: image,
                soldCount: soldCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedProductsTable, CachedProduct>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedProductsTable,
                    CachedProduct
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;
typedef $$CachedCategoriesTableCreateCompanionBuilder =
    CachedCategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> productCount,
      Value<int> rowid,
    });
typedef $$CachedCategoriesTableUpdateCompanionBuilder =
    CachedCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> productCount,
      Value<int> rowid,
    });

class $$CachedCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => column,
  );
}

class $$CachedCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCategoriesTable,
          CachedCategory,
          $$CachedCategoriesTableFilterComposer,
          $$CachedCategoriesTableOrderingComposer,
          $$CachedCategoriesTableAnnotationComposer,
          $$CachedCategoriesTableCreateCompanionBuilder,
          $$CachedCategoriesTableUpdateCompanionBuilder,
          (
            CachedCategory,
            BaseReferences<
              _$AppDatabase,
              $CachedCategoriesTable,
              CachedCategory
            >,
          ),
          CachedCategory,
          PrefetchHooks Function()
        > {
  $$CachedCategoriesTableTableManager(
    _$AppDatabase db,
    $CachedCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> productCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCategoriesCompanion(
                id: id,
                name: name,
                productCount: productCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> productCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCategoriesCompanion.insert(
                id: id,
                name: name,
                productCount: productCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedCategoriesTable, CachedCategory>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedCategoriesTable,
                    CachedCategory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCategoriesTable,
      CachedCategory,
      $$CachedCategoriesTableFilterComposer,
      $$CachedCategoriesTableOrderingComposer,
      $$CachedCategoriesTableAnnotationComposer,
      $$CachedCategoriesTableCreateCompanionBuilder,
      $$CachedCategoriesTableUpdateCompanionBuilder,
      (
        CachedCategory,
        BaseReferences<_$AppDatabase, $CachedCategoriesTable, CachedCategory>,
      ),
      CachedCategory,
      PrefetchHooks Function()
    >;
typedef $$CachedCustomersTableCreateCompanionBuilder =
    CachedCustomersCompanion Function({
      required String id,
      required String name,
      Value<String> phone,
      Value<String> address,
      Value<int> outstandingDebt,
      Value<int> rowid,
    });
typedef $$CachedCustomersTableUpdateCompanionBuilder =
    CachedCustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<int> outstandingDebt,
      Value<int> rowid,
    });

class $$CachedCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outstandingDebt => $composableBuilder(
    column: $table.outstandingDebt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outstandingDebt => $composableBuilder(
    column: $table.outstandingDebt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get outstandingDebt => $composableBuilder(
    column: $table.outstandingDebt,
    builder: (column) => column,
  );
}

class $$CachedCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCustomersTable,
          CachedCustomer,
          $$CachedCustomersTableFilterComposer,
          $$CachedCustomersTableOrderingComposer,
          $$CachedCustomersTableAnnotationComposer,
          $$CachedCustomersTableCreateCompanionBuilder,
          $$CachedCustomersTableUpdateCompanionBuilder,
          (
            CachedCustomer,
            BaseReferences<
              _$AppDatabase,
              $CachedCustomersTable,
              CachedCustomer
            >,
          ),
          CachedCustomer,
          PrefetchHooks Function()
        > {
  $$CachedCustomersTableTableManager(
    _$AppDatabase db,
    $CachedCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> outstandingDebt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                outstandingDebt: outstandingDebt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> outstandingDebt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                outstandingDebt: outstandingDebt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedCustomersTable, CachedCustomer>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedCustomersTable,
                    CachedCustomer
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCustomersTable,
      CachedCustomer,
      $$CachedCustomersTableFilterComposer,
      $$CachedCustomersTableOrderingComposer,
      $$CachedCustomersTableAnnotationComposer,
      $$CachedCustomersTableCreateCompanionBuilder,
      $$CachedCustomersTableUpdateCompanionBuilder,
      (
        CachedCustomer,
        BaseReferences<_$AppDatabase, $CachedCustomersTable, CachedCustomer>,
      ),
      CachedCustomer,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String clientRef,
  required String receiptNumber,
  required DateTime createdAt,
  required int method,
  Value<String?> customerId,
  Value<String?> customerName,
  required String cashierName,
  required int total,
  required String linesJson,
  Value<int> status,
  Value<String?> error,
  Value<String?> transactionId,
  Value<bool> stockConflict,
  Value<String?> cancelReason,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> clientRef,
  Value<String> receiptNumber,
  Value<DateTime> createdAt,
  Value<int> method,
  Value<String?> customerId,
  Value<String?> customerName,
  Value<String> cashierName,
  Value<int> total,
  Value<String> linesJson,
  Value<int> status,
  Value<String?> error,
  Value<String?> transactionId,
  Value<bool> stockConflict,
  Value<String?> cancelReason,
  Value<int> rowid,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientRef => $composableBuilder(
    column: $table.clientRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stockConflict => $composableBuilder(
    column: $table.stockConflict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientRef => $composableBuilder(
    column: $table.clientRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stockConflict => $composableBuilder(
    column: $table.stockConflict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientRef =>
      $composableBuilder(column: $table.clientRef, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get linesJson =>
      $composableBuilder(column: $table.linesJson, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stockConflict => $composableBuilder(
    column: $table.stockConflict,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          SaleRow,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (SaleRow, BaseReferences<_$AppDatabase, $SalesTable, SaleRow>),
          SaleRow,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientRef = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> method = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String> cashierName = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String> linesJson = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<bool> stockConflict = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                clientRef: clientRef,
                receiptNumber: receiptNumber,
                createdAt: createdAt,
                method: method,
                customerId: customerId,
                customerName: customerName,
                cashierName: cashierName,
                total: total,
                linesJson: linesJson,
                status: status,
                error: error,
                transactionId: transactionId,
                stockConflict: stockConflict,
                cancelReason: cancelReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientRef,
                required String receiptNumber,
                required DateTime createdAt,
                required int method,
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                required String cashierName,
                required int total,
                required String linesJson,
                Value<int> status = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<bool> stockConflict = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                clientRef: clientRef,
                receiptNumber: receiptNumber,
                createdAt: createdAt,
                method: method,
                customerId: customerId,
                customerName: customerName,
                cashierName: cashierName,
                total: total,
                linesJson: linesJson,
                status: status,
                error: error,
                transactionId: transactionId,
                stockConflict: stockConflict,
                cancelReason: cancelReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, SaleRow>(table),
                  BaseReferences<_$AppDatabase, $SalesTable, SaleRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      SaleRow,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (SaleRow, BaseReferences<_$AppDatabase, $SalesTable, SaleRow>),
      SaleRow,
      PrefetchHooks Function()
    >;
typedef $$DraftCartsTableCreateCompanionBuilder = DraftCartsCompanion Function({
  Value<int> id,
  required int number,
  Value<String?> customerId,
  Value<String?> customerName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> status,
  Value<String?> chargeJson,
  Value<String?> paidSaleRef,
});
typedef $$DraftCartsTableUpdateCompanionBuilder = DraftCartsCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<String?> customerId,
  Value<String?> customerName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> status,
  Value<String?> chargeJson,
  Value<String?> paidSaleRef,
});

final class $$DraftCartsTableReferences
    extends BaseReferences<_$AppDatabase, $DraftCartsTable, DraftCart> {
  $$DraftCartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DraftCartItemsTable, List<DraftCartItem>>
  _draftCartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.draftCartItems,
    aliasName: 'draft_carts__id__draft_cart_items__draft_id',
  );

  $$DraftCartItemsTableProcessedTableManager get draftCartItemsRefs {
    final manager = $$DraftCartItemsTableTableManager(
      $_db,
      $_db.draftCartItems,
    ).filter((f) => f.draftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_draftCartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DraftCartsTableFilterComposer
    extends Composer<_$AppDatabase, $DraftCartsTable> {
  $$DraftCartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chargeJson => $composableBuilder(
    column: $table.chargeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidSaleRef => $composableBuilder(
    column: $table.paidSaleRef,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> draftCartItemsRefs(
    Expression<bool> Function($$DraftCartItemsTableFilterComposer f) f,
  ) {
    final $$DraftCartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftCartItems,
      getReferencedColumn: (t) => t.draftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftCartItemsTableFilterComposer(
            $db: $db,
            $table: $db.draftCartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DraftCartsTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftCartsTable> {
  $$DraftCartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chargeJson => $composableBuilder(
    column: $table.chargeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidSaleRef => $composableBuilder(
    column: $table.paidSaleRef,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DraftCartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftCartsTable> {
  $$DraftCartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get chargeJson => $composableBuilder(
    column: $table.chargeJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paidSaleRef => $composableBuilder(
    column: $table.paidSaleRef,
    builder: (column) => column,
  );

  Expression<T> draftCartItemsRefs<T extends Object>(
    Expression<T> Function($$DraftCartItemsTableAnnotationComposer a) f,
  ) {
    final $$DraftCartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftCartItems,
      getReferencedColumn: (t) => t.draftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftCartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.draftCartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DraftCartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DraftCartsTable,
          DraftCart,
          $$DraftCartsTableFilterComposer,
          $$DraftCartsTableOrderingComposer,
          $$DraftCartsTableAnnotationComposer,
          $$DraftCartsTableCreateCompanionBuilder,
          $$DraftCartsTableUpdateCompanionBuilder,
          (DraftCart, $$DraftCartsTableReferences),
          DraftCart,
          PrefetchHooks Function({bool draftCartItemsRefs})
        > {
  $$DraftCartsTableTableManager(_$AppDatabase db, $DraftCartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftCartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftCartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftCartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> chargeJson = const Value.absent(),
                Value<String?> paidSaleRef = const Value.absent(),
              }) => DraftCartsCompanion(
                id: id,
                number: number,
                customerId: customerId,
                customerName: customerName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                status: status,
                chargeJson: chargeJson,
                paidSaleRef: paidSaleRef,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int number,
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> status = const Value.absent(),
                Value<String?> chargeJson = const Value.absent(),
                Value<String?> paidSaleRef = const Value.absent(),
              }) => DraftCartsCompanion.insert(
                id: id,
                number: number,
                customerId: customerId,
                customerName: customerName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                status: status,
                chargeJson: chargeJson,
                paidSaleRef: paidSaleRef,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DraftCartsTable, DraftCart>(table),
                  $$DraftCartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({draftCartItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (draftCartItemsRefs) db.draftCartItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (draftCartItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      DraftCart,
                      $DraftCartsTable,
                      DraftCartItem,
                      $DraftCartItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$DraftCartsTableReferences
                          ._draftCartItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DraftCartsTableReferences(
                            db,
                            table,
                            p0,
                          ).draftCartItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'draft_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DraftCartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DraftCartsTable,
      DraftCart,
      $$DraftCartsTableFilterComposer,
      $$DraftCartsTableOrderingComposer,
      $$DraftCartsTableAnnotationComposer,
      $$DraftCartsTableCreateCompanionBuilder,
      $$DraftCartsTableUpdateCompanionBuilder,
      (DraftCart, $$DraftCartsTableReferences),
      DraftCart,
      PrefetchHooks Function({bool draftCartItemsRefs})
    >;
typedef $$DraftCartItemsTableCreateCompanionBuilder =
    DraftCartItemsCompanion Function({
      Value<int> id,
      required int draftId,
      required String productId,
      required String name,
      required int unitPrice,
      required int debtPrice,
      required double qty,
      Value<int> unit,
      Value<bool> isDigital,
      Value<String?> destination,
      required int position,
    });
typedef $$DraftCartItemsTableUpdateCompanionBuilder =
    DraftCartItemsCompanion Function({
      Value<int> id,
      Value<int> draftId,
      Value<String> productId,
      Value<String> name,
      Value<int> unitPrice,
      Value<int> debtPrice,
      Value<double> qty,
      Value<int> unit,
      Value<bool> isDigital,
      Value<String?> destination,
      Value<int> position,
    });

final class $$DraftCartItemsTableReferences
    extends BaseReferences<_$AppDatabase, $DraftCartItemsTable, DraftCartItem> {
  $$DraftCartItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DraftCartsTable _draftIdTable(_$AppDatabase db) =>
      db.draftCarts.createAlias('draft_cart_items__draft_id__draft_carts__id');

  $$DraftCartsTableProcessedTableManager get draftId {
    final $_column = $_itemColumn<int>('draft_id')!;

    final manager = $$DraftCartsTableTableManager(
      $_db,
      $_db.draftCarts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_draftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DraftCartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DraftCartItemsTable> {
  $$DraftCartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debtPrice => $composableBuilder(
    column: $table.debtPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDigital => $composableBuilder(
    column: $table.isDigital,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$DraftCartsTableFilterComposer get draftId {
    final $$DraftCartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.draftId,
      referencedTable: $db.draftCarts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftCartsTableFilterComposer(
            $db: $db,
            $table: $db.draftCarts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftCartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftCartItemsTable> {
  $$DraftCartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debtPrice => $composableBuilder(
    column: $table.debtPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDigital => $composableBuilder(
    column: $table.isDigital,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$DraftCartsTableOrderingComposer get draftId {
    final $$DraftCartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.draftId,
      referencedTable: $db.draftCarts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftCartsTableOrderingComposer(
            $db: $db,
            $table: $db.draftCarts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftCartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftCartItemsTable> {
  $$DraftCartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get debtPrice =>
      $composableBuilder(column: $table.debtPrice, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isDigital =>
      $composableBuilder(column: $table.isDigital, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$DraftCartsTableAnnotationComposer get draftId {
    final $$DraftCartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.draftId,
      referencedTable: $db.draftCarts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftCartsTableAnnotationComposer(
            $db: $db,
            $table: $db.draftCarts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftCartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DraftCartItemsTable,
          DraftCartItem,
          $$DraftCartItemsTableFilterComposer,
          $$DraftCartItemsTableOrderingComposer,
          $$DraftCartItemsTableAnnotationComposer,
          $$DraftCartItemsTableCreateCompanionBuilder,
          $$DraftCartItemsTableUpdateCompanionBuilder,
          (DraftCartItem, $$DraftCartItemsTableReferences),
          DraftCartItem,
          PrefetchHooks Function({bool draftId})
        > {
  $$DraftCartItemsTableTableManager(
    _$AppDatabase db,
    $DraftCartItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftCartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftCartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftCartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> draftId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> debtPrice = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<int> unit = const Value.absent(),
                Value<bool> isDigital = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => DraftCartItemsCompanion(
                id: id,
                draftId: draftId,
                productId: productId,
                name: name,
                unitPrice: unitPrice,
                debtPrice: debtPrice,
                qty: qty,
                unit: unit,
                isDigital: isDigital,
                destination: destination,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int draftId,
                required String productId,
                required String name,
                required int unitPrice,
                required int debtPrice,
                required double qty,
                Value<int> unit = const Value.absent(),
                Value<bool> isDigital = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                required int position,
              }) => DraftCartItemsCompanion.insert(
                id: id,
                draftId: draftId,
                productId: productId,
                name: name,
                unitPrice: unitPrice,
                debtPrice: debtPrice,
                qty: qty,
                unit: unit,
                isDigital: isDigital,
                destination: destination,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DraftCartItemsTable, DraftCartItem>(table),
                  $$DraftCartItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({draftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (draftId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.draftId,
                        referencedTable: $$DraftCartItemsTableReferences
                            ._draftIdTable(db),
                        referencedColumn: $$DraftCartItemsTableReferences
                            ._draftIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DraftCartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DraftCartItemsTable,
      DraftCartItem,
      $$DraftCartItemsTableFilterComposer,
      $$DraftCartItemsTableOrderingComposer,
      $$DraftCartItemsTableAnnotationComposer,
      $$DraftCartItemsTableCreateCompanionBuilder,
      $$DraftCartItemsTableUpdateCompanionBuilder,
      (DraftCartItem, $$DraftCartItemsTableReferences),
      DraftCartItem,
      PrefetchHooks Function({bool draftId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$CachedCategoriesTableTableManager get cachedCategories =>
      $$CachedCategoriesTableTableManager(_db, _db.cachedCategories);
  $$CachedCustomersTableTableManager get cachedCustomers =>
      $$CachedCustomersTableTableManager(_db, _db.cachedCustomers);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$DraftCartsTableTableManager get draftCarts =>
      $$DraftCartsTableTableManager(_db, _db.draftCarts);
  $$DraftCartItemsTableTableManager get draftCartItems =>
      $$DraftCartItemsTableTableManager(_db, _db.draftCartItems);
}
