import 'package:flutter/material.dart';
import 'package:shorten_app/src/controllers/home_controller.dart';
import 'package:shorten_app/src/services/create_url.dart';
import 'package:shorten_app/src/widgets/dropdown_widget.dart';
import 'package:shorten_app/src/widgets/selectable_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isSwitched = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final HomeController urlController = HomeController();
    final display = MediaQuery.of(context).size;
    final Color swithColor = isSwitched ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isSwitched ? Colors.grey[800] : Colors.white,
      floatingActionButton: Switch(
        value: isSwitched,
        activeThumbImage: const AssetImage("assets/moon.png"),
        inactiveThumbImage: const AssetImage("assets/sun.png"),
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: display.height * 0.1,
            ),
            Container(
              margin: EdgeInsets.only(bottom: display.height * 0.05),
              height: display.height * 0.12,
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(
              width: display.width * 0.45,
              child: Column(
                children: [
                  TextField(
                    controller: urlController.urlEC,
                    decoration: InputDecoration(
                        hintText: 'Digite sua url',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: swithColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: swithColor),
                        )),
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: urlController.selectedUtmCampaign,
                          builder: (context, campaign, child) {
                            return dropdownWidget(
                                campaign, urlController.utmCampaignOptions,
                                (String? newValue) {
                              urlController.selectedUtmCampaign.value =
                                  newValue!;
                            });
                          }),
                      ValueListenableBuilder(
                        valueListenable: urlController.selectedUtmSource,
                        builder: (context, source, child) {
                          return dropdownWidget(
                              source, urlController.utmSourceOptions,
                              (String? newValue) {
                            urlController.selectedUtmSource.value = newValue!;
                          });
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: urlController.selectedMedium,
                        builder: (context, medium, child) {
                          return dropdownWidget(
                              medium, urlController.utmMediumOptions,
                              (String? newValue) {
                            urlController.selectedMedium.value = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: display.height * 0.05),
              width: display.width * 0.25,
              height: display.height * 0.05,
              child: ElevatedButton(
                  onPressed: () async {
                    urlController.urlMaked.value = CreateUrl(
                            url: urlController.urlEC.text,
                            campaign: urlController.selectedUtmCampaign.value,
                            medium: urlController.selectedMedium.value,
                            source: urlController.selectedUtmSource.value)
                        .modifyUrl();

                    await urlController.copyUrlToClipboard();
                  },
                  child: const Text(
                    'Encurtar',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: urlController.urlMaked,
                    builder: (context, value, child) {
                      return Text(
                        value,
                        style: TextStyle(color: swithColor),
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () async {
                        await urlController.copyUrlToClipboard();
                      },
                      icon: Icon(
                        Icons.copy,
                        color: swithColor,
                      ))
                ],
              ),
            ),
            SizedBox(
                width: display.width * 0.65,
                child: const SelectableTextField()),
          ],
        ),
      ),
    );
  }
}
