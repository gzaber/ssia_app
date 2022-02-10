import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/delete_node_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'delete_node_event.dart';
part 'delete_node_state.dart';

class DeleteNodeBloc extends Bloc<DeleteNodeEvent, DeleteNodeState> {
  final DeleteNodeViewModel _viewModel;

  DeleteNodeBloc(this._viewModel) : super(DeleteNodeInitial());

  @override
  Stream<DeleteNodeState> mapEventToState(
    DeleteNodeEvent event,
  ) async* {
    if (event is DeleteNode) {
      try {
        yield DeleteNodeDeleting();
        await _viewModel.deleteNodeWithChildren(event.node);
        yield DeleteNodeDeleted(node: _viewModel.node);
      } on Error catch (e) {
        yield DeleteNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield DeleteNodeError(errMessage: e.toString());
      }
    }
  }
}
