// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:experiment_file_system/src/repository/folder_item_repository.dart';
import 'package:experiment_file_system/src/repository/model/folder_item_model.dart';

class FolderItemService extends FolderItemRepository {
  /// The internal constructor.
  FolderItemService._internal();

  /// Returns the singleton instance of [FolderItemService].
  factory FolderItemService.getInstance() => _singletonInstance;

  /// The singleton instance of this [FolderItemService].
  static final _singletonInstance = FolderItemService._internal();

  @override
  Future<bool> checkExistByFolderId({
    required int folderId,
  }) async =>
      await super.database.then((database) => database.rawQuery('''
              SELECT
                COUNT(*) COUNT
              FROM
                $table
              WHERE
                1 = 1
                AND FOLDER_ID = ?
              ''', [
            folderId,
          ]).then((entity) => entity.isEmpty ? 0 : entity[0]['COUNT'] as int)) >
      0;

  @override
  Future<int> countByFolderId({
    required int folderId,
  }) async =>
      await super.database.then(
            (database) => database.rawQuery('''
              SELECT
                COUNT(*) COUNT
              FROM
                $table
              WHERE
                1 = 1
                AND FOLDER_ID = ?
              ''', [
              folderId,
            ]).then((entity) => entity.isEmpty ? 0 : entity[0]['COUNT'] as int),
          );

  @override
  Future<void> delete(FolderItem model) async => await super.database.then(
        (database) => database.delete(
          table,
          where: 'ID = ?',
          whereArgs: [model.id],
        ),
      );

  @override
  Future<void> deleteAll() async => await super.database.then(
        (database) => database.delete(
          table,
        ),
      );

  @override
  Future<void> deleteByFolderId({
    required int folderId,
  }) async =>
      await super.database.then(
            (database) => database.delete(
              table,
              where: 'FOLDER_ID = ?',
              whereArgs: [folderId],
            ),
          );

  @override
  Future<List<FolderItem>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? FolderItem.fromMap(e)
                        : FolderItem.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<List<FolderItem>> findByFolderId({
    required int folderId,
  }) async {
    final learnedWordFolderItems = await super.database.then(
          (database) => database
              .query(
                table,
                where: 'FOLDER_ID = ?',
                whereArgs: [
                  folderId,
                ],
                orderBy: 'SORT_ORDER',
              )
              .then(
                (v) => v
                    .map(
                      (e) => e.isNotEmpty
                          ? FolderItem.fromMap(e)
                          : FolderItem.empty(),
                    )
                    .toList(),
              ),
        );

    return learnedWordFolderItems;
  }

  @override
  Future<FolderItem> findById(int id) async => await super.database.then(
        (database) => database.query(
          table,
          where: 'ID = ?',
          whereArgs: [id],
        ).then(
          (entity) => entity.isNotEmpty
              ? FolderItem.fromMap(entity[0])
              : FolderItem.empty(),
        ),
      );

  @override
  Future<FolderItem> insert(FolderItem model) async {
    model.sortOrder = await _findMaxSortOrderByFolderIdAndUserId(
      folderId: model.folderId,
      userId: model.userId,
    );

    await super.database.then(
          (database) => database
              .insert(
                table,
                model.toMap(),
              )
              .then(
                (int id) async => model.id = id,
              ),
        );

    return model;
  }

  @override
  Future<FolderItem> replace(FolderItem model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  Future<void> replaceSortOrdersByIds({
    required List<FolderItem> folderItems,
  }) async {
    folderItems.asMap().forEach((index, folderItem) async {
      FolderItem storedFolderItem = await findById(folderItem.id);
      storedFolderItem.sortOrder = index;

      await update(storedFolderItem);
    });
  }

  @override
  String get table => 'FOLDER_ITEM';

  @override
  Future<void> update(FolderItem model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );

  Future<int> _findMaxSortOrderByFolderIdAndUserId({
    required int folderId,
    required String userId,
  }) async =>
      await super
          .database
          .then(
            (database) => database.rawQuery(
              '''
                  SELECT
                    CASE WHEN
                      MAX_SORT_ORDER IS NULL THEN 0
                      ELSE MAX_SORT_ORDER + 1
                    END MAX_SORT_ORDER
                  FROM
                    (
                      SELECT
                        MAX(SORT_ORDER) MAX_SORT_ORDER
                      FROM
                        $table
                      WHERE
                        1 = 1
                        AND FOLDER_ID = ?
                        AND USER_ID = ?
                    )
                  ''',
              [
                folderId,
                userId,
              ],
            ),
          )
          .then((entity) =>
              entity.isEmpty ? 0 : entity[0]['MAX_SORT_ORDER'] as int);
}
