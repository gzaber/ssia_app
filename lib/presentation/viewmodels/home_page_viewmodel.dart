import 'package:ssia_app/application/boundaries/get_all_roots/i_get_all_roots_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';

class HomePageViewModel {
  final IGetAllRootsUseCase _getAllRootsUseCase;
  final IUpdateNodeUseCase _updateNodeUseCase;

  List<Node> _roots = [];
  List<String> _errMessages = [];

  Node _root = Node.empty();

  List<Node> get roots => _roots;
  Node get root => _root;

  HomePageViewModel(
      {required IGetAllRootsUseCase getAllRootsUseCase,
      required IUpdateNodeUseCase updateNodeUseCase})
      : _getAllRootsUseCase = getAllRootsUseCase,
        _updateNodeUseCase = updateNodeUseCase;

  Future<void> getRoots() async {
    _roots = [];
    _errMessages = [];
    
    var result = await _getAllRootsUseCase.execute();

    if (result.roots.isEmpty) return;

    result.roots.forEach((rootDto) {
      Node root = Node(
        id: rootDto.id.id,
        parentId: rootDto.parentId.id,
        name: rootDto.name.value,
        description: rootDto.description.value,
        position: rootDto.position.value,
        iconName: rootDto.iconName.value,
      );
      _roots.add(root);
    });
  }

  Future<void> updateNodePosition(String parentId, String id, String name,
      String description, int position, String iconName) async {
    _errMessages = [];

    var verParentId;
    if (parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(parentId);
    }

    var verId;
    if (id == '') {
      _errMessages.add('Id cannot be empty');
    } else {
      verId = Identity.fromString(id);
    }

    Name verName = Name.create(name).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Description verDescription = Description.create(description).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    Position verPosition = Position.create(position).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    IconName verIconName = IconName.create(iconName).fold((err) {
      _errMessages.add(err.message);
      return null;
    }, (val) => val);

    if (_errMessages.isNotEmpty) throw Exception(_errMessages.join('\n'));

    var input = UpdateNodeInput(
      parentId: verParentId,
      id: verId,
      name: verName,
      description: verDescription,
      position: verPosition,
      iconName: verIconName,
    );

    var result = await _updateNodeUseCase.execute(input);

    result.fold(
      (e) => throw Exception(e.message),
      (o) => _root = Node(
        id: o.id.id,
        parentId: o.parentId.id,
        name: o.name.value,
        description: o.name.value,
        position: o.position.value,
        iconName: o.iconName.value,
      ),
    );
  }
}
