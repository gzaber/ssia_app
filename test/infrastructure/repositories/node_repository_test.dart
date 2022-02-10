// @dart=2.9
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:ssia_app/infrastructure/datasources/i_datasource.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
import 'package:ssia_app/infrastructure/repositories/node_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

void main() {
  NodeRepository sut;
  MockDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = NodeRepository(datasource: mockDatasource);
  });

  group('NodeRepository', () {
    var id = Identity.fromString('aa');
    var parentId = Identity.fromString('bb');
    var name = Name.create('name').getOrElse(null);
    var description = desc.Description.create('description').getOrElse(null);
    var position = Position.create(2).getOrElse(null);
    var iconName = IconName.create('icon_name').getOrElse(null);

    var node = Node(
      id: id,
      parentId: parentId,
      name: name,
      description: description,
      position: position,
      iconName: iconName,
    );

    test('.add - should add a node when call to the datasource is successfull',
        () async {
      // arrange

      // act
      await sut.add(node: node);
      // assert
      verify(mockDatasource.addNode(any)).called(1);
    });

    test(
        '.update - should update a node when call to the datasource is successfull',
        () async {
      // arrange

      // act
      await sut.update(node:node);
      // assert
      verify(mockDatasource.updateNode(any)).called(1);
    });

    test(
        '.delete - should delete a node when call to the datasource is successfull',
        () async {
      // arrange

      // act
      await sut.delete(nodeId: node.id);
      // assert
      verify(mockDatasource.deleteNode(any)).called(1);
    });
  });

  group('NodeRepository', () {
    var map = {
      'node_id': 'aa',
      'parent_id': 'bb',
      'name': 'name',
      'description': 'description',
      'position': 3,
      'icon_name': 'icon name',
    };

    test(
        '.find - should return a node when the call to the datasource is successfull',
        () async {
      // arrange
      when(mockDatasource.findNodeById(any))
          .thenAnswer((_) async => Some(NodeModel.fromMap(map)));
      // act
      var optionNode = await sut.findById(nodeId: Identity.fromString('aa'));
      // assert
      expect(optionNode, isNotNull);
      expect(optionNode.fold(() => null, (result) => result.id.id), 'aa');
      verify(mockDatasource.findNodeById(any)).called(1);
    });

    test(
        '.findByParentId - should return a list of nodes when the call to the datasource is successfull',
        () async {
      // arrange
      when(mockDatasource.findNodesByParentId(any))
          .thenAnswer((_) async => [NodeModel.fromMap(map)]);
      // act
      var nodes = await sut.findByParentId(nodeId: Identity.fromString('bb'));
      // assert
      expect(nodes, isNotEmpty);
      expect(nodes.first.parentId.id, 'bb');
      verify(mockDatasource.findNodesByParentId(any)).called(1);
    });

    test(
        '.findRoots - should return a list of roots when the call to the datasource is successfull',
        () async {
      // arrange
      when(mockDatasource.findRoots())
          .thenAnswer((_) async => [NodeModel.fromMap(map)]);
      // act
      var roots = await sut.findRoots();
      // assert
      expect(roots, isNotEmpty);
      expect(roots.first.parentId.id, 'bb');
      verify(mockDatasource.findRoots()).called(1);
    });
  });
}
