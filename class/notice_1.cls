<?php
	class notice_1 {

		/*----------------------------------------------------
		    コンストラクタ
		----------------------------------------------------*/
		function notice_1 () {

		}


		/*----------------------------------------------------
		  お知らせ内容の取得
		----------------------------------------------------*/
		function get_noticeData(  ){

			// ＤＢ名取得
			$DBName = get_DBName("base");

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.notice ";
			$sql .= "WHERE noticeID = '1' ";
			$ret  = sql_query( $sql , "single");

			// 日付変換
			$ret["updateDatetime"] = db2val_datetimeType1( $ret["updateDatetime"] );

			return $ret;
		}


		/*----------------------------------------------------
		  お知らせ内容の更新
		----------------------------------------------------*/
		function update_DB( $input ){
			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 優先度の更新
			$update["noticeText"]            = $input["noticeText"];
			$update["updateDatetime"]["com"] = "now()";

			$sql = "UPDATE {$DBName}.notice SET {update_set} WHERE noticeID = '1' ";
			sql_query( $sql, $update, "1" );
		}
	}



?>