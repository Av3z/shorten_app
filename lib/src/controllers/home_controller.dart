import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shorten_app/src/services/copy_clipboard.dart';
import 'package:shorten_app/src/services/utm_file/service/utm_file_service.dart';

class HomeController extends ChangeNotifier {
  TextEditingController urlEC = TextEditingController();
  TextEditingController notes = TextEditingController();

  ValueNotifier<String> selectedMedium = ValueNotifier('fmkt');
  ValueNotifier<String> selectedUtmSource = ValueNotifier('default');
  ValueNotifier<String> selectedUtmCampaign = ValueNotifier('pr2');
  ValueNotifier<String> urlMaked = ValueNotifier("");

  final UTMFileService _utmFileService;

  HomeController(this._utmFileService);

  List<String> utmMediumOptions = [];
  List<String> utmSourceOptions = [];
  List<String> utmCampaignOptions = [];

  Future<void> loadUTMs() async {
    try {
      utmMediumOptions = await _utmFileService.readUTMs('medium');
      utmSourceOptions = await _utmFileService.readUTMs('source');
      utmCampaignOptions = await _utmFileService.readUTMs('campaign');
      notifyListeners();
    } catch (e) {
      log('Erro ao carregar UTMs: $e');
    }
  }

  void copyUrlToClipboard() {
    var copyClipboard = CopyClipboard();
    copyClipboard.copy(urlMaked.value);
  }
}
