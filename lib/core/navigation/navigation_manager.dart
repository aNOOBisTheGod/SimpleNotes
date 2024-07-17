import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplenotes/src/domain/models/note.dart';

extension NavigaitonManager on BuildContext {
  void goAdd() {
    push('/add');
  }

  void goAddWithNote(Note note) {
    push('/add', extra: note);
  }
}
