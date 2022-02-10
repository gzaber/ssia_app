import 'dart:io';

import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_input.dart';
import 'package:ssia_app/application/boundaries/add_all_nodes/i_add_all_nodes_usecase.dart';
import 'package:ssia_app/application/boundaries/get_node/get_node_input.dart';
import 'package:ssia_app/application/boundaries/get_node/i_get_node_usecase.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'dart:convert';

class ImportNodeViewModel {
  final IGetNodeUseCase _getNodeUseCase;
  final IAddAllNodesUseCase _addAllNodesUseCase;

  List<String> _errMessages = [];
  List<Node> _nodes = [];
  List<Node> _outputNodes = [];

  List<Node> get nodes => _nodes;

  List<Node> get outputNodes => _outputNodes;

  ImportNodeViewModel({
    required IGetNodeUseCase getNodeUseCase,
    required IAddAllNodesUseCase addAllNodesUseCase,
  })  : _getNodeUseCase = getNodeUseCase,
        _addAllNodesUseCase = addAllNodesUseCase;

  Future<void> readFile(String path) async {
    try {
      File file = File(path);

      final contents = await file.readAsString();
      var nodesJson = jsonDecode(contents);

      nodesJson.forEach((item) {
        _nodes.add(Node.fromJson(item));
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addAllNodes() async {
    _errMessages = [];

    if (_nodes.isEmpty) _errMessages.add('File does not contain correct nodes');
    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    int counter = 0;

    for (Node node in _nodes) {
      var input = GetNodeInput(nodeId: Identity.fromString(node.id));
      var result = await _getNodeUseCase.execute(input);

      if (result.getOrElse(null).id.id == node.id)
        throw Exception('Project already exists');

      if (result.getOrElse(null).id.id != 'empty') counter++;
    }

    List<AddAllNodesInput> inputNodes = [];

    if (counter == 0) {
      _nodes.forEach((node) {
        inputNodes.add(_addInputNode(
          node.id,
          node.parentId,
          node.name,
          node.description,
          node.position,
          node.iconName,
        ));
      });
    } else
      return;

    var result = await _addAllNodesUseCase.execute(inputNodes);

    result.fold(
      (error) => throw Exception(error.message),
      (output) {
        output.forEach((o) {
          _outputNodes.add(Node(
            id: o.id.id,
            parentId: o.parentId.id,
            name: o.name.value,
            description: o.description.value,
            position: o.position.value,
            iconName: o.iconName.value,
          ));
        });
      },
    );
  }

  AddAllNodesInput _addInputNode(String id, String parentId, String name,
      String description, int position, String iconName) {
    _errMessages = [];

    var verId;

    if (id == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verId = Identity.fromString(id);
    }

    var verParentId;

    if (parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(parentId);
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

    return AddAllNodesInput(
      id: verId,
      parentId: verParentId,
      name: verName,
      description: verDescription,
      position: verPosition,
      iconName: verIconName,
    );
  }
}
