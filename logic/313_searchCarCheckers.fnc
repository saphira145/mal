<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */
	/*----------------------------------------------------
	    CONVERT : paramExplode
	----------------------------------------------------*/
	function CONVERT_paramExplode ( &$value, $key="", $arg="" ) {

		if( empty($value) ) {
			$value = null;
			return;
		}

		if( strpos( $value, "-" ) !== false ){
			$explodeList = explode("-", $value);

			for( $i = 0, $iMax = count($explodeList); $i < $iMax; $i++ ){
				$tmpValue[] = $explodeList[$i];
			}
		} else {
			$tmpValue[] = $value;
		}

		$value = $tmpValue;
	}


	/*----------------------------------------------------
	    CONVERT : paramDefaultPrice
	----------------------------------------------------*/
	function CONVERT_paramDefaultPrice ( &$value, $key="", $arg="" ) {

		global $ini;

		$tmp_value = $value[0];
		$checkStr  = str_repeat($arg[0], 3);

		if( $tmp_value == $checkStr || empty($tmp_value) ){
			$tmp_value = sprintf( $arg[0] . "%03d", $ini["carPriceNotID"] );
		}

		$value = $tmp_value;
	}

	/*----------------------------------------------------
	    CONVERT : paramNumeric
	----------------------------------------------------*/
	function CONVERT_paramNumeric ( &$value, $key="", $arg="" ) {
		

		if( $value == null || $value == "" ) {
			$value = null;
			return;
		}

		list($checkKey) = explode(" ", $value);

		$value = preg_replace("/\D*/", "", $checkKey);
	}


	/* ==================================================================

	        F I L T E R

	================================================================== */






	/* ==================================================================

	        C H E C K E R

	================================================================== */
	/*----------------------------------------------------
	    CHECK : paramFormat
	----------------------------------------------------*/
	function CHECK_paramFormat ( &$value, $key="", $arg="" ) {

		if( empty($value) ) {
			return;
		}

		$matchString = "/^" . $arg[0] . "{3}$|^" . $arg[0] . "[0-9]+$/";
		if( is_array($value) > 0 ){
			for( $i = 0; $i < count($value); $i++ ){
				if ( !preg_match ( $matchString, $value[$i] ) ) {
					return 1;
				}
			}
		} else {
			if ( !preg_match ( $matchString, $value ) ) {
				return 1;
			}
		}
	}


	/*----------------------------------------------------
	    CHECK : paramDrop
	----------------------------------------------------*/
	function CHECK_paramDrop ( &$value, $key="", $arg="" ) {

		if( is_array($value) > 0 ){
			for( $i = 0, $iMax = count($value); $i < $iMax; $i++ ){
				$ret = ltrim(preg_replace("/\D*/", "", $value[$i]), 0);
				if( $ret <> "" ){
					$tmpValue[] = $ret;
				}
			}
		} else {
			$tmpValue = ltrim(preg_replace("/\D*/", "", $value), 0);
		}
		$value = $tmpValue;
	}


	/*----------------------------------------------------
	    CHECK : searchMakerCodeExist
	----------------------------------------------------*/
	function CHECK_searchMakerCodeExist( &$value, $key="", $arg="" ) {

		if( empty($value) ){
			return;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "active" );

		// WHERE作成
		for( $i = 0; $i < count($value); $i++ ){
			if( is_numeric($value[$i]) ){
				$tmp["value"][] = "'" . sql_escapeString($value[$i]) . "'";
			}
		}
		if( count($tmp["value"]) > 0 ){
			$sql_where = "WHERE makerCode in ( " . implode(",", $tmp["value"]) .") ";
		}

		// 全メーカの取得
		$sql = "SELECT count(makerCode) as cnt FROM {$DBName}.maker {$sql_where} ";
		$tbl = sql_query( $sql, "single" );

		if( $tbl["cnt"] <> count($value) ){
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : searchThemeIDExist
	----------------------------------------------------*/
	function CHECK_searchThemeIDExist ( &$value, $key="", $arg="" ) {
		
		if( empty($value) ){
			return null;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "active" );

		// WHERE作成
		for( $i = 0; $i < count($value); $i++ ){
			if( is_numeric($value[$i]) ){
				$tmp["value"][] = "'" . sql_escapeString($value[$i]) . "'";
			}
		}
		if( count($tmp["value"]) > 0 ){
			$sql_where = "AND themeID in (" . implode(",", $tmp["value"]) .") ";
		}

		// 全テーマの取得
		$sql = "SELECT count(themeID) as cnt FROM {$DBName}.themeMst WHERE statusType = 100 {$sql_where} ";
		$tbl = sql_query( $sql, "single" );

		if( $tbl["cnt"] <> count($value) ){
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : searchBodyTypeExist
	----------------------------------------------------*/
	function CHECK_searchBodyTypeExist ( &$value, $key="", $arg="" ) {

		global $ini;

		if( empty($value) ){
			return null;
		}

		// iniファイルからボディタイプの取得
		for( $i = 0, $iMax = count($ini["bodyType"]); $i < $iMax; $i++ ){
			$chkBodyType[] = $ini["bodyType"][$i]["ID"];
		}

		for( $i = 0, $iMax = count($value); $i < $iMax; $i++ ){
			if( empty($chkBodyType) || !in_array( $value[$i], $chkBodyType ) ){
				return 1;
			}
		}
	}


	/*----------------------------------------------------
	    CHECK : searchPriceExist
	----------------------------------------------------*/
	function CHECK_searchPriceExist ( &$value, $key="", $arg="" ) {

		global $ini;

		if( empty($value) ){
			return null;
		}

		// iniファイルからボディタイプの取得
		for( $i = 1, $iMax = count($ini["carPrice"]); $i <= $iMax; $i++ ){
			$chkPrice[] = $ini["carPrice"][$i]["ID"];
		}

		for( $i = 0, $iMax = count($value); $i < $iMax; $i++ ){
			if( empty($chkPrice) || !in_array( $value[$i], $chkPrice ) ){
				return 1;
			}
		}
	}





?>