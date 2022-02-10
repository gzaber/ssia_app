import 'package:ssia_app/application/boundaries/get_all_roots/get_all_roots_output.dart';

abstract class IGetAllRootsUseCase {
  Future<GetAllRootsOutput> execute();
}
