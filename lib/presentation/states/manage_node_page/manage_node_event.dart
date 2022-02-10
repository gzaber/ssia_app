part of 'manage_node_bloc.dart';

abstract class ManageNodeEvent extends Equatable {
  const ManageNodeEvent();

  @override
  List<Object> get props => [];
}

class AddNode extends ManageNodeEvent {
  final String parentId;
  final String name;
  final String description;
  final int position;
  final String iconName;

  const AddNode({
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}

class UpdateNode extends ManageNodeEvent {
  final String parentId;
  final String id;
  final String name;
  final String description;
  final int position;
  final String iconName;

  const UpdateNode({
    required this.parentId,
    required this.id,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}
