// @dart=2.9

import 'package:ssia_app/application/boundaries/add_node/i_add_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/usecases/add_node_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/states/manage_node_page/manage_node_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/manage_node_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  ManageNodeBloc sut;
  ManageNodeViewModel viewModel;
  IAddNodeUseCase addNodeUseCase;
  IUpdateNodeUseCase updateNodeUseCase;
  IEntityFactory entityFactory;

  setUp(() {
    entityFactory = EntityFactory();
    addNodeUseCase = AddNodeUseCase(
        nodeRepository: FakeNodeRepository(), entityFactory: entityFactory);
    updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: FakeNodeRepository(), entityFactory: entityFactory);
    viewModel = ManageNodeViewModel(
        addNodeUseCase: addNodeUseCase, updateNodeUseCase: updateNodeUseCase);
    sut = ManageNodeBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('ManageNodeBloc -', () {
    test('should emits state: ManageNodeInitial when initial state', () {
      expect(sut.state, ManageNodeInitial());
    });

    blocTest(
      'should emits states [ManageNodeAdding, ManageNodeAdded] when success',
      build: () => sut,
      act: (bloc) => bloc.add(AddNode(
        parentId: 'root',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        ManageNodeAdding(),
        ManageNodeAdded(node: viewModel.node),
      ],
    );

    blocTest(
      'should emits states [ManageNodeAdding, ManageNodeError] on failure',
      build: () {
        return sut;
      },
      act: (bloc) => bloc.add(AddNode(
        parentId: '',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        ManageNodeAdding(),
        ManageNodeError(errMessage: 'error message'),
      ],
    );

    blocTest(
      'should emits states [ManageNodeUpdating, ManageNodeUpdated] when success',
      build: () => sut,
      act: (bloc) => bloc.add(UpdateNode(
        parentId: 'root',
        id: 'id',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        ManageNodeUpdating(),
        ManageNodeUpdated(node: viewModel.node),
      ],
    );

    blocTest(
      'should emits states [ManageNodeUpdating, ManageNodeError] on failure',
      build: () {
        return sut;
      },
      act: (bloc) => bloc.add(UpdateNode(
        parentId: 'dsf',
        id: '',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        ManageNodeUpdating(),
        ManageNodeError(errMessage: 'error message'),
      ],
    );
  });
}
