import 'package:flutter/material.dart';
import 'package:parkware/domain/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityUpdated;
  final Function() onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityUpdated,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              onQuantityUpdated(item.quantity - 1);
            },
          ),
          Padding(
            padding: EdgeInsets.all(10.0), // Agrega un relleno de 15px en todos los lados
            child: Text(
              '${item.quantity}',
              style: TextStyle(fontSize: 15.0), // Tamaño de texto más grande, por ejemplo, 20px
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              onQuantityUpdated(item.quantity + 1);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
