#!/bin/bash
#
# @(#) apply.sh 2014-02-12
#
# USAGE:
#   apply.sh
#
# DESCRIPTION:
#   三菱オートリース「Car sagacité」の車種諸元情報を元に
#   バリューを自動適用する.
#
#   適用時に実行する SQL 文は, テキストファイル
#   [車種バリューID].sql
#   に記述し, 本スクリプトと同一ディレクトリに設置する.
#   同ファイルは
#   - 文字エンコード: UTF-8 (BOM無し)
#   - 改行コード: LF または CR+LF
#   で作成すること.
#
#   例) 適用対象の車種バリュー ID が 123 の場合,
#   123.sql
#   というファイル名に記述し, 保存する.
#
#   crontab に登録する例を以下に示す.
#   */15 * * * * /bin/bash /var/www/sagacite/_bat/valueAutoApply/apply.sh 2>&1 >/var/www/sagacite/log/valueAutoApply_`/bin/date +\%Y\%m\%d`.log
#
# CHANGELOG:
#   2014-02-12  井上 義勝 <y-inoue@hoyusys.co.jp>
#     * 適用データベースを Work のみに変更.
#   2014-01-31  井上 義勝 <y-inoue@hoyusys.co.jp>
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

# MySQL クライアント
MYSQL="/usr/bin/mysql --user=${DB_USER} --password=${DB_PASSWD}"

for SQLFILE in ${DIR}/[0-9]*.sql; do
	# パスを除いた SQL 文のファイル名
	FILEBASE=$(basename ${SQLFILE})
	# バリュー(テーマ)ID
	ID=${FILEBASE%%.sql}

#	for DB in Work _1 _2; do
	for DB in Work; do
		# 対象 DB 名
		DB_NAME=${DB_PREFIX}${DB}

		# バリューを初期化
		echo 'DELETE FROM carTheme WHERE themeID = '${ID} | ${MYSQL} ${DB_NAME}
		echo [$(/bin/date +"%Y-%m-%d %H:%M:%S")] themeID ${ID} initialized on ${DB_NAME}.

		# 適用 SQL 文投入
		${MYSQL} ${DB_NAME} < ${SQLFILE}
		echo [$(/bin/date +"%Y-%m-%d %H:%M:%S")] themeID ${ID} renewed on ${DB_NAME}.
	done
done
