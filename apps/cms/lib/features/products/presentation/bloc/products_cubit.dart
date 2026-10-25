import 'package:core/core.dart';

import '../../../../common/paged_list_cubit.dart';

class ProductsCubit extends PagedListCubit<Product, ProductQuery> {
  ProductsCubit(GetProducts get, this._categories, this._create, this._update, this._adjust, this._delete)
      : super(get.call, const ProductQuery(limit: 50));

  final GetCategories _categories;
  final CreateProduct _create;
  final UpdateProduct _update;
  final AdjustStock _adjust;
  final DeleteProduct _delete;

  List<Category> categories = const [];

  @override
  Future<void> load([ProductQuery? next]) async {
    if (categories.isEmpty) {
      if (await _categories() case Ok(:final value)) categories = value;
    }
    return super.load(next);
  }

  void search(String text) => load(ProductQuery(search: text, categoryId: query.categoryId, limit: 50));
  void filter(String? categoryId) => load(ProductQuery(search: query.search, categoryId: categoryId, limit: 50));

  /// A new category name may be typed; refresh the list afterwards so filters see it.
  Future<Result<Object?>> _withCategoryRefresh(Future<Result<Object?>> Function() action) async {
    final result = await act(action);
    if (result case Ok()) {
      if (await _categories() case Ok(:final value)) categories = value;
    }
    return result;
  }

  Future<Result<Object?>> create(NewProduct p) => _withCategoryRefresh(() => _create(p));
  Future<Result<Object?>> update(Product p, ProductPatch patch) => _withCategoryRefresh(() => _update(p.id, patch));
  Future<Result<void>> adjustStock(Product p, double delta) => act(() => _adjust(p.id, delta));
  Future<Result<void>> delete(Product p) => act(() => _delete(p.id));
}
