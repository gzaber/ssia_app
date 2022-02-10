import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/datasources/i_datasource.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;

  const SqfliteDatasource({required db}) : _db = db;

  @override
  addNode(NodeModel model) async {
    await _db.insert('nodes', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  updateNode(NodeModel model) async {
    await _db.update(
      'nodes',
      model.toMap(),
      where: 'node_id = ?',
      whereArgs: [model.id.id],
    );
  }

  @override
  deleteNode(Identity nodeId) async {
    await _db.delete(
      'nodes',
      where: 'node_id = ?',
      whereArgs: [nodeId.id],
    );
  }

  @override
  Future<Option<NodeModel>> findNodeById(Identity nodeId) async {
    var listOfMaps = await _db.query(
      'nodes',
      where: 'node_id = ?',
      whereArgs: [nodeId.id],
    );

    if (listOfMaps.isEmpty) {
      return None();
    } else {
      return Some(NodeModel.fromMap(listOfMaps.first));
    }
  }

  @override
  Future<List<NodeModel>> findNodesByParentId(Identity nodeId) async {
    var listOfMaps = await _db.query(
      'nodes',
      where: 'parent_id = ?',
      whereArgs: [nodeId.id],
      orderBy: 'position ASC',
    );

    if (listOfMaps.isEmpty) return [];

    return listOfMaps.map<NodeModel>((map) => NodeModel.fromMap(map)).toList();
  }

  @override
  Future<List<NodeModel>> findRoots() async {
    var listOfMaps = await _db.query(
      'nodes',
      where: 'parent_id = ?',
      whereArgs: ['none'],
      orderBy: 'position ASC',
    );

    if (listOfMaps.isEmpty) return [];

    return listOfMaps.map<NodeModel>((map) => NodeModel.fromMap(map)).toList();
  }
}
