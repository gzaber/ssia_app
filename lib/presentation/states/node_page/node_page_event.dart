part of 'node_page_bloc.dart';

abstract class NodePageEvent extends Equatable {
  const NodePageEvent();

  @override
  List<Object> get props => [];
}

class GetNodes extends NodePageEvent {
  final String parentId;

  const GetNodes({required this.parentId});
}

class UpdateNodePosition extends NodePageEvent {
  final String parentId;
  final String id;
  final String name;
  final String description;
  final int position;
  final String iconName;

  const UpdateNodePosition({
    required this.parentId,
    required this.id,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}
