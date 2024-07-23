import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shorten_app/src/services/copy_clipboard.dart';

class HomeController extends ChangeNotifier {
  TextEditingController urlEC = TextEditingController();
  TextEditingController notes = TextEditingController();

  ValueNotifier<String> selectedMedium = ValueNotifier('fmkt');
  ValueNotifier<String> selectedUtmSource = ValueNotifier('default');
  ValueNotifier<String> selectedUtmCampaign = ValueNotifier('pr2');
  ValueNotifier<String> urlMaked = ValueNotifier("");

  final List<String> utmMediumOptions = [
    'fmkt',
    'fut1179',
    'fut1178',
    'fut1164',
    'fut1006',
    'fut1003',
    'wp01',
  ];

  final List<String> utmSourceOptions = [
    'default',
    'wp_channels',
  ];

  final List<String> utmCampaignOptions = [
    'pr1',
    'pr2',
    'pr3',
    'ch1',
    'ch2',
    'ch3',
    'ch4',
    'ch5',
  ];
  void copyUrlToClipboard() {
    var copyClipboard = CopyClipboard();
    copyClipboard.copy(urlMaked.value);
  }
}
