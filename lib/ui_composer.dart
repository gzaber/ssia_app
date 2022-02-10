// @dart=2.9
import 'package:ssia_app/application/boundaries/add_all_nodes/i_add_all_nodes_usecase.dart';
import 'package:ssia_app/application/boundaries/add_node/i_add_node_usecase.dart';
import 'package:ssia_app/application/boundaries/delete_node/i_delete_node_usecase.dart';
import 'package:ssia_app/application/boundaries/get_node/i_get_node_usecase.dart';
import 'package:ssia_app/application/boundaries/get_nodes_by_parent_id/i_get_nodes_by_parent_id_usecase.dart';
import 'package:ssia_app/application/boundaries/update_node/i_update_node_usecase.dart';
import 'package:ssia_app/application/usecases/add_all_nodes_usecase.dart';
import 'package:ssia_app/application/usecases/usecases.dart';
import 'package:ssia_app/domain/factories/i_entity_factory.dart';
import 'package:ssia_app/domain/repositories/i_node_repository.dart';
import 'package:ssia_app/infrastructure/datasources/sqflite_datasource.dart';
import 'package:ssia_app/infrastructure/repositories/node_repository.dart';
import 'package:ssia_app/page_coordinator.dart';
import 'package:ssia_app/infrastructure/factories/entity_factory.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/blocs.dart';
import 'package:ssia_app/presentation/ui/pages/pages.dart';
import 'package:ssia_app/presentation/viewmodels/viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class UiComposer {
  static SqfliteDatasource _datasource;
  static final IEntityFactory _entityFactory = EntityFactory();
  static INodeRepository _nodeRepository;

  static configure(Database db) {
    _datasource = SqfliteDatasource(db: db);
    _nodeRepository = NodeRepository(datasource: _datasource);
  }

  static Widget composeHomePage() {
    PageCoordinator coordinator = PageCoordinator();

    GetAllRootsUseCase getAllRootsUseCase =
        GetAllRootsUseCase(nodeRepository: UiComposer._nodeRepository);

    IUpdateNodeUseCase updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    HomePageViewModel viewModel = HomePageViewModel(
        getAllRootsUseCase: getAllRootsUseCase,
        updateNodeUseCase: updateNodeUseCase);

    return BlocProvider(
      create: (context) => HomePageBloc(viewModel),
      child: HomePage(delegate: coordinator),
    );
  }

  static Widget composeAddNodePage(int nodesSize, String parentId) {
    IAddNodeUseCase addNodeUseCase = AddNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    IUpdateNodeUseCase updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    ManageNodeViewModel viewModel = ManageNodeViewModel(
        addNodeUseCase: addNodeUseCase, updateNodeUseCase: updateNodeUseCase);

    return BlocProvider(
      create: (_) => ManageNodeBloc(viewModel),
      child: ManageNodePage(nodesSize: nodesSize, parentId: parentId),
    );
  }

  static Widget composeUpdateNodePage(Node node) {
    IAddNodeUseCase addNodeUseCase = AddNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    IUpdateNodeUseCase updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    ManageNodeViewModel viewModel = ManageNodeViewModel(
        addNodeUseCase: addNodeUseCase, updateNodeUseCase: updateNodeUseCase);

    return BlocProvider(
      create: (_) => ManageNodeBloc(viewModel),
      child: ManageNodePage(node: node),
    );
  }

  static Widget composeDeleteNodePage(Node node) {
    IDeleteNodeUseCase deleteNodeWithChildrenUseCase =
        DeleteNodeUseCase(
      nodeRepository: UiComposer._nodeRepository,
      entityFactory: UiComposer._entityFactory,
    );

    IGetNodesByParentIdUseCase getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: UiComposer._nodeRepository);

    DeleteNodeViewModel viewModel = DeleteNodeViewModel(
        deleteNodeUseCase: deleteNodeWithChildrenUseCase, getNodesByParentIdUseCase: getNodesByParentIdUseCase);

    return BlocProvider(
      create: (_) => DeleteNodeBloc(viewModel),
      child: DeleteNodePage(node),
    );
  }

  static Widget composeNodePage(Node root, List<String> pathList) {
    PageCoordinator coordinator = PageCoordinator();

    IGetNodesByParentIdUseCase getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: UiComposer._nodeRepository);

    IUpdateNodeUseCase updateNodeUseCase = UpdateNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);

    NodePageViewModel viewModel = NodePageViewModel(
        getNodesByParentIdUseCase: getNodesByParentIdUseCase,
        updateNodeUseCase: updateNodeUseCase);

    return BlocProvider(
      create: (context) => NodePageBloc(viewModel),
      child: NodePage(delegate: coordinator, root: root, pathList: pathList),
    );
  }

  static Widget composeNodeViewPage(Node root) {
    IGetNodesByParentIdUseCase getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: UiComposer._nodeRepository);

    NodeViewViewModel viewModel =
        NodeViewViewModel(getNodesByParentIdUseCase: getNodesByParentIdUseCase);

    return BlocProvider(
      create: (context) => NodeViewBloc(viewModel),
      child: NodeViewPage(root: root),
    );
  }

  static Widget composeExportNodePage(Node root) {
    IGetNodesByParentIdUseCase getNodesByParentIdUseCase =
        GetNodesByParentIdUseCase(nodeRepository: UiComposer._nodeRepository);

    ExportNodeViewModel viewModel = ExportNodeViewModel(
        getNodesByParentIdUseCase: getNodesByParentIdUseCase);

    return BlocProvider(
      create: (context) => ExportNodeBloc(viewModel),
      child: ExportNodePage(root: root),
    );
  }

  static Widget composeImportNodePage() {
    IGetNodeUseCase getNodeUseCase = GetNodeUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);
    IAddAllNodesUseCase addAllNodesUseCase = AddAllNodesUseCase(
        nodeRepository: UiComposer._nodeRepository,
        entityFactory: UiComposer._entityFactory);
    ImportNodeViewModel viewModel = ImportNodeViewModel(
        getNodeUseCase: getNodeUseCase, addAllNodesUseCase: addAllNodesUseCase);

    return BlocProvider(
      create: (context) => ImportNodeBloc(viewModel),
      child: ImportNodePage(),
    );
  }
}
