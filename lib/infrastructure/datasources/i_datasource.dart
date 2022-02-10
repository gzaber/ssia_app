import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

abstract class IDatasource {
  addNode(NodeModel model);
  updateNode(NodeModel model);
  deleteNode(Identity nodeId);
  Future<Option<NodeModel>> findNodeById(Identity nodeId);
  Future<List<NodeModel>> findNodesByParentId(Identity nodeId);
  Future<List<NodeModel>> findRoots();
}
