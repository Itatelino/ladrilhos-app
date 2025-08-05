import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personalizador de Imagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ImageCustomizerScreen(),
    );
  }
}

class ImageCustomizerScreen extends StatefulWidget {
  const ImageCustomizerScreen({super.key});

  @override
  _ImageCustomizerScreenState createState() => _ImageCustomizerScreenState();
}

class _ImageCustomizerScreenState extends State<ImageCustomizerScreen> {
  File? _selectedImage;
  Color _selectedColor = Colors.blue;
  double _width = 300.0;
  double _height = 300.0;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitOrder() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma imagem')),
      );
      return;
    }

    // Implementar a lógica para enviar o pedido
    // Upload para um servidor ou salvar localmente

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido Enviado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dimensões: ${_width.toInt()}x${_height.toInt()}'),
            Text('Cor: ${_selectedColor.toString()}'),
            if (_notesController.text.isNotEmpty)
              Text('Observações: ${_notesController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalizar Imagem')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seleção de imagem
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Selecione uma imagem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _selectedImage == null
                        ? const Icon(Icons.image, size: 100, color: Colors.grey)
                        : Image.file(_selectedImage!, height: 200),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Escolher Imagem'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Cor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione uma cor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ColorPicker(
                      selectedColor: _selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dimensões
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
                    Text('Largura: ${_width.toInt()}px'),
                    Slider(
                      value: _width,
                      min: 100,
                      max: 800,
                      divisions: 7,
                      label: _width.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _width = value;
                        });
                      },
                    ),
                    Text('Altura: ${_height.toInt()}px'),
                    Slider(
                      value: _height,
                      min: 100,
                      max: 800,
                      divisions: 7,
                      label: _height.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _height = value;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Digite alguma observação sobre seu pedido...',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Enviar
            ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'ENVIAR PEDIDO',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  final List<Color> availableColors = const [
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
