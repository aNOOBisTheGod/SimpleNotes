// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../src/data/note_repository_impl.dart' as _i8;
import '../../src/domain/repository/note_repository.dart' as _i7;
import '../../src/domain/usecase/notes/add_note_data.dart' as _i6;
import '../../src/domain/usecase/notes/delete_note_data.dart' as _i4;
import '../../src/domain/usecase/notes/edit_note_data.dart' as _i3;
import '../../src/domain/usecase/notes/get_notes_list.dart' as _i5;
import '../../src/presentation/screens/notes_list_page/notes_list_page_bloc/notes_list_page_bloc.dart'
    as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.EditNoteData>(() => _i3.EditNoteData());
    gh.factory<_i4.DeleteNoteData>(() => _i4.DeleteNoteData());
    gh.factory<_i5.GetNotesList>(() => _i5.GetNotesList());
    gh.factory<_i6.AddNoteData>(() => _i6.AddNoteData());
    gh.factory<_i7.NoteRepository>(() => _i8.NoteRepositoryImpl());
    gh.factory<_i9.NoteListPageBloc>(() => _i9.NoteListPageBloc(
          getNotesList: gh<_i5.GetNotesList>(),
          deleteNoteData: gh<_i4.DeleteNoteData>(),
          editNoteData: gh<_i3.EditNoteData>(),
          addNoteData: gh<_i6.AddNoteData>(),
        ));
    return this;
  }
}
