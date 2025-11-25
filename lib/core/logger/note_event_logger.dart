import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:simplenotes/src/domain/models/note.dart';
import 'package:logger/web.dart';

class NoteEventLogger {
  final logger = Logger(printer: PrettyPrinter());

  void _logToFirebase(String eventName, Map<String, Object?>? parameters) {
    try {
      FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: parameters,
      );
    } catch (e) {
      // Firebase не доступен (например, в тестах или на Linux)
    }
  }

  void noteAdded(Note note) {
    logger.d('Добавлена заметка: ${note.toJson()}');
    _logToFirebase('note_added', {'item_id': note.id});
  }

  void noteEdited(Note noteBefore, Note noteAfter) {
    logger.d(
        'Заметка изменена: ${noteBefore.toJson()} =>  ${noteAfter.toJson()}');
    _logToFirebase('note_updated', {'item_id': noteBefore.id});
  }

  void noteDeleted(Note deletedNote) {
    logger.d('Заметка удалена: ${deletedNote.toJson()}');
    _logToFirebase('note_deleted', {'item_id': deletedNote.id});
  }

  void noteDoneStatusChange(bool showDone) {
    logger.d(
        "Режим просмотра заметок изменен на ${showDone ? '"Показывать сделанные"' : '"Не показывать сделанные"'}");
    _logToFirebase('note_status_edited', {'is_done': showDone});
  }

  void localRevisionUpdated(int currentRevision) {
    logger.d('Локальная ревизия списка обновлена: $currentRevision');
  }

  void remoteRevisionUpdated(int currentRevision) {
    logger.d('Облачная ревизия списка обновлена: $currentRevision');
  }

  void remoteNotesListLoaded() {
    logger.d('Загружен список заметок с сервера');
  }

  void localNotesListLoaded() {
    logger.d(
        'Произошла ошибка при загрузке данных с сервера. Загружен локальный список заметок');
  }

  void remoteNoteAdded(Note note) {
    logger.d('На сервер загружена заметка: ${note.toJson()}');
  }

  void remoteNoteEdited(Note note) {
    logger.d('Заметка изменена на сервере: ${note.toJson()}');
  }

  void remoteNoteDeleted(Note deletedNote) {
    logger.d('Заметка удалена с сервера: ${deletedNote.toJson()}');
  }

  void remoteNotesListPatched() {
    logger.d('Локальный и удаленный списки заметок синхронизированы');
    _logToFirebase('список заметок обновлен', null);
  }
}
