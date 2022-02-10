// @dart=2.9

import 'package:ssia_app/application/usecases/delete_node_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/delete_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  DeleteNodeViewModel sut;
  DeleteNodeUseCase deleteNodeWithChildrenUseCase;
  GetNodesByParentIdUseCase getNodesByParentIdUseCase;
  FakeNodeRepository fakeNodeRepository;
  EntityFactory entityFactory;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: fakeNodeRepository);
    deleteNodeWithChildrenUseCase = DeleteNodeUseCase(
        entityFactory: entityFactory, nodeRepository: fakeNodeRepository);
    sut = DeleteNodeViewModel(
        deleteNodeUseCase: deleteNodeWithChildrenUseCase,
        getNodesByParentIdUseCase: getNodesByParentIdUseCase);
  });

  group('DeleteNodeViewModel.deleteNodeWithChildren -', () {
    test('should throw Exception when there are errors', () async {
      // arrange
      Node node = Node(
          parentId: 'aa',
          id: '',
          name: 'name',
          description: 'desc',
          position: 1,
          iconName: 'icon');
      // assert
      expect(() => sut.deleteNodeWithChildren(node),
          throwsA(matcher.TypeMatcher<Exception>()));
    });

    test(
        'should delete node with children successfully and return deleted node',
        () async {
      // arrange
      Node node = Node(
          parentId: 'aa',
          id: 'bb',
          name: 'name',
          description: 'desc',
          position: 1,
          iconName: 'icon');
      // act
      await sut.deleteNodeWithChildren(node);
      // assert
      expect(sut.node, isNotNull);
      expect(sut.node.id, isNotNull);
    });
  });
}
