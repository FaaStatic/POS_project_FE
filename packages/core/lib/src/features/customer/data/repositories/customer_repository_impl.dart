import '../../../../common/guard.dart';
import '../../../../common/json.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../../../../constants/api_paths.dart';
import '../../../../network/api_client.dart';
import '../../../debt/data/repositories/debt_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

/// CustomerDtoResponse uses Indonesian keys (nama, no_hp, alamat).
Customer customerFromJson(Map<String, dynamic> j) => Customer(
      id: readString(j['id']),
      name: readString(j['nama']),
      phone: readString(j['no_hp']),
      address: readString(j['alamat']),
      active: j['active'] == null || readBool(j['active']),
      debts: readList(j['debts']).map(debtFromJson).toList(),
    );

PurgeMode purgeModeFromJson(Object? data) =>
    readString(readMap(data)['mode']) == 'anonymized' ? PurgeMode.anonymized : PurgeMode.deleted;

class CustomerRemoteDatasource {
  const CustomerRemoteDatasource(this._api);
  final ApiClient _api;

  Future<Paged<Customer>> list(CustomerQuery q, {PageCursor? after, String? order}) async {
    final data = readMap(await _api.get(ApiPaths.customers, query: {
      'search': q.search,
      'status': q.inactive ? 'inactive' : null,
      'limit': q.limit,
      'order': order,
      'after_id': after?.id,
      'after_time': after?.time,
    }));
    return Paged(
      items: readList(data['customer_lists']).map(customerFromJson).toList(),
      cursor: PageCursor.from(data['after_id'], data['after_time']),
      hasNext: readBool(data['has_next']),
    );
  }

  Future<Customer> get(String id) async => customerFromJson(readMap(await _api.get(ApiPaths.customer(id))));

  /// The backend returns no id on create, so the newest customer with the same name is looked up.
  Future<Customer> create(CustomerInput input) async {
    await _api.post(ApiPaths.customers, body: {
      'customer_name': input.name,
      if (input.phone.isNotEmpty) 'phone_number': input.phone,
      if (input.address.isNotEmpty) 'address': input.address,
    });
    final page = await list(CustomerQuery(search: input.name, limit: 10), order: 'desc');
    return page.items.firstWhere(
      (c) => c.name == input.name && c.phone == input.phone,
      orElse: () => page.items.firstWhere((c) => c.name == input.name),
    );
  }

  Future<void> update(String id, CustomerInput input) => _api.put(ApiPaths.customer(id), body: {
        'customer_id': id,
        'customer_name': input.name,
        'phone_number': input.phone,
        'address': input.address,
      });

  Future<void> deactivate(String id) => _api.delete(ApiPaths.customer(id));
  Future<void> restore(String id) => _api.post(ApiPaths.customerRestore(id));
  Future<PurgeMode> purge(String id) async => purgeModeFromJson(await _api.delete(ApiPaths.customerPurge(id)));
}

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._remote);
  final CustomerRemoteDatasource _remote;

  @override
  Future<Result<Paged<Customer>>> list(CustomerQuery query, {PageCursor? after}) =>
      guard(() => _remote.list(query, after: after));

  @override
  Future<Result<List<Customer>>> listAll() => guard(() async {
        final all = <Customer>[];
        PageCursor? cursor;
        do {
          final page = await _remote.list(const CustomerQuery(limit: 100), after: cursor);
          all.addAll(page.items);
          cursor = page.hasNext ? page.cursor : null;
        } while (cursor != null);
        return all;
      });

  @override
  Future<Result<Customer>> get(String id) => guard(() => _remote.get(id));
  @override
  Future<Result<Customer>> create(CustomerInput input) => guard(() => _remote.create(input));
  @override
  Future<Result<void>> update(String id, CustomerInput input) => guard(() => _remote.update(id, input));
  @override
  Future<Result<void>> deactivate(String id) => guard(() => _remote.deactivate(id));
  @override
  Future<Result<void>> restore(String id) => guard(() => _remote.restore(id));
  @override
  Future<Result<PurgeMode>> purge(String id) => guard(() => _remote.purge(id));
}
