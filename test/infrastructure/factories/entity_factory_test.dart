// @dart=2.9

import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EntityFactory sut;

  setUp(() {
    sut = EntityFactory();
  });

  group('EntityFactory -', () {
    var id = Identity.fromString('aa');
    var parentId = Identity.fromString('bb');
    var name = Name.create('name').getOrElse(null);
    var description =
        desc.Description.create('description').getOrElse(null);
    var position = Position.create(2).getOrElse(null);
    var iconName = IconName.create('icon_name').getOrElse(null);

    test('should create new node from provided information', () {
      // arrange

      // act
      var node = sut.newNode(
        parentId: parentId,
        name: name,
        description: description,
        position: position,
        iconName: iconName,
      );
      // assert
      expect(node.id, isNotNull);
      expect(node.name, name);
    });

    test('should create edited node from provided information', () {
      // arrange

      // act
      var node = sut.editedNode(
        id: id,
        parentId: parentId,
        name: name,
        description: description,
        position: position,
        iconName: iconName,
      );
      // assert
      expect(node.id, id);
      expect(node.name, name);
    });

    test('should create empty node', () {
      // arrange

      // act
      var node = sut.emptyNode();
      // assert
      expect(node.id.id, 'empty');
      expect(node.name.value, 'empty');
      expect(node.position.value, 0);
    });
  });
}
