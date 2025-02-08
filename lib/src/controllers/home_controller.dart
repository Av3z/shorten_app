import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';
import 'package:shorten_app/src/services/copy_clipboard.dart';
import 'package:shorten_app/src/services/utm_file/service/utm_file_service.dart';

class HomeController extends ChangeNotifier {
  TextEditingController urlEC = TextEditingController();
  TextEditingController notes = TextEditingController();

  ValueNotifier<String> selectedMedium = ValueNotifier('fmkt');
  ValueNotifier<String> selectedUtmSource = ValueNotifier('default');
  ValueNotifier<String> selectedUtmCampaign = ValueNotifier('pr2');
  ValueNotifier<String> urlMaked = ValueNotifier("");
  ValueNotifier<String> shortenedUrl = ValueNotifier("");

  final UTMFileService _utmFileService;
  final ShortenManager _shortenManager;

  HomeController(this._utmFileService, this._shortenManager);

  List<String> utmMediumOptions = [];
  List<String> utmSourceOptions = [];
  List<String> utmCampaignOptions = [];
  List<String> utmAccessToken = [];
  List<String> utmBaseUrl = [];

  Future<void> loadUTMs() async {
    try {
      utmMediumOptions = await _utmFileService.readUTMs('medium');
      utmSourceOptions = await _utmFileService.readUTMs('source');
      utmCampaignOptions = await _utmFileService.readUTMs('campaign');
      utmAccessToken = await _utmFileService.readUTMs('access_token');
      utmBaseUrl = await _utmFileService.readUTMs('base_url');
      notifyListeners();
    } catch (e) {
      log('Erro ao carregar UTMs: $e');
    }
  }

  void copyUrlToClipboard({bool isShortened = false}) {
    var copyClipboard = CopyClipboard();

    if (isShortened) {
      copyClipboard.copy(shortenedUrl.value);
      return;
    }

    copyClipboard.copy(urlMaked.value);
  }

  FutureOr<bool> shortenUrl() async {
    return _shortenManager
        .shorten(
      utmBaseUrl.first,
      headers: {
        'Authorization': 'Bearer ${utmAccessToken.first}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'long_url': urlMaked.value.toString(),
      }),
    )
        .then((url) {
      shortenedUrl.value = url;
      copyUrlToClipboard(isShortened: true);
      return true;
    }).catchError((error) {
      log("Erro ao encurtar URL: $error");
      return false;
    });
  }
}
