import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/manage_node_page/manage_node_bloc.dart';
import 'package:ssia_app/presentation/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageNodePage extends StatefulWidget {
  final Node? node;
  final int? nodesSize;
  final String? parentId;

  const ManageNodePage({this.nodesSize, this.node, this.parentId});

  @override
  _ManageNodePageState createState() => _ManageNodePageState();
}

class _ManageNodePageState extends State<ManageNodePage> {
  String _id = '';
  String _parentId = '';
  String _name = '';
  String _description = '';
  int _position = 0;
  String _iconName = Utils.defaultIcon;

  @override
  void initState() {
    if (widget.node != null) {
      _id = widget.node?.id ?? '';
      _parentId = widget.node?.parentId ?? '';
      _name = widget.node?.name ?? '';
      _description = widget.node?.description ?? '';
      _position = widget.node?.position ?? _position;
      _iconName = widget.node?.iconName ?? _iconName;
    }

    if (widget.nodesSize != null) {
      _position = widget.nodesSize ?? _position;
    }

    if (widget.parentId != null) {
      _parentId = widget.parentId ?? _parentId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.node == null ? 'Add node' : 'Edit node'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop<bool>(true),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () => widget.node == null ? _addNode(context) : _updateNode(context),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocConsumer<ManageNodeBloc, ManageNodeState>(
              bloc: BlocProvider.of<ManageNodeBloc>(context),
              builder: (context, state) {
                if (state is ManageNodeInitial) return _buildForm();
                if ((state is ManageNodeAdding) || (state is ManageNodeUpdating))
                  return Center(child: CircularProgressIndicator());
                if (state is ManageNodeError) return _buildForm();
                return Center(child: CircularProgressIndicator());
              },
              listener: (context, state) {
                if (state is ManageNodeError) {
                  if (state.errMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.errMessage.toString())));
                  }
                }
                if (state is ManageNodeAdded) {
                  if (state.node.id.isNotEmpty) {
                    Navigator.of(context).pop<bool>(true);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Added: ${state.node.name}')));
                  }
                }
                if (state is ManageNodeUpdated) {
                  if (state.node.id.isNotEmpty) {
                    Navigator.of(context).pop<bool>(true);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Updated: ${state.node.name}')));
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextFormField(
          initialValue: _name,
          maxLines: 1,
          maxLength: 20,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          onChanged: (val) => _name = val.trim(),
        ),
        TextFormField(
          initialValue: _description,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          maxLength: 200,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Description',
          ),
          onChanged: (val) => _description = val.trim(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text('Icon:'),
                SizedBox(height: 10.0),
                Image(
                  image: AssetImage(_iconName),
                  width: 40.0,
                  height: 40.0,
                ),
              ],
            ),
            SizedBox(width: 15.0),
            Center(
              child: ElevatedButton(
                onPressed: _showIconPicker,
                child: Text('SELECT AN ICON'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _addNode(BuildContext context) {
    BlocProvider.of<ManageNodeBloc>(context).add(AddNode(
        parentId: _parentId,
        name: _name,
        description: _description,
        position: _position,
        iconName: _iconName));
  }

  _updateNode(BuildContext context) {
    BlocProvider.of<ManageNodeBloc>(context).add(UpdateNode(
        parentId: _parentId,
        id: _id,
        name: _name,
        description: _description,
        position: _position,
        iconName: _iconName));
  }

  _showIconPicker() {
    String iconName = _iconName;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an icon'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: GridView.builder(
                itemCount: Utils.iconsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      iconName = Utils.iconsList[index];
                      Navigator.pop(context, iconName);
                    },
                    child: Image.asset(
                      Utils.iconsList[index],
                      width: 30.0,
                      height: 30.0,
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, iconName);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        }).then((value) {
      setState(() {
        _iconName = value ?? iconName;
      });
    });
  }
}
