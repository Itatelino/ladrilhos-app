import 'package:flutter/material.dart';
import 'package:ladrilho_app/controlles/sqlite_controller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initDb();
  runApp(const MyApp());
}

class TileProduct {
  final String name;
  final String image;
  TileProduct({required this.name, required this.image});
}

class CartItem {
  final TileProduct product;
  final double widthCm;
  final double heightCm;
  final String notes;
  CartItem({
    required this.product,
    required this.widthCm,
    required this.heightCm,
    required this.notes,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja de Ladrilhos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TileShopScreen(),
    );
  }
}

class TileShopScreen extends StatefulWidget {
  const TileShopScreen({super.key});
  @override
  State<TileShopScreen> createState() => _TileShopScreenState();
}

class _TileShopScreenState extends State<TileShopScreen> {
  final List<TileProduct> _tiles = [
    TileProduct(name: 'Ladrilho 1', image: 'assets/images/lad001.png'),
    TileProduct(name: 'Ladrilho 2', image: 'assets/images/lad002.png'),
    TileProduct(name: 'Ladrilho 3', image: 'assets/images/lad003.png'),
    TileProduct(name: 'Ladrilho 4', image: 'assets/images/lad004.png'),
    TileProduct(name: 'Ladrilho 5', image: 'assets/images/lad005.png'),
    TileProduct(name: 'Ladrilho 6', image: 'assets/images/lad006.png'),
    TileProduct(name: 'Ladrilho 7', image: 'assets/images/lad007.png'),
    TileProduct(name: 'Ladrilho 8', image: 'assets/images/lad008.png'),
    TileProduct(name: 'Ladrilho 9', image: 'assets/images/lad009.png'),
    TileProduct(name: 'Ladrilho 10', image: 'assets/images/lad010.png'),
  ];

  final List<CartItem> _cart = [];

  void _addToCart(
    TileProduct product,
    double width,
    double height,
    String notes,
  ) {
    setState(() {
      _cart.add(
        CartItem(
          product: product,
          widthCm: width,
          heightCm: height,
          notes: notes,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto adicionado ao carrinho!')),
    );
  }

  void _goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutScreen(cart: _cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Ladrilhos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _goToCheckout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tiles.length,
        itemBuilder: (context, index) {
          final tile = _tiles[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.asset(tile.image, width: 60, height: 60),
              title: Text(tile.name),
              trailing: ElevatedButton(
                child: const Text('Personalizar'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => TileCustomizationSheet(
                      product: tile,
                      onAdd: _addToCart,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class TileCustomizationSheet extends StatefulWidget {
  final TileProduct product;
  final Function(TileProduct, double, double, String) onAdd;
  const TileCustomizationSheet({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<TileCustomizationSheet> createState() => _TileCustomizationSheetState();
}

class _TileCustomizationSheetState extends State<TileCustomizationSheet> {
  double _widthCm = 10.0;
  double _heightCm = 10.0;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.asset(widget.product.image, height: 100),
          const SizedBox(height: 10),
          Text('Largura: ${_widthCm.toStringAsFixed(1)} cm'),
          Slider(
            value: _widthCm,
            min: 5,
            max: 80,
            divisions: 75,
            label: _widthCm.toStringAsFixed(1),
            onChanged: (v) => setState(() => _widthCm = v),
          ),
          Text('Altura: ${_heightCm.toStringAsFixed(1)} cm'),
          Slider(
            value: _heightCm,
            min: 5,
            max: 80,
            divisions: 75,
            label: _heightCm.toStringAsFixed(1),
            onChanged: (v) => setState(() => _heightCm = v),
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Observações (opcional)',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Adicionar ao Carrinho'),
            onPressed: () {
              widget.onAdd(
                widget.product,
                _widthCm,
                _heightCm,
                _notesController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cart;
  const CheckoutScreen({super.key, required this.cart});

  Future<void> _sendOrderViaWhatsApp(BuildContext context) async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Carrinho vazio!')));
      return;
    }
    String message = 'Pedido de Ladrilhos:\n';
    for (var item in cart) {
      message +=
          '''
Produto: ${item.product.name}
Imagem: ${item.product.image}
Largura: ${item.widthCm.toStringAsFixed(1)} cm
Altura: ${item.heightCm.toStringAsFixed(1)} cm
Observações: ${item.notes}
--------------------------
''';
    }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        item.product.image,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(item.product.name),
                      subtitle: Text(
                        'Largura: ${item.widthCm.toStringAsFixed(1)} cm\n'
                        'Altura: ${item.heightCm.toStringAsFixed(1)} cm\n'
                        'Obs: ${item.notes}',
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _sendOrderViaWhatsApp(context),
              /*icon: const Icon(Icons.whatsapp, color: Colors.white),*/
              label: const Text('Enviar Pedido via WhatsApp'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
