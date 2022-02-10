// @dart=2.9
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/value_objects/position.dart';
import 'package:matcher/matcher.dart' as matcher;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Position -', () {
    test('should return Failure when value is negative', () {
      // arrange
      var position = Position.create(-5).fold((err) => err, (obj) => obj);
      // act

      // assert
      expect(position, matcher.TypeMatcher<Failure>());
    });

    test('should create position when value is not negative', () {
      // arrange
      var pos = 4;
      var position = Position.create(pos).getOrElse(null);
      // act

      // assert
      expect(position.value, pos);
    });
  });
}
