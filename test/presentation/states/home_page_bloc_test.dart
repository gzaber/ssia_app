// @dart=2.9
import 'package:ssia_app/application/boundaries/get_all_roots/i_get_all_roots_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/usecases/get_all_roots_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/states/home_page/home_page_bloc.dart';
import 'package:ssia_app/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  HomePageBloc sut;
  HomePageViewModel viewModel;
  IGetAllRootsUseCase getAllRootsUseCase;
  IUpdateNodeUseCase updateNodeUseCase;
  EntityFactory entityFactory;

  setUp(() {
    entityFactory = EntityFactory();
    getAllRootsUseCase =
        GetAllRootsUseCase(nodeRepository: FakeNodeRepository());
    updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: FakeNodeRepository(), entityFactory: entityFactory);
    viewModel = HomePageViewModel(
        getAllRootsUseCase: getAllRootsUseCase,
        updateNodeUseCase: updateNodeUseCase);
    sut = HomePageBloc(viewModel);
  });

  tearDown(() => sut.close());

  group('HomePageBloc -', () {
    blocTest(
      'should emits [] when nothing is added',
      build: () => sut,
      expect: () => [],
    );

    test('should emits state: HomePageInitial when initial state', () {
      expect(sut.state, HomePageInitial());
    });

    blocTest(
      'should emits states [HomePageLoading, HomePageLoaded] when success',
      build: () => sut,
      act: (bloc) => bloc.add(GetRoots()),
      expect: () => [
        HomePageLoading(),
        HomePageLoaded(roots: viewModel.roots),
      ],
    );

    blocTest(
      'should emits states [HomePageUpdating, HomePageUpdated] when successfull updated node position',
      build: () => sut,
      act: (bloc) => bloc.add(UpdateRootPosition(
        parentId: 'root',
        id: 'id',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        HomePageUpdating(),
        HomePageUpdated(root: viewModel.root),
      ],
    );

    blocTest(
      'should emits states [HomePageUpdating, HomePageError] on updating node position failure',
      build: () {
        return sut;
      },
      act: (bloc) => bloc.add(UpdateRootPosition(
        parentId: 'dsf',
        id: '',
        name: 'name',
        description: 'description',
        position: 3,
        iconName: 'icon',
      )),
      expect: () => [
        HomePageUpdating(),
        HomePageError(errMessage: 'error message'),
      ],
    );
  });
}
