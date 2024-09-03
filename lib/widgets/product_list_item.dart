import 'package:flutter/material.dart';
import '../models/products.dart';
import '../views/product_edit_view.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final int productIndex;
  final String tableName;

  const ProductListItem({
    super.key,
    required this.product,
    required this.productIndex,
    required this.tableName,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = 'R\$ ${product.valor?.toStringAsFixed(2) ?? '0.00'}';

    if (product.filtro != null && product.modelo != null) {
      subtitle = '${product.filtro} - ${product.modelo} \n$subtitle';
    } else if (product.filtro != null) {
      subtitle = '${product.filtro!}\n$subtitle';
    } else if (product.modelo != null) {
      subtitle = '${product.modelo!}\n$subtitle';
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(product.filtro ?? 'N/A'),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductEditView(
                  product: product,
                  productIndex: productIndex,
                  tableName: tableName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
