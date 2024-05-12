import 'package:flutter/material.dart';
import 'package:parkware/pages/login_page.dart';
import '../controllers/user_controller.dart';
import 'package:parkware/data/api_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      Map<String, dynamic> fetchedNews = await ApiService.getAllNews();
      setState(() {
        newsList = List<Map<String, dynamic>>.from(fetchedNews['result']);
      });
    } catch (e) {
      print('Error en el fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.green, // Color de fondo para la parte superior
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenido",
                      style: TextStyle(
                        fontSize: 20, // Tamaño de la fuente deseado
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      UserController.user?.displayName ?? '',
                      style: TextStyle(
                        fontSize: 16, // Tamaño de la fuente deseado
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (BuildContext context, int index) {
                String imageRef = newsList[index]['image']['asset']['_ref'];
                String imageUrl = ApiService.getImageUrl(imageRef);
                return _buildNewsItem(
                  imageUrl,
                  newsList[index]['title'],
                  newsList[index]['description'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String imageUrl, String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('Leer más'),
          ),
        ],
      ),
    );
  }
}

