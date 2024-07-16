import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:simplenotes/src/domain/models/note.dart';
import 'package:logger/web.dart';

class NoteEventLogger {
  final logger = Logger(printer: PrettyPrinter());

  void noteAdded(Note note) {
    logger.d('Добавлена заметка: ${note.toJson()}');
    FirebaseAnalytics.instance.logEvent(
      name: 'note_added',
      parameters: {
        'item_id': note.id,
      },
    );
  }

  void noteEdited(Note noteBefore, Note noteAfter) {
    logger.d(
        'Заметка изменена: ${noteBefore.toJson()} =>  ${noteAfter.toJson()}');
    FirebaseAnalytics.instance.logEvent(
      name: 'note_updated',
      parameters: {
        'item_id': noteBefore.id,
      },
    );
  }

  void noteDeleted(Note deletedNote) {
    logger.d('Заметка удалена: ${deletedNote.toJson()}');
    FirebaseAnalytics.instance.logEvent(
      name: 'note_deleted',
      parameters: {
        'item_id': deletedNote.id,
      },
    );
  }

  void noteDoneStatusChange(bool showDone) {
    logger.d(
        "Режим просмотра заметок изменен на ${showDone ? '"Показывать сделанные"' : '"Не показывать сделанные"'}");
    FirebaseAnalytics.instance.logEvent(
      name: 'note_status_edited',
      parameters: {
        'is_done': showDone,
      },
    );
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
    FirebaseAnalytics.instance.logEvent(
      name: 'список заметок обновлен',
    );
  }
}
