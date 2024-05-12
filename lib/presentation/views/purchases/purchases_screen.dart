import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkware/controllers/user_controller.dart';
import 'package:parkware/data/api_backend.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late List<dynamic> myOrders;

  @override
  void initState() {
    super.initState();
    myOrders = [];
    _fetchMyOrders();
  }

  Future<void> _fetchMyOrders() async {
    try {
      final String uid = UserController.getCurrentUserUid();
      final response = await ApiBackend.getMyPurchases(uid);
      setState(() {
        myOrders = response;
      });
        DateTime now = DateTime.now();
        print(now);
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Compras'),
      ),
      body: _buildMyOrdersList(),
    );
  }

  Widget _buildMyOrdersList() {
    if (myOrders == null) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: myOrders.length,
      itemBuilder: (BuildContext context, int index) {
        final order = myOrders[index];
        final orderId = order['orderNumber'];
        final orderDate = order['date'];
        return ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Order $orderId'),
          subtitle: Text('Date: ${_formatDate(orderDate)}'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderDetailPage(order: order)),
            );
          },
        );
      },
    );
  }
  String _formatDate(DateTime date) {
  // Formatea la fecha en el formato deseado
  return '${date.day}/${date.month}/${date.year}';
}
}

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order ID: ${order['id']}'),
            Text('Total: \$${order['total']}'),
            // Agrega más detalles del pedido según sea necesario
          ],
        ),
      ),
    );
  }
}
