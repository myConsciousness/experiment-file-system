// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/repository/model/folder_item_model.dart';
import 'package:experiment_file_system/src/repository/repository.dart';

abstract class FolderItemRepository extends Repository<FolderItem> {
  Future<List<FolderItem>> findByFolderId({
    required int folderId,
  });

  Future<int> countByFolderId({
    required int folderId,
  });

  Future<bool> checkExistByFolderId({
    required int folderId,
  });

  Future<void> deleteByFolderId({
    required int folderId,
  });

  Future<void> replaceSortOrdersByIds({
    required List<FolderItem> folderItems,
  });
}
