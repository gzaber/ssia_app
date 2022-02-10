part of 'import_node_bloc.dart';

abstract class ImportNodeState extends Equatable {
  const ImportNodeState();
  
  @override
  List<Object> get props => [];
}

class ImportNodeInitial extends ImportNodeState {
  const ImportNodeInitial();
}

class ImportNodeImporting extends ImportNodeState {
  const ImportNodeImporting();
}

class ImportNodeImported extends ImportNodeState {
  final String rootName;

  const ImportNodeImported({required this.rootName});
}

class ImportNodeError extends ImportNodeState {
  final String errMessage;

  const ImportNodeError({required this.errMessage});
}
