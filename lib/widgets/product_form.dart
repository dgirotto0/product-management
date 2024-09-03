import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final String? initialName;
  final double? initialPrice;
  final void Function(String, double) onSubmit;

  const ProductForm({super.key,
    this.initialName,
    this.initialPrice,
    required this.onSubmit,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName ?? '';
    _price = widget.initialPrice ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _name,
            decoration: const InputDecoration(labelText: 'Nome do Produto'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor insira o nome do produto';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            initialValue: _price.toString(),
            decoration: const InputDecoration(labelText: 'Preço'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor insira o preço';
              }
              return null;
            },
            onSaved: (value) {
              _price = double.parse(value!);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_name, _price);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
