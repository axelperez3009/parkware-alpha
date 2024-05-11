import 'package:flutter/material.dart';
import 'tickets_details_page.dart'; 
import '../domain/models/attraction.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  final List<Attraction> attractions = [
    Attraction(
      name: 'Safari',
      description: '¡Disfruta de un emocionante safari!',
      price: 30.0,
      imageUrls: [
        'https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/428639612_7350713348284236_8719751971340554894_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=lO2YQGWWff0AX-IUnP6&_nc_ht=scontent.fgdl9-1.fna&oh=00_AfBUEVS21GKACNlJHoH3Ecp2ntsCNyj6kALBPHYzhYndWg&oe=65FEDDBB',
        'https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/428639549_7350710164951221_2119606763503927121_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_ohc=_06RXMAY_0cAX93YaTi&_nc_ht=scontent.fgdl9-1.fna&oh=00_AfCmLcwj003BG6OOWMQz-zBVBsu1HL5MsWp_UnuCitxLgA&oe=65FFAA82',
        'https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/432507461_6846625282108821_5762710724586382067_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_ohc=-Sti8f8FXukAX_CpSK8&_nc_ht=scontent.fgdl9-1.fna&oh=00_AfAiyzr7bcE11ZyWkFuqzyPCO9q0jQK80zIPNHxG4wpTfA&oe=65FE9146'
      ],
    ),
    Attraction(
      name: 'Sky Zoo',
      description: '¡Explora el cielo en nuestro zoo aéreo!',
      price: 40.0,
      imageUrls: [
        'https://m.gdltours.com/wp-content/uploads/2017/11/Sky_Zoo_Zoologico_Guadalajara.jpg'
      ],
    ),
    Attraction(
      name: 'Tren',
      description: '¡Viaja por el parque en nuestro tren temático!',
      price: 20.0,
      imageUrls: [
        'https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/432016222_6846634265441256_5732826167494448576_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=HuxPOvh0xIUAX9tHkJn&_nc_ht=scontent.fgdl9-1.fna&oh=00_AfCl-AMLv9_zK2p18j_tKMggwfOmmWc59kprbmWVkZj3oA&oe=65FFA304',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: ListView.builder(
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicketsDetailsPage(attraction: attractions[index])),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(attractions[index].imageUrls.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketsDetailsPage(attraction: attractions[index])),
                      );
                    },
                    child: Text('Ver Detalles del: ${attractions[index].name}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
