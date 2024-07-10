import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simplenotes/src/data/source/local/notes_local_storage.dart';
import 'package:simplenotes/src/domain/models/note.dart';

import 'package:simplenotes/main.dart' as app;

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets('Тест добавления заметки', (WidgetTester tester) async {
    app.main();
    await tester.pump(const Duration(seconds: 2));
    List<Note> data = NotesLocalStorage().loadNotes();
    await Future.delayed(const Duration(seconds: 2));
    int firstresult = data.length;

    final addButton = find.byIcon(Icons.add);
    await tester.tap(addButton);
    await Future.delayed(const Duration(seconds: 2));

    final textButton = find.byType(TextButton);
    await tester.tap(textButton);

    await Future.delayed(const Duration(seconds: 2));
    data = NotesLocalStorage().loadNotes();
    int secondResult = data.length;
    expect(secondResult - firstresult, 1);
  });
}
