import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(
        title: 'WebSocket Demo Basic',
        socket: WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.socket})
      : super(key: key);
  final String title;
  final WebSocketChannel socket;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    widget.socket.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: 'Enter String to be sent to server here....'),
              controller: _controller,
            ),
            StreamBuilder(
              stream: widget.socket.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData
                      ? snapshot.data.toString()
                      : "Snapshot does not have nay data yet",
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  print("pressed");
                  if (_controller.text.isNotEmpty) {
                    widget.socket.sink.add(_controller.text);
                  }
                },
                child: Text("Send message to the server"))
          ],
        ),
      ),
    );
  }
}
