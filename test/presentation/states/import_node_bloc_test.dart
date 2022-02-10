// @dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:ssia_app/application/boundaries/add_all_nodes/i_add_all_nodes_usecase.dart';
import 'package:ssia_app/application/boundaries/get_node/i_get_node_usecase.dart';
import 'package:ssia_app/application/usecases/add_all_nodes_usecase.dart';
import 'package:ssia_app/application/usecases/get_node_usecase.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/states/blocs.dart';
import 'package:ssia_app/presentation/viewmodels/import_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ImportNodeBloc sut;
  ImportNodeViewModel viewModel;
  IGetNodeUseCase getNodeUseCase;
  IAddAllNodesUseCase addAllNodesUseCase;
  INodeRepository nodeRepository;
  IEntityFactory entityFactory;

  setUp(() {
    nodeRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    getNodeUseCase = GetNodeUseCase(
        nodeRepository: nodeRepository, entityFactory: entityFactory);
    addAllNodesUseCase = AddAllNodesUseCase(
        nodeRepository: nodeRepository, entityFactory: entityFactory);
    viewModel = ImportNodeViewModel(
        getNodeUseCase: getNodeUseCase, addAllNodesUseCase: addAllNodesUseCase);
    sut = ImportNodeBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('ImportNodeBloc -', () {
    test('should emits state: ImportNodeInitial when initial state', () {
      expect(sut.state, ImportNodeInitial());
    });

    blocTest(
        'should emits stated [ImportNodeImporting, ImportNodeImported] when success',
        build: () => sut,
        act: (bloc) => bloc.add(ImportNode(
            path:
                'D:\\VSCodeProjects\\_gz_projects\\ssia_app\\test\\presentation\\viewmodels\\nodeFile.json')),
        expect: () => [
              ImportNodeImporting(),
              ImportNodeImported(rootName: viewModel.outputNodes.first.name),
            ]);

    blocTest(
      'should emits states [ImportNodeImporting, ImportNodeError] on failure',
      build: () => sut,
      act: (bloc) => bloc.add(ImportNode(path: 'lol')),
      expect: () => [
        ImportNodeImporting(),
        ImportNodeError(errMessage: 'error message'),
      ],
    );
  });
}
