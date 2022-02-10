import 'package:ssia_app/application/boundaries/delete_node/delete_node_input.dart';
import 'package:ssia_app/application/boundaries/delete_node/delete_node_output.dart';
import 'package:ssia_app/application/boundaries/delete_node/i_delete_node_usecase.dart';
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class DeleteNodeUseCase implements IDeleteNodeUseCase {
  final INodeRepository _nodeRepository;
  final IEntityFactory _entityFactory;

  const DeleteNodeUseCase({
    required INodeRepository nodeRepository,
    required IEntityFactory entityFactory,
  })  : _nodeRepository = nodeRepository,
        _entityFactory = entityFactory;

  @override
  Future<Either<Failure, DeleteNodeOutput>> execute(
      DeleteNodeInput input) async {
    Node deletedNode = _createNodeFromInput(input);

    await _nodeRepository.delete(nodeId: input.id);

    return _buildOutputFromDeletedNode(deletedNode);
  }

  Node _createNodeFromInput(DeleteNodeInput input) {
    return _entityFactory.editedNode(
      id: input.id,
      parentId: input.parentId,
      name: input.name,
      description: input.description,
      position: input.position,
      iconName: input.iconName,
    );
  }

  Either<Failure, DeleteNodeOutput> _buildOutputFromDeletedNode(
      Node deletedNode) {
    var output = DeleteNodeOutput(
      id: deletedNode.id,
      parentId: deletedNode.parentId,
      name: deletedNode.name,
      description: deletedNode.description,
      position: deletedNode.position,
      iconName: deletedNode.iconName,
    );

    return Right(output);
  }
}
