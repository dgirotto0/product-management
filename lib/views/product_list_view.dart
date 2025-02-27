import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'product_add_view.dart';
import 'product_edit_view.dart';

class ProductListView extends StatefulWidget {
  final String tableName;

  const ProductListView({super.key, required this.tableName});

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  int _visibleItemCount = 21;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.getProductsByTable(widget.tableName);
          final visibleProducts = products.take(_visibleItemCount).toList();
          final showLoadMore = _visibleItemCount < products.length;

          return Container(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Grade dos produtos
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = visibleProducts[index];
                        String title = '';
                        String nonPricePart = '';
                        String pricePart = '';

                        switch (widget.tableName) {
                          case 'tb_paletas':
                            title = '${product.cod} - ${product.modelo}';
                            nonPricePart = '${product.tipo} • ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_filtro_oleo':
                          case 'tb_filtro_ar':
                            title = '${product.filtro} - ${product.modelo}';
                            nonPricePart = '• ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_filtro_combustivel':
                          case 'tb_filtro_cabine':
                            title = '${product.filtro} - ${product.modelo}';
                            nonPricePart = '${product.correspondente} • ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_filtro_moto':
                            title = '${product.filtro} - ${product.modelo}';
                            nonPricePart = '• ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_mangueira':
                            title = '${product.cod} - ${product.modelo}';
                            nonPricePart = '${product.numero} • ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_bujao':
                            title = '${product.oleo} - ${product.modelo}';
                            nonPricePart = '${product.tipo} • ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_balde_graxa':
                            title =
                                '${product.oleo} - ${product.especificacao}';
                            nonPricePart = '• ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          case 'tb_oleo_litro':
                          case 'tb_atf':
                            title =
                                '${product.oleo} - ${product.especificacao}';
                            nonPricePart = '${product.viscosidade} • ';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                          default:
                            title = 'Item';
                            nonPricePart = '';
                            pricePart =
                                'R\$${product.valor?.toStringAsFixed(2)}';
                            break;
                        }

                        return Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          text: nonPricePart,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              fontSize: 21),
                                          children: [
                                            TextSpan(
                                              text: pricePart,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ProductEditView(
                                        product: product,
                                        productIndex: index,
                                        tableName: widget.tableName,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: visibleProducts.length,
                    ),
                  ),
                ),
                if (showLoadMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        widthFactor: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _visibleItemCount += 21;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Ver mais',
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ProductAddView(tableName: widget.tableName),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
