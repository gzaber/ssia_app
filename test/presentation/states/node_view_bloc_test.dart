// @dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/states/node_view_page/node_view_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/node_view_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NodeViewBloc sut;
  NodeViewViewModel viewModel;
  IGetNodesByParentIdUseCase getNodesByParentIdUseCase;

  setUp(() {
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: FakeNodeRepository());
    viewModel =
        NodeViewViewModel(getNodesByParentIdUseCase: getNodesByParentIdUseCase);
    sut = NodeViewBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('NodeViewBloc -', () {
    test('should emits state: NodeViewInitial when initial state', () {
      expect(sut.state, NodeViewInitial());
    });

    blocTest(
      'should emits states [NodeViewLoading, NodeViewLoaded] when success',
      build: () => sut,
      act: (bloc) => bloc.add(GetTreeView(id: 'aa')),
      expect: () => [
        NodeViewLoading(),
        NodeViewLoaded(listOfTreeNodes: viewModel.listOfTreeNodes),
      ],
    );

    blocTest(
      'should emits states [NodeViewLoading, NodeViewError] on failure',
      build: () => sut,
      act: (bloc) => bloc.add(GetTreeView(id: '')),
      expect: () => [
        NodeViewLoading(),
        NodeViewError(errMessage: 'error message'),
      ],
    );
  });
}
