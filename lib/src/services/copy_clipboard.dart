import 'package:flutter/services.dart';

class CopyClipboard {
  Future<void> copy(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
  }
}
