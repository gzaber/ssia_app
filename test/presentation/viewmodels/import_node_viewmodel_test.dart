// @dart=2.9

import 'package:ssia_app/application/usecases/add_all_nodes_usecase.dart';
import 'package:ssia_app/application/usecases/get_node_usecase.dart';
import 'package:ssia_app/application/usecases/usecases.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/import_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  ImportNodeViewModel sut;
  GetNodeUseCase getNodeUseCase;
  AddAllNodesUseCase addAllNodesUseCase;
  EntityFactory entityFactory;
  FakeNodeRepository fakeNodeRepository;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    getNodeUseCase =
        GetNodeUseCase(entityFactory: entityFactory, nodeRepository: fakeNodeRepository);
    addAllNodesUseCase =
        AddAllNodesUseCase(entityFactory: entityFactory, nodeRepository: fakeNodeRepository);
    sut =
        ImportNodeViewModel(addAllNodesUseCase: addAllNodesUseCase, getNodeUseCase: getNodeUseCase);
  });

  group('ImportNodeViewModel.readFile -', () {
    test('should return failure if cannot read a file', () async {
      // arrange
      String path = 'lol';
      // act
      // assert
      expect(() => sut.readFile(path), throwsA(matcher.TypeMatcher<Exception>()));
    });

    test('should read file if it is ok', () async {
      // arrange
      String path =
          'D:\\VSCodeProjects\\_gz_projects\\ssia_app\\test\\presentation\\viewmodels\\nodeFile.json';
      // act
      await sut.readFile(path);
      // assert
      expect(sut.nodes, isNotEmpty);
      expect(sut.nodes.first.name, 'F2F');
      expect(sut.nodes.last.name, 'AFI');
    });
  });

  group('ImportNodeViewModel.addAllNodes', () {
    test('should not add any nodes if exist in repo', () async {
      // arrange
      sut.nodes.add(Node(
          id: 'a',
          parentId: 'ggg',
          name: 'gName',
          description: 'gDesc',
          position: 0,
          iconName: 'gIconName'));
      sut.nodes.add(Node(
          id: 'asdf',
          parentId: 'hhh',
          name: 'hName',
          description: 'hDesc',
          position: 0,
          iconName: 'hIconName'));
      // assert
      expect(() => sut.addAllNodes(), throwsException);
      expect(sut.outputNodes.length, 0);
    });

    test('should add all nodes', () async {
      // arrange
      sut.nodes.add(Node(
          id: 'gg',
          parentId: 'ggg',
          name: 'gName',
          description: 'gDesc',
          position: 0,
          iconName: 'gIconName'));
      sut.nodes.add(Node(
          id: 'hh',
          parentId: 'hhh',
          name: 'hName',
          description: 'hDesc',
          position: 0,
          iconName: 'hIconName'));
      // act
      await sut.addAllNodes();
      // assert
      expect(sut.outputNodes.length, 2);
      expect(sut.outputNodes.first.id, 'gg');
      expect(sut.outputNodes.last.id, 'hh');
    });
  });
}
