import 'dart:io';

import 'package:ssia_app/presentation/models/node.dart';
import 'package:ssia_app/presentation/states/node_view_page/node_view_bloc.dart';
import 'package:ssia_app/presentation/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class NodeViewPage extends StatefulWidget {
  final Node root;

  const NodeViewPage({required this.root});

  @override
  _NodeViewPageState createState() => _NodeViewPageState();
}

class _NodeViewPageState extends State<NodeViewPage> {
  final _screenshotController = ScreenshotController();

  AppBar appBar = AppBar();
  bool isList = false;

  @override
  void initState() {
    BlocProvider.of<NodeViewBloc>(context).add(GetTreeView(id: widget.root.id));

    appBar = AppBar(
      title: Text(
        widget.root.name,
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            onPressed: () => _takeScreenshot(),
            icon: Icon(Icons.share),
          ),
        ),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: BlocConsumer<NodeViewBloc, NodeViewState>(
          bloc: BlocProvider.of<NodeViewBloc>(context),
          builder: (context, state) {
            if (state is NodeViewLoaded) {
              if (state.listOfTreeNodes.isEmpty) {
                isList = false;
                return SizedBox();
              } else {
                isList = true;
                return _buildList(state.listOfTreeNodes);
              }
            }
            if (state is NodeViewLoading) return Center(child: CircularProgressIndicator());
            return Center(child: CircularProgressIndicator());
          },
          listener: (context, state) {
            if (state is NodeViewError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errMessage.toString())));
            }
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Map<int, Node>> listOfTreeNodes) {
    var keys = listOfTreeNodes.map((e) => e.keys.first);
    var keysList = keys.toList();
    keysList.sort();
    var maxLevel = keysList.last;

    var keysWithoutDuplicates = keysList.toSet();
    Map<int, Color> keysColors = {};
    keysWithoutDuplicates.forEach((level) {
      keysColors[level] = Utils.getRandomColor();
    });

    var listTileWidth = 150.0;
    var emptyBox = 40.0;
    var screenWidth = (maxLevel + 1) * emptyBox + 150.0 + 2 * emptyBox;

    listOfTreeNodes.insert(0, {0: widget.root});

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: screenWidth, //MediaQuery.of(context).size.width * screenWidthFactor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              color: Colors.white,
              width: screenWidth, //MediaQuery.of(context).size.width,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listOfTreeNodes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        index == 0
                            ? SizedBox(width: emptyBox)
                            : SizedBox(
                                width: listOfTreeNodes[index].keys.first * emptyBox,
                              ),
                        index > 0
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 20.0,
                                  color: keysColors[listOfTreeNodes[index].keys.first],
                                ),
                              )
                            : SizedBox(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: keysColors[listOfTreeNodes[index].keys.first] ?? Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                                child: Image(
                                  image: AssetImage(
                                    listOfTreeNodes[index].values.first.iconName,
                                  ),
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listOfTreeNodes[index].values.first.name,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: listTileWidth,
                                      child: Text(
                                        listOfTreeNodes[index].values.first.description,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _takeScreenshot() async {
    if (isList) {
      final image = await _screenshotController.capture();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/${widget.root.name}_view.png').create();
      await imagePath.writeAsBytes(image!);

      await Share.shareFiles([imagePath.path]);
    }
  }
}
