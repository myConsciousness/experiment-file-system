// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum CreateTableStatement {
  /// The folder table
  folder,

  /// The folder item table
  folderItem,
}

extension CreateTableStatementExt on CreateTableStatement {
  String get path {
    switch (this) {
      case CreateTableStatement.folder:
        return 'assets/sql/ddl/create/create_table_folder.sql';
      case CreateTableStatement.folderItem:
        return 'assets/sql/ddl/create/create_table_folder_item.sql';
    }
  }
}
