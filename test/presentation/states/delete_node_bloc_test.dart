// @dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:ssia_app/application/boundaries/delete_node/i_delete_node_usecase.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/usecases/delete_node_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/delete_node_page/delete_node_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/delete_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DeleteNodeBloc sut;
  DeleteNodeViewModel viewModel;
  IDeleteNodeUseCase deleteNodeUseCase;
  IGetNodesByParentIdUseCase getNodesByParentIdUseCase;
  IEntityFactory entityFactory;

  setUp(() {
    entityFactory = EntityFactory();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: FakeNodeRepository());
    deleteNodeUseCase = DeleteNodeUseCase(
        nodeRepository: FakeNodeRepository(), entityFactory: entityFactory);
    viewModel = DeleteNodeViewModel(
        deleteNodeUseCase: deleteNodeUseCase,
        getNodesByParentIdUseCase: getNodesByParentIdUseCase);
    sut = DeleteNodeBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('DeleteNodeBloc -', () {
    test('should emits state: DeleteNodeInitial when initial state', () {
      expect(sut.state, DeleteNodeInitial());
    });

    blocTest(
      'should emits states [DeleteNodeDeleting, DeleteNodeDeleted] when success',
      build: () => sut,
      act: (bloc) => bloc.add(
        DeleteNode(
          node: Node(
            id: 'aa',
            parentId: 'bb',
            name: 'name',
            description: 'desc',
            position: 2,
            iconName: 'icon',
          ),
        ),
      ),
      expect: () => [
        DeleteNodeDeleting(),
        DeleteNodeDeleted(node: viewModel.node),
      ],
    );

    blocTest(
      'should emits states [DeleteNodeDeleting, DeleteNodeError] on failure',
      build: () => sut,
      act: (bloc) => bloc.add(
        DeleteNode(
          node: Node(
            id: '',
            parentId: 'aa',
            name: 'name',
            description: 'desc',
            position: 2,
            iconName: 'icon',
          ),
        ),
      ),
      expect: () => [
        DeleteNodeDeleting(),
        DeleteNodeError(errMessage: 'error message'),
      ],
    );
  });
}
