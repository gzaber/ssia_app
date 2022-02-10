// @dart=2.9
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/value_objects/icon_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {

  group('IconName -', () {
    test('should return Failure when value is empty', () {
      // arrange
      var iconName = IconName.create('').fold((err) => err, (obj) => obj);
      // act

      // assert
      expect(iconName, matcher.TypeMatcher<Failure>());
    });

    test('should create icon name when value is not empty', () {
      // arrange
      var str = 'icon_name';
      var iconName = IconName.create(str).getOrElse(null);

      // act

      // assert
      expect(iconName.value, str);
    });
  });
}
