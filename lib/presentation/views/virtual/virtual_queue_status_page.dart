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
  List<Message> messages = [];
  late WebSocketChannel channel;

  // 1. Set the WebSocket URL
  final String wsURL = 'wss://9yrw17niu2.execute-api.us-east-2.amazonaws.com/development/';

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

      if (response['message'] != null) {
        setState(() {
          messages.add(
            Message(
              isCurrentUser: false,
              message: response['message'],
            ),
          );
        });
      }
    }, onDone: () {
      initWebsocket();
    });
  }

  void onSubmitMessage(String message) {
    if (message.isEmpty) {
      return;
    }

    setState(() {
      messages.add(Message(isCurrentUser: true, message: message));
    });

    // 4. Send messages over the established WebSocket
    channel.sink
        .add('{"action": "sendMessage", "body": {"message": "$message"}}');
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
              Expanded(
                child: ListView(
                  children: [
                    ...messages.map(
                      (e) => MessageContainer(
                        message: e.message,
                        isCurrentUser: e.isCurrentUser,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: MessageField(
                  onFieldSubmitted: onSubmitMessage,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageField extends StatefulWidget {
  final Function(String) onFieldSubmitted;
  const MessageField({
    Key? key,
    required this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController msgController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: myFocusNode,
      onFieldSubmitted: (value) {
        msgController.text = '';
        widget.onFieldSubmitted(value);
        myFocusNode.requestFocus();
      },
      controller: msgController,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.message, color: Colors.black45, size: 20),
        ),
        prefixIconColor: Colors.grey,
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 30, maxWidth: 30),
        hintText: 'Message',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        fillColor: const Color.fromARGB(255, 228, 228, 228),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      ),
      onChanged: (val) {},
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);
  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // add some padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

class Message {
  bool isCurrentUser;
  String message;
  Message({required this.isCurrentUser, required this.message});
}