import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/catalog/catalog_cubits.dart';
import 'package:kasir/features/checkout/presentation/bloc/assign_barcode_cubit.dart';
import 'package:kasir/features/products/presentation/bloc/products_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  late LocalFixture local;
  late MockProducts remote;

  setUpAll(() => registerFallbackValue(const ProductPatch()));
  setUp(() async {
    local = LocalFixture();
    await local.seed();
    await local.cache.replaceCategories(const [Category(id: 'c1', name: 'Mie')]);
    remote = MockProducts();
  });
  tearDown(() => local.close());

  test('list searches and filters the cache', () async {
    final cubit = ProductsCubit(local.cache)..start();
    var s = await cubit.stream.firstWhere((s) => !s.loading && s.categories.isNotEmpty);
    expect(s.products, hasLength(3));
    cubit.search('aqua');
    s = await cubit.stream.firstWhere((s) => s.products.length == 1);
    expect(s.products.single.id, 'p2');
    cubit.filter('none');
    s = await cubit.stream.firstWhere((s) => s.products.isEmpty);
    expect(s.categoryId, 'none');
    await cubit.close();
  });

  test('edit saves to the server, adjusts stock, and updates the cache', () async {
    when(() => remote.get('p1')).thenAnswer((_) async => const Ok(indomie));
    when(() => remote.adjustStock('p1', 5)).thenAnswer((_) async => const Ok(null));
    when(() => remote.update('p1', any())).thenAnswer((_) async => Ok(indomie.copyWith(name: 'Indomie Baru')));
    final cubit = ProductEditCubit(GetProduct(remote), UpdateProduct(remote), AdjustStock(remote), local.cache);
    await cubit.load('p1');
    await cubit.save(const ProductPatch(name: 'Indomie Baru'), stockDelta: 5);
    expect(cubit.state.saved, isTrue);
    expect((await local.cache.product('p1'))!.name, 'Indomie Baru');
  });

  test('edit failures are kept on screen', () async {
    when(() => remote.get('p1')).thenAnswer((_) async => const Err(NetworkFailure()));
    when(() => remote.adjustStock('p1', -1)).thenAnswer((_) async => const Err(ForbiddenFailure('super only')));
    final cubit = ProductEditCubit(GetProduct(remote), UpdateProduct(remote), AdjustStock(remote), local.cache);
    await cubit.load('p1');
    expect(cubit.state.product?.id, 'p1');
    expect(cubit.state.failure, const NetworkFailure());
    await cubit.save(const ProductPatch(), stockDelta: -1);
    expect(cubit.state.failure, const ForbiddenFailure('super only'));
    when(() => remote.update('p1', any())).thenAnswer((_) async => const Err(ConflictFailure('barcode taken')));
    await cubit.save(const ProductPatch(barcode: '777'));
    expect(cubit.state.failure, const ConflictFailure('barcode taken'));
  });

  test('assign barcode updates the cache so the next scan finds it', () async {
    when(() => remote.update('p2', any())).thenAnswer((_) async => Ok(aqua.copyWith(barcode: '555')));
    final cubit = AssignBarcodeCubit(AssignBarcode(UpdateProduct(remote)), local.cache);
    await cubit.assign(aqua, '555');
    expect(cubit.state.product?.barcode, '555');
    expect((await local.cache.productByBarcode('555'))?.id, 'p2');
    when(() => remote.update('p2', any())).thenAnswer((_) async => const Err(ConflictFailure('dup')));
    await cubit.assign(aqua, '556');
    expect(cubit.state.failure, const ConflictFailure('dup'));
  });
}
