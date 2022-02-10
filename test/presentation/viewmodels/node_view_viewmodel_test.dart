// @dart=2.9

import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/viewmodels/node_view_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NodeViewViewModel sut;
  GetNodesByParentIdUseCase getNodesByParentIdUseCase;
  FakeNodeRepository fakeNodeRepository;

  setUp(() {
    fakeNodeRepository = FakeNodeRepository();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: fakeNodeRepository);
    sut =
        NodeViewViewModel(getNodesByParentIdUseCase: getNodesByParentIdUseCase);
  });

  group('NodeDetailsViewModel.getTreeView -', () {
    test('should return empty list of tree nodes when no nodes in storage',
        () async {
      // arrange
      // act
      await sut.getTreeView('xyz', 0);

      // assert
      expect(sut.listOfTreeNodes.length, 0);
      expect(sut.listOfTreeNodes, isEmpty);
    });

    test('should return list of tree nodes from storage', () async {
      // arrange
      // act
      await sut.getTreeView('a', 0);
      //sut.getListOfMaps();

      // assert
      expect(sut.listOfTreeNodes, isNotEmpty);
      expect(sut.listOfTreeNodes.length, greaterThan(0));
    });
  });
}
