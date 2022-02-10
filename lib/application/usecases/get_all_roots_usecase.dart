import 'dart:collection';

import 'package:ssia_app/application/boundaries/get_all_roots/get_all_roots_output.dart';
import 'package:ssia_app/application/boundaries/get_all_roots/i_get_all_roots_usecase.dart';
import 'package:ssia_app/application/boundaries/node_dto.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';


class GetAllRootsUseCase implements IGetAllRootsUseCase {
  final INodeRepository _nodeRepository;

  GetAllRootsUseCase({required INodeRepository nodeRepository})
      : _nodeRepository = nodeRepository;

  @override
  Future<GetAllRootsOutput> execute() async {
    var roots = await _nodeRepository.findRoots();

    List<NodeDto> output =
        roots.map((root) => NodeDto.fromEntity(root)).toList();

    return GetAllRootsOutput(roots: UnmodifiableListView(output));
  }
}
