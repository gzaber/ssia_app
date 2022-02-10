import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/presentation/models/node.dart';

class NodeViewViewModel {
  final IGetNodesByParentIdUseCase _getNodesByParentIdUseCase;

  List<String> _errMessages = [];
  List<Map<int, Node>> _listOfTreeNodes = [];
  int level = 0;

  List<Map<int, Node>> get listOfTreeNodes =>
      _listOfTreeNodes.reversed.toList();

  NodeViewViewModel(
      {required IGetNodesByParentIdUseCase getNodesByParentIdUseCase})
      : _getNodesByParentIdUseCase = getNodesByParentIdUseCase;

  Future<void> getTreeView(String id, int level) async {
    List<Node> nodes = await _getNodes(id);
    level++;

    var finalNodes = nodes.reversed;

    for (Node node in finalNodes) {
      await getTreeView(node.id, level);
      _listOfTreeNodes.add({level: node});
    }
  }

  Future<List<Node>> _getNodes(String parentId) async {
    List<Node> nodes = [];
    _errMessages = [];

    var verParentId;
    if (parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(parentId);
    }

    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    var input = GetNodesByParentIdInput(nodeId: verParentId);

    var result = await _getNodesByParentIdUseCase.execute(input);

    if (result.getOrElse(null).nodes.isEmpty) return [];

    result.getOrElse(null).nodes.forEach((nodeDto) {
      Node node = Node(
        id: nodeDto.id.id,
        parentId: nodeDto.parentId.id,
        name: nodeDto.name.value,
        description: nodeDto.description.value,
        position: nodeDto.position.value,
        iconName: nodeDto.iconName.value,
      );
      nodes.add(node);
    });

    return nodes;
  }
}
