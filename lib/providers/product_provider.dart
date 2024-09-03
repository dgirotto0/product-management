import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/products.dart';
import '../data/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductController _productController = ProductController();
  final ProductRepository _repository = ProductRepository();

  final Map<String, List<String>> _tableColumns = {
    'tb_paletas': ['cod', 'modelo', 'tipo', 'valor'],
    'tb_filtro_oleo': ['filtro', 'modelo', 'valor'],
    'tb_filtro_ar': ['filtro', 'modelo', 'valor', 'correspondente'],
    'tb_filtro_combustivel': ['filtro', 'modelo', 'valor'],
    'tb_filtro_cabine': ['filtro', 'modelo', 'valor', 'correspondente'],
    'tb_filtro_moto': ['filtro', 'modelo', 'valor'],
    'tb_mangueira': ['cod', 'modelo', 'valor', 'numero'],
    'tb_bujao': ['cod', 'modelo', 'tipo', 'valor'],
    'tb_balde_graxa': ['oleo', 'especificacao', 'valor'],
    'tb_oleo_litro': ['especificacao', 'oleo', 'viscosidade', 'valor'],
    'tb_atf': ['oleo', 'viscosidade', 'especificacao', 'valor'],
  };

  ProductProvider() {
    _loadAllProducts();
  }

  List<Product> getProductsByTable(String tableName) {
    return _productController.getProductsByTable(tableName);
  }

  Future<void> _loadAllProducts() async {
    for (String table in _tableColumns.keys) {
      await _loadProductsByTable(table);
    }
  }

  Future<void> _loadProductsByTable(String tableName) async {
    try {
      final columns = _tableColumns[tableName]!;
      final productsFromDatabase = await _repository.getAllProductsByTable(tableName, columns);
      _productController.setProducts(tableName, productsFromDatabase);
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar produtos da tabela $tableName: $e');
    }
  }

  void updateProduct(int index, Product updatedProduct, String tableName) {
    _productController.updateProduct(tableName, index, updatedProduct);
    notifyListeners();
  }

  Future<void> addProduct(Product product, String tableName) async {
    try {
      final columns = _tableColumns[tableName]!;
      await _repository.insertProduct(product, tableName, columns);
      await _loadProductsByTable(tableName);
    } catch (e) {
      print('Erro ao adicionar produto na tabela $tableName: $e');
      rethrow;
    }
  }
}
