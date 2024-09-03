import 'package:flutter/material.dart';
import '../models/products.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductAddView extends StatefulWidget {
  final String tableName;

  const ProductAddView({super.key, required this.tableName});

  @override
  _ProductAddViewState createState() => _ProductAddViewState();
}

class _ProductAddViewState extends State<ProductAddView> {
  final _formKey = GlobalKey<FormState>();
  String _filtro = '';
  late String _modelo;
  late double _valor;
  String? _tipo;
  String? _cod;
  String? _correspondente;
  String? _numero;
  String? _especificacao;
  String? _oleo;
  String? _viscosidade;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(minWidth: 300),
        decoration: BoxDecoration(
          color: const Color.fromARGB(190, 16, 15, 15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 250, 151, 0), 
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._buildFormFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Product novoProduto = _createProductFromInput();
                      Provider.of<ProductProvider>(context, listen: false)
                          .addProduct(novoProduto, widget.tableName);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 151, 0),
                  ),
                  child: const Text(
                    'Adicionar Produto',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [];

    switch (widget.tableName) {
      case 'tb_paletas':
      case 'tb_bujao':
        fields.addAll([
          _buildTextFormField('Código', (value) => _cod = value!),
          _buildTextFormField('Modelo', (value) => _modelo = value!),
          _buildTextFormField('Tipo', (value) => _tipo = value!),
        ]);
        break;
      case 'tb_filtro_oleo':
      case 'tb_filtro_ar':
      case 'tb_filtro_combustivel':
      case 'tb_filtro_cabine':
      case 'tb_filtro_moto':
        fields.addAll([
          _buildTextFormField('Filtro', (value) => _filtro = value!),
          _buildTextFormField('Modelo', (value) => _modelo = value!),
          if (widget.tableName == 'tb_filtro_ar' ||
              widget.tableName == 'tb_filtro_cabine')
            _buildTextFormField(
              'Correspondente',
              (value) => _correspondente = value!,
            ),
        ]);
        break;
      case 'tb_mangueira':
        fields.addAll([
          _buildTextFormField('Código', (value) => _cod = value!),
          _buildTextFormField('Modelo', (value) => _modelo = value!),
          _buildTextFormField('Número', (value) => _numero = value!),
        ]);
        break;
      case 'tb_balde_graxa':
        fields.addAll([
          _buildTextFormField('Código', (value) => _oleo = value!),
          _buildTextFormField('Especificação', (value) => _especificacao = value!),
        ]);
        break;
      case 'tb_oleo_litro':
      case 'tb_atf':
        fields.addAll([
          _buildTextFormField('Óleo', (value) => _oleo = value!),
          _buildTextFormField('Especificação', (value) => _especificacao = value!),
          _buildTextFormField('Viscosidade', (value) => _viscosidade = value!),
        ]);
        break;
    }

    fields.add(
      _buildTextFormField(
        'Preço',
        (value) => _valor = double.parse(value!),
        keyboardType: TextInputType.number,
      ),
    );

    return fields;
  }

  Widget _buildTextFormField(
    String label,
    FormFieldSetter<String> onSaved, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 250, 151, 0)),
        errorStyle: const TextStyle(color: Color.fromARGB(255, 215, 59, 20)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 250, 151, 0)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: (value) {
        if (label == 'Preço') {
          if (value == null || value.isEmpty) {
            return 'Esse campo é obrigatório';
          }
          final parsedValue = double.tryParse(value);
          if (parsedValue == null) {
            return 'Por favor insira um número válido';
          }
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Product _createProductFromInput() {
    return Product(
      filtro: _filtro.isNotEmpty ? _filtro : '',
      modelo: _modelo,
      valor: _valor,
      tipo: _tipo,
      cod: _cod,
      correspondente: _correspondente,
      numero: _numero,
      especificacao: _especificacao,
      oleo: _oleo,
      viscosidade: _viscosidade,
    );
  }
}
