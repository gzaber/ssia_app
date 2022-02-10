import 'dart:collection';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_input.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/get_nodes_by_parent_id_output.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/boundaries/node_dto.dart';
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class GetNodesByParentIdUseCase implements IGetNodesByParentIdUseCase {
  final INodeRepository _nodeRepository;

  GetNodesByParentIdUseCase({required INodeRepository nodeRepository})
      : _nodeRepository = nodeRepository;

  @override
  Future<Either<Failure, GetNodesByParentIdOutput>> execute(
      GetNodesByParentIdInput input) async {
    var nodes = await _nodeRepository.findByParentId(nodeId: input.nodeId);

    List<NodeDto> output =
        nodes.map((node) => NodeDto.fromEntity(node)).toList();

    return Right(GetNodesByParentIdOutput(nodes: UnmodifiableListView(output)));
  }
}
