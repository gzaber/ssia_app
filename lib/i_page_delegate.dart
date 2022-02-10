import 'package:ssia_app/presentation/models/node.dart';
import 'package:flutter/material.dart';

abstract class PageDelegate {
  Future<bool> onAddNode(BuildContext context, int nodesSize, String parentId);
  Future<bool> onUpdateNode(BuildContext context, Node root);
  Future<bool> onDeleteNode(BuildContext context, Node root);
  Future<void> onNodePage(BuildContext context, Node root, List<String> pathList);
  Future<void> onNodeView(BuildContext context, Node root);
  Future<void> onExportNode(BuildContext context, Node root);
  Future<void> onImportNode(BuildContext context);
}