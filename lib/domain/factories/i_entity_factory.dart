import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';

abstract class IEntityFactory {
  Node newNode({
    required Identity parentId,
    required Name name,
    required Description description,
    required Position position,
    required IconName iconName,
  });

  Node editedNode({
    required Identity id,
    required Identity parentId,
    required Name name,
    required Description description,
    required Position position,
    required IconName iconName,
  });

  Node emptyNode();
}
