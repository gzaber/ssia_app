part of 'manage_node_bloc.dart';

abstract class ManageNodeState extends Equatable {
  const ManageNodeState();

  @override
  List<Object> get props => [];
}

class ManageNodeInitial extends ManageNodeState {
  const ManageNodeInitial();
}

class ManageNodeAdding extends ManageNodeState {
  const ManageNodeAdding();
}

class ManageNodeAdded extends ManageNodeState {
  final Node node;

  const ManageNodeAdded({required this.node});
}

class ManageNodeUpdating extends ManageNodeState {
  const ManageNodeUpdating();
}

class ManageNodeUpdated extends ManageNodeState {
  final Node node;

  const ManageNodeUpdated({required this.node});
}

class ManageNodeError extends ManageNodeState {
  final String errMessage;

  const ManageNodeError({required this.errMessage});
}
