// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/component/add_new_folder_button.dart';
import 'package:experiment_file_system/src/component/dialog/confirm_dialog.dart';
import 'package:experiment_file_system/src/component/dialog/create_new_folder_dialog.dart';
import 'package:experiment_file_system/src/component/dialog/edit_folder_dialog.dart';
import 'package:experiment_file_system/src/const/folder_type.dart';
import 'package:experiment_file_system/src/repository/model/folder_model.dart';
import 'package:experiment_file_system/src/repository/service/folder_item_service.dart';
import 'package:experiment_file_system/src/repository/service/folder_service.dart';
import 'package:experiment_file_system/src/view/folder_items_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    Key? key,
    required this.folderType,
  }) : super(key: key);

  /// The folder type
  final FolderType folderType;

  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  /// The date time formatter
  final _dateTimeFormatter = DateFormat('yyyy/MM/dd');

  /// The folder item service
  final _folderItemService = FolderItemService.getInstance();

  /// The folder service
  final _folderService = FolderService.getInstance();

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

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

  Future<void> _sortCards({
    required List<Folder> folders,
    required int oldIndex,
    required int newIndex,
  }) async {
    folders.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      folders.removeAt(oldIndex),
    );

    // Update all sort orders
    await _folderService.replaceSortOrdersByIds(
      folders: folders,
    );
  }

  Widget _buildFolderCard({
    required Folder folder,
  }) =>
      Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildFolderCardContent(
            folder: folder,
          ),
        ),
      );

  IconData get _folderIcon {
    switch (widget.folderType) {
      case FolderType.none:
        return Icons.folder;
    }
  }

  Widget _buildFolderCardContent({
    required Folder folder,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: _folderItemService.countByFolderId(
                  folderId: folder.id,
                ),
                builder:
                    (BuildContext context, AsyncSnapshot itemCountSnapshot) {
                  if (!itemCountSnapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return Text(
                    _numericTextFormat.format(itemCountSnapshot.data),
                  );
                },
              ),
              Text(
                _dateTimeFormatter.format(
                  folder.createdAt,
                ),
              ),
              Text(
                _dateTimeFormatter.format(
                  folder.updatedAt,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(
                    _folderIcon,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(folder.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () async {
                          await showEditFolderDialog(
                            context: context,
                            folderId: folder.id,
                            folderType: FolderType.none,
                          );

                          super.setState(() {});
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(folder.remarks),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FolderItemsView(
                          folderType: widget.folderType,
                          folderId: folder.id,
                          folderName: folder.name,
                        ),
                      ),
                    ).then((value) => super.setState(() {}));
                  },
                ),
              ),
              IconButton(
                tooltip: 'Delete Folder',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await showConfirmDialog(
                    context: context,
                    title: 'Delete Folder',
                    content:
                        'Are you sure you want to delete the folder "${folder.name}"?',
                    onPressedOk: () async {
                      await _folderService.delete(folder);
                      await _folderItemService.deleteByFolderId(
                          folderId: folder.id);

                      super.setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
        ],
      );

  Future<List<Folder>> _fetchDataSource() async {
    return await _folderService.findByFolderType(
      folderType: widget.folderType,
    );
  }

  Widget _buildFolderListView({
    required List<Folder> folders,
  }) =>
      RefreshIndicator(
        onRefresh: () async {
          super.setState(() {});
        },
        child: ReorderableListView.builder(
          itemCount: folders.length,
          onReorder: (oldIndex, newIndex) async => await _sortCards(
            folders: folders,
            oldIndex: oldIndex,
            newIndex: newIndex,
          ),
          itemBuilder: (_, index) => Column(
            key: Key('${folders[index].sortOrder}'),
            children: [
              _buildFolderCard(
                folder: folders[index],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: 'Add Folder',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await showCreateNewFolderDialog(
                  context: context,
                  folderType: widget.folderType,
                );

                super.setState(() {});
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _fetchDataSource(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final List<Folder> folders = snapshot.data;

            if (folders.isEmpty) {
              return AddNewFolderButton(
                onPressedCreate: () async {
                  await showCreateNewFolderDialog(
                    context: context,
                    folderType: widget.folderType,
                  );

                  super.setState(() {});
                },
              );
            }

            return _buildFolderListView(
              folders: folders,
            );
          },
        ),
      );
}
