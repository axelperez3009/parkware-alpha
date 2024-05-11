import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parkware/domain/models/cart_item.dart';
import 'package:parkware/pages/cart_page.dart';

void main() {
  testWidgets('Test de actualización de cantidad en el carrito', (WidgetTester tester) async {
    List<CartItem> cartItems = [
      CartItem(name: 'Producto 1', price: 10.0, quantity: 2),
      CartItem(name: 'Producto 2', price: 15.0, quantity: 1),
    ];

    bool updateSuccessful = false;

    await tester.pumpWidget(MaterialApp(
      home: CartPage(
        cartItems: cartItems,
        onCartUpdated: (updatedCartItems) {
          updateSuccessful = true;
        },
      ),
    ));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.remove).first);
    await tester.pump();
    expect(updateSuccessful, true);
  });

  testWidgets('Test de eliminación de producto del carrito', (WidgetTester tester) async {
    List<CartItem> cartItems = [
      CartItem(name: 'Producto 1', price: 10.0, quantity: 2),
      CartItem(name: 'Producto 2', price: 15.0, quantity: 1),
    ];

    bool removalSuccessful = false;

    await tester.pumpWidget(MaterialApp(
      home: CartPage(
        cartItems: cartItems,
        onCartUpdated: (updatedCartItems) {
          removalSuccessful = true;
        },
      ),
    ));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pump();

    expect(removalSuccessful, true);
  });
}