import 'package:ssia_app/domain/entities/node.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/domain/value_objects/identity.dart';
import 'package:ssia_app/infrastructure/models/node_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class FakeNodeRepository implements INodeRepository {
  // roots
  var map1 = {
    'node_id': 'a',
    'parent_id': 'none',
    'name': 'F2F',
    'description': 'Katowice',
    'position': 0,
    'icon_name': 'assets/images/building1.png'
  };

  var map2 = {
    'node_id': 'b',
    'parent_id': 'none',
    'name': 'AFI',
    'description': 'Kraków',
    'position': 1,
    'icon_name': 'assets/images/building2.png'
  };

  var map3 = {
    'node_id': 'c',
    'parent_id': 'none',
    'name': 'ZBP',
    'description': 'Kraków Zabłocie',
    'position': 2,
    'icon_name': 'assets/images/building3.png'
  };

  // nodes
  var map4 = {
    'node_id': 'aa',
    'parent_id': 'a',
    'name': 'Kontrola dostępu',
    'description': 'KD',
    'position': 0,
    'icon_name': 'assets/images/system1.png'
  };

  var map5 = {
    'node_id': 'aaa',
    'parent_id': 'aa',
    'name': 'SKD1',
    'description': 'mac: AD34BC22',
    'position': 0,
    'icon_name': 'assets/images/unit1.png'
  };

  var map6 = {
    'node_id': 'aab',
    'parent_id': 'aa',
    'name': 'SKD2',
    'description': 'mac: 87872AC3',
    'position': 1,
    'icon_name': 'assets/images/unit1.png'
  };

  var map7 = {
    'node_id': 'aaaa',
    'parent_id': 'aaa',
    'name': 'KD1',
    'description': 'neuron id: 2394767',
    'position': 0,
    'icon_name': 'assets/images/unit2.png'
  };

  var map8 = {
    'node_id': 'aaab',
    'parent_id': 'aaa',
    'name': 'IO1',
    'description': 'neuron id: 2394767 \n in1: ac \n in2: bat',
    'position': 1,
    'icon_name': 'assets/images/unit2.png'
  };

  // nodes
  var map9 = {
    'node_id': 'ab',
    'parent_id': 'a',
    'name': 'System alarmowy',
    'description': 'SSWiN',
    'position': 0,
    'icon_name': 'assets/images/system2.png'
  };

  var map10 = {
    'node_id': 'aba',
    'parent_id': 'ab',
    'name': 'CA1',
    'description': 'Galaxy 520',
    'position': 0,
    'icon_name': 'assets/images/unit3.png'
  };

  var map11 = {
    'node_id': 'abaa',
    'parent_id': 'aba',
    'name': 'MAG1',
    'description': 'magistrala 1',
    'position': 0,
    'icon_name': 'assets/images/unit1.png'
  };

  var map12 = {
    'node_id': 'abab',
    'parent_id': 'aba',
    'name': 'MAG2',
    'description': 'magistrala 2',
    'position': 1,
    'icon_name': 'assets/images/unit1.png'
  };

  var map13 = {
    'node_id': 'abaaa',
    'parent_id': 'abaa',
    'name': 'RIO1',
    'description': 'in1 - pir\nin2 - kont\in3 - pir',
    'position': 0,
    'icon_name': 'assets/images/unit2.png'
  };

  List<Node> nodes = [];
  List<Node> roots = [];
  List<Node> nodesByParentId = [];

  FakeNodeRepository() {
    nodes = [
      NodeModel.fromMap(map1),
      NodeModel.fromMap(map2),
      NodeModel.fromMap(map3),
      NodeModel.fromMap(map4),
      NodeModel.fromMap(map5),
      NodeModel.fromMap(map6),
      NodeModel.fromMap(map7),
      NodeModel.fromMap(map8),
      NodeModel.fromMap(map9),
      NodeModel.fromMap(map10),
      NodeModel.fromMap(map11),
      NodeModel.fromMap(map12),
      NodeModel.fromMap(map13),
    ];
  }

  @override
  add({required Node node}) {
    return nodes.add(node);
  }

  @override
  update({required Node node}) {
    var counter = 0;
    var idx = 0;
    nodes.forEach((element) {
      if (node.id == element.id) idx = counter;
      counter++;
    });
    nodes[idx] = node;

    return null;
  }

  @override
  delete({required Identity nodeId}) {
    var counter = 0;
    var idx = 0;
    nodes.forEach((element) {
      if (nodeId == element.id) idx = counter;
      counter++;
    });
    nodes.removeAt(idx);

    return null;
  }

  @override
  Future<Option<Node>> findById({required Identity nodeId}) async {
    var output = nodes.where((node) => node.id == nodeId);

    if (output.isEmpty) {
      return None();
    } else {
      return Some(output.first);
    }
  }

  @override
  Future<List<Node>> findByParentId({required Identity nodeId}) async {
    nodesByParentId = [];

    nodes.forEach((node) {
      if (node.parentId == nodeId) {
        nodesByParentId.add(node);
      }
    });

    nodesByParentId
        .sort((a, b) => a.position.value.compareTo(b.position.value));

    return nodesByParentId;
  }

  @override
  Future<List<Node>> findRoots() async {
    roots = [];

    nodes.forEach((node) {
      if (node.parentId.id == 'none') roots.add(node);
    });

    roots.sort((a, b) => a.position.value.compareTo(b.position.value));

    return roots;
  }
}
