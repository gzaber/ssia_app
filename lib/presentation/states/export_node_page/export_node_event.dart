part of 'export_node_bloc.dart';

abstract class ExportNodeEvent extends Equatable {
  const ExportNodeEvent();

  @override
  List<Object> get props => [];
}

class GetNodeList extends ExportNodeEvent {
  final String id;

  const GetNodeList({required this.id});
}

class ExportNodes extends ExportNodeEvent {
  final Node root;
  final String path;
  final String fileName;

  const ExportNodes({
    required this.root,
    required this.path,
    required this.fileName,
  });
}
