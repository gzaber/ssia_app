import 'package:ssia_app/domain/value_objects/value_objects.dart';

class Node {
  Identity id;
  Identity parentId;
  Name name;
  Description description;
  Position position;
  IconName iconName;

  Node({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}
