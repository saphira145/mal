#!/bin/bash
#
# @(#) backupDB.sh 2014-02-13
#
# USAGE:
#   backupDB.sh
#
# DESCRIPTION:
#   三菱オートリース「Car sagacité」の DB をダンプし、
#   gzip 圧縮する.
#
#   crontab に登録する例を以下に示す.
#   54 3 * * * /bin/bash /var/www/sagacite/_bat/DB_backup/backupDB.sh 2>&1
#
# CHANGELOG:
#   2014-02-13  井上 義勝 <y-inoue@hoyusys.co.jp>
#     * 作成.
#
############################################################
# 本スクリプトのディレクトリ
# 相対パスになる場合があるので注意
DIR=$(dirname $0)

# PHP フレームワークの DB 設定ファイル
# 本スクリプトからの相対パスで指定する
INIFILE="${DIR}/../../logic/110_database.ini"

# DB 名の接頭辞
DB_PREFIX='mal_compare'

# DB 接続用 ID
DB_USER=$(grep 'db.user' ${INIFILE} | cut -d'"' -f2)

# DB 接続用パスワード
DB_PASSWD=$(grep 'db.pass' ${INIFILE} | cut -d'"' -f2)

# mysqldump
MYSQLDUMP="/usr/bin/mysqldump --user=${DB_USER} --password=${DB_PASSWD} --default-character-set=utf8 --skip-lock-tables"

# gzip
GZIP="/bin/gzip"

# バックアップを保持する日数
DAYS=14

# 一定期間を過ぎたファイルを消す
find ${DIR} -mtime +${DAYS} -name DB_*.gz -print0 | xargs -t -r -0 echo rm
#echo [$(/bin/date +"%Y-%m-%d %H:%M:%S")] ${FILE} deleted.

# ダンプファイル作成
for DB in Base Work _1 _2; do
	# 対象 DB 名
	DB_NAME=${DB_PREFIX}${DB}
	# ダンプ先
	DUMP_FILE="${DIR}/DB_"$(/bin/date +"%Y%m%dT%H%M%S")"_${DB_NAME}.gz"
	${MYSQLDUMP} ${DB_NAME} | ${GZIP} > ${DUMP_FILE}
#	echo [$(/bin/date +"%Y-%m-%d %H:%M:%S")] ${DB_NAME} dumped to ${DUMP_FILE}.
done
