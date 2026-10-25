import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/customer.dart';

abstract interface class CustomerRepository {
  Future<Result<Paged<Customer>>> list(CustomerQuery query, {PageCursor? after});
  Future<Result<List<Customer>>> listAll();
  Future<Result<Customer>> get(String id);
  Future<Result<Customer>> create(CustomerInput input);
  Future<Result<void>> update(String id, CustomerInput input);
  Future<Result<void>> deactivate(String id);
  Future<Result<void>> restore(String id);

  /// Fails with ConflictFailure while the customer has an active debt.
  Future<Result<PurgeMode>> purge(String id);
}
