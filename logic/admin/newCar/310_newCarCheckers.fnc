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
	    CHECK : newCarMakerCodeExist
	----------------------------------------------------*/
	function CHECK_newCarMakerCodeExist ( &$value, $key="", $arg="" ) {

		if( empty($value) ){
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT makerCode FROM {$DBName}.maker WHERE makerCode = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["makerCode"] != $value ) {
			unset ( $value );
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : newCarModelCodeExist
	----------------------------------------------------*/
	function CHECK_newCarModelCodeExist ( &$value, $key="", $arg="" ) {

		if( empty($value) ){
			return NULL;
		}
		// メーカーコードの取得
		$makerCode = $arg[0];

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"]     = sql_escapeString($value);
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		$sql = "SELECT modelCode FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["modelCode"] != $value ) {
			unset ( $value );
			return 1;
		}


	}




?>