import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'views/product_edit_view.dart';
import 'views/product_list_view.dart';
import 'views/product_pad_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    appWindow.maximize();
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Tabela de Produtos',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/pad': (context) => const ProductPadView(),
      },
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
            icon: Icon(
              Icons.note_alt,
              color: Theme.of(context).primaryColor,
              size: 55,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            onPressed: () {
              Navigator.pushNamed(context, '/pad');
            },
          ),
          title: Text(
            'Gestão de Produtos',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
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
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
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
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Pesquisar',
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 17),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Aba (TabBar)
                TabBar(
                  isScrollable: true,
                  tabs: const [
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
                  labelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).canvasColor,
                  labelStyle: const TextStyle(fontSize: 18),
                  tabAlignment: TabAlignment.center,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSearchResults(context),
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

  Widget _buildSearchResults(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    List<Map<String, dynamic>> filteredResults = [];
    final query = _searchQuery.toLowerCase();

    if (query.isEmpty) {
      return Center(
        child: Text(
          'Digite sua pesquisa na barra acima',
          style: TextStyle(color: Theme.of(context).canvasColor, fontSize: 18),
        ),
      );
    }

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
          filteredResults.add({'table': table, 'product': product, 'index': i});
        }
      }
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
          final productIndex = item['index'] as int;

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
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: Theme.of(context).canvasColor,
                                fontSize: 21),
                            children: [
                              TextSpan(
                                text: pricePart,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
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
