<?php

	// ### Version Data ### parts_convertor.fnc 1.00.00

	/*----------------------------------------------------
	  データ型変換のパーツ群
	----------------------------------------------------*/


	/*=============================================================================
		 DB => VAL
	==============================================================================*/

	/*----------------------------------------------------
		名前変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_name( $input ) {

		list( $ret["familyName"], $ret["givenName"] ) = explode( "@", $input );

		return $ret;

	}

	/*----------------------------------------------------
		email 変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_email( $input ) {

		list( $ret["account"], $ret["domain"] ) = explode( "@", $input );

		return $ret;

	}

	/*----------------------------------------------------
		電話番号 変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_phone( $input ) {

		list( $ret["phone1"], $ret["phone2"], $ret["phone3"] ) = explode( "-", $input );

		return $ret;

	}

	/*----------------------------------------------------
		日付変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_date( $input ) {

		if ( $input != "" ) {
			list( $year, $month, $day ) = explode( "-", $input );

			// ゼロサプレス
			$ret["year"]  = sprintf( "%d", $year );
			$ret["month"] = sprintf( "%d", $month );
			$ret["day"]   = sprintf( "%d", $day );
		}
		else {
			$ret["year"] = "";
			$ret["month"] = "";
			$ret["day"]   = "";
		}

		return $ret;

	}

	/*----------------------------------------------------
		時間変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_datetime( $input ) {

		if ( $input != "" ) {
			list( $date, $time ) = explode( " ", $input );
			list( $year, $month, $day ) = explode( "-", $date );
			list( $hour, $min, $sec ) = explode( ":", $time );

			// ゼロサプレス
			$ret["year"]  = sprintf( "%d", $year );
			$ret["month"] = sprintf( "%d", $month );
			$ret["day"]   = sprintf( "%d", $day );
			$ret["hour"]  = sprintf( "%d", $hour );
			$ret["min"]   = sprintf( "%d", $min );
			$ret["sec"]   = sprintf( "%d", $sec );

		}
		else {
			$ret["year"] = "";
			$ret["month"] = "";
			$ret["day"]   = "";
			$ret["hour"] = "";
			$ret["min"] = "";
			$ret["sec"]   = "";
		}

		return $ret;

	}

	/*----------------------------------------------------
		郵便番号変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_postalCode( $input ) {

		list( $ret["postalCode1"], $ret["postalCode2"] ) = explode( "-", $input );

		return $ret;

	}

	/*----------------------------------------------------
		年月変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_yearMonth( $input ) {

		if ( $input != "" ) {
			list( $month, $day ) = explode( "-", $input );

			// ゼロサプレス
			$ret["month"] = sprintf( "%d", $month );
			$ret["day"]   = sprintf( "%d", $day );
		}
		else {
			$ret["month"] = "";
			$ret["day"]   = "";
		}

		return $ret;

	}



	/*----------------------------------------------------
		時刻変換（HH:MM:SS=>HH:MM）
	----------------------------------------------------*/
	function db2val_timeHMM ( $input ){

		$times = explode( ":", $input );
		$ret = $times[0] . ":" . $times[1];

		return $ret;
	}

	/*----------------------------------------------------
		時刻変換（HH:MM:SS=>hour, min）
	----------------------------------------------------*/
	function db2val_hourMin ( $input ){

		$times = explode( ":", $input );
		$ret["hour"] = sprintf( "%d"  , $times[0] );
		$ret["min"]  = sprintf( "%02d", $times[1] );

		return $ret;
	}


	/*----------------------------------------------------
		文章にリンク先URL（Aタグ）をつける
	----------------------------------------------------*/
	function db2val_contentWithURL ( $content, $url, $linkType ){

		if( trim( $url ) == "" ){
			return $content;
		}

		if( $linkType != "1"
			&& $linkType != "2" ){
			return $content;
		}

		$tag_from_s  = "<a href='";
		$tag_from_e["1"] = "'>";
		$tag_from_e["2"] = "' target='_blank'>";
		$tag_to      = "</a>";

		$tag_from = $tag_from_s . $url . $tag_from_e["{$linkType}"];

		$wkContent = mb_ereg_replace( "\[\[\[", $tag_from, $content );
		$ret = nl2br( mb_ereg_replace( "\]\]\]", $tag_to, $wkContent ) );

		return $ret;
	}










	/*=============================================================================
		 VAL => DB
	==============================================================================*/


	/*----------------------------------------------------
		年月変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_yearMonth( $input ) {

		if ( is_numeric( $input["month"] )
			&& is_numeric( $input["day"] ) ) {
			$month = sprintf( "%02d", $input["month"] );
			$day   = sprintf( "%02d", $input["day"] );
			$ret = $month . "-" . $day;
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}


	/*----------------------------------------------------
		時分変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_hourMin( $input ) {

		if ( is_numeric( $input["hour"] )
			&& is_numeric( $input["min"] ) ) {
			$hour = sprintf( "%02d", $input["hour"] );
			$min   = sprintf( "%02d", $input["min"] );
			$ret = $hour . ":" . $min;
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}


	/*----------------------------------------------------
		名前変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_name( $input ) {

		$ret = $input["familyName"] . "@" . $input["givenName"];

		return $ret;

	}

	/*----------------------------------------------------
		年月日変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_date( $input ) {

		if ( @checkdate( $input["month"], $input["day"], $input["year"] ) ) {
			$month = sprintf( "%02d", $input["month"] );
			$day   = sprintf( "%02d", $input["day"] );
			$ret = $input["year"] . "-" . $month . "-" . $day;
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}

	/*----------------------------------------------------
		日時変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_datetime( $input ) {

		if ( @checkdate( $input["month"], $input["day"], $input["year"] ) ) {
			$month = sprintf( "%02d", $input["month"] );
			$day   = sprintf( "%02d", $input["day"] );
			$hour  = sprintf( "%02d", $input["hour"] );
			$min   = sprintf( "%02d", $input["min"] );
			$sec   = sprintf( "%02d", $input["sec"] );
			$ret   = $input["year"] . "-" . $month . "-" . $day . " " . $hour . ":" . $min . ":" . $sec;
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}

	/*----------------------------------------------------
		メールアドレス変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_email( $input ) {

		$ret = $input["account"] . "@" . $input["domain"];

		return $ret;

	}

	/*----------------------------------------------------
		電話番号変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_phone( $input ) {

		if ( ( is_numeric( $input["phone1"] ) && strlen( $input["phone1"] ) < 10 ) &&
		     ( is_numeric( $input["phone2"] ) && strlen( $input["phone2"] ) < 10 ) &&
		     ( is_numeric( $input["phone3"] ) && strlen( $input["phone3"] ) < 10 ) ) {
			$phone = array( $input["phone1"], $input["phone2"], $input["phone3"] );
			$ret = @join( "-", $phone );
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}

	/*----------------------------------------------------
		郵便番号変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_postalCode( $input ) {

		if ( strlen( $input["postalCode1"] ) < 5 &&
			strlen( $input["postalCode2"] ) < 10 ) {
			$postalCode = array( $input["postalCode1"], $input["postalCode2"] );
			$ret = @join( "-", $postalCode );
		}
		else {
			$ret["com"] = "NULL";
		}

		return $ret;

	}






?>