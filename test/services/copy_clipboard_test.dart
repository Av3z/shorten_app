import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_app/src/services/copy_clipboard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CopyClipboard.copy copies text to clipboard', (WidgetTester tester) async {
    final copier = CopyClipboard();
    const testText = 'https://example.com/test';

    String? mockedClipboard;

    const channel = SystemChannels.platform;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'Clipboard.setData') {
        final args = methodCall.arguments as Map;
        mockedClipboard = args['text'] as String?;
        return null;
      }
      if (methodCall.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': mockedClipboard};
      }
      return null;
    });

    try {
      await copier.copy(testText);

      final data = await Clipboard.getData('text/plain');
      expect(data?.text, testText);
    } finally {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    }
  });
}
