part of 'note.dart';

enum NoteStatus {
  @JsonValue('important')
  high,
  @JsonValue('low')
  low,
  @JsonValue('basic')
  basic;
}
