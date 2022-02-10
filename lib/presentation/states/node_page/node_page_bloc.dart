import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/node_page_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'node_page_event.dart';
part 'node_page_state.dart';

class NodePageBloc extends Bloc<NodePageEvent, NodePageState> {
  final NodePageViewModel _viewModel;

  NodePageBloc(this._viewModel) : super(NodePageInitial());

  @override
  Stream<NodePageState> mapEventToState(
    NodePageEvent event,
  ) async* {
    if (event is GetNodes) {
      try {
        yield NodePageLoading();
        await _viewModel.getNodes(event.parentId);
        yield NodePageLoaded(nodes: _viewModel.nodes);
      } on Error catch (e) {
        yield NodePageError(errMessage: e.toString());
      } on Exception catch (e) {
        yield NodePageError(errMessage: e.toString());
      }
    }
    if (event is UpdateNodePosition) {
      try {
        yield NodePageUpdating();
        await _viewModel.updateNodePosition(
          event.parentId,
          event.id,
          event.name,
          event.description,
          event.position,
          event.iconName,
        );
        yield NodePageUpdated(node: _viewModel.node);
      } on Error catch (e) {
        yield NodePageError(errMessage: e.toString());
      } on Exception catch (e) {
        yield NodePageError(errMessage: e.toString());
      }
    }
  }
}
