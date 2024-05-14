import 'package:flutter/material.dart';
import 'package:parkware/presentation/views/virtual/virtual_queue_registration_screen.dart';
import 'package:parkware/domain/models/attraction.dart';

class VirtualQueuePage extends StatefulWidget {
  final List<Attraction> attractions; // Lista de atracciones disponibles

  const VirtualQueuePage({Key? key, required this.attractions}) : super(key: key);

  @override
  _VirtualQueuePageState createState() => _VirtualQueuePageState();
}

class _VirtualQueuePageState extends State<VirtualQueuePage> {
  Attraction? selectedAttraction; // Atracción seleccionada
  int selectedPersonsCount = 1; // Número de personas seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filas Virtuales'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona una atracción:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.attractions.length,
              itemBuilder: (context, index) {
                final attraction = widget.attractions[index];
                return ListTile(
                  title: Text(attraction.name),
                  subtitle: Text('Precio: \$${attraction.price.toStringAsFixed(2)}'),
                  onTap: () {
                    setState(() {
                      selectedAttraction = attraction;
                    });
                  },
                );
              },
            ),
            if (selectedAttraction != null) ...[
              SizedBox(height: 20),
              Text(
                'Selecciona la cantidad de personas:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (selectedPersonsCount > 1) {
                          selectedPersonsCount--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    '$selectedPersonsCount',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (selectedPersonsCount < 5) {
                          selectedPersonsCount++;
                        }
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la página de registro de fila virtual
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VirtualQueueRegistrationPage(
                      attraction: selectedAttraction!,
                      personsCount: selectedPersonsCount,
                    )),
                  );
                },
                child: const Text('Registrarse en la Fila Virtual'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
