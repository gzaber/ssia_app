part of 'delete_node_bloc.dart';

abstract class DeleteNodeEvent extends Equatable {
  const DeleteNodeEvent();

  @override
  List<Object> get props => [];
}

class DeleteNode extends DeleteNodeEvent {
  final Node node;

  const DeleteNode({required this.node});
}
