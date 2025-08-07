import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorten_app/src/bloc/darkmode_bloc.dart';
import 'package:shorten_app/src/controllers/home_controller.dart';
import 'package:shorten_app/src/core/network_manager/network_manager_http.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager_short_io.dart';
import 'package:shorten_app/src/design_system/snackbarhelper/snackbar_helper.dart';
import 'package:shorten_app/src/services/create_url.dart';
import 'package:shorten_app/src/services/utm_file/service/utm_file_service.dart';
import 'package:shorten_app/src/widgets/dropdown_widget.dart';
import 'package:shorten_app/src/widgets/selectable_text_field.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController urlController;

  @override
  void initState() {
    super.initState();
    urlController = HomeController(UTMFileService(), ShortenManagerShortIo(NetworkManagerHttp()));
    loadUTMs();
  }

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    Color swithColor = Colors.black;
    bool isSwitched = false;

    return BlocConsumer<DarkModeBloc, DarkModeState>(
      listener: (context, state) {
        if (state is IsDarkModeState) {
          isSwitched = true;
          swithColor = Colors.white;
        }

        if (state is IsLightModeState) {
          isSwitched = false;
          swithColor = Colors.black;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isSwitched ? Colors.grey[900] : Colors.white,
          floatingActionButton: Switch(
            value: isSwitched,
            activeThumbImage: const AssetImage("assets/moon.png"),
            inactiveThumbImage: const AssetImage("assets/sun.png"),
            onChanged: (value) => context.read<DarkModeBloc>().add(ChangeDarkMode(value)),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: display.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: urlController.urlEC,
                        style: TextStyle(color: swithColor), // Adjust text color
                        decoration: InputDecoration(
                          hintText: 'Digite a url aqui...',
                          hintStyle: TextStyle(color: swithColor),
                          labelStyle: TextStyle(color: swithColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: swithColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: swithColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: swithColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: urlController.selectedUtmCampaign,
                              builder: (context, campaign, child) {
                                return dropdownWidget(
                                  campaign,
                                  urlController.utmCampaignOptions,
                                  (String? newValue) {
                                    urlController.selectedUtmCampaign.value = newValue!;
                                  },
                                  isSwitched,
                                );
                              },
                            ),
                            const Gap(12),
                            ValueListenableBuilder(
                              valueListenable: urlController.selectedUtmSource,
                              builder: (context, source, child) {
                                return dropdownWidget(
                                  source,
                                  urlController.utmSourceOptions,
                                  (String? newValue) {
                                    urlController.selectedUtmSource.value = newValue!;
                                  },
                                  isSwitched,
                                );
                              },
                            ),
                            const Gap(12),
                            ValueListenableBuilder(
                              valueListenable: urlController.selectedMedium,
                              builder: (context, medium, child) {
                                return dropdownWidget(
                                  medium,
                                  urlController.utmMediumOptions,
                                  (String? newValue) {
                                    urlController.selectedMedium.value = newValue!;
                                  },
                                  isSwitched,
                                );
                              },
                            ),
                            const Gap(12),
                            ValueListenableBuilder(
                              valueListenable: urlController.selectedUtmDomain,
                              builder: (context, domain, child) {
                                return dropdownWidget(
                                  domain,
                                  urlController.utmDomains,
                                  (String? newValue) {
                                    urlController.selectedUtmDomain.value = newValue!;
                                  },
                                  isSwitched,
                                );
                              },
                            ),
                            const Gap(12),
                            Row(
                              children: [
                                Text(
                                  "Usar sugestão de IA ?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: swithColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: urlController.useAI,
                                  builder: (context, value, child) => Checkbox.adaptive(
                                    value: value,
                                    onChanged: (bool? value) {
                                      urlController.useAI.value = value ?? false;
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: display.height * 0.05),
                  width: display.width * 0.25,
                  height: display.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSwitched ? Colors.grey[700] : Colors.grey[200],
                    ),
                    onPressed: () async {
                      urlController.urlMaked.value = CreateUrl(
                        url: urlController.urlEC.text,
                        campaign: urlController.selectedUtmCampaign.value,
                        medium: urlController.selectedMedium.value,
                        source: urlController.selectedUtmSource.value,
                      ).modifyUrl();

                      await Future.delayed(const Duration(milliseconds: 200));

                      final result = await urlController.shortenUrl();

                      if (mounted) {
                        if (result) {
                          SnackbarHelper.showSuccess('URL encurtada com sucesso!', context);
                          return;
                        }
                        SnackbarHelper.showError('Erro ao encurtar URL', context);
                      }
                    },
                    child: Text(
                      'Encurtar',
                      style: TextStyle(color: swithColor, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.topLeft,
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
                            urlController.copyUrlToClipboard();
                          },
                          icon: Icon(
                            Icons.copy,
                            color: swithColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: urlController.shortenedUrl,
                        builder: (context, value, child) {
                          return Text(
                            value,
                            style: TextStyle(color: swithColor),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () async {
                          urlController.copyUrlToClipboard(isShortened: true);
                        },
                        icon: Icon(
                          Icons.copy,
                          color: swithColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: display.width * 0.85,
                  height: display.height * 0.5,
                  child: SelectableTextField(
                    isDarkMode: isSwitched,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void loadUTMs() async {
    await urlController.loadUTMs();
    setState(() {});
  }
}
