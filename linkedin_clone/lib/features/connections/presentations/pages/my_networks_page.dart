import 'package:flutter/material.dart';

class MyNetworksPage extends StatefulWidget {
  const MyNetworksPage({Key? key}) : super(key: key);

  @override
  _MyNetworksPageState createState() => _MyNetworksPageState();
}

class _MyNetworksPageState extends State<MyNetworksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Networks')),
      body: const Center(child: Text('My Networks Page Content')),
    );
  }
}
