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
	    CHECK : mustArg
	----------------------------------------------------*/
	function CHECK_mustArg ( $value, $key="", $arg="" ) {

		for( $i = 0; $i < count( $arg ); $i++ ){
			if( $arg[$i] == "" ){
				return 1;
			}
		}

	}


	/*----------------------------------------------------
	    CHECK : reserveLimit
	    リリース予定時間が１５分以内か？
	----------------------------------------------------*/
	function CHECK_reserveLimit ( &$value, $key="", $arg="" ) {

		global $ini;

		$year  = sprintf( "%04d", $arg[0] );
		$month = sprintf( "%02d", $arg[1] );
		$day   = sprintf( "%02d", $arg[2] );
		$hour  = sprintf( "%02d", $arg[3] );
		$min   = sprintf( "%02d", $arg[4] );
		$sec   = sprintf( "%02d", $arg[5] );

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$fromDatetime = "$year-$month-$day $hour:$min:$sec";
		$toDatetime   = date( "Y-m-d H:i:s", mktime( date( "H"), date( "i") + $ini["reserveSet"]["limit"], date( "s"), date( "m"), date( "d"), date( "Y") ) );

		if( "$fromDatetime" <= "$toDatetime" ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : setReserveLimit
	    すでに設定されているリリース予定時間が３０分以内か？
	----------------------------------------------------*/
	function CHECK_setReserveLimit ( &$value, $key="", $arg="" ) {

		global $ini;

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$toDatetime   = date( "Y-m-d H:i:s", mktime( date( "H"), date( "i") + $ini["reserveSet"]["limit"], date( "s"), date( "m"), date( "d"), date( "Y") ) );

		// SQLインジェクション対応
		$sql_escape["toDatetime"] = sql_escapeString($toDatetime);

		// リリース予定日取得
		$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin WHERE reserveDatetime <= '{$sql_escape["toDatetime"]}' AND reserveDatetime != '0000-00-00 00:00:00'";
		$tbl = (array)sql_query( $sql , "single" );

		if( count( $tbl ) > 0 ) {
			return 1;
		}

	}






?>