import 'package:flutter/material.dart';
import 'package:parkware/domain/models/attraction.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = false;
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Número de Personas: ${widget.personsCount}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Por favor, proporciona la siguiente información:',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _scanQR,
              icon: Icon(Icons.camera_alt),
              label: Text('Escanear Código QR'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrations.length < widget.personsCount
                  ? _register
                  : null,
              child: const Text('Registrar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading) Center(child: CircularProgressIndicator()),
            Text(
              'Registros:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: registrations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.verified, color: Colors.green),
                    title: Text('Verificado', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
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
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  void _scanQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#FFFFFF", "Cancelar", true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        _verifyQRCode(barcodeScanRes);
      }
    } on PlatformException {
      // Handle exception
    }
  }

  void _register() {
    String code = codeController.text;
    if (code.isNotEmpty && registrations.length < widget.personsCount) {
      _verifyQRCode(code);
    }
  }

  Future<void> _verifyQRCode(String qrCode) async {
    // Verificar si el código QR ya está registrado
    if (registrations.contains(qrCode)) {
      _showErrorDialog("Este código QR ya ha sido registrado");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://parkware-backend.vercel.app/api/qrcode/verify'); // Cambia esto a tu URL de API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': qrCode}),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true &&
          responseBody['message'] == "Este código QR está activo") {
        setState(() {
          registrations.add(qrCode);
        });
      } else {
        _showErrorDialog("Este código QR no está activo");
      }
    } else {
      _showErrorDialog("Error verificando el código QR");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
