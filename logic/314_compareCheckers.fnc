<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */

	/*----------------------------------------------------
	    CONVERT : modelNameToMakerCodeModelCode
	----------------------------------------------------*/
	function CONVERT_modelNameToMakerCodeModelCode ( &$value, $key="", $arg="" ) {

		if( $value == "" || $value == "-" || $value == "--" ) {
			$value = null;
			return NULL;
		}
        
		// ＤＢ名取得
		$DBName = get_DBName( "active" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT makerCode, modelCode FROM {$DBName}.model WHERE modelName = '{$sql_escape["value"]}' OR modelNameEng = '{$sql_escape["value"]}'";
		$tbl = sql_query( $sql, "single" );
        
		if( $tbl["makerCode"] != "" || $tbl["modelCode"] != "" ) {
			$value = "{$tbl["makerCode"]}-{$tbl["modelCode"]}";
		}

	}


	/*----------------------------------------------------
	    CONVERT : carGradeToCarGradeID
	----------------------------------------------------*/
	function CONVERT_carGradeToCarGradeID ( &$value, $key="", $arg="" ) {

		$value = preg_replace("/\D*/", "", $value);
	}


	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : makerCodeModelCodeExist
	----------------------------------------------------*/
	function FILTER_makerCodeModelCodeExist ( &$value, $key="", $arg="" ) {

		list( $makerCode, $modelCode ) = explode( "-", $value );

		if( $makerCode == "" && $modelCode == "" ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "active" );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		$sql = "SELECT * FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
		$tbl = sql_query( $sql, "single" );

		if( $tbl["makerCode"] == "" || $tbl["modelCode"] == "" ) {
			return 1;
		}
	}


	/*----------------------------------------------------
	    FILTER : carGradeIDActiveDBExist
	----------------------------------------------------*/
	function FILTER_carGradeIDActiveDBExist ( &$value, $key="", $arg="" ) {

		if( $value == "--" || $value == "-" ) {
			return 1;
		}

		list( $makerCode, $modelCode ) = explode( "-", $arg[0] );

		if( $makerCode == "" && $modelCode == "" || empty($value) ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "active" );

		// SQLインジェクション対応
		$sql_escape["value"]     = sql_escapeString($value);
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		// 車種グレードの確認
		$sql  = "SELECT m.* ";
		$sql .= "FROM {$DBName}.model as m ";
		$sql .= "INNER JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID = cg.carGradeID OR m.s4wdCarGradeID = cg.carGradeID ";
		$sql .= "WHERE m.makerCode = '{$sql_escape["makerCode"]}' AND m.modelCode = '{$sql_escape["modelCode"]}' AND carGradeID = '{$sql_escape["value"]}' ";
		$tbl  = (array)sql_query( $sql );

		if( count($tbl) == 0 ) {
			return 1;
		}

	}


	/* ==================================================================

	        C H E C K E R

	================================================================== */



?>