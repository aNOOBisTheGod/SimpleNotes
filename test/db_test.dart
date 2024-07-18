import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:simplenotes/src/data/source/local/notes_local_storage.dart';
import 'package:simplenotes/src/domain/models/note.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init('./test/database/local');
  await Hive.openBox('notesList');
  await Hive.openBox('revision');

  test('Тест добавления заметки в локальное хранилище', () async {
    List<Note> data = NotesLocalStorage().loadNotes();
    int firstresult = data.length;
    Note note =
        Note.fromText(Random().nextInt(pow(2, 32).toInt()).toString(), '');
    NotesLocalStorage().addNote(note);
    data = NotesLocalStorage().loadNotes();
    int secondResult = data.length;
    expect(secondResult - firstresult, 1);
  });

  test('Тест удаления заметки из локального хранилища', () async {
    List<Note> data = NotesLocalStorage().loadNotes();
    late int firstresult;
    late Note note;
    if (data.isNotEmpty) {
      note = data.last;
      firstresult = data.length;
    } else {
      note = Note.fromText(Random().nextInt(pow(2, 32).toInt()).toString(), '');
      NotesLocalStorage().addNote(note);
      firstresult = 1;
    }
    NotesLocalStorage().deleteNote(note);
    data = NotesLocalStorage().loadNotes();
    int secondResult = data.length;
    expect(secondResult - firstresult, -1);
  });
}
