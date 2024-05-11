import 'package:flutter/material.dart';
import '../domain/models/attraction.dart';
import 'payment_page.dart';

class TicketsDetailsPage extends StatefulWidget {
  final Attraction attraction;

  const TicketsDetailsPage({Key? key, required this.attraction}) : super(key: key);

  @override
  _TicketsDetailsPageState createState() => _TicketsDetailsPageState();
}

class _TicketsDetailsPageState extends State<TicketsDetailsPage> {
  int ticketsCount = 1;
  int totalPrice = 00;

  @override
  Widget build(BuildContext context) {
    totalPrice = ticketsCount * (widget.attraction.price * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.attraction.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner con la primera imagen de la atracción
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(widget.attraction.imageUrls.first, fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          // Pasarela de imágenes de la atracción
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.attraction.imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.network(widget.attraction.imageUrls[index]),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          // Descripción y precio de la atracción
          ListTile(
            title: Text(widget.attraction.description),
            subtitle: Text('\$${widget.attraction.price.toStringAsFixed(2)}'),
          ),
          // Campo para ingresar la cantidad de boletos
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cantidad:'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (ticketsCount > 1) {
                          setState(() {
                            ticketsCount--;
                            totalPrice = ticketsCount * (widget.attraction.price * 100).toInt();
                          });
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(ticketsCount.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ticketsCount++;
                          totalPrice = ticketsCount * (widget.attraction.price * 100).toInt();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Mostrar el total y el botón de pagar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total a pagar: \$${(totalPrice / 100).toStringAsFixed(2)} MXN',),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes implementar la lógica para pagar
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage(totalPrice: totalPrice, ticketCount: ticketsCount, attraction: widget.attraction,),),
                    );
                  },
                  child: Text('Pagar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

