import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_output.dart';
import 'package:ssia_app/application/boundaries/i_usecase.dart';

abstract class IGetNodesByParentIdUseCase
    extends IUseCase<GetNodesByParentIdInput, GetNodesByParentIdOutput> {}
