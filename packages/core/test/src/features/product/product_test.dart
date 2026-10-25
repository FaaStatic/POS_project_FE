import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> productJson(String id, {String? barcode, int type = 0}) => {
      'id': id,
      'sku': 'SKU-$id',
      'barcode': barcode,
      'product_name': 'Indomie Goreng',
      'unit': 0,
      'product_type': type,
      'purchase_price': 2500,
      'selling_price': 3500,
      'selling_price_debt': 4000,
      'stock': 12.5,
      'category_id': 'c1',
      'category': 'Mie Instan',
      'image': '',
      'updated_at': '2026-10-24T10:00:00Z',
    };

void main() {
  late FakeAdapter adapter;
  late ProductRepositoryImpl repo;

  setUp(() {
    adapter = FakeAdapter();
    repo = ProductRepositoryImpl(ProductRemoteDatasource(ApiClient(fakeDio(adapter))));
  });

  test('list maps products and cursor, sends filters', () async {
    adapter.on('GET', ApiPaths.products, (_) => FakeReply(200, envelope({
          'next_id': 'p1',
          'next_time': 't1',
          'has_next': true,
          'product_list': [productJson('p1', barcode: '899', type: 1)],
        })));
    final page = (await repo.list(const ProductQuery(search: 'mie', barcode: '899')) as Ok<Page<Product>>).value;
    final p = page.items.single;
    expect(p.name, 'Indomie Goreng');
    expect(p.isDigital, isTrue);
    expect(p.stock, 12.5);
    expect(p.priceFor(debt: true), 4000);
    expect(p.categoryName, 'Mie Instan');
    expect(page.hasNext, isTrue);
    expect(page.cursor?.id, 'p1');
    expect(adapter.requests.single.queryParameters, {'search': 'mie', 'barcode': '899', 'limit': 100});
  });

  test('listAll follows pages until has_next is false', () async {
    var calls = 0;
    adapter.on('GET', ApiPaths.products, (o) {
      calls++;
      final first = o.queryParameters['last_id'] == null;
      return FakeReply(200, envelope({
        'next_id': first ? 'p1' : '',
        'next_time': first ? 't1' : '',
        'has_next': first,
        'product_list': [productJson(first ? 'p1' : 'p2')],
      }));
    });
    final all = (await repo.listAll() as Ok<List<Product>>).value;
    expect(all.map((p) => p.id), ['p1', 'p2']);
    expect(calls, 2);
  });

  test('update sends only changed fields then refetches', () async {
    adapter
      ..on('PATCH', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(null)))
      ..on('GET', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(productJson('p1', barcode: '123'))));
    final result = await UpdateProduct(repo)('p1', const ProductPatch(barcode: '123', sellingPrice: 3600));
    expect((result as Ok<Product>).value.barcode, '123');
    expect(adapter.requests.first.data, {'barcode': '123', 'selling_price': 3600});
  });

  test('update rejects an invalid barcode locally', () async {
    expect(await UpdateProduct(repo)('p1', const ProductPatch(barcode: 'bad code')),
        const Err<Product>(ValidationFailure('barcode_format')));
    expect(adapter.requests, isEmpty);
  });

  test('AssignBarcode trims and patches barcode', () async {
    adapter
      ..on('PATCH', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(null)))
      ..on('GET', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(productJson('p1', barcode: '899'))));
    await AssignBarcode(UpdateProduct(repo))('p1', ' 899 ');
    expect(adapter.requests.first.data, {'barcode': '899'});
  });

  test('create, stock adjust, delete hit the right endpoints', () async {
    adapter
      ..on('POST', ApiPaths.products, (_) => FakeReply(201, envelope(null)))
      ..on('PATCH', ApiPaths.productsStock, (_) => FakeReply(200, envelope(null)))
      ..on('DELETE', ApiPaths.product('p1'), (_) => FakeReply(200, envelope(null)));
    const input = NewProduct(
      sku: 'A1',
      name: 'Gula 1kg',
      unit: ProductUnit.kg,
      purchasePrice: 14000,
      sellingPrice: 16000,
      sellingPriceDebt: 17000,
      stock: 5,
      category: 'Sembako',
    );
    expect(await CreateProduct(repo)(input), isA<Ok<void>>());
    expect(adapter.requests[0].data['unit'], 2);
    expect(adapter.requests[0].data.containsKey('barcode'), isFalse);
    expect(await AdjustStock(repo)('p1', -2), isA<Ok<void>>());
    expect(adapter.requests[1].data, {'id': 'p1', 'stock': -2.0});
    expect(await AdjustStock(repo)('p1', 0), const Err<void>(ValidationFailure('zero_delta')));
    expect(await DeleteProduct(repo)('p1'), isA<Ok<void>>());
    expect(await GetProduct(repo)('missing'), const Err<Product>(NetworkFailure()));
  });

  test('bulk uploads CSV as multipart and maps the import report', () async {
    adapter.on('POST', ApiPaths.productsBulk, (o) {
      expect(o.data, isA<FormData>());
      expect((o.data as FormData).files.single.key, 'file_upload');
      return FakeReply(201, envelope({
        'total_inserted': 1,
        'total_updated': 1,
        'duplicate_in_file': ['A1'],
        'row_errors': [
          {'line': 3, 'message': 'product_name is empty'},
        ],
      }));
    });
    const p = NewProduct(sku: 'A1', name: 'Kopi, "Kapal"', purchasePrice: 1, sellingPrice: 2, sellingPriceDebt: 3, stock: 1.5, category: 'Minuman', type: ProductType.digital);
    final r = (await BulkCreateProducts(repo)([p]) as Ok<BulkImportResult>).value;
    expect(r.inserted, 1);
    expect(r.rowErrors.single.line, 3);
    expect(await BulkCreateProducts(repo)([]), const Err<BulkImportResult>(ValidationFailure('empty')));
  });

  test('CSV quotes cells with commas and quotes', () {
    const p = NewProduct(sku: 'A1', name: 'Kopi, "Kapal"', purchasePrice: 1, sellingPrice: 2, sellingPriceDebt: 3, stock: 1.5, category: 'Minuman');
    final lines = ProductModel.toCsv([p]).split('\r\n');
    expect(lines.first, ProductModel.csvHeader.join(','));
    expect(lines[1], 'A1,,"Kopi, ""Kapal""",pcs,1,2,3,1.5,Minuman,,physical');
  });
}
