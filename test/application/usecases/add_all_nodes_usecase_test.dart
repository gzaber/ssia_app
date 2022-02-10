// @dart=2.9

import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_input.dart';
import 'package:ssia_app/application/usecases/add_all_nodes_usecase.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/infrastructure/repositories/fakes/fake_node_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AddAllNodesUseCase sut;
  IEntityFactory entityFactory;
  INodeRepository nodeRepository;

  setUp(() {
    entityFactory = EntityFactory();
    nodeRepository = FakeNodeRepository();
    sut = AddAllNodesUseCase(
        entityFactory: entityFactory, nodeRepository: nodeRepository);
  });

  var nodeInput1 = AddAllNodesInput(
    id: Identity.fromString('uu'),
    parentId: Identity.fromString('uuu'),
    name: Name.create('uu_name').getOrElse(null),
    description: desc.Description.create('uu_description').getOrElse(null),
    position: Position.create(0).getOrElse(null),
    iconName: IconName.create('uu_icon_name').getOrElse(null),
  );

  var nodeInput2 = AddAllNodesInput(
    id: Identity.fromString('vv'),
    parentId: Identity.fromString('vvv'),
    name: Name.create('vv_name').getOrElse(null),
    description: desc.Description.create('vv_description').getOrElse(null),
    position: Position.create(0).getOrElse(null),
    iconName: IconName.create('vv_icon_name').getOrElse(null),
  );

  group('AddAllNodesUseCase -', () {
    test('should add list of nodes', () async {
      // arrange
      List<AddAllNodesInput> nodesInput = [nodeInput1, nodeInput2];
      // act
      var result = await sut.execute(nodesInput);
      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse(null).length, 2);
      expect(result.getOrElse(null).first.id.id, 'uu');
      expect(result.getOrElse(null).last.id.id, 'vv');
    });
  });
}
