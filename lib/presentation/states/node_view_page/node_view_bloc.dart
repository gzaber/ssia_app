import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/node_view_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'node_view_event.dart';
part 'node_view_state.dart';

class NodeViewBloc extends Bloc<NodeViewEvent, NodeViewState> {
  final NodeViewViewModel _viewModel;

  NodeViewBloc(this._viewModel) : super(NodeViewInitial());

  @override
  Stream<NodeViewState> mapEventToState(
    NodeViewEvent event,
  ) async* {
    if (event is GetTreeView) {
      try {
        yield NodeViewLoading();
        await _viewModel.getTreeView(event.id, 0);
        yield NodeViewLoaded(listOfTreeNodes: _viewModel.listOfTreeNodes);
      } on Error catch (e) {
        yield NodeViewError(errMessage: e.toString());
      } on Exception catch (e) {
        yield NodeViewError(errMessage: e.toString());
      }
    }
  }
}
