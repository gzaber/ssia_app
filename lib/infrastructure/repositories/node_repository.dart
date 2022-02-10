import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/datasources/i_datasource.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class NodeRepository implements INodeRepository {
  IDatasource _datasource;

  NodeRepository({required IDatasource datasource}) : _datasource = datasource;

  @override
  add({required Node node}) async {
    var model = NodeModel(
      id: node.id,
      parentId: node.parentId,
      name: node.name,
      description: node.description,
      position: node.position,
      iconName: node.iconName,
    );
    return await _datasource.addNode(model);
  }

  @override
  update({required Node node}) async {
    var model = NodeModel(
      id: node.id,
      parentId: node.parentId,
      name: node.name,
      description: node.description,
      position: node.position,
      iconName: node.iconName,
    );
    return await _datasource.updateNode(model);
  }

  @override
  delete({required Identity nodeId}) async {
    return await _datasource.deleteNode(nodeId);
  }

  @override
  Future<Option<Node>> findById({required Identity nodeId}) async {
    return await _datasource.findNodeById(nodeId);
  }

  @override
  Future<List<Node>> findByParentId({required Identity nodeId}) async {
    return await _datasource.findNodesByParentId(nodeId);
  }

  @override
  Future<List<Node>> findRoots() async {
    return await _datasource.findRoots();
  }
}
