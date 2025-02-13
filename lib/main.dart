import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/product_provider.dart';
import 'views/product_edit_view.dart';
import 'views/product_list_view.dart';
import 'views/product_pad_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());

  doWhenWindowReady(() {
    appWindow.maximize(); // Tenta maximizar a janela
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        title: 'Tabela de Produtos',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(224, 172, 0, 0.9),
        ),
        home: const HomeScreen(),
        routes: {
          '/pad': (context) => const ProductPadView(),
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Lista com os nomes de todas as tabelas (na mesma ordem das abas, sem contar a aba "Home")
  final List<String> _allTables = [
    'tb_paletas',
    'tb_filtro_oleo',
    'tb_filtro_ar',
    'tb_filtro_combustivel',
    'tb_filtro_cabine',
    'tb_filtro_moto',
    'tb_mangueira',
    'tb_bujao',
    'tb_balde_graxa',
    'tb_oleo_litro',
    'tb_atf',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 12,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.note_alt,
              color: Color.fromARGB(255, 250, 151, 0),
              size: 55,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            onPressed: () {
              Navigator.pushNamed(context, '/pad');
            },
          ),
          title: const Text(
            'Gestão de Produtos',
            style: TextStyle(
              color: Color.fromARGB(255, 250, 151, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(190, 16, 15, 15),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                // Campo de busca geral
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 500, vertical: 8),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar Geral...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 250, 151, 0),
                              ),
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
                              // Redireciona para a aba "Home"
                              DefaultTabController.of(context).animateTo(0);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = _searchController.text;
                                });
                                DefaultTabController.of(context).animateTo(0);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 151, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Pesquisar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Aba (TabBar)
                const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Home'),
                    Tab(text: 'Paletas'),
                    Tab(text: 'Filtro Óleo'),
                    Tab(text: 'Filtro Ar'),
                    Tab(text: 'Filtro Combustível'),
                    Tab(text: 'Filtro Cabine'),
                    Tab(text: 'Filtro Moto'),
                    Tab(text: 'Mangueira'),
                    Tab(text: 'Bujao'),
                    Tab(text: 'Balde Graxa'),
                    Tab(text: 'Óleo Litro'),
                    Tab(text: 'ATF'),
                  ],
                  labelColor: Color.fromARGB(255, 250, 151, 0),
                  indicatorColor: Color.fromARGB(255, 250, 151, 0),
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 18),
                  tabAlignment: TabAlignment.center,
                ),
              ],
            ),
          ),
        ),
        // As abas: a primeira é a "Home" (resultados unificados) e as demais são as listas específicas.
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSearchResults(
                context), // Aba "Home" com os resultados da pesquisa
            const ProductListView(tableName: 'tb_paletas'),
            const ProductListView(tableName: 'tb_filtro_oleo'),
            const ProductListView(tableName: 'tb_filtro_ar'),
            const ProductListView(tableName: 'tb_filtro_combustivel'),
            const ProductListView(tableName: 'tb_filtro_cabine'),
            const ProductListView(tableName: 'tb_filtro_moto'),
            const ProductListView(tableName: 'tb_mangueira'),
            const ProductListView(tableName: 'tb_bujao'),
            const ProductListView(tableName: 'tb_balde_graxa'),
            const ProductListView(tableName: 'tb_oleo_litro'),
            const ProductListView(tableName: 'tb_atf'),
          ],
        ),
      ),
    );
  }

  /// Método que reúne todos os produtos de todas as tabelas e filtra usando a mesma lógica do seu "buscar"
  Widget _buildSearchResults(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    List<Map<String, dynamic>> filteredResults = [];
    final query = _searchQuery.toLowerCase();

    // Se não houver pesquisa, exibe uma mensagem
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Digite sua pesquisa na barra acima',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    // Percorre cada tabela e aplica a lógica de filtragem
    for (final table in _allTables) {
      final products = productProvider.getProductsByTable(table);
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        bool matches = false;
        switch (table) {
          case 'tb_paletas':
            matches = (product.cod?.toLowerCase().contains(query) ?? false) ||
                (product.modelo?.toLowerCase().contains(query) ?? false) ||
                (product.tipo?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_filtro_oleo':
          case 'tb_filtro_ar':
            matches =
                (product.filtro?.toLowerCase().contains(query) ?? false) ||
                    (product.modelo?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_filtro_combustivel':
          case 'tb_filtro_cabine':
            matches =
                (product.filtro?.toLowerCase().contains(query) ?? false) ||
                    (product.modelo?.toLowerCase().contains(query) ?? false) ||
                    (product.correspondente?.toLowerCase().contains(query) ??
                        false);
            break;
          case 'tb_filtro_moto':
            matches =
                (product.filtro?.toLowerCase().contains(query) ?? false) ||
                    (product.modelo?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_mangueira':
            matches = (product.cod?.toLowerCase().contains(query) ?? false) ||
                (product.modelo?.toLowerCase().contains(query) ?? false) ||
                (product.numero?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_bujao':
            matches = (product.oleo?.toLowerCase().contains(query) ?? false) ||
                (product.modelo?.toLowerCase().contains(query) ?? false) ||
                (product.tipo?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_balde_graxa':
            matches = (product.oleo?.toLowerCase().contains(query) ?? false) ||
                (product.especificacao?.toLowerCase().contains(query) ?? false);
            break;
          case 'tb_oleo_litro':
          case 'tb_atf':
            matches = (product.oleo?.toLowerCase().contains(query) ?? false) ||
                (product.especificacao?.toLowerCase().contains(query) ??
                    false) ||
                (product.viscosidade?.toLowerCase().contains(query) ?? false);
            break;
          default:
            matches = product.toString().toLowerCase().contains(query);
        }
        if (matches) {
          // Armazena também o índice "i" do produto na tabela
          filteredResults.add({'table': table, 'product': product, 'index': i});
        }
      }
    }

    return Container(
      color: const Color.fromARGB(190, 16, 15, 15),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 4,
        ),
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          final item = filteredResults[index];
          final product = item['product'];
          final table = item['table'] as String;
          final productIndex =
              item['index'] as int; // Índice real do produto na tabela

          String title = '';
          String nonPricePart = '';
          String pricePart = '';

          switch (table) {
            case 'tb_paletas':
              title = '${product.cod} - ${product.modelo}';
              nonPricePart = '${product.tipo} • ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_filtro_oleo':
            case 'tb_filtro_ar':
              title = '${product.filtro} - ${product.modelo}';
              nonPricePart = '• ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_filtro_combustivel':
            case 'tb_filtro_cabine':
              title = '${product.filtro} - ${product.modelo}';
              nonPricePart = '${product.correspondente} • ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_filtro_moto':
              title = '${product.filtro} - ${product.modelo}';
              nonPricePart = '• ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_mangueira':
              title = '${product.cod} - ${product.modelo}';
              nonPricePart = '${product.numero} • ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_bujao':
              title = '${product.oleo} - ${product.modelo}';
              nonPricePart = '${product.tipo} • ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_balde_graxa':
              title = '${product.oleo} - ${product.especificacao}';
              nonPricePart = '• ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            case 'tb_oleo_litro':
            case 'tb_atf':
              title = '${product.oleo} - ${product.especificacao}';
              nonPricePart = '${product.viscosidade} • ';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
            default:
              title = 'Item';
              nonPricePart = '';
              pricePart = 'R\$${product.valor?.toStringAsFixed(2)}';
              break;
          }

          return Card(
            color: const Color.fromARGB(190, 16, 15, 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Área de texto
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título limitado a 2 linhas com reticências
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Subtítulo
                        RichText(
                          text: TextSpan(
                            text: nonPricePart,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 21),
                            children: [
                              TextSpan(
                                text: pricePart,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 250, 151, 0),
                                  fontSize: 21,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botão de edição fixo à direita
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 250, 151, 0),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ProductEditView(
                          product: product,
                          productIndex: productIndex,
                          tableName: table,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
