#!/bin/bash
echo "F5 SITES Mysql Manager, Sync Posts (Download/Upload Latest Posts) (linux to linux)"
echo "Don't forget to manually set and copy config-example.sh to config.sh"
echo "Hi, $USER"

echo "What database you want to sync? Write database name and hit enter"
echo "Please hit enter for fnetwok database, or tip database name"
read DATABASENAME

if [ "$DATABASENAME"=="" ]; then
echo "Using default fnetwork database"
DATABASENAME="fnetwork"
fi


# Configuration file
echo "Load configuration file... (to change settings open config.sh)"
source config.sh

POSTS_TABLE=$WP_PREFIX"posts"

echo "Looking for last post_id local..."
LAST_ID_LOCAL=$(mysql fnetwork -u $MYSQL_USER_LOCAL -p$MYSQL_PASS_LOCAL -se "SELECT ID FROM $POSTS_TABLE ORDER BY ID DESC LIMIT 1")
echo "LOCAL (last id): $LAST_ID_LOCAL"

echo "Connecting to remote server for last post_id remote..."
LAST_ID_REMOTE=$(ssh $SSH_USER@$IP "mysql fnetwork -u $MYSQL_USER_REMOTE -p$MYSQL_PASS_REMOTE -se 'SELECT ID FROM $POSTS_TABLE ORDER BY ID DESC LIMIT 1'")
echo "REMOTE (last id): $LAST_ID_REMOTE"

#if ["$LAST_ID_LOCAL"="$LAST_ID_REMOTE"];
if [ "$LAST_ID_LOCAL" == "$LAST_ID_REMOTE" ]; then
echo "Already synched, nothing to do, quiting..."
echo "quit"
else 
	if [ "$LAST_ID_LOCAL" < "$LAST_ID_REMOTE" ]; then
	echo "Local posts is ahead of remote, uploading posts to remote server..."
	echo "WARNING, ALL DATABASE WILL BE SYNCHED (not only posts)..."
	source sync-local-to-remote.sh
	else
	echo "Remote posts is ahead of local, downloading posts to local server..."
	echo "WARNING, ALL DATABASE WILL BE SYNCHED (not only posts)..."
	#source sync-posts-remote-to-local.sh
	source sync-remote-to-local.sh
	fi

fi


#2 - busca o ultimo post id remote
#3 - compara a diferenca
#4 - prepara o pacote 
#4.1 - consulta post_meta e tudo relacionado ao ID de cada um que der diferente
#5 - faz copia de seguranca
#6 - sobrescreve

#echo "connecting to a remote server to dump a copy of a database..."
#ssh $SSH_USER@$IP "mysqldump -u $MYSQL_USER_REMOTE -p$MYSQL_PASS_REMOTE --lock-tables=false  --databases --add-drop-database --compatible=mysql4,no_table_options --default-character-set=utf8 $DATABASENAME | gzip > /tmp/$DATABASENAME-remote.sql.gz"

#echo "downloading and extracting database..."
#scp $SSH_USER@$IP:/tmp/$DATABASENAME-remote.sql.gz /tmp/$DATABASENAME-remote.sql.gz
#gunzip -fv /tmp/$DATABASENAME-remote.sql.gz 

#echo "dumping a safety copy from local database..."
#mysqldump -u $MYSQL_USER_LOCAL -p$MYSQL_PASS_LOCAL --lock-tables=false --databases --add-drop-database --compatible=mysql4,no_table_options --default-character-set=utf8 $DATABASENAME | gzip -v > /tmp/$DATABASENAME-local-safe-copy.sql.gz

#echo "importing and replace local data with remote..."
#mysql -u $MYSQL_USER_LOCAL -p$MYSQL_PASS_LOCAL $DATABASENAME < /tmp/$DATABASENAME-remote.sql

#echo "sync-local-to-remote.sh ended."
echo "by Francisco Matelli Matulovic | franciscomat.com | f5sites.com"