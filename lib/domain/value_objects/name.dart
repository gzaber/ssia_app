import 'package:ssia_app/domain/core/failure.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Name extends Equatable {
  final String value;

  Name._(this.value);

  static Either<Failure, Name> create(String value) {
    if (value.trim().isEmpty)
      return Left(Failure('Name cannot be empty'));
    else
      return Right(Name._(value));
  }

  @override
  List<Object?> get props => [value];
}
