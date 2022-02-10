import 'package:ssia_app/domain/core/failure.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class IconName extends Equatable {
  final String value;

  IconName._(this.value);

  static Either<Failure, IconName> create(String value) {
    if (value.trim().isEmpty)
      return Left(Failure('Icon name cannot be empty'));
    else
      return Right(IconName._(value));
  }

  @override
  List<Object?> get props => [value];
}
