// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      text: json['text'] as String,
      status: $enumDecode(_$NoteStatusEnumMap, json['importance']),
      deadline: (json['deadline'] as num?)?.toInt(),
      isDone: json['done'] as bool,
      color: json['color'] as String?,
      createdAt: (json['created_at'] as num).toInt(),
      changedAt: (json['changed_at'] as num).toInt(),
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': _$NoteStatusEnumMap[instance.status]!,
      'deadline': instance.deadline,
      'done': instance.isDone,
      'color': instance.color,
      'created_at': instance.createdAt,
      'changed_at': instance.changedAt,
      'last_updated_by': instance.lastUpdatedBy,
    };

const _$NoteStatusEnumMap = {
  NoteStatus.high: 'important',
  NoteStatus.low: 'low',
  NoteStatus.basic: 'basic',
};

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      status: $enumDecode(_$NoteStatusEnumMap, json['importance']),
      deadline: (json['deadline'] as num?)?.toInt(),
      isDone: json['done'] as bool,
      color: json['color'] as String?,
      createdAt: (json['created_at'] as num).toInt(),
      changedAt: (json['changed_at'] as num).toInt(),
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': _$NoteStatusEnumMap[instance.status]!,
      'deadline': instance.deadline,
      'done': instance.isDone,
      'color': instance.color,
      'created_at': instance.createdAt,
      'changed_at': instance.changedAt,
      'last_updated_by': instance.lastUpdatedBy,
    };
