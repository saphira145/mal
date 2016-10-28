<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */









	/* ==================================================================

	        F I L T E R

	================================================================== */










	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/*----------------------------------------------------
	    CHECK : importCSVMast
	----------------------------------------------------*/
	function CHECK_importCSVMast ( &$value, $key="", $arg="" ) {

		$file_name = $arg[0];

		if( $file_name == "" ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : importCSVExtension
	----------------------------------------------------*/
	function CHECK_importCSVExtension ( &$value, $key="", $arg="" ) {

		global $ini;

		$file_name = $arg[0];

		// 未入力時はチェックしない
		if( $file_name == "" ) {
			return;
		}

		list( $name, $extension ) = explode( ".", $file_name );

		// 小文字に変換
		$extension = strtolower( $extension );

		if( "$extension" != "{$ini["csv"]["extension"]}" ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : importCSVSize
	----------------------------------------------------*/
	function CHECK_importCSVSize ( &$value, $key="", $arg="" ) {

		global $ini;

		$size = $arg[0];

		// 未入力時はチェックしない
		if( $size == "" ) {
			return;
		}

		if( $size > $ini["csv"]["maxSize"] ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : reserveLimit
	    リリース予定時間が３０分以内か？
	----------------------------------------------------*/
	function CHECK_reserveLimit ( &$value, $key="", $arg="" ) {

		global $ini;

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$fromDatetime = date( "Y-m-d H:i:s" );
		$toDatetime   = date( "Y-m-d H:i:s", mktime( date( "H"), date( "i") + $ini["reserve"]["limit"], date( "s"), date( "m"), date( "d"), date( "Y") ) );

		// SQLインジェクション対応
		$sql_escape["toDatetime"]   = sql_escapeString($toDatetime);
		$sql_escape["fromDatetime"] = sql_escapeString($fromDatetime);

		// リリース予定日取得
		$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin WHERE reserveDatetime >= '{$sql_escape["fromDatetime"]}' AND reserveDatetime <= '{$sql_escape["toDatetime"]}' AND reserveDatetime != '0000-00-00 00:00:00'";
		$tbl = (array)sql_query( $sql , "single" );

		if( count( $tbl ) > 0 ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : workLock
	    更新ＤＢにロックがかかっているか？
	    0 => オフ、1 => オン
	----------------------------------------------------*/
	function CHECK_workLock ( &$value, $key="", $arg="" ) {

		global $ini;

		$lockFlg = get_DBLockFlg ( "workDBLockFlg" );

		if( $lockFlg == 1 ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : testLock
	    更新ＤＢにロックがかかっているか？
	    0 => オフ、1 => オン
	----------------------------------------------------*/
	function CHECK_testLock ( &$value, $key="", $arg="" ) {

		global $ini;

		$lockFlg = get_DBLockFlg ( "testDBLockFlg" );

		if( $lockFlg == 1 ) {
			return 1;
		}

	}





?>