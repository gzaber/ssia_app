import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';

class NodeModel extends Node {
  Identity id;
  Identity parentId;
  Name name;
  Description description;
  Position position;
  IconName iconName;

  NodeModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  }) : super(
          id: id,
          parentId: parentId,
          name: name,
          description: description,
          position: position,
          iconName: iconName,
        );

  factory NodeModel.fromMap(Map<String, dynamic> map) {
    return NodeModel(
      id: Identity.fromString(map['node_id']),
      parentId: Identity.fromString(map['parent_id']),
      name: Name.create(map['name']).getOrElse(null),
      description: Description.create(map['description']).getOrElse(null),
      position: Position.create(map['position']).getOrElse(null),
      iconName: IconName.create(map['icon_name']).getOrElse(null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'node_id': id.id,
      'parent_id': parentId.id,
      'name': name.value,
      'description': description.value,
      'position': position.value,
      'icon_name': iconName.value,
    };
  }

  factory NodeModel.empty() {
    return NodeModel(
      id: Identity.fromString('empty'),
      parentId: Identity.fromString('empty'),
      name: Name.create('empty').getOrElse(null),
      description: Description.create('empty').getOrElse(null),
      position: Position.create(0).getOrElse(null),
      iconName: IconName.create('empty').getOrElse(null),
    );
  }
}
