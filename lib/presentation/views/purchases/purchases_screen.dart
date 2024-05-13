import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkware/controllers/user_controller.dart';
import 'package:parkware/data/api_backend.dart';
import 'package:flutter/material.dart';
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
        final timestamp = order['date'];
        DateTime dateTime = DateTime.parse(timestamp);
        String formattedDateTime = '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
        return ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Order $orderId'),
          subtitle: Text('Fecha: ${formattedDateTime}'),
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

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  String _addMicroseconds(int value) {
    String micros = value.toString();
    if (micros.length < 6) {
      // Añadir ceros a la izquierda si es necesario
      micros = '0' * (6 - micros.length) + micros;
    }
    return micros;
  }
}

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timestamp = order['date'];
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDateTime = '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Fecha: ${formattedDateTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Total: \$${order['total']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Order Number: ${order['orderNumber']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${order['status']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'User ID: ${order['uid']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Products: ${order['products'].toString()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}.${_addMicroseconds(dateTime.microsecond)}';
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  String _addMicroseconds(int value) {
    String micros = value.toString();
    if (micros.length < 6) {
      micros = '0' * (6 - micros.length) + micros;
    }
    return micros;
  }
}

