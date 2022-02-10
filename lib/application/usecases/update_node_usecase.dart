import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_output.dart';
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class UpdateNodeUseCase implements IUpdateNodeUseCase {
  final INodeRepository _nodeRepository;
  final IEntityFactory _entityFactory;

  const UpdateNodeUseCase({
    required INodeRepository nodeRepository,
    required IEntityFactory entityFactory,
  })  : _nodeRepository = nodeRepository,
        _entityFactory = entityFactory;

  @override
  Future<Either<Failure, UpdateNodeOutput>> execute(
      UpdateNodeInput input) async {
    Node updatedNode = _createNodeFromInput(input);

    await _nodeRepository.update(node: updatedNode);

    return _buildOutputFromUpdatedNode(updatedNode);
  }

  Node _createNodeFromInput(UpdateNodeInput input) {
    return _entityFactory.editedNode(
      id: input.id,
      parentId: input.parentId,
      name: input.name,
      description: input.description,
      position: input.position,
      iconName: input.iconName,
    );
  }

  Either<Failure, UpdateNodeOutput> _buildOutputFromUpdatedNode(
      Node updatedNode) {
    var output = UpdateNodeOutput(
      id: updatedNode.id,
      parentId: updatedNode.parentId,
      name: updatedNode.name,
      description: updatedNode.description,
      position: updatedNode.position,
      iconName: updatedNode.iconName,
    );

    return Right(output);
  }
}
