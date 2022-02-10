// @dart=2.9

import 'package:ssia_app/application/boundaries/get_node/get_node_input.dart';
import 'package:ssia_app/application/usecases/get_node_usecase.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GetNodeUseCase sut;
  EntityFactory entityFactory;
  FakeNodeRepository fakeNodeRepository;

  setUp(() {
    entityFactory = EntityFactory();
    fakeNodeRepository = FakeNodeRepository();
    sut = GetNodeUseCase(nodeRepository: fakeNodeRepository, entityFactory: entityFactory);
  });

  group('GetNodeUseCase -', () {
    test('should return node if exists', () async {
      // arrange
      var input = GetNodeInput(nodeId: Identity.fromString('a'));
      // act
      var result = await sut.execute(input);
      // assert
      expect(result.getOrElse(null).name, isNotNull);
      expect(result.getOrElse(null).name.value, 'F2F');
    });

    test('should return empty node', () async {
      // arrange
      var input = GetNodeInput(nodeId: Identity.fromString('lol'));
      // act
      var result = await sut.execute(input);
      // assert
      expect(result.getOrElse(null).name, isNotNull);
      expect(result.getOrElse(null).name.value, 'empty');
      expect(result.getOrElse(null).id.id, 'empty');
    });
  });
}
