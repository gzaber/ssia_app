part of 'node_page_bloc.dart';

abstract class NodePageState extends Equatable {
  const NodePageState();

  @override
  List<Object> get props => [];
}

class NodePageInitial extends NodePageState {
  const NodePageInitial();
}

class NodePageLoading extends NodePageState {
  const NodePageLoading();
}

class NodePageLoaded extends NodePageState {
  final List<Node> nodes;

  const NodePageLoaded({required this.nodes});
}

class NodePageUpdating extends NodePageState {
  const NodePageUpdating();
}

class NodePageUpdated extends NodePageState {
  final Node node;

  const NodePageUpdated({required this.node});
}

class NodePageError extends NodePageState {
  final String errMessage;

  const NodePageError({required this.errMessage});
}
