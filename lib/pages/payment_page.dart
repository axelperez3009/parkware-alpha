import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkware/config/constants/environment.dart';
import '../domain/models/attraction.dart';

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  final int ticketCount;
  final Map<String, dynamic>  attraction;

  const PaymentPage({
    Key? key,
    required this.totalPrice,
    required this.ticketCount,
    required this.attraction,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late GlobalKey<FormState> paymentForm;
  Map<String, dynamic>? paymentIntentData;
  final secretKey = Environment.stripeSecretKey;

  @override
  void initState() {
    super.initState();
    paymentForm = GlobalKey<FormState>();
    makePayment(
      totalPrice: widget.totalPrice,
      ticketCount: widget.ticketCount,
      attraction: widget.attraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTicketHeader(),
              SizedBox(height: 20),
              _buildTicketDetails(),
              Expanded(child: SizedBox()),
              _buildCheckoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Ticket de Pago',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          _getCurrentDate(),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTicketDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atracción: ${widget.attraction['name']}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Descripción: ${widget.attraction['description']}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Precio por boleto: \$${widget.attraction['price'].toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Cantidad de boletos: ${widget.ticketCount}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Total a pagar: \$${(widget.totalPrice / 100).toStringAsFixed(2)} MXN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        displayPaymentSheet();
      },
      label: Text('Pagar'),
      icon: Icon(Icons.payment),
      backgroundColor: Colors.green,
    );
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  Future<void> makePayment({
    required int totalPrice,
    required int ticketCount,
    required Map<String, dynamic>  attraction,
  }) async {
    try {
      paymentIntentData = await createPaymentIntent(totalPrice);
      const gpay = PaymentSheetGooglePay(
        merchantCountryCode: "MX",
        testEnv: true,
      );
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            googlePay: gpay,
            merchantDisplayName: 'Adiwele',
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          ),
        );
      }
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(int amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': 'MXN',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      return jsonDecode(response.body.toString());
    } catch (e) {
      debugPrint(e.toString());
      throw e;
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
            (value) {},
          );
    } on StripeException catch (e) {
      debugPrint('Payment failed: ${e.error.localizedMessage}');
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
    }
  }
}
