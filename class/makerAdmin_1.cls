<?php


	class makerAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function makerAdmin () {

		}


		/*----------------------------------------------------
		    メーカー情報追加
		----------------------------------------------------*/
		function insert_DB ( $input ) {

			$insert["makerCode"]         = $input["makerInfo"]["makerCode"];
			$insert["makerName"]         = $input["makerInfo"]["makerName"];
			$insert["makerNameEng"]      = $input["makerInfo"]["makerNameEng"];
			$insert["countryID"]         = $input["makerInfo"]["countryID"];
			$insert["dispNum"]           = $input["makerInfo"]["dispNum"];

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql = "INSERT INTO {$DBName}.maker {insert_value};";
			list( $affected_row, $makerCode ) = sql_query( $sql, $insert, "1" );

			// 表示順登録
			$this->update_dispNum( $input["makerInfo"]["dispNum"], $insert["makerCode"] );

			return $affected_row;
		}


		/*----------------------------------------------------
		    表示順登録
		----------------------------------------------------*/
		function update_dispNum ( $dispNum, $makerCode ) {

			if ( $makerCode == ""
				|| $makerCode == "0" ){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);

			// 登録されたメーカー以外のリストを取得
			$sql = "SELECT makerCode, dispNum FROM {$DBName}.maker WHERE makerCode != '{$sql_escape["makerCode"]}' ORDER BY dispNum";
			$list = (array)sql_query( $sql );

			// 登録表示順がデータより大きい場合は最後の表示順＋１に変更
			if( $dispNum > $this->get_lastDispNum() ) {
				$update["dispNum"] = $this->get_lastDispNum() + 1;

				$sql = "UPDATE {$DBName}.maker SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}'";
				sql_query( $sql, $update, "1" );
			}
			else{
				for( $i=0; $i<count( $list ); $i++ ) {
					// 同じ表示順があった場合は間に新規登録されたほうを優先する
					if( $dispNum == $list[$i]["dispNum"] ) {
						$makerList[]["makerCode"] = $makerCode;
					}
					$makerList[]["makerCode"]   = $list[$i]["makerCode"];
				}

				// 表示順を更新する
				for( $i=0; $i<count( $makerList ); $i++ ) {
					$makerList[$i]["dispNum"] = $i + 1;
					$this->update_dispNumDB( $makerList[$i] );
				}
			}
		}


		/*----------------------------------------------------
		    最後の表示番号を取得
		----------------------------------------------------*/
		function get_lastDispNum () {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql = "SELECT dispNum FROM {$DBName}.maker ORDER BY dispNum DESC";
			$tbl = sql_query( $sql, "single" );

			$ret = sprintf( "%d", $tbl["dispNum"] );

			return $ret;
		}


		/*----------------------------------------------------
		    メーカー更新
		----------------------------------------------------*/
		function update_DB ( $input ) {

			if ( $input["makerCode"] == ""
				|| $input["makerCode"] == "0" ){
				return;
			}

			$update["makerName"]          = $input["makerName"];
			$update["makerNameEng"]       = $input["makerNameEng"];
			$update["countryID"]          = $input["countryID"];

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);

			$sql = "UPDATE {$DBName}.maker SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}'";
			sql_query( $sql, $update, "1" );
		}


		/*----------------------------------------------------
		    表示順更新
		----------------------------------------------------*/
		function update_dispNumDB ( $input ) {

			if ( $input["makerCode"] == ""
				|| $input["makerCode"] == "0" ){
				return;
			}

			$update["dispNum"]          = $input["dispNum"];

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);

			$sql = "UPDATE {$DBName}.maker SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}'";
			sql_query( $sql, $update, "1" );
		}


		/*----------------------------------------------------
		    メーカー情報削除
		----------------------------------------------------*/
		function delete_DB ( $input ) {

			if ( $input["makerCode"] == ""
				|| $input["makerCode"] == "0" ){
				return;
			}

			global $class;

			// メーカー情報と関連するデータ全て削除
			delete_makerInfoAndRelationData( $input["makerCode"] );

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 表示順更新
			$sql = "SELECT * FROM {$DBName}.maker ORDER BY dispNum";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {
				$list[$i]["dispNum"] = $i + 1;
				$this->update_dispNumDB( $list[$i] );
			}
		}


		/*----------------------------------------------------
		  メーカーリスト取得
		----------------------------------------------------*/
		function get_list ( $input="" ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM {$DBName}.maker ";
			$tbl = sql_query( $sql, "single" );

			$sql = "SELECT makerCode FROM {$DBName}.maker ORDER BY dispNum, makerCode";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {
				$list[$i] = $this->get_info( $list[$i]["makerCode"] );
			}

			return array( $list, $pageInfo );
		}


		/*----------------------------------------------------
		  メーカー情報取得
		----------------------------------------------------*/
		function get_info ( $makerCode ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);

			$sql = "SELECT * FROM {$DBName}.maker WHERE makerCode = '{$sql_escape["makerCode"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}
	}

?>