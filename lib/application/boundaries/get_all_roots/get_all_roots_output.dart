import 'dart:collection';
import 'package:ssia_app/application/boundaries/node_dto.dart';

class GetAllRootsOutput {
  final UnmodifiableListView<NodeDto> roots;

  GetAllRootsOutput({required this.roots});
}
