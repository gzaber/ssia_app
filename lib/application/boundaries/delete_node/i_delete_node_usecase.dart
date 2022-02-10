import 'package:ssia_app/application/boundaries/delete_node/delete_node_input.dart';
import 'package:ssia_app/application/boundaries/delete_node/delete_node_output.dart';
import 'package:ssia_app/application/boundaries/i_usecase.dart';

abstract class IDeleteNodeUseCase
    extends IUseCase<DeleteNodeInput, DeleteNodeOutput> {}
