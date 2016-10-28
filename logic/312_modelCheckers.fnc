<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */







	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : modelCodeExist
	----------------------------------------------------*/
	function FILTER_modelCodeExist ( &$value, $key="", $arg="" ) {

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT modelCode FROM {$DBName}.model WHERE modelCode = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["modelCode"] != $value ) {
			unset ( $value );
			return 1;
		}

	}



	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/*----------------------------------------------------
	    CHECK : dupModelCode
	----------------------------------------------------*/
	function CHECK_dupModelCode ( &$value, $key="", $arg="" ) {

		$orgMakerCode = $arg[0];
		$orgModelCode = $arg[1];
		$makerCode    = $arg[2];

		if( $value == "" || ( ( $makerCode == $orgMakerCode ) && ( $value == $orgModelCode ) ) ) {
			return;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["value"]     = sql_escapeString($value);
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		$sql = "SELECT modelCode FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["value"]}'";
		$tbl = sql_query( $sql );

		if( count( $tbl ) > 0 ) {
			return 1;
		}

	}





	/*----------------------------------------------------
	    CHECK : mustArray
	----------------------------------------------------*/
	function CHECK_mustArray ( &$value, $key="", $arg="" ) {

		if( is_array( $value ) ) {
			foreach( $value as $k => $v ) {
				if( $v == "" ) {
					return 1;
				}
			}
		}

	}



	/*----------------------------------------------------
	    CHECK : is_numericArray
	----------------------------------------------------*/
	function CHECK_is_numericArray ( &$value, $key="", $arg="" ) {

		if( is_array( $value ) ) {
			foreach( $value as $k => $v ) {
				if( !is_numeric( $v ) ) {
					return 1;
				}
			}
		}

	}



	/*----------------------------------------------------
	    CHECK : minMaxRange
	----------------------------------------------------*/
	function CHECK_minMaxRange ( &$value, $key="", $arg="" ) {

		$min = $value["mini"];
		$max = $value["max"];

		if( $min > $max ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : carBodyPhotoExtension
	----------------------------------------------------*/
	function CHECK_carBodyPhotoExtension ( &$value, $key="", $arg="" ) {

		global $ini;
		$extensionList = $ini["carBody"]["extension"];

		$fileName = $value["name"];

		if( $fileName == "" ) {
			return 0;
		}

		// 拡張子を取り出す
		$result = explode( ".", $fileName );
		$extension = array_pop( $result );

		// 小文字に変換
		$extension = strtolower( $extension );

		for( $i=0; $i<count( $extensionList ); $i++ ) {
			$extensions = explode( ",", $extensionList[$i]["type"] );
			for( $j=0; $j<count( $extensions ); $j++ ) {
				if( $extensions[$j] == $extension ) {
					return 0;
				}
			}
		}

		return 1;
	}



	/*----------------------------------------------------
	    CHECK : carPhotoSize
	----------------------------------------------------*/
	function CHECK_carPhotoSize ( &$value, $key="", $arg="" ) {

		global $ini;

		$fineName = $value["name"];
		$size     = $value["size"];

		// 未入力時はチェックしない
		if( $fineName == "" ) {
			return;
		}

		if( $size > $ini["carBody"]["photoMaxSize"] || $size == 0 ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : mustArray_price
	----------------------------------------------------*/
	function CHECK_mustArray_price ( &$value, $key="", $arg="" ) {

		$min = $value["mini"];
		$max = $value["max"];

		if( ( $min != "" && $max == "" ) || ( $min == "" && $max != "" ) ){
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : is_numericArray_price
	----------------------------------------------------*/
	function CHECK_is_numericArray_price ( &$value, $key="", $arg="" ) {

		if( is_array( $value ) ) {
			foreach( $value as $k => $v ) {
				if( !empty($v) && !is_numeric( $v ) ) {
					return 1;
				}
			}
		}
	}



?>