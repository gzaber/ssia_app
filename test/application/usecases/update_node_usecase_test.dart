// @dart=2.9
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNodeRepository extends Mock implements INodeRepository {}

class MockEntityFactory extends Mock implements IEntityFactory {}

void main() {
  UpdateNodeUseCase sut;
  MockNodeRepository mockNodeRepository;
  MockEntityFactory mockEntityFactory;

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    mockEntityFactory = MockEntityFactory();

    sut = UpdateNodeUseCase(nodeRepository: mockNodeRepository, entityFactory: mockEntityFactory);
  });

  group('UpdateNodeUseCase -', () {
    var rootInput = UpdateNodeInput(
      id: Identity.fromString('aa'),
      parentId: Identity.fromString('none'),
      name: Name.create('Updated name').getOrElse(null),
      description: desc.Description.create('Node description').getOrElse(null),
      position: Position.create(4).getOrElse(null),
      iconName: IconName.create('icon_name').getOrElse(null),
    );

    var nodeInput = UpdateNodeInput(
      id: Identity.fromString('aa'),
      parentId: Identity.fromString('bb'),
      name: Name.create('Updated name').getOrElse(null),
      description: desc.Description.create('Node description').getOrElse(null),
      position: Position.create(4).getOrElse(null),
      iconName: IconName.create('icon_name').getOrElse(null),
    );

    test('should return updated root when updated successfully', () async {
      // arrange
      when(mockEntityFactory.editedNode(
              id: anyNamed('id'),
              parentId: anyNamed('parentId'),
              name: anyNamed('name'),
              description: anyNamed('description'),
              position: anyNamed('position'),
              iconName: anyNamed('iconName')))
          .thenReturn(Node(
        id: rootInput.id,
        parentId: rootInput.parentId,
        name: rootInput.name,
        description: rootInput.description,
        position: rootInput.position,
        iconName: rootInput.iconName,
      ));
      // act
      var result = await sut.execute(rootInput);
      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse(null).id, equals(Identity.fromString('aa')));
      expect(result.getOrElse(null).parentId.id, 'none');
      expect(result.getOrElse(null).name.value, equals('Updated name'));
      verify(mockNodeRepository.update(node: anyNamed('node'))).called(1);
    });

    test('should return updated node when updated successfully', () async {
      // arrange
      when(mockEntityFactory.editedNode(
              id: anyNamed('id'),
              parentId: anyNamed('parentId'),
              name: anyNamed('name'),
              description: anyNamed('description'),
              position: anyNamed('position'),
              iconName: anyNamed('iconName')))
          .thenReturn(Node(
        id: nodeInput.id,
        parentId: nodeInput.parentId,
        name: nodeInput.name,
        description: nodeInput.description,
        position: nodeInput.position,
        iconName: nodeInput.iconName,
      ));
      // act
      var result = await sut.execute(nodeInput);
      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse(null).id, equals(Identity.fromString('aa')));
      expect(result.getOrElse(null).parentId, equals(Identity.fromString('bb')));
      expect(result.getOrElse(null).name.value, equals('Updated name'));
      verify(mockNodeRepository.update(node: anyNamed('node'))).called(1);
    });
  });
}
