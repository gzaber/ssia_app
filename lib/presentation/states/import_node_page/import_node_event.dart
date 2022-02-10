part of 'import_node_bloc.dart';

abstract class ImportNodeEvent extends Equatable {
  const ImportNodeEvent();

  @override
  List<Object> get props => [];
}

class ImportNode extends ImportNodeEvent {
  final String path;

  const ImportNode({required this.path});
}


