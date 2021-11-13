import 'package:experiment_file_system/src/const/folder_type.dart';
import 'package:experiment_file_system/src/view/folder_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExperimentFileSystem());
}

class ExperimentFileSystem extends StatelessWidget {
  const ExperimentFileSystem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FolderView(folderType: FolderType.none),
    );
  }
}
