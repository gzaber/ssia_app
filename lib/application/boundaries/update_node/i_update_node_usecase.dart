import 'package:ssia_app/application/boundaries/i_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_output.dart';

abstract class IUpdateNodeUseCase
    extends IUseCase<UpdateNodeInput, UpdateNodeOutput> {}
