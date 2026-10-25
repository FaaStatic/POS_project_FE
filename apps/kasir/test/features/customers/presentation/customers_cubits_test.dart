import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/common/catalog/catalog_cubits.dart';
import 'package:kasir/features/customers/presentation/bloc/customers_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  late LocalFixture local;
  late MockCustomers remote;

  setUpAll(() => registerFallbackValue(const CustomerInput(name: '')));
  setUp(() async {
    local = LocalFixture();
    remote = MockCustomers();
    await local.cache.replaceCustomers(const [Customer(id: 'k1', name: 'Bu Sri'), Customer(id: 'k2', name: 'Pak Budi')]);
  });
  tearDown(() => local.close());

  test('search filters the cached list', () async {
    final cubit = CustomersCubit(local.cache)..search('budi');
    final state = await cubit.stream.firstWhere((s) => !s.loading);
    expect(state.customers.single.id, 'k2');
    await cubit.close();
  });

  test('adding needs internet and stores the new customer in the cache', () async {
    final network = FakeNetwork(false);
    final cubit = AddCustomerCubit(CreateCustomer(remote), local.cache, network);
    await cubit.save(const CustomerInput(name: 'Mbak Ani'));
    expect(cubit.state.failure, const NetworkFailure());
    network.online = true;
    when(() => remote.create(any())).thenAnswer((_) async => const Ok(Customer(id: 'k3', name: 'Mbak Ani')));
    await cubit.save(const CustomerInput(name: 'Mbak Ani'));
    expect(cubit.state.saved?.id, 'k3');
    expect(await local.cache.customer('k3'), isNotNull);
  });

  test('add failure is shown', () async {
    when(() => remote.create(any())).thenAnswer((_) async => const Err(ServerFailure('boom')));
    final cubit = AddCustomerCubit(CreateCustomer(remote), local.cache, FakeNetwork());
    await cubit.save(const CustomerInput(name: 'X'));
    expect(cubit.state.failure, const ServerFailure('boom'));
  });

  test('detail shows the cached copy when the server is unreachable', () async {
    when(() => remote.get('k1')).thenAnswer((_) async => const Err(NetworkFailure()));
    final cubit = CustomerDetailCubit(GetCustomer(remote), local.cache);
    await cubit.load('k1');
    expect(cubit.state.customer?.name, 'Bu Sri');
    expect(cubit.state.failure, const NetworkFailure());
    when(() => remote.get('k1')).thenAnswer((_) async => const Ok(Customer(id: 'k1', name: 'Bu Sri', phone: '0812')));
    await cubit.load('k1');
    expect(cubit.state.customer?.phone, '0812');
  });
}
