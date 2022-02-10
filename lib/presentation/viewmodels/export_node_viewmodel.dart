import 'dart:convert';
import 'dart:io';

import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';

class ExportNodeViewModel {
  final IGetNodesByParentIdUseCase _getNodesByParentIdUseCase;

  List<String> _errMessages = [];
  List<Node> _nodes = [];

  List<Node> get nodes => _nodes;

  ExportNodeViewModel(
      {required IGetNodesByParentIdUseCase getNodesByParentIdUseCase})
      : _getNodesByParentIdUseCase = getNodesByParentIdUseCase;

  Future<File> saveFile(Node root, String path, String fileName) async {
    _errMessages = [];
    List<Map<String, dynamic>> nodesJson = [];

    nodesJson.add(root.toJson());
    _nodes.forEach((node) => nodesJson.add(node.toJson()));

    var jsonString = jsonEncode(nodesJson);

    if (fileName.trim().isEmpty) _errMessages.add('File name cannot be empty.');
    if (path.trim().isEmpty) _errMessages.add('Path cannot be empty.');
    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    File jsonFile = File('$path/$fileName.json');
    await jsonFile.writeAsString(jsonString);

    return jsonFile;
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
}
