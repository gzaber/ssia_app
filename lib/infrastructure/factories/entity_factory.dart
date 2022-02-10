import 'package:uuid/uuid.dart';

import '../../domain/entities/node.dart';
import '../../domain/factories/i_entity_factory.dart';
import '../../domain/value_objects/value_objects.dart';

class EntityFactory implements IEntityFactory {
  @override
  Node editedNode({
    required Identity id,
    required Identity parentId,
    required Name name,
    required Description description,
    required Position position,
    required IconName iconName,
  }) {
    return Node(
      id: id,
      parentId: parentId,
      name: name,
      description: description,
      position: position,
      iconName: iconName,
    );
  }

  @override
  Node newNode({
    required Identity parentId,
    required Name name,
    required Description description,
    required Position position,
    required IconName iconName,
  }) {
    return Node(
      id: Identity.fromString(Uuid().v4()),
      parentId: parentId,
      name: name,
      description: description,
      position: position,
      iconName: iconName,
    );
  }

  @override
  Node emptyNode() {
    return Node(
        id: Identity.fromString('empty'),
        parentId: Identity.fromString('empty'),
        name: Name.create('empty').getOrElse(null),
        description: Description.create('empty').getOrElse(null),
        position: Position.create(0).getOrElse(null),
        iconName: IconName.create('empty').getOrElse(null));
  }
}
