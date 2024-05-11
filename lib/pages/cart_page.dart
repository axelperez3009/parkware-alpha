import 'package:flutter/material.dart';
import 'payment_page_cart.dart';
import '../domain/models/cart_item.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(List<CartItem>) onCartUpdated;

  const CartPage({Key? key, required this.cartItems, required this.onCartUpdated}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    updateQuantity(index, item.quantity - 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    updateQuantity(index, item.quantity + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Icono rojo
                  onPressed: () {
                    removeFromCart(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a la página de pago
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPageCart(
                cartItems: widget.cartItems,
                totalPrice: totalAmount.toInt() * 100, // Convertir el total a centavos
              ),
            ),
          );
        },
        label: Text('Pagar'),
        icon: Icon(Icons.payment),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Total: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(index);
    } else {
      setState(() {
        widget.cartItems[index].quantity = newQuantity;
        widget.onCartUpdated(widget.cartItems);
      });
    }
  }

  void removeFromCart(int index) {
    setState(() {
      // Eliminar el producto del carrito
      widget.cartItems.removeAt(index);
      // Actualizar el carrito en la página anterior
      widget.onCartUpdated(widget.cartItems);
    });
  }

  double get totalAmount {
    return widget.cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
  }
}
