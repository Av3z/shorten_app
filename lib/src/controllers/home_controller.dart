import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

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
  ValueNotifier<String> selectedUtmDomain = ValueNotifier('brbolavip.link');
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
  List<String> utmDomains = [];
  List<String> suggestions = [];

  ValueNotifier<bool> useAI = ValueNotifier(false);

  Future<void> loadUTMs() async {
    try {
      utmMediumOptions = await _utmFileService.readUTMs('medium');
      utmSourceOptions = await _utmFileService.readUTMs('source');
      utmCampaignOptions = await _utmFileService.readUTMs('campaign');
      utmAccessToken = await _utmFileService.readUTMs('access_token');
      utmBaseUrl = await _utmFileService.readUTMs('base_url');
      utmDomains = await _utmFileService.readUTMs('domains');
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
    var body = <String, dynamic>{};

    log('utmDomain: ${selectedUtmDomain.value}');

    final uri = Uri.parse(urlMaked.value);
    final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    var title = slug.replaceAll('-', ' ').trim();
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    }

    if (selectedUtmDomain.value.isEmpty) {
      body = {
        'originalURL': urlMaked.value,
        'title': title,
      };
    } else {
      body = {
        'originalURL': urlMaked.value,
        'domain': selectedUtmDomain.value,
        'title': title,
      };
    }

    final data = await _shortenManager.shorten(
      utmBaseUrl.first,
      headers: {
        'Authorization': utmAccessToken.first,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final segments = uri.pathSegments;
    final team = segments.isNotEmpty ? segments.first.toLowerCase() : '';

    final slugLimited = segments.isNotEmpty ? segments.last.toLowerCase().split('-').take(4).join('-') : '';
    final suggestionPath = '$team-$slugLimited';

    if (useAI.value) {
      final idString = data['idString'];
      final base = utmBaseUrl.first.replaceAll(RegExp(r'/links$'), '');
      final updateUrl = '$base/links/$idString';

      Map<String, dynamic> updated = await _shortenManager.updateLink<Map<String, dynamic>>(
        updateUrl,
        headers: {
          'Authorization': utmAccessToken.first,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'path': suggestionPath}),
      );

      if (updated['field'] == 'path') {
        final suffix = Random().nextInt(49) + 2;
        final newPath = '$suggestionPath-$suffix';
        updated = await _shortenManager.updateLink<Map<String, dynamic>>(
          updateUrl,
          headers: {
            'Authorization': utmAccessToken.first,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'path': newPath}),
        );
      }

      shortenedUrl.value = updated['shortURL'];
      copyUrlToClipboard(isShortened: true);
      return true;
    }

    shortenedUrl.value = data['shortURL'];
    copyUrlToClipboard(isShortened: true);

    return true;
  }
}
