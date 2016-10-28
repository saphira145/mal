<?php



	/*----------------------------------------------------
	  テーブル名を指定して日付の登録
	----------------------------------------------------*/
	function update_datetimeBySelectTableIDFiledName ( $tableID, $filed, $updateDatetime="" ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		if( $updateDatetime == "" ) {
			$updateDatetime = date( "Y-m-d H:i:s" );
		}

		// SQLインジェクション対応
		$sql_escape["tableID"] = sql_escapeString($tableID);

		$sql = "SELECT * FROM {$DBName}.tableAdmin WHERE tableID = '{$sql_escape["tableID"]}'";
		$tbl = (array)sql_query( $sql, "single" );

		$filedName = "$filed" . "Datetime";

		$DBdata["$filedName"]  = $updateDatetime;

		if( count( $tbl ) > 0 ){
			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set} WHERE tableID = '{$sql_escape["tableID"]}'";
		}
		else{
			$DBdata["tableID"]  = $tableID;
			$sql = "INSERT INTO {$DBName}.tableAdmin {insert_value};";
		}

		sql_query( $sql, $DBdata );

	}



	/*----------------------------------------------------
	  テーブル名を指定して更新情報取得
	----------------------------------------------------*/
	function get_tableAdminInfo ( $tableID ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		// SQLインジェクション対応
		$sql_escape["tableID"] = sql_escapeString($tableID);

		$sql = "SELECT * FROM {$DBName}.tableAdmin WHERE tableID = '{$sql_escape["tableID"]}'";
		$ret = sql_query( $sql, "single" );

		// 日付変換
		$ret["workDatetime"]    = db2val_datetimeType1( $ret["workDatetime"] );
		$ret["activeDatetime"]  = db2val_datetimeType1( $ret["activeDatetime"] );
		$ret["reserveDatetime"] = db2val_datetimeType1( $ret["reserveDatetime"] );


		return $ret;
	}



	/*----------------------------------------------------
	  最新の本番予定日時を取得
	----------------------------------------------------*/
	function get_newReserveDatetime () {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin WHERE reserveDatetime != '0000-00-00 00:00:00' ORDER BY reserveDatetime DESC LIMIT 1";
		$ret = sql_query( $sql, "single" );

		if( $ret["reserveDatetime"] == "" ) {
			return NULL;
		}


		return $ret["reserveDatetime"];
	}




?>