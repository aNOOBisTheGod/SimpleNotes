import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyA63fi3nvEJGR1v9G7x_quVL6avsK0pZFQ',
    appId: '1:542744020459:android:6a4058226d991e0931c5ae',
    messagingSenderId: 'sendid',
    projectId: 'linus-torvalds',
  ));
  Directory dir = await getApplicationDocumentsDirectory();
  HttpOverrides.global = MyHttpOverrides();
  configureDependencies();
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 10),
  ));
  remoteConfig.fetchAndActivate();
  Hive.init(dir.path);
  await Hive.openBox('notesList');
  await Hive.openBox('revision');
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.log(details.toString());
  };
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
