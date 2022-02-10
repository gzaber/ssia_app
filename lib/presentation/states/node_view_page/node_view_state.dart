part of 'node_view_bloc.dart';

abstract class NodeViewState extends Equatable {
  const NodeViewState();
  
  @override
  List<Object> get props => [];
}

class NodeViewInitial extends NodeViewState {
  const NodeViewInitial();
}

class NodeViewLoading extends NodeViewState {
  const NodeViewLoading();
}

class NodeViewLoaded extends NodeViewState {
  final List<Map<int, Node>> listOfTreeNodes;

  const NodeViewLoaded({required this.listOfTreeNodes});
}

class NodeViewError extends NodeViewState {
  final String errMessage;

  const NodeViewError({required this.errMessage});
}
