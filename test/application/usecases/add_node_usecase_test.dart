// @dart=2.9
import 'package:ssia_app/application/boundaries/add_node/add_node_input.dart';
import 'package:ssia_app/application/usecases/add_node_usecase.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNodeRepository extends Mock implements INodeRepository {}

class MockEntityFactory extends Mock implements IEntityFactory {}

void main() {
  AddNodeUseCase sut;
  MockNodeRepository mockNodeRepository;
  MockEntityFactory mockEntityFactory;

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    mockEntityFactory = MockEntityFactory();

    sut = AddNodeUseCase(nodeRepository: mockNodeRepository, entityFactory: mockEntityFactory);
  });

  group('AddNodeUseCase -', () {
    var rootInput = AddNodeInput(
      parentId: Identity.fromString('none'),
      name: Name.create('Node name').getOrElse(null),
      description: desc.Description.create('Node description').getOrElse(null),
      position: Position.create(4).getOrElse(null),
      iconName: IconName.create('icon_name').getOrElse(null),
    );

    var nodeInput = AddNodeInput(
      parentId: Identity.fromString('bb'),
      name: Name.create('Node name').getOrElse(null),
      description: desc.Description.create('Node description').getOrElse(null),
      position: Position.create(4).getOrElse(null),
      iconName: IconName.create('icon_name').getOrElse(null),
    );

    test('should return root with created id when added successfully', () async {
      // arrange
      when(mockEntityFactory.newNode(
        parentId: anyNamed('parentId'),
        name: anyNamed('name'),
        description: anyNamed('description'),
        position: anyNamed('position'),
        iconName: anyNamed('iconName'),
      )).thenReturn(Node(
        id: Identity.fromString('aaa'),
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
      expect(result.getOrElse(null).id, isNotNull);
      expect(result.getOrElse(null).parentId.id, 'none');
      verify(mockNodeRepository.add(node: anyNamed('node'))).called(1);
    });

    test('should return node with created id when added successfully', () async {
      // arrange
      when(mockEntityFactory.newNode(
        parentId: anyNamed('parentId'),
        name: anyNamed('name'),
        description: anyNamed('description'),
        position: anyNamed('position'),
        iconName: anyNamed('iconName'),
      )).thenReturn(Node(
        id: Identity.fromString('aaa'),
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
      expect(result.getOrElse(null).id, isNotNull);
      expect(result.getOrElse(null).parentId, isNotNull);
      verify(mockNodeRepository.add(node: anyNamed('node'))).called(1);
    });
  });
}
