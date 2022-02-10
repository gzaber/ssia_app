// @dart=2.9
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'add_node_usecase_test.dart';

void main() {
  GetNodesByParentIdUseCase sut;
  MockNodeRepository mockNodeRepository;

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    sut = GetNodesByParentIdUseCase(nodeRepository: mockNodeRepository);
  });

  group('GetNodesByParentIdUseCase -', () {
    var input = GetNodesByParentIdInput(nodeId: Identity.fromString('aa'));
    test('should return an empty list when no nodes are found', () async {
      // arrange
      when(mockNodeRepository.findByParentId(nodeId: input.nodeId))
          .thenAnswer((_) async => []);
      // act
      var result = await sut.execute(input);
      // assert
      expect(result.getOrElse(null).nodes, isEmpty);
    });

    test('should return list of roots', () async {
      // arrange
      var root = Node(
        id: Identity.fromString('aa'),
        parentId: Identity.fromString('none'),
        name: Name.create('Root name').getOrElse(null),
        description:
            desc.Description.create('Root description').getOrElse(null),
        position: Position.create(4).getOrElse(null),
        iconName: IconName.create('icon_name').getOrElse(null),
      );

      var roots = [root];
      when(mockNodeRepository.findByParentId(nodeId: input.nodeId))
          .thenAnswer((_) async => roots);
      // act
      var result = await sut.execute(input);
      // assert
      expect(result.getOrElse(null).nodes, isNotEmpty);
      expect(result.getOrElse(null).nodes.first.id, isNotNull);
      expect(result.getOrElse(null).nodes.first.parentId.id, 'none');
      verify(mockNodeRepository.findByParentId(nodeId: input.nodeId));
    });

    test('should return list of nodes', () async {
      // arrange
      var node = Node(
        id: Identity.fromString('aa'),
        parentId: Identity.fromString('bb'),
        name: Name.create('Node name').getOrElse(null),
        description:
            desc.Description.create('Node description').getOrElse(null),
        position: Position.create(4).getOrElse(null),
        iconName: IconName.create('icon_name').getOrElse(null),
      );

      var nodes = [node];
      when(mockNodeRepository.findByParentId(nodeId: input.nodeId))
          .thenAnswer((_) async => nodes);
      // act
      var result = await sut.execute(input);
      // assert
      expect(result.getOrElse(null).nodes, isNotEmpty);
      expect(result.getOrElse(null).nodes.first.id, isNotNull);
      expect(result.getOrElse(null).nodes.first.parentId, isNotNull);
      verify(mockNodeRepository.findByParentId(nodeId: input.nodeId));
    });
  });
}
