// @dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/states/node_page/node_page_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/node_page_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NodePageBloc sut;
  NodePageViewModel viewModel;
  IGetNodesByParentIdUseCase getNodesByParentIdUseCase;
  IUpdateNodeUseCase updateNodeUseCase;
  EntityFactory entityFactory;

  setUp(() {
    entityFactory = EntityFactory();
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: FakeNodeRepository());
    updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: FakeNodeRepository(), entityFactory: entityFactory);
    viewModel = NodePageViewModel(
        getNodesByParentIdUseCase: getNodesByParentIdUseCase,
        updateNodeUseCase: updateNodeUseCase);
    sut = NodePageBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('NodePageBloc -', () {
    blocTest(
      'should emits [] when nothing is added',
      build: () => sut,
      expect: () => [],
    );

    test('should emits state: NodePageInitial when initial state', () {
      expect(sut.state, NodePageInitial());
    });

    blocTest(
      'should emits states [NodePageLoading, NodePageLoaded] when success',
      build: () => sut,
      act: (bloc) => bloc.add(GetNodes(parentId: 'parId')),
      expect: () => [
        NodePageLoading(),
        NodePageLoaded(nodes: viewModel.nodes),
      ],
    );

    blocTest(
      'should emits states [NodePageUpdating, NodePageUpdated] when successfull updated node position',
      build: () => sut,
      act: (bloc) => bloc.add(UpdateNodePosition(
        parentId: 'aa',
        id: 'id',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        NodePageUpdating(),
        NodePageUpdated(node: viewModel.node),
      ],
    );

    blocTest(
      'should emits states [HomePageUpdating, HomePageError] on updating node position failure',
      build: () {
        return sut;
      },
      act: (bloc) => bloc.add(UpdateNodePosition(
        parentId: 'dsf',
        id: '',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        NodePageUpdating(),
        NodePageError(errMessage: 'error message'),
      ],
    );
  });
}
