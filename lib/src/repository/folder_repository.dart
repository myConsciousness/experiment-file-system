// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/const/folder_type.dart';
import 'package:experiment_file_system/src/repository/model/folder_model.dart';
import 'package:experiment_file_system/src/repository/repository.dart';

abstract class FolderRepository extends Repository<Folder> {
  Future<List<Folder>> findByFolderType({
    required FolderType folderType,
  });

  Future<bool> checkExistByFolderTypeAndName({
    required FolderType folderType,
    required String name,
  });

  Future<void> replaceSortOrdersByIds({
    required List<Folder> folders,
  });
}
