import 'package:ssia_app/domain/value_objects/value_objects.dart';

class DeleteNodeOutput {
  final Identity id;
  final Identity parentId;
  final Name name;
  final Description description;
  final Position position;
  final IconName iconName;

  const DeleteNodeOutput({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });
}
