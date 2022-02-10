import 'package:ssia_app/i_page_delegate.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/node_page/node_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NodePage extends StatefulWidget {
  final PageDelegate delegate;
  final Node root;
  final List<String> pathList;

  const NodePage(
      {required this.delegate, required this.root, required this.pathList});

  @override
  _NodePageState createState() => _NodePageState();
}

class _NodePageState extends State<NodePage> {
  bool _isHeaderExpanded = false;
  List<Node> _nodes = [];
  String _path = '';
  List<String> _pathList = [];

  @override
  void initState() {
    widget.pathList.forEach((element) {
      _path += '$element/';
    });

    _path = '$_path${widget.root.name}';

    _pathList = widget.pathList;
    _pathList.add('${widget.root.name}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      BlocProvider.of<NodePageBloc>(context)
          .add(GetNodes(parentId: widget.root.id));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _path,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildExpansionPanel(),
              BlocConsumer<NodePageBloc, NodePageState>(
                bloc: BlocProvider.of<NodePageBloc>(context),
                builder: (context, state) {
                  if (state is NodePageLoaded)
                    return _buildListView(state.nodes);
                  if ((state is NodePageLoading) || (state is NodePageUpdating))
                    return Center(child: CircularProgressIndicator());
                  return Center(child: CircularProgressIndicator());
                },
                listener: (context, state) {
                  if (state is NodePageError) {
                    if (state.errMessage.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errMessage.toString())));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddNodePage,
      ),
    );
  }

  Widget _buildExpansionPanel() {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isHeaderExpanded = !_isHeaderExpanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: _isHeaderExpanded,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Image.asset(
                widget.root.iconName,
                width: 40.0,
                height: 40.0,
              ),
              title: Text(widget.root.name),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                    top: BorderSide(color: Colors.grey),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.root.description),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildPath(_pathList),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildPath(List<String> pathList) {
    List<Widget> widgetsList = [];
    int idx = 0;
    String prefix = '|__ ';
    String space = '';
    String tab = '      ';
    int lastIdx = pathList.length - 1;

    widgetsList.add(Text(
      'Path:',
      style: TextStyle(fontWeight: FontWeight.bold),
    ));

    pathList.forEach((element) {
      widgetsList.add(
        Text(
          idx > 0 ? space + prefix + pathList[idx] : pathList[idx],
          style:
              TextStyle(color: idx == lastIdx ? Colors.orange.shade900 : Colors.black),
        ),
      );
      idx++;
      if (idx > 1) space += tab;
    });

    return widgetsList;
  }

  _buildListView(List<Node> nodes) {
    _nodes = nodes;

    return SingleChildScrollView(
      child: ReorderableListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _nodes.length,
        itemBuilder: (context, index) {
          return _buildSlidable(_nodes[index]);
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Node item = _nodes.removeAt(oldIndex);
            _nodes.insert(newIndex, item);

            int counter = 0;
            _nodes.forEach((element) {
              _updateNode(element, counter);
              counter++;
            });
          });
        },
      ),
    );
  }

  _buildSlidable(Node node) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      key: Key('${node.id}'),
      child: Slidable(
        child: _buildListTile(node),
        actionPane: SlidableDrawerActionPane(),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Close',
            color: Colors.green,
            icon: Icons.close,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () => _showUpdateNodePage(node),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _showDeleteNodePage(node),
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Tree view',
            color: Colors.green,
            icon: Icons.account_tree,
            onTap: () => _showNodeViewPage(node),
          ),
          IconSlideAction(
            caption: 'Reorder',
            color: Colors.white,
            icon: Icons.reorder,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  _buildListTile(Node node) {
    return ListTile(
      title: Text(node.name),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.subdirectory_arrow_right,
            size: 40.0,
            color: Colors.grey,
          ),
          Image(
            image: AssetImage(node.iconName),
            width: 40.0,
            height: 40.0,
          ),
        ],
      ),
      onTap: () => _showNodePage(node),
    );
  }

  _showAddNodePage() async {
    var node =
        await widget.delegate.onAddNode(context, _nodes.length, widget.root.id);

    if (node) {
      BlocProvider.of<NodePageBloc>(context)
          .add(GetNodes(parentId: widget.root.id));
    }
  }

  _showUpdateNodePage(Node node) async {
    var nodeResult = await widget.delegate.onUpdateNode(context, node);

    if (nodeResult) {
      BlocProvider.of<NodePageBloc>(context)
          .add(GetNodes(parentId: widget.root.id));
    }
  }

  _showDeleteNodePage(Node node) async {
    var nodeResult = await widget.delegate.onDeleteNode(context, node);

    if (nodeResult) {
      BlocProvider.of<NodePageBloc>(context)
          .add(GetNodes(parentId: widget.root.id));
    }
  }

  _showNodePage(Node node) async {
    await widget.delegate.onNodePage(context, node, _pathList);

    _pathList.removeLast();

    BlocProvider.of<NodePageBloc>(context)
        .add(GetNodes(parentId: widget.root.id));
  }

  _showNodeViewPage(Node root) async {
    await widget.delegate.onNodeView(context, root);

    BlocProvider.of<NodePageBloc>(context)
        .add(GetNodes(parentId: widget.root.id));
  }

  _updateNode(Node node, int position) {
    BlocProvider.of<NodePageBloc>(context).add(UpdateNodePosition(
        parentId: node.parentId,
        id: node.id,
        name: node.name,
        description: node.description,
        position: position,
        iconName: node.iconName));
  }
}
