part of 'export_node_bloc.dart';

abstract class ExportNodeState extends Equatable {
  const ExportNodeState();

  @override
  List<Object> get props => [];
}

class ExportNodeInitial extends ExportNodeState {
  const ExportNodeInitial();
}

class ExportNodeLoading extends ExportNodeState {
  const ExportNodeLoading();
}

class ExportNodeLoaded extends ExportNodeState {
  final List<Node> nodes;

  const ExportNodeLoaded({required this.nodes});
}

class ExportNodeSave extends ExportNodeState {
  final Node root;
  final String path;
  final String fileName;

  const ExportNodeSave(
      {required this.root, required this.path, required this.fileName});
}

class ExportNodeSaving extends ExportNodeState {
  const ExportNodeSaving();
}

class ExportNodeSaved extends ExportNodeState {
  final String fileName;

  const ExportNodeSaved({required this.fileName});
}

class ExportNodeError extends ExportNodeState {
  final String errMessage;

  const ExportNodeError({required this.errMessage});
}
