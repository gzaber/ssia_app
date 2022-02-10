part of 'node_view_bloc.dart';

abstract class NodeViewEvent extends Equatable {
  const NodeViewEvent();

  @override
  List<Object> get props => [];
}

class GetTreeView extends NodeViewEvent {
  final String id;

  const GetTreeView({required this.id});
}
