import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> queue = [];
  late WebSocketChannel channel;

  // 1. Set the WebSocket URL
  final String wsURL = 'wss://ytfqydvxll.execute-api.us-east-2.amazonaws.com/dev/';

  @override
  void initState() {
    initWebsocket();
    super.initState();
  }

  void initWebsocket() {
    // 2. Connect to the WebSocket
    channel = IOWebSocketChannel.connect(
      Uri.parse(wsURL),
      pingInterval: const Duration(minutes: 1),
    );

    // 3. Set WebSocket listener
    channel.stream.listen((event) {
      Map response = jsonDecode(event);
      print(response);
      if (response['message'] != null) {
        setState(() {
          queue = List<String>.from(response['queue']);
        });
      }
    }, onDone: () {
      initWebsocket();
    });
  }

  void joinQueue() {
    // 4. Send a request to join the queue over the established WebSocket
    channel.sink.add(jsonEncode({'action': 'enqueue', 'body': {}}));
  }

  @override
  void dispose() {
    // 5. Clean up the existing WebSocket connection
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: joinQueue,
                child: Text('Unirse a la Fila'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: queue.map((e) => QueueItem(queuePosition: e)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QueueItem extends StatelessWidget {
  final String queuePosition;
  
  const QueueItem({Key? key, required this.queuePosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            queuePosition,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}

