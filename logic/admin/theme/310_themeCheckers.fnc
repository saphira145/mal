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
	    CHECK : themeIDExist
	----------------------------------------------------*/
	function CHECK_themeIDExist ( &$value, $key="", $arg="" ) {

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT themeID FROM {$DBName}.themeMst WHERE themeID = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["themeID"] != $value ) {
			unset ( $value );
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : themeMakerCodeExist
	----------------------------------------------------*/
	function CHECK_themeMakerCodeExist ( &$value, $key="", $arg="" ) {

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
	    CHECK : themeModelCodeExist
	----------------------------------------------------*/
	function CHECK_themeModelCodeExist ( &$value, $key="", $arg="" ) {

		if( empty($value) && empty($arg[0])){
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

	/*----------------------------------------------------
	    CHECK : themeBodyTypeExist
	----------------------------------------------------*/
	function CHECK_themeBodyTypeExist ( &$value, $key="", $arg="" ) {

		global $ini;

		// メーカーコードの取得
		$bodyType  = $arg[0];
		$makerCode = $arg[1];
		$modelCode = $value;

		if( empty($makerCode) && empty($modelCode) ){
			return NULL;
		}

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);
		$sql_escape["bodyType"]  = sql_escapeString($bodyType);

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		$sql  = "SELECT m.makerCode, m.modelCode, cg.bodyModel ";
		$sql .= "FROM {$DBName}.model as m ";
		$sql .= "INNER JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID = cg.carGradeID OR m.s4wdCarGradeID = cg.carGradeID ";
		$sql .= "WHERE m.makerCode = '{$sql_escape["makerCode"]}' AND m.modelCode = '{$sql_escape["modelCode"]}' AND cg.bodyModel = '{$sql_escape["bodyType"]}' ";
		$sql .= "GROUP BY m.makerCode, m.modelCode, cg.bodyModel ";
		$tbl  = sql_query( $sql, "single" );

		if ( $tbl["modelCode"] != $modelCode ) {
			unset ( $modelCode );
			return 1;
		}
	}

	/*----------------------------------------------------
	    CHECK : statusType
	----------------------------------------------------*/
	function CHECK_statusType ( &$value, $key="", $arg="" ) {

		if ( $value == "" ){
			return;
		}

		global $ini;

		for( $i=0; $i<count( $ini["themeStatus"] ); $i++ ){
			if ( $ini["themeStatus"][$i]["id"] == $value ){
				return;
			}
		}

		return 1;

	}



?>