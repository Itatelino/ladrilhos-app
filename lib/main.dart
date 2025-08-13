import 'package:flutter/material.dart';
import 'package:ladrilho_app/controlles/sqlite_controller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initDb();
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

class _ImageCustomizerScreenState extends State<ImageCustomizerScreen> {
  String? _selectedAssetImage;
  double _widthCm = 10.0;
  double _heightCm = 10.0;
  final TextEditingController _notesController = TextEditingController();

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
  ];

  Future<void> _submitOrder() async {
    if (_selectedAssetImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma imagem')),
      );
      return;
    }

    final orderData = {
      'image': _selectedAssetImage,
      'width_cm': _widthCm,
      'height_cm': _heightCm,
      'notes': _notesController.text,
      'created_at': DateTime.now().toIso8601String(),
    };

    await SqliteController().insertOrder(orderData);

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido Salvo'),
        content: const Text('Seu pedido foi salvo localmente!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendOrderViaWhatsApp() async {
    final message =
        '''
Pedido de Ladrilho:
Imagem: $_selectedAssetImage
Largura: ${_widthCm.toStringAsFixed(1)} cm
Altura: ${_heightCm.toStringAsFixed(1)} cm
Observações: ${_notesController.text}
''';

    final url = Uri.parse(
      'https://wa.me/message/TH6UCYQCCKX7D1${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
                      max: 40,
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
                      max: 40,
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
              child: const Text('Salvar Pedido'),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _sendOrderViaWhatsApp,
              /* icon: const Icon(Icons.whatsapp, color: Colors.white),*/
              label: const Text('Enviar via WhatsApp'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
