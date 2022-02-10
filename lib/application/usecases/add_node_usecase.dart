import 'package:ssia_app/application/boundaries/add_node/add_node_input.dart';
import 'package:ssia_app/application/boundaries/add_node/add_node_output.dart';
import 'package:ssia_app/application/boundaries/add_node/i_add_node_usecase.dart';
import 'package:ssia_app/domain/core/failure.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class AddNodeUseCase implements IAddNodeUseCase {
  final INodeRepository _nodeRepository;
  final IEntityFactory _entityFactory;

  AddNodeUseCase({
    required INodeRepository nodeRepository,
    required IEntityFactory entityFactory,
  })  : _nodeRepository = nodeRepository,
        _entityFactory = entityFactory;

  @override
  Future<Either<Failure, AddNodeOutput>> execute(AddNodeInput input) async {
    Node newNode = _createNodeFromInput(input);

    await _nodeRepository.add(node: newNode);

    return _buildOutputFromNewNode(newNode);
  }

  Node _createNodeFromInput(AddNodeInput input) {
    return _entityFactory.newNode(
      parentId: input.parentId,
      name: input.name,
      description: input.description,
      position: input.position,
      iconName: input.iconName,
    );
  }

  Either<Failure, AddNodeOutput> _buildOutputFromNewNode(Node newNode) {
    var output = AddNodeOutput(
      id: newNode.id,
      parentId: newNode.parentId,
      name: newNode.name,
      description: newNode.description,
      position: newNode.position,
      iconName: newNode.iconName,
    );

    return Right(output);
  }
}
