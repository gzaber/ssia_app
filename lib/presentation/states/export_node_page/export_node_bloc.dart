import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/viewmodels.dart';
import 'package:equatable/equatable.dart';

part 'export_node_event.dart';
part 'export_node_state.dart';

class ExportNodeBloc extends Bloc<ExportNodeEvent, ExportNodeState> {
  final ExportNodeViewModel _viewModel;

  ExportNodeBloc(this._viewModel) : super(ExportNodeInitial());

  @override
  Stream<ExportNodeState> mapEventToState(
    ExportNodeEvent event,
  ) async* {
    if (event is GetNodeList) {
      try {
        yield ExportNodeLoading();
        await _viewModel.getNodeList(event.id);
        yield ExportNodeLoaded(nodes: _viewModel.nodes);
      } on Error catch (e) {
        yield ExportNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield ExportNodeError(errMessage: e.toString());
      }
    }
    if (event is ExportNodes) {
      try {
        yield ExportNodeSaving();
        await _viewModel.saveFile(event.root, event.path, event.fileName);
        yield ExportNodeSaved(fileName: '${event.path}/${event.fileName}');
      } on Error catch (e) {
        yield ExportNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield ExportNodeError(errMessage: e.toString());
      }
    }
  }
}
