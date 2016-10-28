<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */

	/*----------------------------------------------------
	    CONVERT : sortNumeric
	----------------------------------------------------*/
	function CONVERT_sortNumeric ( &$value, $key="", $arg="" ) {
		
		if( empty($value) ) {
			$value = null;
			return;
		}

		if( strpos( $value, "," ) !== false ){
			$explodeList = explode(",", $value);

			for( $i = 0, $iMax = count($explodeList); $i < $iMax; $i++ ){
				list($checkKey) = explode(" ", $explodeList[$i]);

				$tmpValue[] = preg_replace("/\D*/", "", $checkKey);
			}
		} else {
			$tmpValue[] = $value;
		}

		$value = @implode( ",", $tmpValue );
	}








	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : makerCodeExist
	----------------------------------------------------*/
	function FILTER_makerCodeExist ( &$value, $key="", $arg="" ) {

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



	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/*----------------------------------------------------
	    CHECK : argEqualMust
	----------------------------------------------------*/
	function CHECK_argEqualMust ( &$value, $key="", $arg="" ) {

		$makerCode  = $arg[0];
		$targetID = $arg[1];

		if( $targetID != $makerCode ) {
			return NULL;
		}

		if( $value == "" ) {
			unset ( $value );
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : dupMakerCode
	----------------------------------------------------*/
	function CHECK_dupMakerCode ( &$value, $key="", $arg="" ) {

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT makerCode FROM {$DBName}.maker WHERE makerCode = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["makerCode"] > 0 ) {
			unset ( $value );
			return 1;
		}

	}







?>