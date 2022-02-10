// @dart=2.9
import 'package:ssia_app/application/usecases/get_all_roots_usecase.dart';
import 'package:ssia_app/application/usecases/update_node_usecase.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:ssia_app/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  HomePageViewModel sut;
  GetAllRootsUseCase getAllRootsUseCase;
  UpdateNodeUseCase updateNodeUseCase;
  FakeNodeRepository fakeRootRepository;
  EntityFactory entityFactory;

  setUp(() {
    fakeRootRepository = FakeNodeRepository();
    entityFactory = EntityFactory();
    getAllRootsUseCase = GetAllRootsUseCase(nodeRepository: fakeRootRepository);
    updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: fakeRootRepository, entityFactory: entityFactory);

    sut = HomePageViewModel(
        getAllRootsUseCase: getAllRootsUseCase,
        updateNodeUseCase: updateNodeUseCase);
  });

  group('HomePageViewModel.getRoots -', () {
    test('should return empty list of roots when no roots in storage',
        () async {
      // arrange
      fakeRootRepository.nodes = [];
      // act
      await sut.getRoots();
      // assert
      expect(sut.roots.length, 0);
      expect(sut.roots, isEmpty);
    });

    test('should return roots from storage', () async {
      // arrange

      // act
      await sut.getRoots();
      // assert
      expect(sut.roots, isNotEmpty);
      expect(sut.roots.length, 3);
      expect(sut.roots.first.id, 'a');
      expect(sut.roots.last.id, 'c');
    });
  });

  group('HomePageViewModel.updateNodePosition -', () {
    test('should throw Exception when errors with input', () {
      // assert
      expect(() => sut.updateNodePosition('sdf', '', 'name', 'description', 3, 'iconName'),
          throwsA(matcher.TypeMatcher<Exception>()));
    });

    test('should update node successfully and return node with id', () async {
      // act
      await sut.updateNodePosition('aa', 'bb', 'name', 'description', 2, 'iconName');
      // assert
      expect(sut.root, isNotNull);
      expect(sut.root.id, isNotNull);
    });
  });
}
