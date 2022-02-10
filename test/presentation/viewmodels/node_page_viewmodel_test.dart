// @dart=2.9
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/viewmodels/node_page_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  NodePageViewModel sut;
  IGetNodesByParentIdUseCase getNodesByParentIdUseCase;
  IUpdateNodeUseCase updateNodeUseCase;
  FakeNodeRepository fakeNodeRepository;
  EntityFactory entityFactory;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: fakeNodeRepository);
    updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: fakeNodeRepository, entityFactory: entityFactory);

    sut = NodePageViewModel(
      getNodesByParentIdUseCase: getNodesByParentIdUseCase,
      updateNodeUseCase: updateNodeUseCase,
    );
  });

  group('NodePageViewModel.getNodes -', () {
    test('should return empty list of nodes when no nodes in storage',
        () async {
      // arrange
      fakeNodeRepository.nodes = [];
      // act
      await sut.getNodes('zz');
      // assert
      expect(sut.nodes.length, 0);
      expect(sut.nodes, isEmpty);
    });

    test('should return nodes from storage', () async {
      // arrange

      // act
      await sut.getNodes('a');
      // assert
      expect(sut.nodes, isNotEmpty);
      expect(sut.nodes.length, 2);
      expect(sut.nodes.first.id, 'aa');
    });
  });

  group('HomePageViewModel.updateNodePosition -', () {
    test('should throw Exception when errors with input', () {
      // assert
      expect(
          () => sut.updateNodePosition(
              'sdf', '', 'name', 'description', 3, 'iconName'),
          throwsA(matcher.TypeMatcher<Exception>()));
    });

    test('should update node successfully and return node with id', () async {
      // act
      await sut.updateNodePosition(
          'aa', 'bb', 'name', 'description', 2, 'iconName');
      // assert
      expect(sut.node, isNotNull);
      expect(sut.node.id, isNotNull);
    });
  });
}
