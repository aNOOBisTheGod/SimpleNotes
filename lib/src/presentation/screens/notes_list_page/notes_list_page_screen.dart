import 'package:simplenotes/core/flavors/flavors_manager.dart';
import 'package:simplenotes/core/navigation/navigation_manager.dart';
import 'package:simplenotes/core/utils/get_device_id.dart';
import 'package:simplenotes/l10n/generated/app_localizations.dart';
import 'package:simplenotes/src/domain/models/note.dart';
import 'package:simplenotes/src/presentation/screens/notes_list_page/notes_list_page_bloc/notes_list_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simplenotes/src/presentation/screens/notes_list_page/widgets/notes_list.dart';

import 'widgets/appbar_delegate.dart';

class NotesListPageScreen extends StatelessWidget {
  const NotesListPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Content();
  }
}

class _Content extends StatelessWidget {
  _Content();

  final TextEditingController addNoteTitleController = TextEditingController();

  SliverPersistentHeader makeHeader() {
    return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 100.0,
        maxHeight: 200.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteListPageBloc = context.read<NoteListPageBloc>();

    noteListPageBloc.add(LoadNotes());
    return BlocBuilder<NoteListPageBloc, NoteListPageState>(
        builder: (context, state) {
      List<Note> notesList = List.from(noteListPageBloc.state.notesList);
      if (!noteListPageBloc.state.showDone) {
        notesList.removeWhere((element) => element.isDone);
      }

      return Scaffold(
        body: Stack(
          children: [
            state.status == NoteListPageStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.status == NoteListPageStatus.error
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.simpleError),
                      )
                    : CustomScrollView(
                        slivers: [
                          makeHeader(),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0, bottom: 150),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).cardColor,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 3)
                                        ]),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        NotesListWidget(notesList: notesList),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: addNoteTitleController,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .createNew,
                                                enabledBorder: InputBorder.none,
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      String id =
                                                          await GetDeviceId()
                                                              .getId();
                                                      noteListPageBloc.add(
                                                          AddNote(Note.fromText(
                                                              addNoteTitleController
                                                                  .text,
                                                              id)));
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      addNoteTitleController
                                                          .text = '';
                                                    },
                                                    icon: const Icon(
                                                        Icons.send))),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            FlavorsManager().getAppMode() == AppFlavors.dev
                ? const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('dev'),
                    ),
                  )
                : Container()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () {
            context.goAdd();
          },
          tooltip: AppLocalizations.of(context)!.createNew,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
