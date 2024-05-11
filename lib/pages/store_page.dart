import 'package:flutter/material.dart';
import 'package:parkware/presentation/views/cart/cart_screen.dart';
import 'package:parkware/domain/models/cart_item.dart';
import 'package:parkware/data/api_service.dart';

class LimitedText extends StatelessWidget {
  final String description;
  final int wordLimit;

  LimitedText(this.description, {required this.wordLimit});

  @override
  Widget build(BuildContext context) {
    List<String> words = description.split(' ');
    String truncatedText = words.take(wordLimit).join(' ');

    return Text(truncatedText);
  }
}

class StorePage extends StatefulWidget {
  final String storeName;
  final String id;

  const StorePage({Key? key, required this.storeName, required this.id}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<CartItem> cartItems = [];
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final Map<String, dynamic> productos = await ApiService.getAllProducts();
      setState(() {
        products = productos['result'];
      });
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems, onCartUpdated: _updateCart)),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bebidas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildProductsList(), // Utiliza la función para construir la lista de productos
            ],
          ),
        ),
      ),
    );
  }

  // Función para construir la lista de productos
  Widget _buildProductsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: products.map<Widget>((product) {
          double price = double.parse(product['price']);
          String imageRef = product['images'][0]['asset']['_ref'];
          String imageUrl = ApiService.getImageUrl(imageRef);
          return _buildProductItem(
            product['name']['es_es'],
            price,
            imageUrl,
            product['description']['es_es'],
          );
        }).toList(),
      ),
    );
  }

  // Función para construir cada elemento de producto
  Widget _buildProductItem(String name, double price, String imageUrl, String description) {
    return GestureDetector(
      onTap: () {
        _showProductDetails(name, price, imageUrl, description);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${price.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(String name, double price, String imageUrl, String description) {
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  LimitedText(
                    description,
                    wordLimit: 20,),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(name, price, quantity);
                      Navigator.pop(context);
                    },
                    child: Text('Agregar al carrito'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void addToCart(String itemName, double itemPrice, int quantity) {
    setState(() {
      cartItems.add(CartItem(name: itemName, price: itemPrice, quantity: quantity));
    });
  }

  void _updateCart(List<CartItem> updatedCart) {
    setState(() {
      cartItems = updatedCart;
    });
  }
}
