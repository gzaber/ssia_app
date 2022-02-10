// @dart=2.9

import 'dart:io';

import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/viewmodels/export_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  ExportNodeViewModel sut;
  GetNodesByParentIdUseCase getNodesByParentIdUseCase;
  FakeNodeRepository fakeNodeRepository;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: fakeNodeRepository);
    sut = ExportNodeViewModel(
        getNodesByParentIdUseCase: getNodesByParentIdUseCase);
  });

  group('ExportNodeViewModel.getTree -', () {
    test('should return empty list of nodes when no such id', () async {
      // arrange
      // act
      await sut.getNodeList('xyz');
      // assert
      expect(sut.nodes.length, 0);
      expect(sut.nodes, isEmpty);
    });

    test('should return list of nodes from storage', () async {
      // arrange
      // act
      await sut.getNodeList('ab');
      //sut.printNodes();
      // assert
      expect(sut.nodes.length, greaterThan(0));
      expect(sut.nodes, isNotEmpty);
    });
  });

  group('ExportNodeViewModel.saveFile -', () {
    test('should return a file if successfull saved', () async {
      // act
      var file = await sut.saveFile(
          Node(
            id: 'zx',
            parentId: 'none',
            name: 'name',
            description: 'description',
            position: 0,
            iconName: 'icon',
          ),
          Directory.current.path,
          'fileName');
      // assert
      expect(file, isNotNull);
      expect(file.path, isNotEmpty);
      expect(await file.exists(), isTrue);
    });

    test('should throw exception when path or file name empty', () async {
      expect(
          () => sut.saveFile(
              Node(
                id: 'zx',
                parentId: 'none',
                name: 'name',
                description: 'description',
                position: 0,
                iconName: 'icon',
              ),
             '',
              'sff'),
          throwsA(matcher.TypeMatcher<Exception>()));
    });
  });
}
