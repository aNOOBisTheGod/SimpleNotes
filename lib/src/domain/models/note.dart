import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_status.dart';
part 'note.freezed.dart';
part 'note.g.dart';

@unfreezed
@JsonSerializable()
class Note with _$Note {
  factory Note({
    required String id,
    required String text,
    @JsonKey(name: 'importance') required NoteStatus status,
    int? deadline,
    @JsonKey(name: 'done') required bool isDone,
    String? color,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'changed_at') required int changedAt,
    @JsonKey(name: 'last_updated_by') required String lastUpdatedBy,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  factory Note.fromText(String text, String deviceId) => Note(
      id: Random().nextInt(pow(2, 32).toInt()).toString(),
      text: text,
      status: NoteStatus.basic,
      isDone: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      changedAt: DateTime.now().millisecondsSinceEpoch,
      lastUpdatedBy: deviceId);
}
