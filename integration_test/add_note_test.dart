import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simplenotes/src/data/source/local/notes_local_storage.dart';
import 'package:simplenotes/src/domain/models/note.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:simplenotes/core/di/injection.dart';
import 'package:simplenotes/core/navigation/router.dart';
import 'package:simplenotes/core/themes/dark_theme.dart';
import 'package:simplenotes/core/themes/light_theme.dart';
import 'package:simplenotes/core/utils/http_overrides.dart';
import 'package:simplenotes/l10n/generated/app_localizations.dart';
import 'package:simplenotes/src/presentation/screens/edit_note_page/edit_note_page_bloc/edit_note_page_bloc.dart';
import 'package:simplenotes/src/presentation/screens/notes_list_page/notes_list_page_bloc/notes_list_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initTestApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  HttpOverrides.global = MyHttpOverrides();
  configureDependencies();
  Hive.init(dir.path);
  await Hive.openBox('notesList');
  await Hive.openBox('revision');
}

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<NoteListPageBloc>()),
        BlocProvider(create: (context) => EditNotePageBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ru'),
        ],
        theme: lightTheme,
        darkTheme: darkTheme,
      ),
    );
  }
}

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Тест добавления заметки', (WidgetTester tester) async {
    await initTestApp();
    await tester.pumpWidget(const SimpleNotesApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    List<Note> data = NotesLocalStorage().loadNotes();
    int firstresult = data.length;

    final addButton = find.byIcon(Icons.add);
    await tester.tap(addButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final textButton = find.byType(TextButton);
    await tester.tap(textButton);

    await tester.pumpAndSettle(const Duration(seconds: 2));
    data = NotesLocalStorage().loadNotes();
    int secondResult = data.length;
    expect(secondResult - firstresult, 1);
  });
}
