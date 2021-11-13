// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/const/folder_type.dart';
import 'package:experiment_file_system/src/repository/model/folder_item_model.dart';
import 'package:experiment_file_system/src/repository/service/folder_item_service.dart';
import 'package:flutter/material.dart';

class FolderItemsView extends StatefulWidget {
  const FolderItemsView({
    Key? key,
    required this.folderType,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  /// The folder type
  final FolderType folderType;

  @override
  _FolderItemsViewState createState() => _FolderItemsViewState();
}

class _FolderItemsViewState extends State<FolderItemsView> {
  /// The folder item service
  final _folderItemService = FolderItemService.getInstance();

  late List<FolderItem> _folderItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<FolderItem>> _fetchDataSource({
    required int folderId,
  }) async =>
      await _folderItemService.findByFolderId(
        folderId: folderId,
      );

  String get _appBarTitle {
    switch (widget.folderType) {
      case FolderType.none:
        return 'Experiment Folders';
    }
  }

  Future<void> _sortCards({
    required List<FolderItem> folderItems,
    required int oldIndex,
    required int newIndex,
  }) async {
    folderItems.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      folderItems.removeAt(oldIndex),
    );

    // Update all sort orders
    await _folderItemService.replaceSortOrdersByIds(
      folderItems: folderItems,
    );

    _folderItems = folderItems;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: FutureBuilder(
          future: _fetchDataSource(folderId: widget.folderId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final List<FolderItem> items = snapshot.data;

            if (items.isEmpty) {
              return const Center(
                child: Text('No Items'),
              );
            }

            _folderItems = List.from(items);

            return RefreshIndicator(
              onRefresh: () async {
                super.setState(() {});
              },
              child: ReorderableListView.builder(
                itemCount: items.length,
                onReorder: (oldIndex, newIndex) async => await _sortCards(
                  folderItems: items,
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ),
                itemBuilder: (_, index) => Column(
                  key: Key('${items[index].sortOrder}'),
                  children: [],
                ),
              ),
            );
          },
        ),
      );
}
