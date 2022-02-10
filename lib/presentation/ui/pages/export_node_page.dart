import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/blocs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportNodePage extends StatefulWidget {
  final Node root;

  const ExportNodePage({required this.root});

  @override
  _ExportNodePageState createState() => _ExportNodePageState();
}

class _ExportNodePageState extends State<ExportNodePage> {
  List<Node> nodes = [];
  String _fileName = '';
  String _path = '';

  @override
  void initState() {
    // BlocProvider.of<ExportNodeBloc>(context)
    //     .add(GetNodeList(id: widget.root.id));

    var nowYear = DateTime.now().year.toString();
    var nowMonth = DateTime.now().month.toString();
    var nowDay = DateTime.now().day.toString();
    var nowHour = DateTime.now().hour.toString();
    var nowMinute = DateTime.now().minute;

    _fileName =
        '${widget.root.name}_${nowYear}_${nowMonth}_${nowDay}_${nowHour}_$nowMinute';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocConsumer<ExportNodeBloc, ExportNodeState>(
          bloc: BlocProvider.of<ExportNodeBloc>(context),
          builder: (context, state) {
            if (state is ExportNodeInitial) return _buildExportDialog();
            if (state is ExportNodeLoaded) {
              nodes = state.nodes;
              return _buildExportDialog();
            }
            if (state is ExportNodeSaving)
              return Center(child: CircularProgressIndicator());
            if (state is ExportNodeLoading)
              return Center(child: CircularProgressIndicator());
            return Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is ExportNodeSaved) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('File saved: ${state.fileName.toString()}')));
            }
            if (state is ExportNodeError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage.toString())));
            }
          },
        ),
      ),
    );
  }

  Widget _buildExportDialog() {
    return AlertDialog(
      title: Text('Export'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Open folder:'),
                IconButton(
                  onPressed: () => _getPath(),
                  icon: Icon(Icons.folder_open, size: 30.0),
                ),
              ],
            ),
            TextFormField(
              enabled: false,
              initialValue: _path,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Path',
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              enabled: true,
              initialValue: _fileName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'File name',
              ),
              onChanged: (val) => _fileName = val,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _saveNodes(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  _getPath() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      _path = directoryPath;

      BlocProvider.of<ExportNodeBloc>(context)
          .add(GetNodeList(id: widget.root.id));
    }
  }

  _saveNodes() async {
    if (_path.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Path cannot be empty')));
      return;
    }
    if (_fileName.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('File name cannot be empty')));
      return;
    }

    if (await Permission.storage.request().isGranted) {
      BlocProvider.of<ExportNodeBloc>(context).add(
          ExportNodes(root: widget.root, path: _path, fileName: _fileName));
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
