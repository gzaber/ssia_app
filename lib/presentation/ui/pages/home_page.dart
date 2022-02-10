import 'package:ssia_app/i_page_delegate.dart';
import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/home_page/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  final PageDelegate delegate;

  HomePage({required this.delegate});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Node> _roots = [];
  String _path = 'Home';

  @override
  Widget build(BuildContext context) {
    setState(() {
      BlocProvider.of<HomePageBloc>(context).getRoots();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _path,
          style: TextStyle(fontSize: 18.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              onPressed: () => _showImportNodePage(),
              icon: Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<HomePageBloc, HomePageState>(
          bloc: BlocProvider.of<HomePageBloc>(context),
          builder: (context, state) {
            if (state is HomePageLoaded) return _buildListView(state.roots);
            if ((state is HomePageLoading) || (state is HomePageUpdating))
              return Center(child: CircularProgressIndicator());
            return Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is HomePageError) {
              if (state.errMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage.toString())));
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddNodePage(context),
      ),
    );
  }

  _buildListView(List<Node> roots) {
    _roots = roots;

    return ReorderableListView.builder(
      itemCount: _roots.length,
      itemBuilder: (context, index) {
        return _buildSlidable(_roots[index]);
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Node item = _roots.removeAt(oldIndex);
          _roots.insert(newIndex, item);

          int counter = 0;
          _roots.forEach((element) {
            _updateNode(element, counter);
            counter++;
          });
        });
      },
    );
  }

  _buildSlidable(Node root) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      key: Key('${root.id}'),
      child: Slidable(
        child: _buildListTile(root),
        actionPane: SlidableDrawerActionPane(),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Close',
            color: Colors.white,
            icon: Icons.close,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () => _showUpdateNodePage(root),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _showDeleteNodePage(root),
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Export',
            color: Colors.purple,
            icon: Icons.file_download,
            onTap: () => _showExportNodePage(root),
          ),
          IconSlideAction(
            caption: 'Tree view',
            color: Colors.green,
            icon: Icons.account_tree,
            onTap: () => _showNodeViewPage(root),
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

  _buildListTile(Node root) {
    return ListTile(
      title: Text(root.name),
      leading: Image(
        image: AssetImage(root.iconName),
        width: 40.0,
        height: 40.0,
      ),
      onTap: () => _showNodePage(root),
    );
  }

  _showAddNodePage(BuildContext context) async {
    var nodeResult =
        await widget.delegate.onAddNode(context, _roots.length, 'none');

    if (nodeResult) {
      BlocProvider.of<HomePageBloc>(context).getRoots();
    }
  }

  _showUpdateNodePage(Node root) async {
    var nodeResult = await widget.delegate.onUpdateNode(context, root);

    if (nodeResult) {
      BlocProvider.of<HomePageBloc>(context).getRoots();
    }
  }

  _showDeleteNodePage(Node root) async {
    var nodeResult = await widget.delegate.onDeleteNode(context, root);

    if (nodeResult) {
      BlocProvider.of<HomePageBloc>(context).getRoots();
    }
  }

  _showNodePage(Node root) async {
    List<String> path = [_path];
    await widget.delegate.onNodePage(context, root, path);

    BlocProvider.of<HomePageBloc>(context).getRoots();
  }

  _showNodeViewPage(Node root) async {
    await widget.delegate.onNodeView(context, root);

    BlocProvider.of<HomePageBloc>(context).getRoots();
  }

  _showExportNodePage(Node root) async {
    await widget.delegate.onExportNode(context, root);

    BlocProvider.of<HomePageBloc>(context).getRoots();
  }

  _showImportNodePage() async {
    await widget.delegate.onImportNode(context);

    BlocProvider.of<HomePageBloc>(context).getRoots();
  }

  _updateNode(Node node, int position) {
    BlocProvider.of<HomePageBloc>(context).add(UpdateRootPosition(
        parentId: node.parentId,
        id: node.id,
        name: node.name,
        description: node.description,
        position: position,
        iconName: node.iconName));
  }
}
