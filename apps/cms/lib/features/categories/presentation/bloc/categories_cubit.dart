import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesState {
  const CategoriesState({this.loading = true, this.items = const [], this.failure});
  final bool loading;
  final List<Category> items;
  final Failure? failure;
}

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._get, this._create, this._rename, this._delete) : super(const CategoriesState());
  final GetCategories _get;
  final CreateCategory _create;
  final RenameCategory _rename;
  final DeleteCategory _delete;

  Future<void> load() async {
    emit(CategoriesState(items: state.items));
    final result = await _get();
    emit(switch (result) {
      Ok(:final value) => CategoriesState(loading: false, items: value),
      Err(:final failure) => CategoriesState(loading: false, failure: failure),
    });
  }

  Future<Result<T>> _act<T>(Future<Result<T>> Function() action) async {
    final result = await action();
    if (result case Ok()) await load();
    return result;
  }

  Future<Result<Category>> create(String name) => _act(() => _create(name, existing: state.items));
  Future<Result<void>> rename(Category c, String name) => _act(() => _rename(c.id, name, existing: state.items));
  Future<Result<void>> delete(Category c) => _act(() => _delete(c));
}
