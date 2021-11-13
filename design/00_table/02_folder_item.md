# Folder Item

## Overview

| Physical Name | Logical Name   | Remarks                          |
| ------------- | -------------- | -------------------------------- |
| folder_item   | フォルダー項目 | フォルダーの項目情報を管理する。 |

## Definition

| Physical Name | Logical Name  | PK  | U   | NN  | Type    | Remarks                                  |
| ------------- | ------------- | --- | --- | --- | ------- | ---------------------------------------- |
| ID            | ユニーク ID   | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                  |
| FOLDER_ID     | フォルダー ID | -   | -   | ✓   | INTEGER | 項目に紐づくフォルダーの外部キー。       |
| ITEM_ID       | 項目 ID       | -   | -   | ✓   | TEXT    | フォルダー項目に紐づくデータの外部キー。 |
| REMARKS       | 備考          | -   | -   | ✓   | TEXT    | 項目の備考。                             |
| SORT_ORDER    | 並び順        | -   | -   | ✓   | INTEGER | 項目の並び順。                           |
| DELETED       | 削除          | -   | -   | ✓   | TEXT    | フォルダー項目の削除状態を示すフラグ。   |
| CREATED_AT    | 作成日時      | -   | -   | ✓   | INTEGER | レコードの作成日時。                     |
| UPDATED_AT    | 更新日時      | -   | -   | ✓   | INTEGER | レコードの更新日時。                     |
