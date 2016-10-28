<?php


	class releaseAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function releaseAdmin () {

		}


		/*----------------------------------------------------
		    リリース日更新
		----------------------------------------------------*/
		function update_reserveDB ( $input ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			$update["reserveDatetime"] = val2db_datetime( $input["reserveInfo"]["reserveDatetime"] );

			// 更新
			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set}";

			sql_query( $sql, $update, "1" );
		}


		/*----------------------------------------------------
		    リリース日削除
		----------------------------------------------------*/
		function delete_reserveDB () {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 現在より１５以内のリリース時間か？
			$toDatetime   = date( "Y-m-d H:i:s", mktime( date( "H"), date( "i") + $ini["reserveSet"]["limit"], date( "s"), date( "m"), date( "d"), date( "Y") ) );

			// リリース予定日取得
			$sql_escape["toDatetime"] = sql_escapeString($toDatetime);

			$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin WHERE reserveDatetime <= '{$sql_escape["toDatetime"]}' AND reserveDatetime != '0000-00-00 00:00:00'";
			$tbl = (array)sql_query( $sql , "single" );

			// 現在より１５以内の場合ロールバックフラグをオフにする
			if( count( $tbl ) > 0 ) {
				change_rollBackDBLockFlg( 0 );
			}

			// リリース日時クリア
			$update["reserveDatetime"]          = "0000-00-00 00:00:00";

			// 更新
			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set}";
			sql_query( $sql, $update, "1" );
		}


		/*----------------------------------------------------
		    前回のデータに戻す
		----------------------------------------------------*/
		function back_activeSW () {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// ロールバックフラグはオンか？
			$flg = get_DBLockFlg ( "rollbackFlg" );
			// ロールバックフラグはオフだったら処理しない
			if( $flg == 0 ) {
				return NULL;
			}

			// 現在どのＤＢがアクティブか？
			$num = get_activeDBNum ();

			// アクティブＤＢの切り替え
			if( $num == 1 ) {
				change_activeDB ( 2 );
			}
			else{
				change_activeDB ( 1 );
			}

			// ロールバックフラグをオフ
			change_rollBackDBLockFlg( 0 );

			return 1;
		}


		/*----------------------------------------------------
		   リリース日時取得
		----------------------------------------------------*/
		function get_reserveInfo () {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin";
			$ret = sql_query( $sql, "single" );

			$ret["reserveDatetime"] = db2val_datetimeType1( $ret["reserveDatetime"] );

			return $ret;
		}




		/*----------------------------------------------------
		  モード変更
		----------------------------------------------------*/
		function change_dispMode () {

			// クッキーをチェック
			$testFlg = get_dispModeFlg();;

			if( $testFlg != 1 ) {
				// テスト表示モード
				$this->set_testMode();
				return 1;
			}
			else{
				// 通常表示モード
				$this->set_defaultMode();
				return 9;
			}

		}



		/*----------------------------------------------------
		  テスト表示モード
		----------------------------------------------------*/
		function set_testMode () {

			global $path;

			$cookie["name"]       = "testDispMode";
			$cookie["value"]      = "ON";
			$cookie["timeout"]    = "0";
			$cookie["path"]       = "/";
			$cookie["domain"]     = $path["host"]["name"];

			// クッキーの設定
			setcookie( $cookie["name"], $cookie["value"], $cookie["timeout"], $cookie["path"], $cookie["domain"] );

		}



		/*----------------------------------------------------
		  通常表示モード
		----------------------------------------------------*/
		function set_defaultMode () {

			global $path;

			setcookie( "testDispMode", "", time()-3600, "/", $path["host"]["name"] );

		}
	}



?>