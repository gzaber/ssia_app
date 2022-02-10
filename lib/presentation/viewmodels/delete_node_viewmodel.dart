import 'package:ssia_app/application/boundaries/delete_node/delete_node_input.dart';
import 'package:ssia_app/application/boundaries/delete_node/i_delete_node_usecase.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';

class DeleteNodeViewModel {
  final IDeleteNodeUseCase _deleteNodeUseCase;
  final IGetNodesByParentIdUseCase _getNodesByParentIdUseCase;

  List<String> _errMessages = [];
  List<Node> _nodes = [];

  Node _node = Node(
    id: 'empty',
    parentId: 'empty',
    name: 'empty',
    description: 'empty',
    position: 0,
    iconName: 'empty',
  );

  Node get node => _node;

  DeleteNodeViewModel(
      {required IDeleteNodeUseCase deleteNodeUseCase,
      required IGetNodesByParentIdUseCase getNodesByParentIdUseCase})
      : _deleteNodeUseCase = deleteNodeUseCase,
        _getNodesByParentIdUseCase = getNodesByParentIdUseCase;

  Future<void> deleteNodeWithChildren(Node node) async {
    if (node.id.trim().isEmpty) throw Exception('Incorrect input data');

    _nodes.add(node);
    await getNodeList(node.id);

    for (Node node in _nodes.reversed) {
      await _deleteNode(node);
    }
  }

  Future<void> getNodeList(String id) async {
    List<Node> nodes = await _getNodes(id);

    for (Node node in nodes) {
      await getNodeList(node.id);
      _nodes.add(node);
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

  Future<void> _deleteNode(Node node) async {
    _errMessages = [];

    var verParentId;

    if (node.parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(node.parentId);
    }

    var verId;

    if (node.id == '') {
      _errMessages.add('Id cannot be empty');
    } else {
      verId = Identity.fromString(node.id);
    }

    Name verName = Name.create(node.name).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Description verDescription =
        Description.create(node.description).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Position verPosition = Position.create(node.position).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    IconName verIconName = IconName.create(node.iconName).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    var input = DeleteNodeInput(
      id: verId,
      parentId: verParentId,
      name: verName,
      description: verDescription,
      position: verPosition,
      iconName: verIconName,
    );

    var result = await _deleteNodeUseCase.execute(input);

    result.fold(
      (e) => throw Exception(e.message),
      (o) => _node = Node(
        id: o.id.id,
        parentId: o.parentId.id,
        name: o.name.value,
        description: o.name.value,
        position: o.position.value,
        iconName: o.iconName.value,
      ),
    );
  }
}
