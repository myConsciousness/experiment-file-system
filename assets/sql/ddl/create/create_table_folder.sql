CREATE TABLE FOLDER (
  ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  PARENT_FOLDER_ID INTEGER NOT NULL,
  FOLDER_TYPE INTEGER NOT NULL,
  NAME TEXT NOT NULL,
  REMARKS TEXT NOT NULL,
  SORT_ORDER INTEGER NOT NULL,
  DELETED TEXT NOT NULL,
  CREATED_AT INTEGER NOT NULL,
  UPDATED_AT INTEGER NOT NULL
);
