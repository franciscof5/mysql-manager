#!/bin/bash
echo "Dumping a diff file for $DATABASENAME to: $LOCAL_TEMP_DIR..."
diff $LOCAL_TEMP_DIR/$DATABASENAME$TABLES_SELECTED-local.sql $LOCAL_TEMP_DIR/$DATABASENAME$TABLES_SELECTED-remote.sql > $LOCAL_TEMP_DIR/$DATABASENAME$TABLES_SELECTED-diff.sql
gedit $LOCAL_TEMP_DIR/$DATABASENAME$TABLES_SELECTED-diff.sql
