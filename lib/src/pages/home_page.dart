import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shorten_app/src/controllers/home_controller.dart';
import 'package:shorten_app/src/services/create_url.dart';
import 'package:shorten_app/src/widgets/dropdown_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final HomeController urlController = HomeController();
    
    return Scaffold(
      body:  Column(children: [
        TextField(
          controller: urlController.urlEC,
          decoration: const InputDecoration(
            hintText: 'Digite sua url'),),

        Row(children: [
          ValueListenableBuilder(
            valueListenable: urlController.selectedUtmCampaign,
            builder: (context, campaign, child) {
              return dropdownWidget(
                campaign, 
                urlController.utmCampaignOptions, 
                (String? newValue) {
                    urlController.selectedUtmCampaign.value = newValue!;
                });
            }
          ),

          ValueListenableBuilder(
            valueListenable: urlController.selectedUtmSource, 
            builder: (context, source, child) {
              return dropdownWidget(
                source, 
                urlController.utmSourceOptions, 
                (String? newValue) {
                   urlController.selectedUtmSource.value = newValue!;
                });
          },),

          ValueListenableBuilder(
            valueListenable: urlController.selectedMedium, 
            builder: (context, medium, child) {
              return dropdownWidget(
                medium, 
                urlController.utmMediumOptions, 
                (String? newValue) {
                   urlController.selectedMedium.value = newValue!;
                });
          },),

        ],),

        TextButton(
          style: const ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 15, 105, 179))
          ),
          onPressed: () async { 
            urlController.urlMaked.value = CreateUrl(
              url: urlController.urlEC.text, 
              campaign: urlController.selectedUtmCampaign.value, 
              medium: urlController.selectedMedium.value, 
              source: urlController.selectedUtmSource.value).modifyUrl();

            await urlController.copyUrlToClipboard();
            
        }, child: const Text('Encurtar', style: TextStyle(color: Colors.white),)),

        const Text('Sua URL abaixo', style: TextStyle(color: Colors.black),),
        Row(children: [
          ValueListenableBuilder(
          valueListenable: urlController.urlMaked, 
          builder: (context, value, child) {
            return Text(value);
          },),

          
          IconButton(onPressed: () async {
            await urlController.copyUrlToClipboard();
          } , icon: const Icon(Icons.copy))
        ],),


        SizedBox(
          child: TextField(
              controller: urlController.notes,
              keyboardType: TextInputType.multiline,
              maxLines: null, // Permite múltiplas linhas
              expands: false,  // Expande para preencher o espaço disponível
              decoration: const InputDecoration(
                hintText: 'Digite seu texto aqui...',
                border: OutlineInputBorder(),
              ),
            ),
        ),

      ],),
    );
  }
}