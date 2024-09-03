import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../providers/product_provider.dart';

class ProductEditView extends StatefulWidget {
  final Product product;
  final int productIndex;
  final String tableName;

  const ProductEditView({
    super.key,
    required this.product,
    required this.productIndex,
    required this.tableName,
  });

  @override
  _ProductEditViewState createState() => _ProductEditViewState();
}

class _ProductEditViewState extends State<ProductEditView> {
  final _formKey = GlobalKey<FormState>();
  late String _filtro;
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
  void initState() {
    super.initState();
    _filtro = widget.product.filtro ?? '';
    _modelo = widget.product.modelo ?? '';
    _valor = widget.product.valor ?? 0.0;
    _tipo = widget.product.tipo;
    _cod = widget.product.cod;
    _correspondente = widget.product.correspondente;
    _numero = widget.product.numero;
    _especificacao = widget.product.especificacao;
    _oleo = widget.product.oleo;
    _viscosidade = widget.product.viscosidade;
  }

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
            width: 3
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
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:const Color.fromARGB(255, 250, 151, 0),
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
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
          _buildTextFormField(
              'Código', (value) => _cod = value!,
              initialValue: _cod),
          _buildTextFormField(
              'Modelo', (value) => _modelo = value!,
              initialValue: _modelo),
          _buildTextFormField('Tipo', (value) => _tipo = value!,
              initialValue: _tipo),
        ]);
        break;
      case 'tb_filtro_oleo':
      case 'tb_filtro_ar':
      case 'tb_filtro_combustivel':
      case 'tb_filtro_cabine':
      case 'tb_filtro_moto':
        fields.addAll([
          _buildTextFormField(
              'Filtro', (value) => _filtro = value!,
              initialValue: _filtro),
          _buildTextFormField(
              'Modelo', (value) => _modelo = value!,
              initialValue: _modelo),
          if (widget.tableName == 'tb_filtro_ar' ||
              widget.tableName == 'tb_filtro_cabine')
            _buildTextFormField('Correspondente',
                (value) => _correspondente = value!,
                initialValue: _correspondente),
        ]);
        break;
      case 'tb_mangueira':
        fields.addAll([
          _buildTextFormField(
              'Código', (value) => _cod = value!,
              initialValue: _cod),
          _buildTextFormField(
              'Modelo', (value) => _modelo = value!,
              initialValue: _modelo),
          _buildTextFormField(
              'Número', (value) => _numero = value!,
              initialValue: _numero),
        ]);
        break;
      case 'tb_balde_graxa':
        fields.addAll([
          _buildTextFormField(
              'Código', (value) => _oleo = value!,
              initialValue: _oleo),
          _buildTextFormField('Especificação',
              (value) => _especificacao = value!,
              initialValue: _especificacao),
        ]);
        break;
      case 'tb_oleo_litro':
      case 'tb_atf':
        fields.addAll([
          _buildTextFormField('Óleo', (value) => _oleo = value!,
              initialValue: _oleo),
          _buildTextFormField('Especificação',
              (value) => _especificacao = value!,
              initialValue: _especificacao),
          _buildTextFormField('Viscosidade',
              (value) => _viscosidade = value!,
              initialValue: _viscosidade),
        ]);
        break;
    }

    fields.add(
      _buildTextFormField(
        'Preço',
        (value) => _valor = double.parse(value!),
        initialValue: _valor.toString(),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Esse campo é obrigatório';
          }
          if (double.tryParse(value) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
      ),
    );

    return fields;
  }

  Widget _buildTextFormField(
    String label,
    FormFieldSetter<String> onSaved, {
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 250, 151, 0)),
        errorStyle: const TextStyle(color: Color.fromARGB(255, 215, 59, 20)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 250, 151, 0)),
        ),
        ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final editedProduct = Product(
        filtro: _filtro,
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

      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.productIndex, editedProduct, widget.tableName);

      Navigator.of(context).pop();
    }
  }
}
