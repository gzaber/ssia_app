// @dart=2.9

import 'package:ssia_app/application/usecases/add_node_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/viewmodels/manage_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  ManageNodeViewModel sut;
  AddNodeUseCase addNodeUseCase;
  UpdateNodeUseCase updateNodeUseCase;
  FakeNodeRepository fakeNodeRepository;
  EntityFactory entityFactory;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    addNodeUseCase = AddNodeUseCase(
        nodeRepository: fakeNodeRepository, entityFactory: entityFactory);

    updateNodeUseCase = UpdateNodeUseCase(nodeRepository: fakeNodeRepository, entityFactory: entityFactory);

    sut = ManageNodeViewModel(addNodeUseCase: addNodeUseCase, updateNodeUseCase: updateNodeUseCase);
  });

  group('ManageNodeViewModel.addNode -', () {
    test('should throw Exception when errors with input', () {
      // assert
      expect(() => sut.addNode('', 'name', 'description', 3, 'iconName'),
          throwsA(matcher.TypeMatcher<Exception>()));
    });

    test('should add node successfully and return node with id', () async {
      // act
      await sut.addNode('aa', 'name', 'description', 2, 'iconName');
      // assert
      expect(sut.node, isNotNull);
      expect(sut.node.id, isNotNull);
    });
  });

  group('ManageNodeViewModel.updateNode -', () {
    test('should throw Exception when errors with input', () {
      // assert
      expect(() => sut.updateNode('sdf', '', 'name', 'description', 3, 'iconName'),
          throwsA(matcher.TypeMatcher<Exception>()));
    });

    test('should update node successfully and return node with id', () async {
      // act
      await sut.updateNode('aa', 'bb', 'name', 'description', 2, 'iconName');
      // assert
      expect(sut.node, isNotNull);
      expect(sut.node.id, isNotNull);
    });
  });
}
