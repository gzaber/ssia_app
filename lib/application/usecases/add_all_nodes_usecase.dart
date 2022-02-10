import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_output.dart';
import 'package:ssia_app/application/boundaries/add_all_nodes/add_all_nodes_input.dart';
import 'package:ssia_app/application/boundaries/add_all_nodes/i_add_all_nodes_usecase.dart';
import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:ssia_app/domain/core/failure.dart';

class AddAllNodesUseCase implements IAddAllNodesUseCase {
  final INodeRepository _nodeRepository;
  final IEntityFactory _entityFactory;

  AddAllNodesUseCase(
      {required INodeRepository nodeRepository,
      required IEntityFactory entityFactory})
      : _nodeRepository = nodeRepository,
        _entityFactory = entityFactory;

  @override
  Future<Either<Failure, List<AddAllNodesOutput>>> execute(
      List<AddAllNodesInput> nodesInput) async {
    List<Node> importedNodes = [];

    nodesInput.forEach((inputItem) {
      importedNodes.add(_createNodeFromInput(inputItem));
    });

    for (Node importedNode in importedNodes) {
      await _nodeRepository.add(node: importedNode);
    }

    return _buildOutputFromImportedNodes(importedNodes);
  }

  Node _createNodeFromInput(AddAllNodesInput input) {
    return _entityFactory.editedNode(
      id: input.id,
      parentId: input.parentId,
      name: input.name,
      description: input.description,
      position: input.position,
      iconName: input.iconName,
    );
  }

  Either<Failure, List<AddAllNodesOutput>> _buildOutputFromImportedNodes(
      List<Node> importedNodes) {
    List<AddAllNodesOutput> outputList = [];

    importedNodes.forEach((importedNode) {
      outputList.add(AddAllNodesOutput(
        id: importedNode.id,
        parentId: importedNode.parentId,
        name: importedNode.name,
        description: importedNode.description,
        position: importedNode.position,
        iconName: importedNode.iconName,
      ));
    });

    return Right(outputList);
  }
}
