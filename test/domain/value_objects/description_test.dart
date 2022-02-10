// @dart=2.9
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/value_objects/description.dart' as desc;
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  
  group('Description -', () {
    test('should return Failure when value is empty', () {
      // arrange
      var description =
          desc.Description.create('').fold((err) => err, (obj) => obj);
      // act

      // assert
      expect(description, matcher.TypeMatcher<Failure>());
    });

    test('should create description when value is not empty', () {
      // arrange
      var str = 'Some description';
      var description = desc.Description.create(str).getOrElse(null);
      // act

      // assert
      expect(description.value, str);
    });
  });
}
