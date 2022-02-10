part of 'delete_node_bloc.dart';

abstract class DeleteNodeState extends Equatable {
  const DeleteNodeState();

  @override
  List<Object> get props => [];
}

class DeleteNodeInitial extends DeleteNodeState {
  const DeleteNodeInitial();
}

class DeleteNodeDeleting extends DeleteNodeState {
  const DeleteNodeDeleting();
}

class DeleteNodeDeleted extends DeleteNodeState {
  final Node node;

  const DeleteNodeDeleted({required this.node});
}

class DeleteNodeError extends DeleteNodeState {
  final String errMessage;

  const DeleteNodeError({required this.errMessage});
}
