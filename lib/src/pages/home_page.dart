import 'package:flutter/material.dart';
import 'package:shorten_app/src/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController urlController = HomeController();

    return Scaffold(
      body:  Column(children: [
        TextField(
          controller: urlController.urlEC,
          decoration: const InputDecoration(
            hintText: 'Digite sua url'),),
        
        TextButton(onPressed: () {}, child: const Text('Encurtar'))
      ],),
    );
  }
}