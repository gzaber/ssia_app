import 'package:ssia_app/domain/core/failure.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int value;

  Position._(this.value);

  static Either<Failure, Position> create(int value) {
    if (value.isNegative)
      return Left(Failure('Position cannot be negative'));
    else
      return Right(Position._(value));
  }

  @override
  List<Object?> get props => [value];
}
