import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/manage_node_viewmodel.dart';
import 'package:equatable/equatable.dart';

part 'manage_node_event.dart';
part 'manage_node_state.dart';

class ManageNodeBloc extends Bloc<ManageNodeEvent, ManageNodeState> {
  final ManageNodeViewModel _viewModel;

  ManageNodeBloc(this._viewModel) : super(ManageNodeInitial());

  @override
  Stream<ManageNodeState> mapEventToState(
    ManageNodeEvent event,
  ) async* {
    if (event is AddNode) {
      try {
        yield ManageNodeAdding();
        await _viewModel.addNode(
          event.parentId,
          event.name,
          event.description,
          event.position,
          event.iconName,
        );
        yield ManageNodeAdded(node: _viewModel.node);
      } on Error catch (e) {
        yield ManageNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield ManageNodeError(
            errMessage: e.toString().replaceAll('Exception: ', ''));
      }
    }
    if (event is UpdateNode) {
      try {
        yield ManageNodeUpdating();
        await _viewModel.updateNode(
          event.parentId,
          event.id,
          event.name,
          event.description,
          event.position,
          event.iconName,
        );
        yield ManageNodeUpdated(node: _viewModel.node);
      } on Error catch (e) {
        yield ManageNodeError(errMessage: e.toString());
      } on Exception catch (e) {
        yield ManageNodeError(
            errMessage: e.toString().replaceAll('Exception: ', ''));
      }
    }
  }
}
