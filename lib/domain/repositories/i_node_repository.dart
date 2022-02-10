import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

abstract class INodeRepository {
  add({required Node node});
  update({required Node node});
  delete({required Identity nodeId});
  Future<Option<Node>> findById({required Identity nodeId});
  Future<List<Node>> findByParentId({required Identity nodeId});
  Future<List<Node>> findRoots();
}
