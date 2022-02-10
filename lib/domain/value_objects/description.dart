import 'package:ssia_app/domain/core/failure.dart';
//ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Description extends Equatable {
  final String value;

  Description._(this.value);

  static Either<Failure, Description> create(String value) {
    if (value.trim().isEmpty)
      return Left(Failure('Description cannot be empty'));
    else
      return Right(Description._(value));
  }

  @override
  List<Object?> get props => [value];
}
