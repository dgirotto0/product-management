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
  int _visibleItemCount = 10;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(190, 16, 15, 15),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SizedBox(
                height: 40,
                width: 400, 
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
                          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 250, 151, 0)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10), // Espaçamento entre o campo e o botão
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = _searchController.text;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 250, 151, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Pesquisar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.getProductsByTable(widget.tableName);
                final filteredProducts = products.where((product) {
                  final query = _searchQuery.toLowerCase();
                  switch (widget.tableName) {
                    case 'tb_paletas':
                      return (product.cod?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false) ||
                            (product.tipo?.toLowerCase().contains(query) ?? false);
                    case 'tb_filtro_oleo':
                    case 'tb_filtro_ar':
                      return (product.filtro?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false);
                    case 'tb_filtro_combustivel':
                    case 'tb_filtro_cabine':
                      return (product.filtro?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false) ||
                            (product.correspondente?.toLowerCase().contains(query) ?? false);
                    case 'tb_filtro_moto':
                      return (product.filtro?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false);
                    case 'tb_mangueira':
                      return (product.cod?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false) ||
                            (product.numero?.toLowerCase().contains(query) ?? false);
                    case 'tb_bujao':
                      return (product.oleo?.toLowerCase().contains(query) ?? false) ||
                            (product.modelo?.toLowerCase().contains(query) ?? false) ||
                            (product.tipo?.toLowerCase().contains(query) ?? false);
                    case 'tb_balde_graxa':
                      return (product.oleo?.toLowerCase().contains(query) ?? false) ||
                            (product.especificacao?.toLowerCase().contains(query) ?? false);
                    case 'tb_oleo_litro':
                    case 'tb_atf':
                      return (product.oleo?.toLowerCase().contains(query) ?? false) ||
                            (product.especificacao?.toLowerCase().contains(query) ?? false) ||
                            (product.viscosidade?.toLowerCase().contains(query) ?? false);
                    default:
                      return product.toString().toLowerCase().contains(query);
                  }

                }).toList();
                final visibleProducts = filteredProducts.take(_visibleItemCount).toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: visibleProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == visibleProducts.length) {
                      return Visibility(
                        visible: _visibleItemCount < filteredProducts.length,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 650),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _visibleItemCount += 10;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 250, 151, 0),
                            ),
                            child: const Text(
                              'Ver mais...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final product = visibleProducts[index];
                    String title = '';
                    String subtitle = '';

                    switch (widget.tableName) {
                      case 'tb_paletas':
                        title = '${product.cod} - ${product.modelo}';
                        subtitle = '${product.tipo} • R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_filtro_oleo':
                      case 'tb_filtro_ar':
                        title = '${product.filtro} - ${product.modelo}';
                        subtitle = '• R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_filtro_combustivel':
                      case 'tb_filtro_cabine':
                        title = '${product.filtro} - ${product.modelo}';
                        subtitle = '${product.correspondente} • R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_filtro_moto':
                        title = '${product.filtro} - ${product.modelo}';
                        subtitle = '• R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_mangueira':
                        title = '${product.cod} - ${product.modelo}';
                        subtitle = '${product.numero} • R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_bujao':
                        title = '${product.oleo} - ${product.modelo}';
                        subtitle = '${product.tipo} • R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_balde_graxa':
                        title = '${product.oleo} - ${product.especificacao}';
                        subtitle = '• R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      case 'tb_oleo_litro':
                      case 'tb_atf':
                        title = '${product.oleo} - ${product.especificacao}';
                        subtitle = '${product.viscosidade} • R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                      default:
                        title = 'Item';
                        subtitle = 'R\$${product.valor?.toStringAsFixed(2)}';
                        break;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: const Color.fromARGB(190, 16, 15, 15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 250, 151, 0),
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ProductAddView(
              tableName: widget.tableName,
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 250, 151, 0),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
