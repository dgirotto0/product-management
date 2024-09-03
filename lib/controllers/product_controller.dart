import '../models/products.dart';

class ProductController {
  final Map<String, List<Product>> _productsByTable = {};

  List<Product> getProductsByTable(String tableName) {
    return _productsByTable[tableName] ?? [];
  }

  void addProduct(String tableName, Product product) {
    if (!_productsByTable.containsKey(tableName)) {
      _productsByTable[tableName] = [];
    }
    _productsByTable[tableName]!.add(product);
  }

  void updateProduct(String tableName, int index, Product updatedProduct) {
    if (_productsByTable.containsKey(tableName)) {
      List<Product> products = _productsByTable[tableName]!;
      if (index >= 0 && index < products.length) {
        products[index] = updatedProduct;
      }
    }
  }

  void setProducts(String tableName, List<Product> newProducts) {
    _productsByTable[tableName] = newProducts;
  }
}
