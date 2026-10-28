import '../../../../common/failure.dart';
import '../../../../common/page.dart';
import '../../../../common/result.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  const GetCustomers(this._repo);
  final CustomerRepository _repo;

  Future<Result<Paged<Customer>>> call(CustomerQuery query, {PageCursor? after}) => _repo.list(query, after: after);
}

class GetCustomer {
  const GetCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<Customer>> call(String id) => _repo.get(id);
}

class CreateCustomer {
  const CreateCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<Customer>> call(CustomerInput input) {
    if (input.name.trim().isEmpty) return Future.value(const Err(ValidationFailure('required')));
    return _repo.create(input.copyWith(name: input.name.trim(), phone: input.phone.trim(), address: input.address.trim()));
  }
}

class UpdateCustomer {
  const UpdateCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<void>> call(String id, CustomerInput input) {
    if (input.name.trim().isEmpty) return Future.value(const Err(ValidationFailure('required')));
    return _repo.update(id, input.copyWith(name: input.name.trim()));
  }
}

class DeactivateCustomer {
  const DeactivateCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<void>> call(String id) => _repo.deactivate(id);
}

class RestoreCustomer {
  const RestoreCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<void>> call(String id) => _repo.restore(id);
}

class PurgeCustomer {
  const PurgeCustomer(this._repo);
  final CustomerRepository _repo;

  Future<Result<PurgeMode>> call(Customer customer) {
    if (customer.hasActiveDebt) return Future.value(const Err(ConflictFailure('customer_has_debt')));
    return _repo.purge(customer.id);
  }
}
