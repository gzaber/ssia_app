import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';

class NodePageViewModel {
  final IGetNodesByParentIdUseCase _getNodesByParentIdUseCase;
  final IUpdateNodeUseCase _updateNodeUseCase;

  List<Node> _nodes = [];
  List<String> _errMessages = [];
  Node _node = Node.empty();

  List<Node> get nodes => _nodes;
  Node get node => _node;

  NodePageViewModel(
      {required IGetNodesByParentIdUseCase getNodesByParentIdUseCase,
      required IUpdateNodeUseCase updateNodeUseCase})
      : _getNodesByParentIdUseCase = getNodesByParentIdUseCase,
        _updateNodeUseCase = updateNodeUseCase;

  Future<void> getNodes(String parentId) async {
    _nodes = [];
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

    if (result.getOrElse(null).nodes.isEmpty) return;

    result.getOrElse(null).nodes.forEach((nodeDto) {
      Node node = Node(
        id: nodeDto.id.id,
        parentId: nodeDto.parentId.id,
        name: nodeDto.name.value,
        description: nodeDto.description.value,
        position: nodeDto.position.value,
        iconName: nodeDto.iconName.value,
      );
      _nodes.add(node);
    });
  }

  Future<void> updateNodePosition(String parentId, String id, String name,
      String description, int position, String iconName) async {
    _errMessages = [];

    var verParentId;
    if (parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(parentId);
    }

    var verId;
    if (id == '') {
      _errMessages.add('Id cannot be empty');
    } else {
      verId = Identity.fromString(id);
    }

    Name verName = Name.create(name).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Description verDescription = Description.create(description).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Position verPosition = Position.create(position).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    IconName verIconName = IconName.create(iconName).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    var input = UpdateNodeInput(
      parentId: verParentId,
      id: verId,
      name: verName,
      description: verDescription,
      position: verPosition,
      iconName: verIconName,
    );

    var result = await _updateNodeUseCase.execute(input);

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
