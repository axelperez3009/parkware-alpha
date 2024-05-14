import 'package:flutter/material.dart';
import 'package:parkware/domain/models/attraction.dart';
import 'dart:convert';
import 'dart:typed_data';


class VirtualQueueRegistrationPage extends StatefulWidget {
  final Attraction attraction;
  final int personsCount;

  const VirtualQueueRegistrationPage({
    Key? key,
    required this.attraction,
    required this.personsCount,
  }) : super(key: key);

  @override
  _VirtualQueueRegistrationPageState createState() =>
      _VirtualQueueRegistrationPageState();
}

class _VirtualQueueRegistrationPageState
    extends State<VirtualQueueRegistrationPage> {
  List<String> registrations = [];

  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro en la Fila Virtual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Atracción: ${widget.attraction.name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Número de Personas: ${widget.personsCount}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Por favor, proporciona la siguiente información:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Código',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Acción para abrir la cámara
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrations.length < widget.personsCount
                  ? _register
                  : null,
              child: const Text('Registrar'),
            ),
            SizedBox(height: 20),
            Text(
              'Registros:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: registrations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: registrations[index].startsWith('data:image') // Check if registration is QR code
                        ? _buildQRImage(registrations[index])
                        : Text(registrations[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          registrations.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: registrations.length == widget.personsCount
          ? FloatingActionButton(
              onPressed: () {
                // Acción para ingresar a la fila virtual
              },
              child: Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  Widget _buildQRImage(String base64String) {
    Uint8List bytes = base64Decode(base64String.split(',').last);
    return Image.memory(bytes, width: 50, height: 50); // Change width and height as needed
  }

  void _register() {
    String code = codeController.text;
    if (code.isNotEmpty && registrations.length < widget.personsCount) {
      setState(() {
        registrations.add(code.startsWith('data:image') ? code : 'data:image/png;base64,$code');
        codeController.clear();
      });
    }
  }
}
