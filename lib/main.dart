import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/product_provider.dart';
import 'views/product_list_view.dart';
import 'views/product_pad_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  runApp(const MyApp());
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.edit_note, 
              color: Color.fromARGB(255, 250, 151, 0),
              size: 30,
              ),
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
          bottom: const TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: [
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
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            ProductListView(tableName: 'tb_paletas'),
            ProductListView(tableName: 'tb_filtro_oleo'),
            ProductListView(tableName: 'tb_filtro_ar'),
            ProductListView(tableName: 'tb_filtro_combustivel'),
            ProductListView(tableName: 'tb_filtro_cabine'),
            ProductListView(tableName: 'tb_filtro_moto'),
            ProductListView(tableName: 'tb_mangueira'),
            ProductListView(tableName: 'tb_bujao'),
            ProductListView(tableName: 'tb_balde_graxa'),
            ProductListView(tableName: 'tb_oleo_litro'),
            ProductListView(tableName: 'tb_atf'),
          ],
        ),
      ),
    );
  }
}
