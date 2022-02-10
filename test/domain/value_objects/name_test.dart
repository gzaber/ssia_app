// @dart=2.9
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/value_objects/name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  group('Name -', () {
    test('should return Failure when value is empty', () {
      // arrange
      var name = Name.create('').fold((err) => err, (obj) => obj);
      // act

      // assert
      expect(name, matcher.TypeMatcher<Failure>());
    });

    test('should create name when value is not empty', () {
      // arrange
      var str = 'Face2Face';
      var name = Name.create(str).getOrElse(null);
      // act

      // assert
      expect(name.value, str);
    });
  });
}
