import 'package:ssia_app/i_page_delegate.dart';
import 'package:ssia_app/presentation/models/node.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ssia_app/ui_composer.dart';
import 'package:flutter/material.dart';

class PageCoordinator implements PageDelegate {
  @override
  Future<bool> onAddNode(
      BuildContext context, int nodesSize, String parentId) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeAddNodePage(nodesSize, parentId),
      ),
    );
    return result ?? false;
  }

  @override
  Future<bool> onUpdateNode(BuildContext context, Node node) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeUpdateNodePage(node),
      ),
    );
    return result ?? false;
  }

  @override
  Future<bool> onDeleteNode(BuildContext context, Node node) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeDeleteNodePage(node),
      ),
    );
    return result ?? false;
  }

  @override
  Future<void> onNodePage(
      BuildContext context, Node node, List<String> pathList) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: false,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeNodePage(node, pathList),
      ),
    );
  }

  @override
  Future<void> onNodeView(BuildContext context, Node root) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeNodeViewPage(root),
      ),
    );
  }

  @override
  Future<void> onExportNode(BuildContext context, Node root) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeExportNodePage(root),
      ),
    );
  }

  @override
  Future<void> onImportNode(BuildContext context) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UiComposer.composeImportNodePage(),
      ),
    );
  }
}
