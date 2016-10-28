<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */









	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : carGradeExist
	----------------------------------------------------*/
	function FILTER_carGradeExist ( &$value, $key="", $arg="" ) {

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT carGradeID FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["carGradeID"] != $value ) {
			unset ( $value );
			return 1;
		}

	}




	/*----------------------------------------------------
	    FILTER : carGradeExistCodeChk
	----------------------------------------------------*/
	function FILTER_carGradeExistCodeChk ( &$value, $key="", $arg="" ) {

		if( ( empty($arg[0]) && empty($arg[1])) || empty($value) ){
			return null;
		}

		$makerCode = $arg[0];
		$modelCode = $arg[1];

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"]     = sql_escapeString($value);
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		$sql = "SELECT carGradeID FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["value"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["carGradeID"] != $value ) {
			unset ( $value );
			return 1;
		}

	}








	/* ==================================================================

	        C H E C K E R

	================================================================== */




?>