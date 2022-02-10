import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';

class NodeDto {
  Identity id;
  Identity parentId;
  Name name;
  Description description;
  Position position;
  IconName iconName;

  NodeDto({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });

  NodeDto.fromEntity(Node node)
      : id = node.id,
        parentId = node.parentId,
        name = node.name,
        description = node.description,
        position = node.position,
        iconName = node.iconName;
}
