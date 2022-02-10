// @dart=2.9

import 'package:ssia_app/application/usecases/get_all_roots_usecase.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNodeRepository extends Mock implements INodeRepository {}

void main() {
  GetAllRootsUseCase sut;
  MockNodeRepository mockNodeRepository;

  setUp(() {
    mockNodeRepository = MockNodeRepository();
    sut = GetAllRootsUseCase(nodeRepository: mockNodeRepository);
  });

  group('GetAllRootsUseCase -', () {
    test('should return an empty list when no roots are found', () async {
      // arrange
      when(mockNodeRepository.findRoots()).thenAnswer((_) async => []);
      // act
      var result = await sut.execute();
      // assert
      expect(result.roots, isEmpty);
    });

    test('should return list of roots', () async {
      // arrange
      var root = Node(
        id: Identity.fromString('aa'),
        parentId: Identity.fromString('none'),
        name: Name.create('Root name').getOrElse(null),
        description:
            desc.Description.create('Root description').getOrElse(null),
        position: Position.create(4).getOrElse(() => null),
        iconName: IconName.create('icon_name').getOrElse(null),
      );

      var roots = [root];
      when(mockNodeRepository.findRoots()).thenAnswer((_) async => roots);
      // act
      var result = await sut.execute();
      // assert
      expect(result.roots, isNotEmpty);
      expect(result.roots.first.parentId.id, 'none');
      verify(mockNodeRepository.findRoots());
    });
  });
}
