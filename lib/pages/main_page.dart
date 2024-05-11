import 'package:flutter/material.dart';
import 'package:parkware/pages/login_page.dart';
import '../controllers/user_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.blue, // Color de fondo para la parte superior
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
            child: ListView(
              children: [
                _buildNewsItem(
                  'https://c8.alamy.com/compes/e0j86b/coincidieron-en-zoo-de-guadalajara-jalisco-mexico-e0j86b.jpg',
                  'ZOOLOGICO GUADALAJARA',
                  '#EstasVacaciones Planifica tu visita al ZOOLOGICO GUADALAJARA! :::Abierto TODOS LOS DÍAS durante Semana Santa y Pascua::: 🗓️🕦🕥Te compartimos nuestros horarios 👇👇👇 ¡Pasa todo un día de diversión al aire libre con las aventuras que ya conoces y muchas novedades más! 🙊👀',
                ),
                _buildNewsItem(
                  'https://media-cdn.tripadvisor.com/media/photo-s/07/2c/f9/9b/zoologico-guadalajara.jpg',
                  'ZOOLOGICO GUADALAJARA',
                  '¡Elige tú diversión y acompáñanos a vivir la experiencia ZOOLOGICO GUADALAJARA! 👇🐾🐯🌿 Con Paquete Guadazoo 🎟🎫 podrás disfrutar de presentación de aves en el auditorio techado, 🐦Villa Australiana, 🦘🦘 Herpetario, 🐍🐢 Selva Tropical, 🐅 Rancho Veterinario, 👩‍⚕️Maravillas del Kalahari (suricatas), 🐒 Monkeyland, CIA museo interactivo, 🐻 Michilía ¡y mucho más! En Paquete Premier además de todo esto; 🐠🐡💦 sumérgete en el mundo marino del acuario, disfruta de un emocionante recorrido e… Ver más',
                ),
                _buildNewsItem(
                  'https://play-lh.googleusercontent.com/SKDBJvmf4Pu1YfPasBuVwu6vDkTrL-HoiVqLt8XRgvNotykzIYnlRiEKRXbUTI0NEks',
                  'ZOOLOGICO GUADALAJARA',
                  '¡Visítanos este lunes 18 de marzo! 📆👇⏰Abierto de 9:00am a 6:00pmDisfruta este puente en tu ZOOLOGICO GUADALAJARA 🙌🐘🍃observa a tus animales favoritos, disfruta de recorrido en tren, Safari Masai Mara, o SkyZoo (teleférico) ¡tú eliges la diversión!¡#EstePuente pasa todo un día de diversión al aire libre con tus familiares o amigos! 🐾🙋🏻‍♀️🙋🏼‍♂️➡️ Consulta más en: www.zooguadalajara.com.mx',
                ),
              ],
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
