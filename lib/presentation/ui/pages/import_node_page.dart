import 'package:ssia_app/presentation/states/blocs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportNodePage extends StatefulWidget {
  @override
  _ImportNodePageState createState() => _ImportNodePageState();
}

class _ImportNodePageState extends State<ImportNodePage> {
  String _path = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocConsumer<ImportNodeBloc, ImportNodeState>(
          bloc: BlocProvider.of<ImportNodeBloc>(context),
          builder: (context, state) {
            if (state is ImportNodeInitial) return _buildImportDialog();
            if (state is ImportNodeImporting)
              return Center(child: CircularProgressIndicator());
            return Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is ImportNodeImported) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Imported: ${state.rootName}')));
            }
            if (state is ImportNodeError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errMessage
                      .toString()
                      .replaceAll('Exception: ', ''))));
            }
          },
        ),
      ),
    );
  }

  Widget _buildImportDialog() {
    return AlertDialog(
      title: Text('Import'),
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
            Text(
              _path,
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _importNodes(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  _getPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _path = result.files.single.path ?? '';
      setState(() {});
    }
  }

  _importNodes() async {
    if (_path.trim().isNotEmpty)
      BlocProvider.of<ImportNodeBloc>(context).add(ImportNode(path: _path));
    else
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Path to file cannot be empty')));
  }
}
