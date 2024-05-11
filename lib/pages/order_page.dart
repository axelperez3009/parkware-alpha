import 'package:flutter/material.dart';
import 'store_page.dart';
import 'package:parkware/data/api_service.dart';
import 'package:parkware/domain/models/store.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<Store> stores; // Tipo específico Store en lugar de dynamic
  Store? selectedStore;

  @override
  void initState() {
    super.initState();
    stores = [];
    selectedStore = null;
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    try {
      Map<String, dynamic> fetchedStores = await ApiService.getAllStores();
      setState(() {
        stores = (fetchedStores['result'] as List<dynamic>)
            .map((storeData) => Store.fromJson(storeData))
            .toList();
      });
    } catch (e) {
      print('Error en el fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordena'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tiendas Cercanas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildStoresList(),
          ],
        ),
      ),
      floatingActionButton: selectedStore != null && selectedStore!.available
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorePage(storeName: selectedStore!.name, id: 'js')),
                );
              },
              child: Icon(Icons.shopping_cart),
            )
          : null,
    );
  }

Widget _buildStoresList() {
  return Container(
    height: 120, // Altura máxima de la lista de tiendas
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 150, // Ancho máximo de cada elemento de la tienda
          child: _buildStoreItem(stores[index]),
        );
      },
    ),
  );
}


Widget _buildStoreItem(Store store) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedStore = selectedStore == store ? null : store;
      });
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Espaciado interno
      child: Container(
        width: 120, // Ancho deseado del elemento de la tienda
        height: 80, // Altura deseada del elemento de la tienda
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
          color: selectedStore == store ? Colors.blue[100] : Colors.white, // Color de fondo
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              store.available ? Icons.store : Icons.store_outlined,
              size: 36,
              color: store.available ? Colors.green : Colors.red,
            ),
            SizedBox(height: 4),
            Text(
              store.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              store.available ? 'Abierta' : 'Cerrada',
              style: TextStyle(
                fontSize: 10,
                color: store.available ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}
