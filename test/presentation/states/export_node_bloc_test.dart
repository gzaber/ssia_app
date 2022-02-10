// @dart=2.9

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/usecases/get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/export_node_page/export_node_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/viewmodels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ExportNodeBloc sut;
  ExportNodeViewModel viewModel;
  IGetNodesByParentIdUseCase getNodesByParentIdUseCase;

  setUp(() {
    getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: FakeNodeRepository());
    viewModel = ExportNodeViewModel(
        getNodesByParentIdUseCase: getNodesByParentIdUseCase);
    sut = ExportNodeBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('ExportNodeBloc -', () {
    test('should emits state: ExportNodeInitial when initial state', () {
      expect(sut.state, ExportNodeInitial());
    });

    blocTest(
      'should emits states [ExportNodeLoading, ExportNodeLoaded] when success',
      build: () => sut,
      act: (bloc) => bloc.add(GetNodeList(id: 'aa')),
      expect: () => [
        ExportNodeLoading(),
        ExportNodeLoaded(nodes: viewModel.nodes),
      ],
    );

    blocTest(
      'should emits states [ExportNodeLoading, ExportNodeError] on failure',
      build: () => sut,
      act: (bloc) => bloc.add(GetNodeList(id: '')),
      expect: () => [
        ExportNodeLoading(),
        ExportNodeError(errMessage: 'error message'),
      ],
    );

    blocTest(
      'should emits states [ExportNodeSaving, ExportNodeSaved] when success',
      build: () => sut,
      act: (bloc) => bloc.add(
        ExportNodes(
            root: Node(
              id: 'zx',
              parentId: 'none',
              name: 'name',
              description: 'description',
              position: 0,
              iconName: 'icon',
            ),
            path: Directory.current.path,
            fileName: 'fileName'),
        expect: () => [
          ExportNodeSaving(),
          ExportNodeSaved(fileName: 'fileName'),
        ],
      ),
    );

    blocTest(
      'should emits states [ExportNodeSaving, ExportNodeError] when success',
      build: () => sut,
      act: (bloc) => bloc.add(
        ExportNodes(
            root: Node(
              id: 'zx',
              parentId: 'none',
              name: 'name',
              description: 'description',
              position: 0,
              iconName: 'icon',
            ),
            path: '',
            fileName: 'file name'),
        expect: () => [
          ExportNodeSaving(),
          ExportNodeError(errMessage: 'errMessage'),
        ],
      ),
    );
  });
}
