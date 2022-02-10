import 'dart:collection';

import 'package:ssia_app/application/boundaries/node_dto.dart';

class GetNodesByParentIdOutput {
  final UnmodifiableListView<NodeDto> nodes;

  GetNodesByParentIdOutput({required this.nodes});
}