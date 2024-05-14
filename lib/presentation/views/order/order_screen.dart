import 'package:flutter/material.dart';
import 'package:parkware/presentation/views/store/store_screen.dart';
import 'package:parkware/data/api_service.dart';
import 'package:parkware/domain/models/store.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<Store> stores;
  Store? selectedStore;
  bool isLoading = false; // Variable para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    stores = [];
    selectedStore = null;
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    setState(() {
      isLoading = true; // Inicia la carga
    });
    try {
      Map<String, dynamic> fetchedStores = await ApiService.getAllStores();
      setState(() {
        stores = (fetchedStores['result'] as List<dynamic>)
            .map((storeData) => Store.fromJson(storeData))
            .toList();
        isLoading = false; // Finaliza la carga cuando se obtienen los datos
      });
    } catch (e) {
      print('Error en el fetch: $e');
      setState(() {
        isLoading = false; // Finaliza la carga en caso de error
      });
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
            Expanded( // Envuelve la lista en un Expanded para que pueda ocupar todo el espacio disponible
              child: RefreshIndicator( // Agrega el RefreshIndicator
                onRefresh: _fetchStores, // Define la función que se ejecutará al hacer pull to refresh
                child: isLoading ? _buildLoadingIndicator() : _buildStoresList(), // Muestra el indicador de carga o la lista de tiendas
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: selectedStore != null && selectedStore!.available
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorePage(storeName: selectedStore!.name,catalogsId: selectedStore!.catalogs, id: selectedStore!.id, )),
                );
              },
              child: Icon(Icons.shopping_cart),
            )
          : null,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(), // Muestra un indicador de carga centrado
    );
  }

  Widget _buildStoresList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 150,
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
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: selectedStore == store ? Colors.blue[100] : Colors.white,
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
