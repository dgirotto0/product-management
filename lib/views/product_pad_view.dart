import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../providers/product_provider.dart';

class ProductPadView extends StatefulWidget {
  const ProductPadView({super.key});

  @override
  _ProductPadViewState createState() => _ProductPadViewState();
}

class _ProductPadViewState extends State<ProductPadView> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: const Color.fromARGB(255, 250, 151, 0),
  );

  String _recognizedText = '';
  String _productPrice = '';
  String _productFilter = '';
  bool _canGoForward = false;

  void _recognizeText() async {
    try {
      final image = await _controller.toImage();
      final bytes = await image?.toByteData(format: ImageByteFormat.png);

      if (bytes == null) {
        throw Exception('Erro ao converter imagem para bytes.');
      }

      final imageBase64 = base64Encode(bytes.buffer.asUint8List());

      const apiKey = 'AIzaSyA_6SkupboP69oUXtUfMePLc6O2-X9GZFU';
      const url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'requests': [
            {
              'image': {
                'content': imageBase64,
              },
              'features': [
                {
                  'type': 'TEXT_DETECTION',
                  'maxResults': 1,
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final textAnnotations = data['responses'][0]['textAnnotations'] as List;
        if (textAnnotations.isNotEmpty) {
          final text = textAnnotations[0]['description'] as String;
          setState(() {
            _recognizedText = text.trim().toUpperCase().replaceAll(' ', '').
                                                        replaceAll('|', '').
                                                        replaceAll('\\', '').
                                                        replaceAll('ç', '');
          });
          _findProductDetails(_recognizedText);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao reconhecer texto: Nenhum texto detectado'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao reconhecer texto: Erro na API do Google Cloud Vision'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao reconhecer texto: $e')),
      );
    }
  }

  void _findProductDetails(String productName) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    List<String> tablesToSearch = [
      'tb_filtro_ar',
      'tb_filtro_cabine',
      'tb_filtro_combustivel',
      'tb_filtro_oleo'
    ];

    for (String tableName in tablesToSearch) {
      try {
        final product = productProvider.getProductsByTable(tableName).firstWhere(
              (product) =>
                  product.filtro?.replaceAll(' ', '').toUpperCase().trim() ==
                  productName
        );
        setState(() {
          _productFilter = product.filtro ?? 'Não encontrado';
          _productPrice = product.valor?.toStringAsFixed(2) ?? 'Não encontrado';
        });
        print(productName);
        return;
      } catch (e) {
        continue;
      }
    }
    setState(() {
      _productFilter = 'Não encontrado';
      _productPrice = 'Não encontrado';
    });
  }

  void _undoLastStroke() {
    if (_controller.isNotEmpty) {
      setState(() {
        _controller.undo();
        _canGoForward = true;
      });
    }
  }

  void _redoLastStroke() {
    if (_canGoForward) {
      setState(() {
        _controller.redo();
        _canGoForward = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      appBar: AppBar(
        title: const Text(
          'Buscar Preço do Produto',
          style: TextStyle(color: Color.fromARGB(255, 250, 151, 0)),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 600,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 250, 151, 0),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Signature(
                      controller: _controller,
                      backgroundColor: const Color.fromARGB(190, 16, 15, 15),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.undo),
                        color: const Color.fromARGB(255, 250, 151, 0),
                        onPressed: _undoLastStroke,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.redo),
                        color: const Color.fromARGB(255, 250, 151, 0),
                        onPressed: _canGoForward ? _redoLastStroke : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto reconhecido: $_recognizedText',
              style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 250, 151, 0)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _recognizedText = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 151, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Limpar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _recognizeText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 151, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Buscar Produto',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Preço: ',
                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 250, 151, 0)),
                        ),
                        TextSpan(
                          text: _productPrice,
                          style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Filtro: ',
                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 250, 151, 0)),
                        ),
                        TextSpan(
                          text: _productFilter,
                          style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
