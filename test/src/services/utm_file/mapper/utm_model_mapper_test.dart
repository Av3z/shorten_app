import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_app/src/services/utm_file/mapper/utm_model_mapper.dart';

void main() {
  String json = '''
  {
    "medium": [
        "fmkt",
        "fut1179",
        "fut1178",
        "fut1164",
        "fut1003",
        "fut1006"
    ],
    "source": [
        "default",
        "wp_channels"
    ],
    "campaign": [
        "ra",
        "pr2",
        "pr3",
        "ch3",
        "ch5"
    ],
    "access_token": "",
    "base_url": "https://api.short.io/links",
    "domains": [
        "antenadosnofutebol.link",
        "brbolavip.link",
        "somosfanaticos.link",
        "torcedores.link",
        "futebolmania.link"
    ]
}
  ''';

  test('should convert json to a model', () {
    final utmModel = UtmModelMapper.fromJson(jsonDecode(json));

    expect(utmModel.medium[0], 'fmkt');
  });
}
