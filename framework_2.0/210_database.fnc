<?php

	// ### Version Data ### database.fnc 1.00.00

	/*----------------------------------------------------
	    ＤＢ関連ファンクション群
	----------------------------------------------------*/

	/*----------------------------------------------------
	    DB接続
	            db_use 設定は unit 単位
	----------------------------------------------------*/
	function connect_db() {

		global $ini;

		if ( $ini["db_use"] != "no" ) {

			// DBに接続
//			if( !$con["db"] = mysql_pconnect( $ini["db"]["host"], $ini["db"]["user"], $ini["db"]["pass"] ) ) {
			if( !$con["db"] = mysql_connect( $ini["db"]["host"], $ini["db"]["user"], $ini["db"]["pass"] ) ) {
				$ini["fwerr"][][1] = "接続失敗";
				fw_exit;
			}

			// DBを選択
			if( !mysql_select_db( $ini["db"]["db"], $con["db"] ) ) {
				$ini["fwerr"][][1] = "データベース選択失敗";
				fw_exit;
			}

			// MySQL文字コード設定
			mysql_set_charset( 'utf8' );

		}

	}



	/*----------------------------------------------------
		SQL の発行
			※ticOptionが1でdbTicは必須となる
	----------------------------------------------------*/
	function sql_query( $sql, $second='', $ticOption='' ) {

		if ( $ticOption == "1" || $ticOption == "use_dbTicket" ){
			if ( !is_dbTicket() ){
//				echo "<br>\n<br>\nDBチケットが設定されていません！<br>\n<br>\n";
				return;
			}
		}

		$command = abstract_command( $sql );

		switch( $command ) {

			case "SELECT":
				if ( $second == "single" || $second == "multiple" ) {
					$select_type = $second;
				}
				return select_query( $sql, $select_type );
				break;

			case "ADDON":
				//使用していないのでコメントアウト
				//addon_query( $sql, $second );
				return;
				break;

			case "UPDATE":
				$return = update_query( $sql, $second );
				return $return;
				break;

			case "INSERT":
				return insert_query( $sql, $second );
				break;

			default:
				return other_query( $sql );

		}

	}



			/*----------------------------------------------------
				コマンド種類の取得
			----------------------------------------------------*/
			function abstract_command( $sql ) {

				preg_match( "/^([^ ]+)/", $sql, $matches );
				return strtoupper( $matches[1] );

			}


			/*----------------------------------------------------
				SELECT文の実行
			----------------------------------------------------*/
			function select_query( $sql, $select_type="multiple" ) {

				global $last_sql;
				$last_sql = $sql;

				$result = @mysql_query( $sql );
				$mnr = @mysql_num_rows( $result );
				if ( $mnr == 0 ){
					return;
				}
				else {
					while( $row = @mysql_fetch_array( $result, MYSQL_ASSOC ) ) {
						$tbl[] = $row;
					}
				}

				@mysql_free_result( $result );


				if ( $select_type === "single" ) {
					return $tbl[0];
				}
				else {
					return $tbl;
				}

			}


			/*----------------------------------------------------
				ADDON文の実行
			----------------------------------------------------*/
			function addon_query( $sql, $update ) {

				global $last_sql;

				preg_match ( "/(ADDON)\s+([^\s]+)\s+((WHERE)\s+(.*))?/", $sql, $match );

				if ( $match[4] == "WHERE" ) {
					$sql = "SELECT * FROM $match[2] WHERE $match[5]";
					$tbl = (array)sql_query ( $sql );
					if ( count ( $tbl ) > 0 ) {
						$sql = "UPDATE $match[2] SET {update_set} WHERE $match[5]";
						sql_query ( $sql, 0, '', $update );
						return;
					}
				}

				$sql = "INSERT INTO $match[2] {insert_value}";
				sql_query ( $sql, 0, '', $update );

			}


			/*----------------------------------------------------
				UPDATE文の実行
			----------------------------------------------------*/
			function update_query( $sql, $update ) {

				global $last_sql;

				$update_set = create_update_set( $update );

				$sql = mb_ereg_replace( "\{update_set\}", $update_set, $sql );
				$last_sql = $sql;
				$result = @mysql_query( $sql );

				$affected_row = @mysql_affected_rows();

				@mysql_free_result( $result );


				return $affected_row;

			}


					/*----------------------------------------------------
						UPDATE-SETの生成
					----------------------------------------------------*/
					function create_update_set( $update ) {

						if ( is_array ( $update ) ) {
							foreach( $update as $name => $value ) {
								if ( is_array( $value ) ) {
									if ( $value["com"] != "AVOID" ) {
										$update_set_array[] = "${name}={$value["com"]}";
									}
								}
								else {
									$update_set_array[] = "${name}=\"".mysql_real_escape_string( $value ).'"';
								}
							}

							return @join( ", ", $update_set_array );

						}

					}


			/*----------------------------------------------------
				INSERT文の実行
			----------------------------------------------------*/
			function insert_query( $sql, $update='' ) {

				global $last_sql;

				$insert_value = create_insert_value( $update );
				$sql = mb_ereg_replace ( "\{insert_value\}", $insert_value, $sql );
				$last_sql = $sql;
				$result = @mysql_query( $sql );
				$affected_row = @mysql_affected_rows();
				$insert_id    = @mysql_insert_id();

				@mysql_free_result( $result );


				return array( $affected_row, $insert_id );

			}


					/*----------------------------------------------------
						INSERT-VALUEの生成
					----------------------------------------------------*/
					function create_insert_value( $update ) {

						if ( !is_array( $update ) ) { return; }

						foreach( $update as $name => $value ) {
							if ( is_array( $value ) ) {
								if ( $value["com"] != "AVOID" ) {
									$insert_field_array[] = $name;
									$insert_value_array[] = $value["com"];
								}
							}
							else {
								$insert_field_array[] = $name;
//								$insert_value_array[] = "'". addslashes( mysql_real_escape_string( $value )) . "'";
								$insert_value_array[] = '"'. mysql_real_escape_string( $value ) . '"';
							}
						}

						$insert_field = "( ".@join( ", ", $insert_field_array )." )";
						$insert_value = "( ".@join( ", ", $insert_value_array )." )";

						return $insert_field." VALUES ".$insert_value;

					}


			/*----------------------------------------------------
				その他のSQL文の実行
			----------------------------------------------------*/
			function other_query( $sql ) {

				global $last_sql;
				$last_sql = $sql;

				$result = @mysql_query( $sql );
				$affected_row = @mysql_affected_rows();
				@mysql_free_result( $result );

				return $affected_row;

			}


	/*----------------------------------------------------
		DBチケットの存在チェック
	----------------------------------------------------*/
	function is_dbTicket () {

		global $ini;

		if ( $ini["dbTicket"]["full"] == "" && strlen( $_POST["dbTicket"] ) == 38 && preg_match ( "#^{$ini["dbTicketKey"]}#", $_POST["dbTicket"] ) ) {
			$ini["dbTicket"]["full"] = $_POST["dbTicket"];
		}

		if ( $ini["dbTicket"]["full"] != "" ) {
			list ( $ini["dbTicket"]["key"], $ini["dbTicket"]["uniqueNumber"] ) = explode ( "__", $ini["dbTicket"]["full"] );

			// SQLインジェクション対応
			$sql_escape["key"]          = sql_escapeString($ini["dbTicket"]["key"]);
			$sql_escape["uniqueNumber"] = sql_escapeString($ini["dbTicket"]["uniqueNumber"]);

			$sql = "SELECT timestamp FROM dbTicket WHERE ticketKey = '{$sql_escape["key"]}' AND uniqueNumber = '{$sql_escape["uniqueNumber"]}'";
			$tbl = sql_query ( $sql, "single" );
		}

		$ini["dbTicket"]["time"] = $tbl["timestamp"];
		$ini["dbTicket"]["timeNumber"] = (int)preg_replace ( "#-| |:#", "", $ini["dbTicket"]["time"] );
		if ( $ini["dbTicket"]["timeNumber"] > 0 ) {
			return true;
		}


		return false;


	}


	/*----------------------------------------------------
		DBチケットの発行
	----------------------------------------------------*/
	function issue_dbTicket() {

		global $ini, $class;

		clean_dbTicketFromDB ();

		$ini["dbTicket"]["uniqueNumber"] = sprintf( "%06d", rand(0,999999) ) . date("_YmdHis");

		// DBにDBチケットデータを格納
		$insert["ticketKey"]    = $ini["dbTicket"]["key"];
		$insert["uniqueNumber"] = $ini["dbTicket"]["uniqueNumber"];

		if ( $class["session"]->memberID > 0 ) {
			$insert["memberID"]   =  $class["session"]->memberID;
		}

		$sql = "INSERT INTO dbTicket {insert_value};";
		list( $affected_row, $insert_id ) = sql_query( $sql, $insert );

		$ini["dbTicket"]["full"] = $ini["dbTicket"]["key"] . "__" . $ini["dbTicket"]["uniqueNumber"];

	}


	/*----------------------------------------------------
		DBチケットの解放
	----------------------------------------------------*/
	function drop_dbTicket () {

		global $ini;

		if ( is_dbTicket() ) {
			// SQLインジェクション対応
			$sql_escape["key"]          = sql_escapeString($ini["dbTicket"]["key"]);
			$sql_escape["uniqueNumber"] = sql_escapeString($ini["dbTicket"]["uniqueNumber"]);

			$sql = "DELETE FROM dbTicket WHERE ticketKey = '{$sql_escape["key"]}' AND uniqueNumber = '{$sql_escape["uniqueNumber"]}'";
			sql_query ( $sql );
		}

		unset($ini["dbTicket"]["full"]);
		unset($ini["dbTicket"]["uniqueNumber"]);

	}


	/*----------------------------------------------------
		DBから古いDBチケットを削除
	----------------------------------------------------*/
	function clean_dbTicketFromDB () {

		$sql = "DELETE FROM dbTicket WHERE timestamp < date_sub( now(), interval 1440 minute )";
		sql_query ( $sql );

	}


	/*----------------------------------------------------
		文字列をエンコードする
	----------------------------------------------------*/
	function sql_escapeString( $value ){
		return mysql_real_escape_string( stripslashes($value) );
	}


?>