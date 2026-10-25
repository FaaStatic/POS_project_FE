import '../../../category/domain/entities/category.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../product/domain/entities/product.dart';

/// Device-local copy of products, categories, and customers (kasir only).
abstract interface class CatalogCache {
  /// Most-sold first, then by name.
  Stream<List<Product>> watchProducts({String? search, String? categoryId});
  Future<Product?> productByBarcode(String barcode);
  Future<Product?> product(String id);
  Future<Map<String, double>> stockOf(Iterable<String> productIds);

  /// Replaces the cache while keeping each product's local sales count.
  Future<void> replaceProducts(List<Product> products);
  Future<void> upsertProduct(Product product);

  /// Applies stock deltas; [countSale] also bumps the sales count used for ordering.
  Future<void> adjustStock(Map<String, double> deltas, {bool countSale = false});

  Stream<List<Category>> watchCategories();
  Future<void> replaceCategories(List<Category> categories);

  Stream<List<Customer>> watchCustomers({String? search});
  Future<Customer?> customer(String id);
  Future<void> replaceCustomers(List<Customer> customers);
  Future<void> upsertCustomer(Customer customer);
}
