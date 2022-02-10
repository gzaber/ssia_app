import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_input.dart';
import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_output.dart';
import 'package:ssia_app/application/boundaries/i_usecase.dart';

abstract class IAddAllNodesUseCase extends IUseCase<List<AddAllNodesInput>, List<AddAllNodesOutput>> {}