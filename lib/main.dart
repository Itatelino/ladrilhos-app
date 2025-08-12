import 'dart:convert';
// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:ladrilho_app/controlles/sqlite_controller.dart';
// ignore: unused_import
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initDb(); // Simula inicialização assíncrona
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ladrilhos da Roça',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ImageCustomizerScreen(),
    );
  }
}

class ImageCustomizerScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ImageCustomizerScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageCustomizerScreenState createState() => _ImageCustomizerScreenState();
}

// ignore: unused_element
class _ImageCustomizerScreenState extends State<ImageCustomizerScreen> {
  // Remova o File e o ImagePicker
  // File? _selectedImage;
  String? _selectedAssetImage;
  Color _selectedColor = Colors.blue;
  double _widthCm = 10.0;
  double _heightCm = 10.0;
  final TextEditingController _notesController = TextEditingController();

  // Lista de imagens dos assets
  final List<String> _assetImages = [
    'assets/images/lad001.png',
    'assets/images/lad002.png',
    'assets/images/lad003.png',
    'assets/images/lad004.png',
    'assets/images/lad005.png',
    'assets/images/lad006.png',
    'assets/images/lad007.png',
    'assets/images/lad008.png',
    'assets/images/lad009.png',
    'assets/images/lad010.png',
    // Adicione mais caminhos conforme necessário
  ];

  // ignore: unused_element
  void _submitOrder() async {
    if (_selectedAssetImage == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        // Antes era context
        const SnackBar(content: Text('Por favor, selecione uma imagem')),
      );
      return;
    }

    // Exemplo de dados do pedido
    final orderData = {
      'image': _selectedAssetImage,
      // ignore: deprecated_member_use
      'color': _selectedColor.value,
      'width_cm': _widthCm,
      'height_cm': _heightCm,
      'notes': _notesController.text,
    };

    // Envio para uma API fictícia (substitua pela sua URL)
    try {
      final response = await http.post(
        Uri.parse('https://sua-api.com/pedidos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: (context as BuildContext), // Antes era context
          builder: (context) => AlertDialog(
            title: const Text('Pedido Enviado'),
            content: const Text('Seu pedido foi enviado com sucesso!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Erro ao enviar pedido');
      }
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: (context as BuildContext), // Antes era context
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Falha ao enviar pedido: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu Ladrilho')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seleção de imagem dos assets
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Selecione um Ladrilho',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectedAssetImage == null
                        ? const Icon(Icons.image, size: 100, color: Colors.grey)
                        : Image.asset(_selectedAssetImage!, height: 200),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: _assetImages.map((img) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAssetImage = img;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedAssetImage == img
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(img, width: 60, height: 60),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Cor (igual ao seu código atual)

            // Dimensões em centímetros
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Defina as dimensões',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Largura: ${_widthCm.toStringAsFixed(1)} cm'),
                    Slider(
                      value: _widthCm,
                      min: 5,
                      max: 80,
                      divisions: 75,
                      label: _widthCm.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _widthCm = value;
                        });
                      },
                    ),
                    Text('Altura: ${_heightCm.toStringAsFixed(1)} cm'),
                    Slider(
                      value: _heightCm,
                      min: 5,
                      max: 80,
                      divisions: 75,
                      label: _heightCm.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _heightCm = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Observações
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                  ),
                  maxLines: 3,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão de envio
            ElevatedButton(
              onPressed: _submitOrder,
              child: const Text('Enviar Pedido'),
            ),

            // código (observações, botão enviar, etc)...
          ],
        ),
      ),
    );

    // Observações
    // ignore: non_constant_identifier_names
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

// Move this outside the class as a top-level constant
final List<Color> availableColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  // ignore: use_super_parameters
  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableColors.map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor == color
                    ? Colors.black
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
