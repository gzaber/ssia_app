import 'package:ssia_app/application/boundaries/get_node/get_node_output.dart';
import 'package:ssia_app/application/boundaries/get_node/get_node_input.dart';
import 'package:ssia_app/application/boundaries/get_node/i_get_node_usecase.dart';
import 'package:ssia_app/application/boundaries/node_dto.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:ssia_app/domain/core/failure.dart';

class GetNodeUseCase implements IGetNodeUseCase {
  final INodeRepository _nodeRepository;
  final IEntityFactory _entityFactory;

  GetNodeUseCase(
      {required INodeRepository nodeRepository,
      required IEntityFactory entityFactory})
      : _nodeRepository = nodeRepository,
        _entityFactory = entityFactory;

  @override
  Future<Either<Failure, GetNodeOutput>> execute(GetNodeInput input) async {
    var node = await _nodeRepository.findById(nodeId: input.nodeId);

    NodeDto output = NodeDto.fromEntity(
      node.fold(
        () => _entityFactory.emptyNode(),
        (result) => result,
      ),
    );

    return Right(
      GetNodeOutput(
        id: output.id,
        parentId: output.parentId,
        name: output.name,
        description: output.description,
        position: output.position,
        iconName: output.iconName,
      ),
    );
  }
}
