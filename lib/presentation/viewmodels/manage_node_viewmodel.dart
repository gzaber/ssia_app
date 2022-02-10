import 'package:ssia_app/application/boundaries/add_node/add_node_input.dart';
import 'package:ssia_app/application/boundaries/add_node/i_add_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/update_node_input.dart';
import 'package:ssia_app/domain/value_objects/value_objects.dart';
import 'package:ssia_app/presentation/models/node.dart';

class ManageNodeViewModel {
  final IAddNodeUseCase _addNodeUseCase;
  final IUpdateNodeUseCase _updateNodeUseCase;

  List<String> _errMessages = [];
  Node _node = Node.empty();

  Node get node => _node;

  ManageNodeViewModel(
      {required IAddNodeUseCase addNodeUseCase,
      required IUpdateNodeUseCase updateNodeUseCase})
      : _addNodeUseCase = addNodeUseCase,
        _updateNodeUseCase = updateNodeUseCase;

  Future<void> addNode(String parentId, String name, String description,
      int position, String iconName) async {
    _errMessages = [];

    var verParentId;

    if (parentId == '') {
      _errMessages.add('Parent id cannot be empty');
    } else {
      verParentId = Identity.fromString(parentId);
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

    var input = AddNodeInput(
      parentId: verParentId,
      name: verName,
      description: verDescription,
      position: verPosition,
      iconName: verIconName,
    );

    var result = await _addNodeUseCase.execute(input);

    result.fold(
      (e) => throw Exception(e.message),
      (o) => _node = Node(
        id: o.id.id,
        parentId: o.parentId.id,
        name: o.name.value,
        description: o.name.value,
        position: o.position.value,
        iconName: o.iconName.value,
      ),
    );
  }

  Future<void> updateNode(String parentId, String id, String name,
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
      (o) => _node = Node(
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
