import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/delete_node_page/delete_node_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteNodePage extends StatefulWidget {
  final Node node;

  DeleteNodePage(this.node);

  @override
  _DeleteNodePageState createState() => _DeleteNodePageState();
}

class _DeleteNodePageState extends State<DeleteNodePage> {
  String _name = '';
  String _iconName = '';

  @override
  void initState() {
    _name = widget.node.name;
    _iconName = widget.node.iconName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocConsumer<DeleteNodeBloc, DeleteNodeState>(
          bloc: BlocProvider.of<DeleteNodeBloc>(context),
          builder: (context, state) {
            if (state is DeleteNodeInitial) return _buildDeleteDialog();
            if (state is DeleteNodeDeleting)
              return Center(child: CircularProgressIndicator());
            return Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is DeleteNodeDeleted) {
              Navigator.of(context).pop<bool>(true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Deleted: ${state.node.name}')));
            }
            if (state is DeleteNodeError) {
              Navigator.of(context).pop<bool>(false);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage.toString())));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDeleteDialog() {
    return AlertDialog(
      title: Text('Delete'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete'),
          SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage(_iconName),
                width: 20.0,
                height: 20.0,
              ),
              SizedBox(width: 5.0),
              Text('$_name?'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>Navigator.of(context).pop<bool>(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _deleteNode(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  _deleteNode(BuildContext context) {
    BlocProvider.of<DeleteNodeBloc>(context).add(DeleteNode(node: widget.node));
  }
}
