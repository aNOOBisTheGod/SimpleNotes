import 'dart:io';

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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  HttpOverrides.global = MyHttpOverrides();
  configureDependencies();
  Hive.init(dir.path);
  await Hive.openBox('notesList');
  await Hive.openBox('revision');
  runApp(const SimpleNotesApp());
}

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NoteListPageBloc>(
            create: (context) => GetIt.I<NoteListPageBloc>(),
          ),
          BlocProvider<EditNotePageBloc>(
            create: (context) => EditNotePageBloc(),
          ),
        ],
        child: MaterialApp.router(localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ], supportedLocales: const [
          Locale('en'),
          Locale('ru'),
        ], darkTheme: darkTheme, routerConfig: router, theme: lightTheme));
  }
}
