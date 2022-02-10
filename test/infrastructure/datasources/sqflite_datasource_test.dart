// @dart=2.9
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/datasources/sqflite_datasource.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockSqfliteDatabase extends Mock implements Database {}

void main() {
  SqfliteDatasource sut;
  MockSqfliteDatabase database;

  setUp(() {
    database = MockSqfliteDatabase();
    sut = SqfliteDatasource(db: database);
  });

  var nodeMap = {
    'node_id': 'aa',
    'parent_id': 'bb',
    'name': 'name',
    'description': 'description',
    'position': 3,
    'icon_name': 'iconName',
  };

  var rootMap = {
    'node_id': 'aa',
    'parent_id': 'none',
    'name': 'name',
    'description': 'description',
    'position': 3,
    'icon_name': 'iconName',
  };

  group('SqfliteDatasource.addNode -', () {
    test('should perform a database insert', () async {
      // arrange
      var nodeModel = NodeModel.fromMap(nodeMap);
      when(database.insert('nodes', nodeModel.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace))
          .thenAnswer((_) async => 1);
      // act
      await sut.addNode(nodeModel);
      // assert
      verify(database.insert('nodes', nodeModel.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
    });
  });

  group('SqfliteDatasource.updateNode -', () {
    test('should perform a database update', () async {
      // arrange
      var nodeModel = NodeModel.fromMap(nodeMap);
      when(database.update(
        'nodes',
        nodeModel.toMap(),
        where: 'node_id = ?',
        whereArgs: [nodeModel.id.id],
      )).thenAnswer((_) async => 1);
      // act
      await sut.updateNode(nodeModel);
      // assert
      verify(database.update(
        'nodes',
        nodeModel.toMap(),
        where: 'node_id = ?',
        whereArgs: [nodeModel.id.id],
      )).called(1);
    });
  });

  group('SqfliteDatasource.deleteNode -', () {
    test('should perform a database delete', () async {
      // arrange
      var nodeModel = NodeModel.fromMap(nodeMap);
      when(database.delete(
        'nodes',
        where: 'node_id = ?',
        whereArgs: [nodeModel.id.id],
      )).thenAnswer((_) async => 1);
      // act
      await sut.deleteNode(nodeModel.id);
      // assert
      verify(database.delete('nodes',
          where: 'node_id = ?', whereArgs: [nodeModel.id.id])).called(1);
    });
  });

  group('SqfliteDatasource.findNodeById -', () {
    test('should perform a database query and return a matching record',
        () async {
      // arrange
      when(database.query('nodes',
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((_) async => [nodeMap]);
      // act
      var optionNodeModel = await sut.findNodeById(Identity.fromString('aa'));
      // assert
      expect(optionNodeModel, isNotNull);
      expect(optionNodeModel.fold(() => null, (result) => result.id.id),'aa');
      expect(optionNodeModel.fold(() => null, (result) => result.name.value), 'name');
    });
  });

  group('SqfliteDatasource.findNodesByParentId -', () {
    test(
        'should perform a database query and return nodes by parent id records',
        () async {
      // arrange
      when(database.query(
        'nodes',
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
        orderBy: 'position ASC',
      )).thenAnswer((_) async => [nodeMap]);
      // act
      var nodeModels = await sut.findNodesByParentId(Identity.fromString('bb'));
      // assert
      expect(nodeModels, isNotEmpty);
      expect(nodeModels.first.parentId.id, 'bb');
      expect(nodeModels.first.name.value, 'name');
    });
  });

  group('SqfliteDatasource.findRoots -', () {
    test('should perform a database query and return all roots', () async {
      // arrange
      when(database.query(
        'nodes',
        where: 'parent_id = ?',
        whereArgs: ['none'],
        orderBy: 'position ASC',
      )).thenAnswer((_) async => [rootMap]);
      // act
      var roots = await sut.findRoots();
      // assert
      expect(roots, isNotEmpty);
      expect(roots.first.parentId.id, 'none');
      verify(database.query(
        'nodes',
        where: 'parent_id = ?',
        whereArgs: ['none'],
        orderBy: 'position ASC',
      )).called(1);
    });
  });
}
