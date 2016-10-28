<?php


	class newCarAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function newCarAdmin_1 () {

		}


		/*----------------------------------------------------
		    更新
		----------------------------------------------------*/
		function update_DB ( $input ) {
			global $class;

			if ( $input["newCarInfo"]["carNum"] == "" || $input["newCarInfo"]["carNum"] == "0" ){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["carNum"] = sql_escapeString($input["newCarInfo"]["carNum"]);

			// 既に登録されているか？
			$sql = "SELECT newCarNum FROM {$DBName}.newCar WHERE newCarNum = '{$sql_escape["carNum"]}'";
			$tbl = sql_query( $sql, "single" );

			$DBInfo["makerCode"]             = $input["newCarInfo"]["makerCode"];
			$DBInfo["modelCode"]             = $input["newCarInfo"]["modelCode"];
			$DBInfo["updateDatetime"]["com"] = "now()";
			$DBInfo["updateMemberID"]        = $class["session"]->memberID;

			// 更新
			if( $tbl["newCarNum"] > 0 ) {
				$sql = "UPDATE {$DBName}.newCar SET {update_set} WHERE newCarNum = '{$sql_escape["carNum"]}'";

			}
			// 登録
			else{
				$DBInfo["newCarNum"]          = $input["newCarInfo"]["carNum"];
				$sql = "INSERT INTO {$DBName}.newCar {insert_value};";
			}
			sql_query( $sql, $DBInfo, "1" );

		}


		/*----------------------------------------------------
		   リスト取得
		----------------------------------------------------*/
		function get_list ( $lixtCnt=3 ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["lixtCnt"] = sql_escapeString($lixtCnt);

			$sql = "SELECT * FROM {$DBName}.newCar ORDER BY newCarNum LIMIT {$sql_escape["lixtCnt"]}";
			$list = (array)sql_query( $sql );

			return $list;
		}
	}

?>