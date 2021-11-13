// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:experiment_file_system/src/component/dialog/input_error_dialog.dart';
import 'package:experiment_file_system/src/const/folder_type.dart';
import 'package:experiment_file_system/src/repository/model/folder_model.dart';
import 'package:experiment_file_system/src/repository/service/folder_service.dart';
import 'package:flutter/material.dart';

/// The folder service
final _folderService = FolderService.getInstance();

late AwesomeDialog _dialog;

final _folderName = TextEditingController();
final _remarks = TextEditingController();

Future<T?> showCreateNewFolderDialog<T>({
  required BuildContext context,
  required FolderType folderType,
}) async {
  _folderName.text = '';
  _remarks.text = '';

  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    _getDialogTitle(
                      folderType: folderType,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    TextField(
                      controller: _folderName,
                      maxLength: 50,
                      onChanged: (text) {
                        _folderName.text = text;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _remarks,
                      maxLines: 5,
                      maxLength: 200,
                      onChanged: (text) {
                        _remarks.text = text;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Create',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    final trimmedFolderName = _folderName.text.trim();

                    if (trimmedFolderName.isEmpty) {
                      await showInputErrorDialog(
                          context: context,
                          content: 'The folder name is required.');
                      return;
                    }

                    if (await _isFolderDuplicated(
                      folderType: folderType,
                      folderName: trimmedFolderName,
                    )) {
                      await showInputErrorDialog(
                          context: context,
                          content:
                              'The folder "$trimmedFolderName" already exists.');
                      return;
                    }

                    await _createNewFolder(
                      folderType: folderType,
                      folderName: trimmedFolderName,
                    );

                    _dialog.dismiss();
                  },
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Cancel',
                  color: Theme.of(context).colorScheme.error,
                  pressEvent: () {
                    _dialog.dismiss();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog.show();
}

String _getDialogTitle({
  required FolderType folderType,
}) {
  switch (folderType) {
    case FolderType.none:
      return 'Create New Folder';
  }
}

Future<bool> _isFolderDuplicated({
  required FolderType folderType,
  required String folderName,
}) async =>
    await _folderService.checkExistByFolderTypeAndName(
      folderType: folderType,
      name: folderName,
    );

Future<void> _createNewFolder({
  required FolderType folderType,
  required String folderName,
}) async =>
    await _folderService.insert(
      Folder.from(
        parentFolderId: -1,
        folderType: folderType,
        name: folderName,
        remarks: _remarks.text,
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
