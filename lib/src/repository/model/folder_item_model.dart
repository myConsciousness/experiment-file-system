// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/repository/utils/boolean_text.dart';
import 'package:experiment_file_system/src/repository/const/column/folder_item_column.dart';

class FolderItem {
  int id = -1;
  int folderId;
  String itemId;
  String remarks;
  String userId;
  int sortOrder;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [FolderItem].
  FolderItem.empty()
      : _empty = true,
        folderId = -1,
        itemId = '',
        remarks = '',
        userId = '',
        sortOrder = -1,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [FolderItem] based on the parameters.
  FolderItem.from({
    this.id = -1,
    required this.folderId,
    required this.itemId,
    required this.remarks,
    required this.userId,
    this.sortOrder = -1,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [FolderItem] based on the [map] passed as an argument.
  factory FolderItem.fromMap(Map<String, dynamic> map) => FolderItem.from(
        id: map[FolderItemColumn.id],
        folderId: map[FolderItemColumn.folderId],
        itemId: map[FolderItemColumn.itemId],
        remarks: map[FolderItemColumn.remarks],
        userId: map[FolderItemColumn.userId],
        sortOrder: map[FolderItemColumn.sortOrder],
        deleted: map[FolderItemColumn.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderItemColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderItemColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [FolderItem] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[FolderItemColumn.folderId] = folderId;
    map[FolderItemColumn.itemId] = itemId;
    map[FolderItemColumn.remarks] = remarks;
    map[FolderItemColumn.userId] = userId;
    map[FolderItemColumn.sortOrder] = sortOrder;
    map[FolderItemColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[FolderItemColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[FolderItemColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
