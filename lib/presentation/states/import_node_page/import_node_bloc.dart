import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/viewmodels/import_node_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'import_node_event.dart';
part 'import_node_state.dart';

class ImportNodeBloc extends Bloc<ImportNodeEvent, ImportNodeState> {
  final ImportNodeViewModel _viewModel;

  ImportNodeBloc(this._viewModel) : super(ImportNodeInitial());

  @override
  Stream<ImportNodeState> mapEventToState(
    ImportNodeEvent event,
  ) async* {
    if (event is ImportNode) {
      try {
        yield ImportNodeImporting();
        await _viewModel.readFile(event.path);
        await _viewModel.addAllNodes();
        yield ImportNodeImported(rootName: _viewModel.outputNodes.first.name);
      } on Error catch (e) {
        yield ImportNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield ImportNodeError(errMessage: e.toString());
      }
    }
  }
}
